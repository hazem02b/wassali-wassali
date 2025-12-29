import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

/// Provider pour gérer l'authentification - Correspond au AuthContext du web
class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isClient => _currentUser?.role == 'client';
  bool get isTransporter => _currentUser?.role == 'transporter';

  /// Connexion
  Future<bool> login({
    required String email,
    required String password,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.login(
        email: email,
        password: password,
        role: role,
      );

      if (result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
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

  /// Inscription
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String role,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
      );

      if (result['user'] != null) {
        _currentUser = User.fromJson(result['user']);
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

  /// Déconnexion
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Ignorer les erreurs de déconnexion
    }
    
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  /// Récupérer l'utilisateur actuel
  Future<void> fetchCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _apiService.getCurrentUser();
      _currentUser = User.fromJson(user);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Mettre à jour le profil
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? city,
    String? country,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = await _apiService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        address: address,
        city: city,
        country: country,
      );

      _currentUser = User.fromJson(updatedUser);
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

  /// Changer le mot de passe
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

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

  /// Réinitialiser l'erreur
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
