import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service API - COPIE EXACTE du web (api.service.ts)
/// Base URL: http://localhost:8000/api/v1
class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  
  // EXACTEMENT comme le web: BASE_URL = 'http://localhost:8000/api/v1'
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1'; // Android emulator

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          followRedirects: true,
          maxRedirects: 5,
          headers: {
            'Content-Type': 'application/json',
          },
        )),
        _storage = const FlutterSecureStorage() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'token');
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
        
        // Auto-déconnexion si 401
        if (error.response?.statusCode == 401) {
          await _storage.delete(key: 'token');
        }
        
        return handler.next(error);
      },
    ));
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      return data['detail']?.toString() ?? 'Erreur serveur';
    }
    return e.message ?? 'Erreur réseau';
  }

  // ==================== AUTHENTICATION ====================
  // EXACTEMENT comme le web: /auth/login

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'role': role,
      });
      
      // Sauvegarder le token EXACTEMENT comme le web: localStorage.setItem('token', ...)
      await _storage.write(key: 'token', value: response.data['access_token']);
      
      // Sauvegarder les infos utilisateur pour getCurrentUser()
      if (response.data['user'] != null) {
        await _storage.write(key: 'user_name', value: response.data['user']['name']);
        await _storage.write(key: 'user_email', value: response.data['user']['email']);
        await _storage.write(key: 'user_role', value: response.data['user']['role']);
      }
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Récupérer les infos utilisateur stockées localement
  Future<Map<String, dynamic>> getCurrentUserLocal() async {
    final name = await _storage.read(key: 'user_name');
    final email = await _storage.read(key: 'user_email');
    final role = await _storage.read(key: 'user_role');
    
    return {
      'name': name ?? 'Guest',
      'email': email ?? '',
      'role': role ?? '',
    };
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'role': role,
      });
      
      await _storage.write(key: 'token', value: response.data['access_token']);
      
      if (response.data['user'] != null) {
        await _storage.write(key: 'user_name', value: '${response.data['user']['first_name']} ${response.data['user']['last_name']}');
        await _storage.write(key: 'user_email', value: response.data['user']['email']);
        await _storage.write(key: 'user_role', value: response.data['user']['role']);
      }
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  // ==================== TRIPS ====================

  Future<List<Map<String, dynamic>>> getTrips() async {
    try {
      final response = await _dio.get('/trips/');
      if (response.data is List) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getTripById(int id) async {
    try {
      final response = await _dio.get('/trips/$id');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== BOOKINGS ====================
  // EXACTEMENT comme le web: API_CONFIG.ENDPOINTS.MY_BOOKINGS = '/bookings/my'

  Future<List<Map<String, dynamic>>> getMyBookings() async {
    try {
      final response = await _dio.get('/bookings/my');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getBookingById(int bookingId) async {
    try {
      final response = await _dio.get('/bookings/$bookingId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createBooking({
    required int tripId,
    required double weight,
    String? packageDescription,
    String? pickupAddress,
    String? deliveryAddress,
    String? pickupPhone,
    String? deliveryPhone,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/bookings/', data: {
        'trip_id': tripId,
        'weight': weight,
        if (packageDescription != null) 'package_description': packageDescription,
        if (pickupAddress != null) 'pickup_address': pickupAddress,
        if (deliveryAddress != null) 'delivery_address': deliveryAddress,
        if (pickupPhone != null) 'pickup_phone': pickupPhone,
        if (deliveryPhone != null) 'delivery_phone': deliveryPhone,
        if (notes != null) 'notes': notes,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== TRIPS ====================
  // EXACTEMENT comme le web: /trips/search

  Future<List<Map<String, dynamic>>> searchTrips({
    String? originCity,
    String? destinationCity,
    DateTime? departureDate,
    double? maxPrice,
  }) async {
    try {
      final response = await _dio.get('/trips/search', queryParameters: {
        if (originCity != null) 'origin_city': originCity,
        if (destinationCity != null) 'destination_city': destinationCity,
        if (departureDate != null) 'departure_date': departureDate.toIso8601String(),
        if (maxPrice != null) 'max_price': maxPrice,
      });
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getTripDetails(int tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== TRANSPORTER ====================

  Future<Map<String, dynamic>> registerTransporter({
    required String email,
    required String name,
    required String phone,
    required String password,
    required String vehicleType,
  }) async {
    try {
      final response = await _dio.post('/auth/register/transporter', data: {
        'email': email,
        'name': name,
        'phone': phone,
        'password': password,
        'vehicle_type': vehicleType,
      });
      
      await _storage.write(key: 'token', value: response.data['access_token']);
      
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createTrip({
    required String originCity,
    required String originCountry,
    required String destinationCity,
    required String destinationCountry,
    required DateTime departureDate,
    DateTime? arrivalDate,
    required double maxWeight,
    required double pricePerKg,
    String? vehicleInfo,
    String? description,
  }) async {
    try {
      final response = await _dio.post('/trips/', data: {
        'origin_city': originCity,
        'origin_country': originCountry,
        'destination_city': destinationCity,
        'destination_country': destinationCountry,
        'departure_date': departureDate.toIso8601String(),
        if (arrivalDate != null) 'arrival_date': arrivalDate.toIso8601String(),
        'max_weight': maxWeight,
        'price_per_kg': pricePerKg,
        'available_weight': maxWeight,
        if (vehicleInfo != null) 'vehicle_info': vehicleInfo,
        if (description != null) 'description': description,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }int tripId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/trips/$tripId', data: updates);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<List<Map<String, dynamic>>> getMyTrips() async {
    try {
      final response = await _dio.get('/trips/my-trips');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList() null) 'vehicle_info': vehicleType,
        if (description != null) 'description': description,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteTrip(int id) async {
    try {
      await _dio.delete('/trips/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== BOOKINGS MANAGEMENT ====================

  Future<Map<String, dynamic>> updateBooking({
    required int id,
    String? status,
  }) async {
    try {
      final response = await _dio.put('/bookings/$id', data: {
        if (status != null) 'status': status,int bookingId, Map<String, dynamic> updates) async {
    try {
      final response = await _dio.put('/bookings/$bookingId', data: updates
  Future<Map<String, dynamic>> acceptBooking(int id) async {
    return updateBooking(id: id, status: 'confirmed');
  }

  Future<Map<String, dynamic>> rejectBooking(int id) async {
    return updateBooking(id: id, status: 'cancelled');
  }

  Future<Map<String, dynamic>> startDelivery(int id) async {
    return updateBooking(id: id, status: 'in_transit');
  }

  Future<Map<String, dynamic>> markAsDelivered(int id) async {
    return updateBooking(id: id, status: 'delivered');
  }

  // ==================== PROFILE ====================

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _dio.put('/users/me', data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
      });
      
      // MetfirstName,
    String? lastName,
    String? phone,
    String? address,
    String? city,
    String? country,
  }) async {
    try {
      final response = await _dio.put('/users/me', data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (country != null) 'country': country,
      });
      
      // Mettre à jour le cache local
      if (firstName != null && lastName != null) {
        await _storage.write(key: 'user_name', value: '$firstName $lastName'
    required String email,
    required String userType,
  }) async {
    try {
      await _dio.post('/auth/forgot-password', data: {
        'email': email,
        'user_type': userType,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String userType,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post('/auth/reset-password', data: {
        'email': email,
        'user_type': userType,
        'reset_code': code,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> changoldPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.post('/auth/change-password', data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // ==================== NOTIFICATIONS ====================
  
  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final response = await _dio.get('/notifications/');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      await _dio.put('/notifications/$notificationId/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> markAllNotificationsAsRead() async {
    try {
      await _dio.put('/notifications/mark-all-read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _dio.delete('/notifications/$notificationId' 'new_password': newPassword,
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== STATISTICS ====================

  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await _dio.get('/users/me/stats');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ==================== REVIEWS ====================

  Future<Map<String, dynamic>> createReview({
    required int bookingId,
    required int transporterId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await _dio.post('/reviews/', data: {
        'booking_id': bookingId,
        'transporter_id': transporterId,
        'rating': rating,
        'comment': comment,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getTransporterReviews(int transporterId) async {
    try {
      final response = await _dio.get('/reviews/transporter/$transporterId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getMyReviews() async {
    try {
      final response = await _dio.get('/reviews/my-reviews');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>?> getBookingReview(int bookingId) async {
    try {
      final response = await _dio.get('/reviews/booking/$bookingId');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // Retourner null si pas de review trouvée
      return null;
    }
  }

  // ==================== MESSAGING ====================

  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final response = await _dio.get('/messages/conversations');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getConversationMessages(String conversationId) async {
    try {
      final response = await _dio.get('/messages/$conversationId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendMessage({
    required int receiverId,
    required String content,
  }) async {
    try {
      final response = await _dio.post('/messages/', data: {
        'receiver_id': receiverId,
        'content': content,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markMessageAsRead(int messageId) async {
    try {
      await _dio.put('/messages/$messageId/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _dio.delete('/messages/$conversationId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}
