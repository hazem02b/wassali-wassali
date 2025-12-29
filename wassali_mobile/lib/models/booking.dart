import 'user.dart';
import 'trip.dart';

/// Modèle Booking - Correspond au backend Booking model
class Booking {
  final int id;
  final int tripId;
  final int clientId;
  final double weight;
  final String? packageDescription;
  final double totalPrice;
  final String status; // 'pending', 'accepted', 'in_transit', 'delivered', 'cancelled'
  final String? trackingNumber;
  final String? pickupAddress;
  final String? deliveryAddress;
  final String? pickupPhone;
  final String? deliveryPhone;
  final String? notes;
  final DateTime? deliveredAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Trip? trip;
  final User? client;

  Booking({
    required this.id,
    required this.tripId,
    required this.clientId,
    required this.weight,
    this.packageDescription,
    required this.totalPrice,
    required this.status,
    this.trackingNumber,
    this.pickupAddress,
    this.deliveryAddress,
    this.pickupPhone,
    this.deliveryPhone,
    this.notes,
    this.deliveredAt,
    required this.createdAt,
    this.updatedAt,
    this.trip,
    this.client,
  });

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'accepted':
        return 'Accepté';
      case 'in_transit':
        return 'En transit';
      case 'delivered':
        return 'Livré';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  bool get canCancel => status == 'pending' || status == 'accepted';
  bool get canReview => status == 'delivered';

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      tripId: json['trip_id'] as int,
      clientId: json['client_id'] as int,
      weight: (json['weight'] as num).toDouble(),
      packageDescription: json['package_description'] as String?,
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as String,
      trackingNumber: json['tracking_number'] as String?,
      pickupAddress: json['pickup_address'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      pickupPhone: json['pickup_phone'] as String?,
      deliveryPhone: json['delivery_phone'] as String?,
      notes: json['notes'] as String?,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      trip: json['trip'] != null
          ? Trip.fromJson(json['trip'] as Map<String, dynamic>)
          : null,
      client: json['client'] != null
          ? User.fromJson(json['client'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trip_id': tripId,
      'client_id': clientId,
      'weight': weight,
      'package_description': packageDescription,
      'total_price': totalPrice,
      'status': status,
      'tracking_number': trackingNumber,
      'pickup_address': pickupAddress,
      'delivery_address': deliveryAddress,
      'pickup_phone': pickupPhone,
      'delivery_phone': deliveryPhone,
      'notes': notes,
      'delivered_at': deliveredAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (trip != null) 'trip': trip!.toJson(),
      if (client != null) 'client': client!.toJson(),
    };
  }
}
