import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';

class LeaveReviewPage extends StatefulWidget {
  final int bookingId;
  final int transporterId;
  final String transporterName;

  const LeaveReviewPage({
    super.key,
    required this.bookingId,
    required this.transporterId,
    required this.transporterName,
  });

  @override
  State<LeaveReviewPage> createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _alreadyReviewed = false;
  bool _checkingReview = true;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyReviewed();
  }

  Future<void> _checkIfAlreadyReviewed() async {
    try {
      final apiService = ApiService();
      final booking = await apiService.getBookingById(widget.bookingId);
      
      if (mounted) {
        setState(() {
          _alreadyReviewed = booking['has_review'] == true;
          _checkingReview = false;
        });
        
        // Si déjà reviewé, rediriger immédiatement
        if (_alreadyReviewed) {
          Future.delayed(Duration.zero, () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vous avez déjà laissé un avis pour cette réservation'),
                  backgroundColor: Colors.orange,
                ),
              );
              context.go('/my-bookings');
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _checkingReview = false);
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une note')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final apiService = ApiService();
      await apiService.createReview(
        bookingId: widget.bookingId,
        transporterId: widget.transporterId,
        rating: _rating,
        comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Avis soumis avec succès !'),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      context.go('/my-bookings');
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isSubmitting = false);
      
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
    if (_checkingReview || _alreadyReviewed) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Leave a Review', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How was your experience?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Rate your trip with ${widget.transporterName}',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 16),
            ),
            const SizedBox(height: 32),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    iconSize: 48,
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFBBF24),
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ),
            if (_rating > 0)
              Center(
                child: Text(
                  _getRatingText(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0066FF),
                  ),
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              'Tell us more about your experience',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _commentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Share details about your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0066FF)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Rate different aspects',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildAspectRating('Communication', Icons.chat_bubble_outline),
            const SizedBox(height: 12),
            _buildAspectRating('Punctuality', Icons.access_time),
            const SizedBox(height: 12),
            _buildAspectRating('Package Care', Icons.inventory_2_outlined),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Review',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  Widget _buildAspectRating(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B7280)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                Icons.star_border,
                size: 20,
                color: const Color(0xFFD1D5DB),
              );
            }),
          ),
        ],
      ),
    );
  }
}
