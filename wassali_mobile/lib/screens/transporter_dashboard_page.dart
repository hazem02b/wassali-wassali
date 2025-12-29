import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class TransporterDashboardPage extends StatefulWidget {
  const TransporterDashboardPage({super.key});

  @override
  State<TransporterDashboardPage> createState() => _TransporterDashboardPageState();
}

class _TransporterDashboardPageState extends State<TransporterDashboardPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _trips = [];
  List<Map<String, dynamic>> _bookings = [];
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final apiService = ApiService();
      
      // Charger toutes les données en parallèle
      final results = await Future.wait([
        apiService.getTrips(),
        apiService.getMyBookings(),
        apiService.getCurrentUser(),
        apiService.getUserStats(),
      ]);
      
      _trips = results[0] as List<Map<String, dynamic>>;
      _bookings = results[1] as List<Map<String, dynamic>>;
      _userData = results[2] as Map<String, dynamic>;
      _stats = results[3] as Map<String, dynamic>;
      
      print('✅ Dashboard chargé:');
      print('   Utilisateur: ${_userData?['name']}');
      print('   Stats: $_stats');
      
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      print('❌ Erreur dashboard: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading dashboard: $e')),
      );
    }
  }

  Future<void> _acceptBooking(int bookingId) async {
    try {
      final apiService = ApiService();
      await apiService.acceptBooking(bookingId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Réservation acceptée ! Le client sera notifié.'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      _loadDashboardData();
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

  Future<void> _rejectBooking(int bookingId) async {
    try {
      final apiService = ApiService();
      await apiService.rejectBooking(bookingId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Réservation rejetée ! Le client sera notifié.'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadDashboardData();
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

  Future<void> _startDelivery(int bookingId) async {
    try {
      final apiService = ApiService();
      await apiService.startDelivery(bookingId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚚 Livraison commencée !'),
          backgroundColor: Color(0xFF0066FF),
        ),
      );
      _loadDashboardData();
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

  Future<void> _markAsDelivered(int bookingId) async {
    try {
      final apiService = ApiService();
      await apiService.markAsDelivered(bookingId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Livraison confirmée ! Le client peut laisser un avis.'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      _loadDashboardData();
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

  @override
  Widget build(BuildContext context) {
    // Utiliser les stats de l'API au lieu de calculer localement
    final totalTrips = _stats?['total_trips'] ?? 0;
    final pendingBookingsCount = _stats?['pending_bookings'] ?? 0;
    final totalRevenue = _stats?['total_revenue'] ?? 0.0;
    
    final now = DateTime.now();
    final activeTrips = _trips.where((t) => DateTime.parse(t['departure_date']).isAfter(now)).toList();
    final pendingBookings = _bookings.where((b) => b['status'].toString().toLowerCase() == 'pending').toList();
    final confirmedPaidBookings = _bookings.where((b) => 
      b['status'].toString().toLowerCase() == 'confirmed' && b['is_paid'] == true
    ).toList();
    final inTransitBookings = _bookings.where((b) => 
      b['status'].toString().toLowerCase() == 'in_transit'
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF9500), Color(0xFFE68600)],
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Bienvenue,',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _userData?['name'] ?? 'Transporteur',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildStatCard(totalTrips.toString(), 'actifs', Icons.local_shipping),
                                  const SizedBox(width: 8),
                                  _buildStatCard(pendingBookingsCount.toString(), 'En attente', Icons.schedule),
                                  const SizedBox(width: 8),
                                  _buildStatCard('${totalRevenue.toStringAsFixed(0)}€', 'Revenu', Icons.attach_money),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (activeTrips.isNotEmpty) ...[
                        _buildNextTrip(activeTrips.first),
                        const SizedBox(height: 16),
                      ],
                      if (confirmedPaidBookings.isNotEmpty) ...[
                        _buildBookingsSection('💰 Réservations confirmées (payées)', confirmedPaidBookings, 'confirmed'),
                        const SizedBox(height: 16),
                      ],
                      if (inTransitBookings.isNotEmpty) ...[
                        _buildBookingsSection('🚚 Livraisons en cours', inTransitBookings, 'in_transit'),
                        const SizedBox(height: 16),
                      ],
                      _buildBookingsSection('Réservations en attente', pendingBookings, 'pending'),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFFFFEBD6))),
          ],
        ),
      ),
    );
  }

  Widget _buildNextTrip(Map<String, dynamic> trip) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Prochain trajet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text('${trip['origin_city']} → ${trip['destination_city']}'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Color(0xFF6B7280)),
              const SizedBox(width: 8),
              Text(DateTime.parse(trip['departure_date']).toString().split(' ')[0]),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.push('/my-trips'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF4EB),
              foregroundColor: const Color(0xFFFF9500),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Voir les détails'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsSection(String title, List<Map<String, dynamic>> bookings, String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          if (bookings.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  type == 'pending' ? 'Aucune réservation en attente' : 'Aucune donnée disponible',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ),
            )
          else
            ...bookings.take(5).map((booking) => _buildBookingItem(booking, type)),
        ],
      ),
    );
  }

  Widget _buildBookingItem(Map<String, dynamic> booking, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['client']?['name'] ?? 'Inconnu',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${booking['trip']?['origin_city'] ?? ''} → ${booking['trip']?['destination_city'] ?? ''}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${booking['total_price']?.toStringAsFixed(2) ?? '0.00'}€',
                style: const TextStyle(color: Color(0xFFFF9500), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              if (type == 'pending')
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _acceptBooking(booking['id']),
                      icon: const Icon(Icons.check, color: Color(0xFF10B981), size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _rejectBooking(booking['id']),
                      icon: const Icon(Icons.close, color: Colors.red, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                )
              else if (type == 'confirmed')
                ElevatedButton(
                  onPressed: () => _startDelivery(booking['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('🚚 Commencer', style: TextStyle(fontSize: 12)),
                )
              else if (type == 'in_transit')
                ElevatedButton(
                  onPressed: () => _markAsDelivered(booking['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('✓ Livré', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => context.push('/create-trip'),
            icon: const Icon(Icons.add),
            label: const Text('Publier un trajet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9500),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/my-reviews'),
            icon: const Icon(Icons.star),
            label: const Text('Mes avis'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF9500),
      unselectedItemColor: Colors.grey,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            // Already on dashboard
            break;
          case 1:
            context.go('/my-trips');
            break;
          case 2:
            context.go('/create-trip');
            break;
          case 3:
            context.go('/messages');
            break;
          case 4:
            context.go('/my-transporter-profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Trajets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Créer',
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
    );
  }
}
