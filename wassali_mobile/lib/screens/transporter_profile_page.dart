import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransporterProfilePage extends StatefulWidget {
  final int transporterId;

  const TransporterProfilePage({
    super.key,
    required this.transporterId,
  });

  @override
  State<TransporterProfilePage> createState() => _TransporterProfilePageState();
}

class _TransporterProfilePageState extends State<TransporterProfilePage> {
  Map<String, dynamic>? _transporter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransporter();
  }

  Future<void> _loadTransporter() async {
    // TODO: Fetch transporter details from API
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _transporter = {
        'id': widget.transporterId,
        'name': 'Ahmed El Mansouri',
        'email': 'ahmed@example.com',
        'phone': '+212 XXX XXX XXX',
        'rating': 4.8,
        'reviewsCount': 142,
        'tripsCount': 89,
        'memberSince': '2023',
        'isVerified': true,
        'vehicleType': 'Van',
        'bio': 'Professional transporter with 5 years of experience. Specialized in fragile items and international routes.',
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Transporter Profile', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFFF9500),
                        child: Text(
                          _transporter!['name'].toString().substring(0, 1),
                          style: const TextStyle(fontSize: 36, color: Colors.white),
                        ),
                      ),
                      if (_transporter!['isVerified'])
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 16, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _transporter!['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 20, color: Color(0xFFFBBF24)),
                      const SizedBox(width: 4),
                      Text(
                        '${_transporter!['rating']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' (${_transporter!['reviewsCount']} reviews)',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('${_transporter!['tripsCount']}', 'Trips'),
                      _buildStat(_transporter!['memberSince'], 'Since'),
                      _buildStat(_transporter!['vehicleType'], 'Vehicle'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _transporter!['bio'],
                    style: const TextStyle(color: Color(0xFF6B7280), height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Reviews',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/transporter-reviews/${widget.transporterId}');
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildReviewItem('Great transporter!', 5, 'John D.', '2 days ago'),
                  const Divider(),
                  _buildReviewItem('Professional and on time', 5, 'Sarah K.', '1 week ago'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.message),
                      label: const Text('Message'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildReviewItem(String comment, int rating, String author, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: const Color(0xFFFBBF24),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(color: Color(0xFF374151))),
          const SizedBox(height: 4),
          Text(
            '- $author',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
