import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

/// SearchResultsPage - COPIE EXACTE de SearchResults.tsx
class SearchResultsPage extends StatefulWidget {
  final String? from;
  final String? to;
  final String? date;

  const SearchResultsPage({
    super.key,
    this.from,
    this.to,
    this.date,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> _trips = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    try {
      setState(() {
        _loading = true;
        _error = '';
      });

      final results = await _apiService.getTrips();

      // Filtrer par paramètres de recherche
      List<Map<String, dynamic>> filteredTrips = results;
      
      if (widget.from != null && widget.from!.isNotEmpty) {
        filteredTrips = filteredTrips.where((trip) {
          final originCity = trip['origin_city']?.toString().toLowerCase() ?? '';
          return originCity.contains(widget.from!.toLowerCase());
        }).toList();
      }

      if (widget.to != null && widget.to!.isNotEmpty) {
        filteredTrips = filteredTrips.where((trip) {
          final destCity = trip['destination_city']?.toString().toLowerCase() ?? '';
          return destCity.contains(widget.to!.toLowerCase());
        }).toList();
      }

      setState(() {
        _trips = filteredTrips;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.from ?? 'Tout'} → ${widget.to ?? 'Tout'}',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            Text(
              widget.date ?? 'N\'importe quand',
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black),
            onPressed: () {
              // TODO: Filtres
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtres en développement'),
                  backgroundColor: Color(0xFF0066FF),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Bannière résultats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              border: Border(
                bottom: BorderSide(color: Color(0xFFBFDBFE)),
              ),
            ),
            child: Text(
              '${_trips.length} ${_trips.length > 1 ? 'résultats trouvés' : 'résultat trouvé'}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),

          // Liste des trajets
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0066FF),
                    ),
                  )
                : _error.isNotEmpty
                    ? Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _error,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      )
                    : _trips.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Color(0xFFD1D5DB),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Aucun trajet disponible',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Essayez de modifier vos critères',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchTrips,
                            color: const Color(0xFF0066FF),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _trips.length,
                              itemBuilder: (context, index) {
                                final trip = _trips[index];
                                return _buildTripCard(trip);
                              },
                            ),
                          ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    final transporter = trip['transporter'] ?? {};
    final pricePerKg = trip['price_per_kg'] ?? 0;
    final rating = transporter['rating']?.toDouble() ?? 0.0;
    final isVerified = transporter['is_verified'] == true;
    
    String formattedDate = 'N/A';
    if (trip['departure_date'] != null) {
      try {
        final date = DateTime.parse(trip['departure_date']);
        formattedDate = DateFormat('d MMM, HH:mm').format(date);
      } catch (e) {
        // Ignorer erreur de parsing
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/trip/${trip['id']}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info transporteur
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0066FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (transporter['name']?.toString() ?? 'T')
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  transporter['name']?.toString() ?? 'Transporteur',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isVerified) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ],
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: Color(0xFFFBBF24),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${pricePerKg.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                        const Text(
                          'par kg',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Route
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${trip['origin_city'] ?? 'N/A'} → ${trip['destination_city'] ?? 'N/A'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Date
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Poids disponible
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(
                      '${trip['available_weight'] ?? 0}kg disponible',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bouton Voir détails
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/trip/${trip['id']}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Voir les détails',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      selectedItemColor: const Color(0xFF0066FF),
      unselectedItemColor: const Color(0xFF9CA3AF),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Réservations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
      },
    );
  }
}
