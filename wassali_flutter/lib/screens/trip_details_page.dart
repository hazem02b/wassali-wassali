import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'booking_form_page.dart';

class TransportDetailsPage extends StatefulWidget {
  final int tripId;

  const TransportDetailsPage({super.key, required this.tripId});

  @override
  State<TransportDetailsPage> createState() => _TransportDetailsPageState();
}

class _TransportDetailsPageState extends State<TransportDetailsPage> {
  final _apiService = ApiService();
  
  Map<String, dynamic>? _trip;
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTripDetails();
  }

  Future<void> _fetchTripDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _apiService.getTripById(widget.tripId);
      setState(() {
        _trip = data;
      });

      // Charger les avis du transporteur
      if (data['transporter']?['id'] != null) {
        try {
          final reviewsData = await _apiService.getTransporterReviews(
            data['transporter']['id'],
          );
          setState(() {
            _reviews = reviewsData;
          });
        } catch (err) {
          print('Error fetching reviews: $err');
          setState(() {
            _reviews = [];
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return "Aujourd'hui";
    if (difference == 1) return "Hier";
    if (difference < 7) return "Il y a $difference jours";
    if (difference < 30) return "Il y a ${(difference / 7).floor()} semaines";
    
    return DateFormat('MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF0066FF),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading trip details...',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null || _trip == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _errorMessage ?? 'Trip not found',
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Search'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final trip = _trip!;
    final transporter = trip['transporter'] ?? {};
    
    final departureDate = DateTime.parse(trip['departure_date']);
    final formattedDate = DateFormat('MMM d, yyyy').format(departureDate);
    final formattedTime = DateFormat('hh:mm a').format(departureDate);
    
    final maxWeight = trip['max_weight'] ?? 0;
    final availableWeight = trip['available_weight'] ?? 0;
    final capacity = maxWeight > 0 
        ? ((maxWeight - availableWeight) / maxWeight * 100).round() 
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // Header with back button
              SliverToBoxAdapter(
                child: Container(
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
                    ],
                  ),
                ),
              ),

              // Transporter Profile
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: const Center(
                              child: Text(
                                '👨',
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      transporter['name'] ?? 'Transporter',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (transporter['is_verified'] == true)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF3B82F6),
                                        size: 20,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xFFFBBF24),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      (transporter['rating'] ?? 0.0).toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      ' (${transporter['total_trips'] ?? 0} trips)',
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
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Contact Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.phone,
                                size: 20,
                              ),
                              label: const Text('Call'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1F2937),
                                side: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.message,
                                size: 20,
                              ),
                              label: const Text('Message'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1F2937),
                                side: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Route & Time Info
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trip Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        'Route',
                        '${trip['origin_city']} → ${trip['destination_city']}',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.access_time,
                        'Departure',
                        '$formattedDate at $formattedTime',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.inventory_2_outlined,
                        'Available Capacity',
                        '${availableWeight}kg / ${maxWeight}kg ($capacity% used)',
                      ),
                    ],
                  ),
                ),
              ),

              // Pricing
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pricing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Price per kg',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            '${trip['price_per_kg']}€',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0066FF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Description
              if (trip['description'] != null && trip['description'].isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Additional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          trip['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF374151),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Transportable Items
              if (trip['accepted_items'] != null && 
                  (trip['accepted_items'] as List).isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Items Transportable',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (trip['accepted_items'] as List).map((item) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF10B981),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

              // Reviews
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 128),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_reviews.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Aucun avis pour le moment',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      else
                        ..._reviews.map((review) => _buildReviewCard(review)),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Fixed Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Price per kg',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '${trip['price_per_kg']}€',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0066FF),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            Text(
                              '${availableWeight}kg',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (trip['is_active'] == true && availableWeight > 0)
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookingFormPage(tripId: widget.tripId),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFD1D5DB),
                          disabledForegroundColor: const Color(0xFF6B7280),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          trip['is_active'] != true
                              ? 'Trip Not Available'
                              : availableWeight <= 0
                                  ? 'No Capacity Available'
                                  : 'Book Now - Reserve Your Spot',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF9CA3AF),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFF3F4F6),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['client']?['name'] ?? 'Client',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 16,
                    color: index < (review['rating'] ?? 0)
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFFD1D5DB),
                  );
                }),
              ),
            ],
          ),
          if (review['comment'] != null && review['comment'].isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              review['comment'],
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            _formatDate(review['created_at']),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}
