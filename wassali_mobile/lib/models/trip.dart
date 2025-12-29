import 'user.dart';

/// Modèle Trip - Correspond au backend Trip model
class Trip {
  final int id;
  final int transporterId;
  final String originCity;
  final String originCountry;
  final String destinationCity;
  final String destinationCountry;
  final DateTime departureDate;
  final DateTime? arrivalDate;
  final double maxWeight;
  final double availableWeight;
  final double pricePerKg;
  final String? description;
  final String? vehicleInfo;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final User? transporter;

  Trip({
    required this.id,
    required this.transporterId,
    required this.originCity,
    required this.originCountry,
    required this.destinationCity,
    required this.destinationCountry,
    required this.departureDate,
    this.arrivalDate,
    required this.maxWeight,
    required this.availableWeight,
    required this.pricePerKg,
    this.description,
    this.vehicleInfo,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.transporter,
  });

  bool get isAvailable => status == 'active' && availableWeight > 0;
  
  String get route => '$originCity → $destinationCity';

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as int,
      transporterId: json['transporter_id'] as int,
      originCity: json['origin_city'] as String,
      originCountry: json['origin_country'] as String,
      destinationCity: json['destination_city'] as String,
      destinationCountry: json['destination_country'] as String,
      departureDate: DateTime.parse(json['departure_date'] as String),
      arrivalDate: json['arrival_date'] != null
          ? DateTime.parse(json['arrival_date'] as String)
          : null,
      maxWeight: (json['max_weight'] as num).toDouble(),
      availableWeight: (json['available_weight'] as num).toDouble(),
      pricePerKg: (json['price_per_kg'] as num).toDouble(),
      description: json['description'] as String?,
      vehicleInfo: json['vehicle_info'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      transporter: json['transporter'] != null
          ? User.fromJson(json['transporter'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transporter_id': transporterId,
      'origin_city': originCity,
      'origin_country': originCountry,
      'destination_city': destinationCity,
      'destination_country': destinationCountry,
      'departure_date': departureDate.toIso8601String(),
      'arrival_date': arrivalDate?.toIso8601String(),
      'max_weight': maxWeight,
      'available_weight': availableWeight,
      'price_per_kg': pricePerKg,
      'description': description,
      'vehicle_info': vehicleInfo,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (transporter != null) 'transporter': transporter!.toJson(),
    };
  }
}
