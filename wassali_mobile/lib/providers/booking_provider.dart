import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/api_service.dart';

/// Provider pour gérer les réservations
class BookingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Booking> _bookings = [];
  Booking? _selectedBooking;
  bool _isLoading = false;
  String? _error;

  List<Booking> get bookings => _bookings;
  Booking? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Créer une nouvelle réservation
  Future<bool> createBooking({
    required int tripId,
    required double weight,
    String? packageDescription,
    String? pickupAddress,
    String? deliveryAddress,
    String? pickupPhone,
    String? deliveryPhone,
    String? notes,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newBooking = await _apiService.createBooking(
        tripId: tripId,
        weight: weight,
        packageDescription: packageDescription,
        pickupAddress: pickupAddress,
        deliveryAddress: deliveryAddress,
        pickupPhone: pickupPhone,
        deliveryPhone: deliveryPhone,
        notes: notes,
      );

      _selectedBooking = Booking.fromJson(newBooking);
      _bookings.insert(0, _selectedBooking!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Récupérer toutes les réservations de l'utilisateur
  Future<void> fetchMyBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _apiService.getMyBookings();
      _bookings = (results as List)
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Récupérer une réservation par ID
  Future<void> fetchBookingById(int bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final booking = await _apiService.getBookingById(bookingId);
      _selectedBooking = Booking.fromJson(booking);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Annuler une réservation
  Future<bool> cancelBooking(int bookingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedBooking = await _apiService.updateBooking(
        bookingId,
        {'status': 'cancelled'},
      );

      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = Booking.fromJson(updatedBooking);
      }

      if (_selectedBooking?.id == bookingId) {
        _selectedBooking = Booking.fromJson(updatedBooking);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Mettre à jour le statut d'une réservation (transporteur)
  Future<bool> updateBookingStatus(int bookingId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedBooking = await _apiService.updateBooking(
        bookingId,
        {'status': status},
      );

      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _bookings[index] = Booking.fromJson(updatedBooking);
      }

      if (_selectedBooking?.id == bookingId) {
        _selectedBooking = Booking.fromJson(updatedBooking);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearBookings() {
    _bookings = [];
    _selectedBooking = null;
    notifyListeners();
  }

  void setSelectedBooking(Booking? booking) {
    _selectedBooking = booking;
    notifyListeners();
  }
}
