import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../services/api_service.dart';

/// Provider pour gérer les trajets
class TripProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Trip> _trips = [];
  Trip? _selectedTrip;
  bool _isLoading = false;
  String? _error;

  List<Trip> get trips => _trips;
  Trip? get selectedTrip => _selectedTrip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Rechercher des trajets
  Future<void> searchTrips({
    String? originCity,
    String? destinationCity,
    DateTime? departureDate,
    double? maxPrice,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _apiService.searchTrips(
        originCity: originCity,
        destinationCity: destinationCity,
        departureDate: departureDate,
        maxPrice: maxPrice,
      );

      _trips = (results as List)
          .map((json) => Trip.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Récupérer un trajet par ID
  Future<void> fetchTripById(int tripId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final trip = await _apiService.getTripById(tripId);
      _selectedTrip = Trip.fromJson(trip);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Créer un nouveau trajet (transporteur)
  Future<bool> createTrip({
    required String originCity,
    required String originCountry,
    required String destinationCity,
    required String destinationCountry,
    required DateTime departureDate,
    DateTime? arrivalDate,
    required double maxWeight,
    required double pricePerKg,
    String? description,
    String? vehicleInfo,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTrip = await _apiService.createTrip(
        originCity: originCity,
        originCountry: originCountry,
        destinationCity: destinationCity,
        destinationCountry: destinationCountry,
        departureDate: departureDate,
        arrivalDate: arrivalDate,
        maxWeight: maxWeight,
        pricePerKg: pricePerKg,
        description: description,
        vehicleInfo: vehicleInfo,
      );

      _trips.insert(0, Trip.fromJson(newTrip));
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

  /// Récupérer les trajets du transporteur
  Future<void> fetchMyTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _apiService.getMyTrips();
      _trips = (results as List)
          .map((json) => Trip.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mettre à jour un trajet
  Future<bool> updateTrip(int tripId, Map<String, dynamic> updates) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedTrip = await _apiService.updateTrip(tripId, updates);
      
      final index = _trips.indexWhere((t) => t.id == tripId);
      if (index != -1) {
        _trips[index] = Trip.fromJson(updatedTrip);
      }

      if (_selectedTrip?.id == tripId) {
        _selectedTrip = Trip.fromJson(updatedTrip);
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

  /// Supprimer un trajet
  Future<bool> deleteTrip(int tripId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteTrip(tripId);
      _trips.removeWhere((t) => t.id == tripId);

      if (_selectedTrip?.id == tripId) {
        _selectedTrip = null;
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

  void clearTrips() {
    _trips = [];
    _selectedTrip = null;
    notifyListeners();
  }
}
