// user_model.dart - Modèle utilisateur
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
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool get isTransporter => type == 'transporter';
  bool get isClient => type == 'client';
}
