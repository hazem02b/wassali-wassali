import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String type; // 'client' ou 'transporter'
  final bool verified;
  final String? avatar;
  final double? rating;
  final int? reviews;
  final int totalBookings;
  final double totalSpent;
  final int? totalTrips; // Pour transporteurs
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.type,
    this.verified = false,
    this.avatar,
    this.rating,
    this.reviews,
    this.totalBookings = 0,
    this.totalSpent = 0,
    this.totalTrips,
    required this.createdAt,
  });

  // Créer depuis Firestore
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      type: data['type'] ?? 'client',
      verified: data['verified'] ?? false,
      avatar: data['avatar'],
      rating: data['rating']?.toDouble(),
      reviews: data['reviews'],
      totalBookings: data['totalBookings'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      totalTrips: data['totalTrips'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Créer depuis Map
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      type: data['type'] ?? 'client',
      verified: data['verified'] ?? false,
      avatar: data['avatar'],
      rating: data['rating']?.toDouble(),
      reviews: data['reviews'],
      totalBookings: data['totalBookings'] ?? 0,
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      totalTrips: data['totalTrips'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convertir en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'type': type,
      'verified': verified,
      'avatar': avatar,
      'rating': rating,
      'reviews': reviews,
      'totalBookings': totalBookings,
      'totalSpent': totalSpent,
      if (totalTrips != null) 'totalTrips': totalTrips,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Getters
  bool get isTransporter => type == 'transporter';
  bool get isClient => type == 'client';
  String get initials {
    final parts = name.split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // Copy with
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? type,
    bool? verified,
    String? avatar,
    double? rating,
    int? reviews,
    int? totalBookings,
    double? totalSpent,
    int? totalTrips,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      verified: verified ?? this.verified,
      avatar: avatar ?? this.avatar,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      totalBookings: totalBookings ?? this.totalBookings,
      totalSpent: totalSpent ?? this.totalSpent,
      totalTrips: totalTrips ?? this.totalTrips,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
