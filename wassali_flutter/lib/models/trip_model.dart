import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  final String id;
  final String transporterId;
  final String transporterName;
  final String? transporterAvatar;
  final double? transporterRating;
  final bool transporterVerified;
  final String from;
  final String to;
  final DateTime date;
  final String time;
  final double pricePerKg;
  final int totalCapacity;
  final int availableCapacity;
  final String status; // 'active', 'completed', 'cancelled'
  final List<String> transportableItems;
  final String? specialNotes;
  final bool isNegotiable;
  final bool hasInsurance;
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.transporterId,
    required this.transporterName,
    this.transporterAvatar,
    this.transporterRating,
    this.transporterVerified = false,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.pricePerKg,
    required this.totalCapacity,
    required this.availableCapacity,
    this.status = 'active',
    this.transportableItems = const [],
    this.specialNotes,
    this.isNegotiable = false,
    this.hasInsurance = false,
    required this.createdAt,
  });

  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TripModel(
      id: doc.id,
      transporterId: data['transporterId'] ?? '',
      transporterName: data['transporterName'] ?? '',
      transporterAvatar: data['transporterAvatar'],
      transporterRating: data['transporterRating']?.toDouble(),
      transporterVerified: data['transporterVerified'] ?? false,
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      totalCapacity: data['totalCapacity'] ?? 0,
      availableCapacity: data['availableCapacity'] ?? 0,
      status: data['status'] ?? 'active',
      transportableItems: List<String>.from(data['transportableItems'] ?? []),
      specialNotes: data['specialNotes'],
      isNegotiable: data['isNegotiable'] ?? false,
      hasInsurance: data['hasInsurance'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory TripModel.fromMap(Map<String, dynamic> data, String id) {
    return TripModel(
      id: id,
      transporterId: data['transporterId'] ?? '',
      transporterName: data['transporterName'] ?? '',
      transporterAvatar: data['transporterAvatar'],
      transporterRating: data['transporterRating']?.toDouble(),
      transporterVerified: data['transporterVerified'] ?? false,
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      totalCapacity: data['totalCapacity'] ?? 0,
      availableCapacity: data['availableCapacity'] ?? 0,
      status: data['status'] ?? 'active',
      transportableItems: List<String>.from(data['transportableItems'] ?? []),
      specialNotes: data['specialNotes'],
      isNegotiable: data['isNegotiable'] ?? false,
      hasInsurance: data['hasInsurance'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transporterId': transporterId,
      'transporterName': transporterName,
      'transporterAvatar': transporterAvatar,
      'transporterRating': transporterRating,
      'transporterVerified': transporterVerified,
      'from': from,
      'to': to,
      'date': Timestamp.fromDate(date),
      'time': time,
      'pricePerKg': pricePerKg,
      'totalCapacity': totalCapacity,
      'availableCapacity': availableCapacity,
      'status': status,
      'transportableItems': transportableItems,
      'specialNotes': specialNotes,
      'isNegotiable': isNegotiable,
      'hasInsurance': hasInsurance,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Getters
  int get capacityPercentage =>
      totalCapacity > 0
          ? ((totalCapacity - availableCapacity) / totalCapacity * 100).round()
          : 0;

  bool get isFull => availableCapacity <= 0;
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  TripModel copyWith({
    String? id,
    String? transporterId,
    String? transporterName,
    String? transporterAvatar,
    double? transporterRating,
    bool? transporterVerified,
    String? from,
    String? to,
    DateTime? date,
    String? time,
    double? pricePerKg,
    int? totalCapacity,
    int? availableCapacity,
    String? status,
    List<String>? transportableItems,
    String? specialNotes,
    bool? isNegotiable,
    bool? hasInsurance,
    DateTime? createdAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      transporterId: transporterId ?? this.transporterId,
      transporterName: transporterName ?? this.transporterName,
      transporterAvatar: transporterAvatar ?? this.transporterAvatar,
      transporterRating: transporterRating ?? this.transporterRating,
      transporterVerified: transporterVerified ?? this.transporterVerified,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      time: time ?? this.time,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      totalCapacity: totalCapacity ?? this.totalCapacity,
      availableCapacity: availableCapacity ?? this.availableCapacity,
      status: status ?? this.status,
      transportableItems: transportableItems ?? this.transportableItems,
      specialNotes: specialNotes ?? this.specialNotes,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      hasInsurance: hasInsurance ?? this.hasInsurance,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
