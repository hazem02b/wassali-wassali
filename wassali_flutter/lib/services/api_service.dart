import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service API pour communiquer avec le backend FastAPI
/// Base URL: http://localhost:8000/api/v1
class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; // Pour Android emulator
  // Pour device réel, utilisez: 'http://VOTRE_IP:8000/api/v1'

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        )),
        _storage = const FlutterSecureStorage() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Ajouter le token d'authentification
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('📤 ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('❌ ${error.response?.statusCode} ${error.requestOptions.path}');
        print('Error: ${error.response?.data}');
        
        // Si le token est invalide (401 Unauthorized), supprimer le token
        if (error.response?.statusCode == 401) {
          final data = error.response?.data;
          if (data is Map && data['detail']?.toString().contains('Could not validate credentials') == true) {
            print('🔑 Token invalide - Suppression du token');
            await _storage.delete(key: 'access_token');
          }
        }
        
        return handler.next(error);
      },
    ));
  }

  // ==================== AUTHENTICATION ====================

  /// Inscription client
  Future<Map<String, dynamic>> registerClient({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register/client', data: {
        'email': email,
        'name': name,
        'phone': phone,
        'password': password,
      });
      
      // Sauvegarder le token
      await _storage.write(
        key: 'access_token',
        value: response.data['access_token'],
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Inscription transporteur
  Future<Map<String, dynamic>> registerTransporter({
    required String email,
    required String name,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register/transporter', data: {
        'email': email,
        'name': name,
        'phone': phone,
        'password': password,
      });
      
      await _storage.write(
        key: 'access_token',
        value: response.data['access_token'],
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Connexion
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role, // 'client' ou 'transporter'
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'role': role,
      });
      
      await _storage.write(
        key: 'access_token',
        value: response.data['access_token'],
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mot de passe oublié - Envoie un code par email
  Future<void> forgotPassword({
    required String email,
    required String role,
  }) async {
    try {
      await _dio.post('/auth/forgot-password', data: {
        'email': email,
        'role': role,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Réinitialiser le mot de passe avec le code
  Future<void> resetPassword({
    required String email,
    required String role,
    required String resetCode,
    required String newPassword,
  }) async {
    try {
      await _dio.post('/auth/reset-password', data: {
        'email': email,
        'role': role,
        'reset_code': resetCode,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Récupérer les infos de l'utilisateur connecté
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mettre à jour le profil
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? avatarUrl,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (address != null) data['address'] = address;
      if (avatarUrl != null) data['avatar_url'] = avatarUrl;

      final response = await _dio.put('/auth/me', data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Changer le mot de passe
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.put('/auth/change-password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  // ==================== TRIPS ====================

  /// Récupérer tous les trajets
  Future<List<dynamic>> getTrips() async {
    try {
      final response = await _dio.get('/trips');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Rechercher des trajets
  Future<List<dynamic>> searchTrips({
    String? originCity,
    String? destinationCity,
    DateTime? departureDate,
  }) async {
    try {
      final params = <String, dynamic>{};
      if (originCity != null) params['origin_city'] = originCity;
      if (destinationCity != null) params['destination_city'] = destinationCity;
      if (departureDate != null) {
        params['departure_date'] = departureDate.toIso8601String();
      }

      final response = await _dio.get('/trips/search', queryParameters: params);
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Créer un trajet (transporteur)
  Future<Map<String, dynamic>> createTrip({
    required String originCity,
    required String originCountry,
    required String destinationCity,
    required String destinationCountry,
    required DateTime departureDate,
    DateTime? arrivalDate,
    required double maxWeight,
    required double pricePerKg,
    String? description,
    List<String>? acceptedItems,
    String? vehicleInfo,
  }) async {
    try {
      final response = await _dio.post('/trips', data: {
        'origin_city': originCity,
        'origin_country': originCountry,
        'destination_city': destinationCity,
        'destination_country': destinationCountry,
        'departure_date': departureDate.toIso8601String(),
        'arrival_date': arrivalDate?.toIso8601String(),
        'max_weight': maxWeight,
        'price_per_kg': pricePerKg,
        'description': description,
        'accepted_items': acceptedItems,
        'vehicle_info': vehicleInfo,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== BOOKINGS ====================

  /// Récupérer mes réservations (client)
  Future<List<dynamic>> getMyBookings() async {
    try {
      final response = await _dio.get('/bookings/my');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Créer une réservation
  Future<Map<String, dynamic>> createBooking({
    required int tripId,
    required double weight,
    required String pickupAddress,
    required String deliveryAddress,
    String? packageDescription,
  }) async {
    try {
      final response = await _dio.post('/bookings', data: {
        'trip_id': tripId,
        'weight': weight,
        'pickup_address': pickupAddress,
        'delivery_address': deliveryAddress,
        'package_description': packageDescription,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== ERROR HANDLING ====================

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
      return 'Erreur: ${error.response!.statusCode}';
    } else {
      return 'Erreur de connexion au serveur';
    }
  }
}
