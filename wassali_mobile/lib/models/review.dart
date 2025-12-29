import 'user.dart';

/// Modèle Review - Correspond au backend Review model
class Review {
  final int id;
  final int bookingId;
  final int clientId;
  final int transporterId;
  final int rating; // 1-5
  final String? comment;
  final DateTime createdAt;
  final User? client;

  Review({
    required this.id,
    required this.bookingId,
    required this.clientId,
    required this.transporterId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.client,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as int,
      bookingId: json['booking_id'] as int,
      clientId: json['client_id'] as int,
      transporterId: json['transporter_id'] as int,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      client: json['client'] != null
          ? User.fromJson(json['client'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'client_id': clientId,
      'transporter_id': transporterId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      if (client != null) 'client': client!.toJson(),
    };
  }
}
