import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _trips = [];
  String _filter = 'all'; // all, active, past

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    
    try {
      final apiService = ApiService();
      _trips = await apiService.getTrips();
      
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading trips: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final filteredTrips = _trips.where((trip) {
      final departureDate = DateTime.parse(trip['departure_date']);
      
      if (_filter == 'active') {
        return departureDate.isAfter(now);
      } else if (_filter == 'past') {
        return departureDate.isBefore(now);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Trips', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFF9500)),
            onPressed: () => context.push('/create-trip'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Active', 'active'),
                const SizedBox(width: 8),
                _buildFilterChip('Past', 'past'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTrips.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_shipping_outlined, size: 64, color: Colors.grey[300]),
                            const SizedBox(height: 16),
                            const Text(
                              'No trips found',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your first trip to get started',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => context.push('/create-trip'),
                              icon: const Icon(Icons.add),
                              label: const Text('Create Trip'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9500),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTrips,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredTrips.length,
                          itemBuilder: (context, index) {
                            final trip = filteredTrips[index];
                            final departureDate = DateTime.parse(trip['departure_date']);
                            final isActive = departureDate.isAfter(now);
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xFFE5E7EB)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  '${trip['origin_city']} → ${trip['destination_city']}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B7280)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${departureDate.day}/${departureDate.month}/${departureDate.year}',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.inventory_2, size: 14, color: Color(0xFF6B7280)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${trip['available_weight']}kg / ${trip['max_weight']}kg available',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.euro, size: 14, color: Color(0xFF6B7280)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${trip['price_per_kg']}€/kg',
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isActive ? 'Actif' : 'Passé',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (isActive) ...[
                                      const SizedBox(width: 8),
                                      PopupMenuButton<String>(
                                        onSelected: (value) async {
                                          if (value == 'edit') {
                                            // TODO: Navigate to edit trip page
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Édition du trajet bientôt disponible')),
                                            );
                                          } else if (value == 'delete') {
                                            final confirm = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('Supprimer le trajet'),
                                                content: const Text('Voulez-vous vraiment supprimer ce trajet ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false),
                                                    child: const Text('Annuler'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () => Navigator.pop(context, true),
                                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                    child: const Text('Supprimer'),
                                                  ),
                                                ],
                                              ),
                                            );
                                            
                                            if (confirm == true) {
                                              try {
                                                final apiService = ApiService();
                                                await apiService.deleteTrip(trip['id']);
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text('✓ Trajet supprimé'),
                                                    backgroundColor: Color(0xFF10B981),
                                                  ),
                                                );
                                                _loadTrips();
                                              } catch (e) {
                                                if (!mounted) return;
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('❌ Erreur: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Modifier')])),
                                          const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, size: 18, color: Colors.red), SizedBox(width: 8), Text('Supprimer', style: TextStyle(color: Colors.red))])),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                                onTap: () {
                                  context.push('/trip/${trip['id']}');
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9500) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9500) : const Color(0xFFE5E7EB),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF374151),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
