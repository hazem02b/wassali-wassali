// trip_model.dart - Modèle de trajet
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
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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

  int get capacityPercentage => 
      ((totalCapacity - availableCapacity) / totalCapacity * 100).round();
}
