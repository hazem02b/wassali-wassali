import 'package:flutter/material.dart';

class TransporterReviewsPage extends StatelessWidget {
  final int transporterId;

  const TransporterReviewsPage({
    super.key,
    required this.transporterId,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch reviews from API
    final reviews = [
      {
        'id': 1,
        'author': 'John Doe',
        'rating': 5,
        'comment': 'Excellent service! Very professional and my package arrived safely and on time.',
        'date': '2024-01-20',
        'route': 'Casablanca → Paris',
      },
      {
        'id': 2,
        'author': 'Sarah Smith',
        'rating': 5,
        'comment': 'Great communication throughout the journey. Highly recommended!',
        'date': '2024-01-18',
        'route': 'Rabat → London',
      },
      {
        'id': 3,
        'author': 'Mohammed Ali',
        'rating': 4,
        'comment': 'Good experience overall. Package was well taken care of.',
        'date': '2024-01-15',
        'route': 'Marrakech → Brussels',
      },
    ];

    final averageRating = 4.8;
    final totalReviews = 142;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Reviews', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  averageRating.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < averageRating.floor() ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFBBF24),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on $totalReviews reviews',
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 16),
                _buildRatingBar(5, 120),
                _buildRatingBar(4, 18),
                _buildRatingBar(3, 3),
                _buildRatingBar(2, 1),
                _buildRatingBar(1, 0),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF0066FF),
                              child: Text(
                                review['author'].toString().substring(0, 1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review['author'].toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    review['route'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
                                  const SizedBox(width: 4),
                                  Text(
                                    review['rating'].toString(),
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          review['comment'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF374151),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          review['date'].toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Row(
              children: [
                Text(
                  '$stars',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, size: 16, color: Color(0xFFFBBF24)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: count / 142,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
