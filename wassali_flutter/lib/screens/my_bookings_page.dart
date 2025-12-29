import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'leave_review_page.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  final _apiService = ApiService();
  
  String _activeTab = 'active';
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getMyBookings();
      
      if (data is List) {
        final bookingsWithPaidStatus = data.map((booking) => {
          ...booking,
          'is_paid': booking['is_paid'] == true,
        }).toList();
        setState(() {
          _bookings = bookingsWithPaidStatus;
        });
      } else {
        setState(() {
          _bookings = [];
        });
      }
    } catch (e) {
      final errorMsg = e.toString();
      
      // Si l'erreur contient "Could not validate credentials", rediriger vers login
      if (errorMsg.contains('Could not validate credentials') || errorMsg.contains('401')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expirée. Veuillez vous reconnecter.'),
              backgroundColor: Color(0xFFDC2626),
              duration: Duration(seconds: 3),
            ),
          );
          // Rediriger vers la page de connexion après 2 secondes
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          });
        }
      }
      
      setState(() {
        _errorMessage = errorMsg;
        _bookings = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredBookings {
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
    switch (statusLower) {
      case 'confirmed':
        return const Color(0xFFDEEBFF);
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'delivered':
        return const Color(0xFFDCFCE7);
      case 'in_transit':
        return const Color(0xFFF3E8FF);
      case 'cancelled':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  Color _getStatusTextColor(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return const Color(0xFF1D4ED8);
      case 'pending':
        return const Color(0xFFA16207);
      case 'delivered':
        return const Color(0xFF15803D);
      case 'in_transit':
        return const Color(0xFF7C3AED);
      case 'cancelled':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF374151);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Mes réservations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _fetchBookings,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.refresh,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

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
                        'Actives',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _activeTab == 'active'
                              ? Colors.white
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
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
                        'Terminées',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _activeTab == 'completed'
                              ? Colors.white
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF0066FF),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Chargement...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFECACA),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Color(0xFFDC2626),
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFDC2626),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchBookings,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0066FF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Réessayer'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : _filteredBookings.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: Color(0xFFD1D5DB),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _activeTab == 'active'
                                        ? 'Aucune réservation active'
                                        : 'Aucune réservation terminée',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0066FF),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Rechercher un trajet'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredBookings.length,
                            itemBuilder: (context, index) {
                              final booking = _filteredBookings[index];
                              if (booking == null || booking['trip'] == null) {
                                return const SizedBox.shrink();
                              }
                              return _buildBookingCard(booking);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final trip = booking['trip'] ?? {};
    final formattedDate = trip['departure_date'] != null
        ? DateFormat('d MMM').format(DateTime.parse(trip['departure_date']))
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF3F4F6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${trip['origin_city'] ?? 'Inconnu'} → ${trip['destination_city'] ?? 'Inconnu'}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${booking['weight'] ?? 0}kg',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking['status']),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _getStatusText(booking['status']),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusTextColor(booking['status']),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(booking['total_price'] ?? 0).toStringAsFixed(2)}€',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF0066FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.only(top: 8),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFF3F4F6),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suivi: ${booking['tracking_number'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Transporteur: ${trip['transporter']?['name'] ?? 'Inconnu'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            ..._buildStatusActions(booking, trip),
          ],
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    final statusLower = status.toLowerCase();
    switch (statusLower) {
      case 'confirmed':
        return 'confirmé';
      case 'pending':
        return 'en attente';
      case 'delivered':
        return 'livré';
      case 'in_transit':
        return 'en transit';
      case 'cancelled':
        return 'annulé';
      default:
        return status;
    }
  }

  List<Widget> _buildStatusActions(
    Map<String, dynamic> booking,
    Map<String, dynamic> trip,
  ) {
    final status = booking['status'].toString().toLowerCase();
    final List<Widget> widgets = [];

    if (status == 'confirmed' && booking['is_paid'] != true) {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFBBF7D0),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Accepté par le transporteur',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF15803D),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '💳 Vous pouvez procéder au paiement',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Page de paiement en cours de développement'),
                  backgroundColor: Color(0xFF0066FF),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Payer maintenant - ${(booking['total_price'] ?? 0).toStringAsFixed(2)}€',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else if (status == 'in_transit') {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE9D5FF),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🚚 Colis en transit',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7C3AED),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '📦 Votre colis est en route',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (status == 'pending') {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFFDE68A),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '⏳ En attente de l\'approbation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFA16207),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '💡 Paiement après acceptation',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFCA8A04),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (status == 'cancelled') {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFFECACA),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '❌ Réservation refusée',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDC2626),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '💰 Aucun paiement effectué',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B5563),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '🔍 Chercher un autre trajet',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else if (status == 'delivered') {
      widgets.add(
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFBBF7D0),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '✅ Livré avec succès',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF15803D),
                ),
              ),
              SizedBox(height: 4),
              Text(
                '📦 Votre colis a été livré',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
        ),
      );
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaveReviewPage(
                    bookingId: booking['id'],
                    transporterId: trip['transporter_id'] ?? 0,
                    transporterName: trip['transporter']?['name'] ?? 'Inconnu',
                    tripDetails: {
                      'origin': trip['origin_city'] ?? '',
                      'destination': trip['destination_city'] ?? '',
                    },
                  ),
                ),
              );
            },
            icon: const Icon(Icons.star, size: 20),
            label: const Text(
              'Laisser un avis',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
