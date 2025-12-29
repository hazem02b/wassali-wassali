import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

/// MyBookingsPage - COPIE EXACTE de MyBookings.tsx
class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final _apiService = ApiService();
  String _activeTab = 'active'; // 'active' ou 'completed'
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      setState(() {
        _loading = true;
        _error = '';
      });

      final data = await _apiService.getMyBookings();
      
      setState(() {
        _bookings = data.map((booking) {
          return Map<String, dynamic>.from(booking)
            ..['is_paid'] = booking['is_paid'] == true;
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _bookings = [];
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredBookings {
    return _bookings.where((booking) {
      if (booking == null || booking['status'] == null) return false;
      
      final status = booking['status'].toString().toLowerCase();
      if (_activeTab == 'active') {
        return ['pending', 'confirmed', 'in_transit'].contains(status);
      } else {
        return ['delivered', 'cancelled'].contains(status);
      }
    }).toList();
  }

  Color _getStatusColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower == 'confirmed') return const Color(0xFF3B82F6);
    if (statusLower == 'pending') return const Color(0xFFF59E0B);
    if (statusLower == 'delivered') return const Color(0xFF10B981);
    if (statusLower == 'in_transit') return const Color(0xFFA855F7);
    if (statusLower == 'cancelled') return const Color(0xFFEF4444);
    return const Color(0xFF6B7280);
  }

  Color _getStatusBgColor(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower == 'confirmed') return const Color(0xFFDBEAFE);
    if (statusLower == 'pending') return const Color(0xFFFEF3C7);
    if (statusLower == 'delivered') return const Color(0xFFD1FAE5);
    if (statusLower == 'in_transit') return const Color(0xFFF3E8FF);
    if (statusLower == 'cancelled') return const Color(0xFFFEE2E2);
    return const Color(0xFFF3F4F6);
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
        title: const Text(
          'Mes Réservations',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 'active'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _activeTab == 'active'
                            ? const Color(0xFF0066FF)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Actives (${_filteredBookings.where((b) => ['pending', 'confirmed', 'in_transit'].contains(b['status'].toString().toLowerCase())).length})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _activeTab == 'active'
                              ? Colors.white
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = 'completed'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _activeTab == 'completed'
                            ? const Color(0xFF0066FF)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Terminées (${_filteredBookings.where((b) => ['delivered', 'cancelled'].contains(b['status'].toString().toLowerCase())).length})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _activeTab == 'completed'
                              ? Colors.white
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _loading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF0066FF),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Chargement des réservations...',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ],
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
                    : _filteredBookings.isEmpty
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
                                Text(
                                  _activeTab == 'active'
                                      ? 'Aucune réservation active'
                                      : 'Aucune réservation terminée',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Navigation vers recherche
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Page Recherche en développement'),
                                        backgroundColor: Color(0xFF0066FF),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0066FF),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Trouver des trajets'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchBookings,
                            color: const Color(0xFF0066FF),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _filteredBookings.length,
                              itemBuilder: (context, index) {
                                final booking = _filteredBookings[index];
                                return _buildBookingCard(booking);
                              },
                            ),
                          ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    if (booking['trip'] == null) return const SizedBox.shrink();

    final trip = booking['trip'];
    final status = booking['status']?.toString() ?? 'unknown';
    final formattedDate = trip['departure_date'] != null
        ? DateFormat('MMM d').format(DateTime.parse(trip['departure_date']))
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec route et statut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${trip['origin_city'] ?? 'Inconnu'} → ${trip['destination_city'] ?? 'Inconnu'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.inbox_outlined, size: 16, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          '${booking['weight'] ?? 0}kg',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusBgColor(status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusText(status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(booking['total_price'] ?? 0).toStringAsFixed(2)}€',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF0066FF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Info transporteur et tracking
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suivi: ${booking['tracking_number'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Transporteur: ${trip['transporter']?['name'] ?? 'Inconnu'}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          // Messages selon le statut
          if (status.toLowerCase() == 'confirmed' && booking['is_paid'] != true)
            _buildConfirmedMessage(booking),
          if (status.toLowerCase() == 'in_transit')
            _buildInTransitMessage(),
          if (status.toLowerCase() == 'pending')
            _buildPendingMessage(),
          if (status.toLowerCase() == 'cancelled')
            _buildCancelledMessage(booking),
          if (status.toLowerCase() == 'delivered')
            _buildDeliveredMessage(booking),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    final s = status.toLowerCase();
    if (s == 'confirmed') return 'Confirmée';
    if (s == 'pending') return 'En attente';
    if (s == 'delivered') return 'Livrée';
    if (s == 'in_transit') return 'En transit';
    if (s == 'cancelled') return 'Annulée';
    return status;
  }

  Widget _buildConfirmedMessage(Map<String, dynamic> booking) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            border: Border.all(color: const Color(0xFF10B981)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Acceptée par le transporteur',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF047857)),
              ),
              SizedBox(height: 4),
              Text(
                '💳 Vous pouvez procéder au paiement',
                style: TextStyle(fontSize: 12, color: Color(0xFF059669)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigation vers paiement
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Page Paiement en développement'),
                  backgroundColor: Color(0xFF0066FF),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Payer maintenant - ${(booking['total_price'] ?? 0).toStringAsFixed(2)}€',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInTransitMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        border: Border.all(color: const Color(0xFFA855F7)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🚚 Colis en transit',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7C3AED)),
          ),
          SizedBox(height: 4),
          Text(
            '📦 Votre colis est en route',
            style: TextStyle(fontSize: 12, color: Color(0xFF9333EA)),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingMessage() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        border: Border.all(color: const Color(0xFFF59E0B)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⏳ En attente d\'approbation',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFD97706)),
          ),
          SizedBox(height: 4),
          Text(
            '💡 Paiement après acceptation',
            style: TextStyle(fontSize: 12, color: Color(0xFFF59E0B)),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledMessage(Map<String, dynamic> booking) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            border: Border.all(color: const Color(0xFFEF4444)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '❌ Réservation rejetée',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)),
              ),
              SizedBox(height: 4),
              Text(
                '💰 Aucun paiement effectué',
                style: TextStyle(fontSize: 12, color: Color(0xFFEF4444)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Navigation vers recherche
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Page Recherche en développement'),
                  backgroundColor: Color(0xFF6B7280),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B7280),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '🔍 Chercher un autre trajet',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveredMessage(Map<String, dynamic> booking) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            border: Border.all(color: const Color(0xFF10B981)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Livré avec succès',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF047857)),
              ),
              SizedBox(height: 4),
              Text(
                '📦 Colis livré',
                style: TextStyle(fontSize: 12, color: Color(0xFF059669)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              final transporterId = booking['trip']?['transporter']?['id'];
              final transporterName = booking['trip']?['transporter']?['name'] ?? 'Transporteur';
              
              if (transporterId != null) {
                context.push(
                  '/leave-review/${booking['id']}',
                  extra: {
                    'transporterId': transporterId,
                    'transporterName': transporterName,
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Informations du transporteur manquantes'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.star, size: 20),
            label: const Text(
              'Laisser un avis',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // Réservations est l'index 1
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
