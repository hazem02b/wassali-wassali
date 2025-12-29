/// Modèle User - Correspond au backend User model
class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String role; // 'client' ou 'transporter'
  final String? address;
  final String? city;
  final String? country;
  final String? photoUrl;
  final bool? isVerified;
  final double? rating;
  final int? totalTrips;
  final int? completedTrips;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.role,
    this.address,
    this.city,
    this.country,
    this.photoUrl,
    this.isVerified,
    this.rating,
    this.totalTrips,
    this.completedTrips,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      photoUrl: json['photo_url'] as String?,
      isVerified: json['is_verified'] as bool?,
      rating: json['rating']?.toDouble(),
      totalTrips: json['total_trips'] as int?,
      completedTrips: json['completed_trips'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'role': role,
      'address': address,
      'city': city,
      'country': country,
      'photo_url': photoUrl,
      'is_verified': isVerified,
      'rating': rating,
      'total_trips': totalTrips,
      'completed_trips': completedTrips,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? role,
    String? address,
    String? city,
    String? country,
    String? photoUrl,
    bool? isVerified,
    double? rating,
    int? totalTrips,
    int? completedTrips,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      photoUrl: photoUrl ?? this.photoUrl,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      completedTrips: completedTrips ?? this.completedTrips,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
