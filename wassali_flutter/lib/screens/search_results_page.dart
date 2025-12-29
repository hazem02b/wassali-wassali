import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import 'transport_details_page.dart';

/// Page de résultats de recherche - CONVERSION EXACTE de SearchResults.tsx
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
  List<dynamic> _trips = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final results = await _apiService.getTrips();
      
      // Filter by search params if provided
      List<dynamic> filteredTrips = results;
      
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
    final lang = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header - EXACT comme le web
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.from ?? 'Any'} → ${widget.to ?? 'Any'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.date ?? 'Anytime',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Show filters
                      },
                      icon: Icon(
                        Icons.tune,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: isDark 
                            ? const Color(0xFF374151) 
                            : const Color(0xFFF3F4F6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: _loading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: Color(0xFF0066FF),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          lang.t('loadingBookings'),
                          style: TextStyle(
                            color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark 
                                ? const Color(0xFF7F1D1D).withOpacity(0.2)
                                : const Color(0xFFFEF2F2),
                            border: Border.all(
                              color: isDark 
                                  ? const Color(0xFF991B1B)
                                  : const Color(0xFFFECACA),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _error!,
                            style: TextStyle(
                              color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          // Results Count - EXACT comme le web
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark 
                                  ? const Color(0xFF1E3A8A).withOpacity(0.2)
                                  : const Color(0xFFEFF6FF),
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark 
                                      ? const Color(0xFF1E40AF)
                                      : const Color(0xFFBFDBFE),
                                ),
                              ),
                            ),
                            child: Text(
                              '${_trips.length} ${_trips.length > 1 ? lang.t('resultsFound') : lang.t('result')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? const Color(0xFFD1D5DB) : const Color(0xFF374151),
                              ),
                            ),
                          ),

                          // Trips List
                          Expanded(
                            child: _trips.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.archive_outlined,
                                          size: 64,
                                          color: isDark 
                                              ? const Color(0xFF4B5563)
                                              : const Color(0xFFD1D5DB),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          lang.t('noTripsAvailable'),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: isDark 
                                                ? const Color(0xFFD1D5DB)
                                                : const Color(0xFF6B7280),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          lang.t('tryModifying'),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isDark 
                                                ? const Color(0xFF6B7280)
                                                : const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _trips.length,
                                    itemBuilder: (context, index) {
                                      final trip = _trips[index];
                                      return _buildTripCard(trip, isDark, lang);
                                    },
                                  ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(isDark, lang),
    );
  }

  Widget _buildTripCard(dynamic trip, bool isDark, LanguageProvider lang) {
    final transporter = trip['transporter'];
    final dateFormat = DateFormat('d MMM, HH:mm', 'fr_FR');
    final departureDate = DateTime.parse(trip['departure_date']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransportDetailsPage(tripId: trip['id']),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transporter Info - EXACT comme le web
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFFE6F0FF),
                      child: transporter?['avatar'] != null
                          ? ClipOval(
                              child: Image.network(
                                transporter['avatar'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person, color: Color(0xFF0066FF)),
                              ),
                            )
                          : const Icon(Icons.person, color: Color(0xFF0066FF)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  transporter?['name'] ?? 'Transporter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? Colors.white : const Color(0xFF111827),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (transporter?['is_verified'] == true) ...[
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: Color(0xFF3B82F6),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 12,
                                color: Color(0xFFFBBF24),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (transporter?['rating'] ?? 0.0).toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
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
                        Text(
                          '${trip['price_per_kg']}€',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                        Text(
                          lang.t('perKg'),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Route - EXACT comme le web
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${trip['origin_city'] ?? 'N/A'} → ${trip['destination_city'] ?? 'N/A'}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Date - EXACT comme le web
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(departureDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Available weight - EXACT comme le web
                Row(
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 16,
                      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${trip['available_weight']}kg ${lang.t('available')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // View Details Button - EXACT comme le web
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransportDetailsPage(tripId: trip['id']),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      lang.t('viewDetails'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildBottomNav(bool isDark, LanguageProvider lang) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, lang.t('home'), false, isDark, () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.search, lang.t('search'), true, isDark, () {}),
              _buildNavItem(Icons.receipt_long, lang.t('bookings'), false, isDark, () {}),
              _buildNavItem(Icons.message, lang.t('messages'), false, isDark, () {}),
              _buildNavItem(Icons.person, lang.t('profile'), false, isDark, () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0066FF).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive
                  ? const Color(0xFF0066FF)
                  : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF0066FF)
                    : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
