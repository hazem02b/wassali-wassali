import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  String get userRole => _currentUser?['role'] ?? '';
  bool get isClient => userRole == 'client';
  bool get isTransporter => userRole == 'transporter';

  Future<void> loadCurrentUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = await _apiService.getCurrentUser();
      _currentUser = user;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUser(Map<String, dynamic> user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      // Ignore logout errors
    } finally {
      _currentUser = null;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
