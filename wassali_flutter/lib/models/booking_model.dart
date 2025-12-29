import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String tripId;
  final String clientId;
  final String clientName;
  final String? clientPhone;
  final String transporterId;
  final String transporterName;
  final String from;
  final String to;
  final DateTime tripDate;
  final String packageDescription;
  final double weight;
  final double pricePerKg;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'in_transit', 'delivered', 'cancelled'
  final String paymentMethod;
  final bool paymentCompleted;
  final bool hasInsurance;
  final String? pickupAddress;
  final String? deliveryAddress;
  final String? trackingNumber;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.tripId,
    required this.clientId,
    required this.clientName,
    this.clientPhone,
    required this.transporterId,
    required this.transporterName,
    required this.from,
    required this.to,
    required this.tripDate,
    required this.packageDescription,
    required this.weight,
    required this.pricePerKg,
    required this.totalPrice,
    this.status = 'pending',
    this.paymentMethod = 'cash',
    this.paymentCompleted = false,
    this.hasInsurance = false,
    this.pickupAddress,
    this.deliveryAddress,
    this.trackingNumber,
    this.cancelReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      tripId: data['tripId'] ?? '',
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      clientPhone: data['clientPhone'],
      transporterId: data['transporterId'] ?? '',
      transporterName: data['transporterName'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      tripDate: (data['tripDate'] as Timestamp).toDate(),
      packageDescription: data['packageDescription'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'cash',
      paymentCompleted: data['paymentCompleted'] ?? false,
      hasInsurance: data['hasInsurance'] ?? false,
      pickupAddress: data['pickupAddress'],
      deliveryAddress: data['deliveryAddress'],
      trackingNumber: data['trackingNumber'],
      cancelReason: data['cancelReason'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory BookingModel.fromMap(Map<String, dynamic> data, String id) {
    return BookingModel(
      id: id,
      tripId: data['tripId'] ?? '',
      clientId: data['clientId'] ?? '',
      clientName: data['clientName'] ?? '',
      clientPhone: data['clientPhone'],
      transporterId: data['transporterId'] ?? '',
      transporterName: data['transporterName'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      tripDate: (data['tripDate'] as Timestamp).toDate(),
      packageDescription: data['packageDescription'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? 'cash',
      paymentCompleted: data['paymentCompleted'] ?? false,
      hasInsurance: data['hasInsurance'] ?? false,
      pickupAddress: data['pickupAddress'],
      deliveryAddress: data['deliveryAddress'],
      trackingNumber: data['trackingNumber'],
      cancelReason: data['cancelReason'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'clientId': clientId,
      'clientName': clientName,
      'clientPhone': clientPhone,
      'transporterId': transporterId,
      'transporterName': transporterName,
      'from': from,
      'to': to,
      'tripDate': Timestamp.fromDate(tripDate),
      'packageDescription': packageDescription,
      'weight': weight,
      'pricePerKg': pricePerKg,
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentCompleted': paymentCompleted,
      'hasInsurance': hasInsurance,
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'trackingNumber': trackingNumber,
      'cancelReason': cancelReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInTransit => status == 'in_transit';
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';

  BookingModel copyWith({
    String? id,
    String? tripId,
    String? clientId,
    String? clientName,
    String? clientPhone,
    String? transporterId,
    String? transporterName,
    String? from,
    String? to,
    DateTime? tripDate,
    String? packageDescription,
    double? weight,
    double? pricePerKg,
    double? totalPrice,
    String? status,
    String? paymentMethod,
    bool? paymentCompleted,
    bool? hasInsurance,
    String? pickupAddress,
    String? deliveryAddress,
    String? trackingNumber,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      transporterId: transporterId ?? this.transporterId,
      transporterName: transporterName ?? this.transporterName,
      from: from ?? this.from,
      to: to ?? this.to,
      tripDate: tripDate ?? this.tripDate,
      packageDescription: packageDescription ?? this.packageDescription,
      weight: weight ?? this.weight,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
