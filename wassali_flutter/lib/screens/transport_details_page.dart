import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/language_provider.dart';
import '../services/api_service.dart';

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
    _loadTripDetails();
  }

  Future<void> _loadTripDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load trip details
      final trips = await _apiService.getTrips();
      final trip = trips.firstWhere(
        (t) => t['id'] == widget.tripId,
        orElse: () => throw Exception('Trip not found'),
      );
      
      setState(() {
        _trip = trip;
      });

      // Load transporter reviews if transporter ID is available
      if (trip['transporter'] != null && trip['transporter']['id'] != null) {
        try {
          // TODO: Implement getTransporterReviews in API service
          // final reviews = await _apiService.getTransporterReviews(trip['transporter']['id']);
          // setState(() => _reviews = reviews);
        } catch (e) {
          print('Error loading reviews: $e');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.t('trip_details'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null || _trip == null) {
      return Scaffold(
        appBar: AppBar(title: Text(lang.t('trip_details'))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Trip not found',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(lang.t('back')),
              ),
            ],
          ),
        ),
      );
    }

    final trip = _trip!;
    final transporter = trip['transporter'] as Map<String, dynamic>?;
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('HH:mm');
    final departureDate = DateTime.parse(trip['departure_date']);
    
    final maxWeight = (trip['max_weight'] ?? 0).toDouble();
    final availableWeight = (trip['available_weight'] ?? maxWeight).toDouble();
    final usedWeight = maxWeight - availableWeight;
    final capacity = maxWeight > 0 ? ((usedWeight / maxWeight) * 100).round() : 0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            // Trip Route Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip['origin_city'] ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              trip['origin_country'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.arrow_downward, color: Colors.white70, size: 20),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip['destination_city'] ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              trip['destination_country'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trip Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: lang.t('departure_date'),
                    value: '${dateFormat.format(departureDate)} at ${timeFormat.format(departureDate)}',
                  ),
                  const SizedBox(height: 16),

                  // Price
                  _buildDetailRow(
                    icon: Icons.attach_money,
                    label: lang.t('price_per_kg'),
                    value: '${trip['price_per_kg']} TND/kg',
                    valueColor: const Color(0xFF0066FF),
                  ),
                  const SizedBox(height: 16),

                  // Capacity Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.scale, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.t('capacity'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  '${availableWeight.toStringAsFixed(0)} kg ${lang.t('available')} / ${maxWeight.toStringAsFixed(0)} kg',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: capacity / 100,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(
                            capacity > 80
                                ? Colors.orange
                                : capacity > 50
                                    ? const Color(0xFFFF9500)
                                    : const Color(0xFF0066FF),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (trip['description'] != null && trip['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      lang.t('description'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trip['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],

                  // Transporter Info
                  if (transporter != null) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      lang.t('transporter'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFFF9500),
                          child: Text(
                            (transporter['name'] ?? 'T')[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                                    transporter['name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (transporter['is_verified'] == true) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.verified,
                                      color: Color(0xFF0066FF),
                                      size: 20,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${transporter['rating'] ?? 0.0} (${transporter['total_trips'] ?? 0} ${lang.t('trips')})',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            // TODO: Navigate to chat
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/booking-form',
                  arguments: trip,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                lang.t('book_now'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
