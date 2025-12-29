import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/api_service.dart';

/// Provider pour gérer les notifications
class NotificationProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Récupérer toutes les notifications
  Future<void> fetchNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _apiService.getNotifications();
      _notifications = (results as List)
          .map((json) => AppNotification.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Marquer une notification comme lue
  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiService.markNotificationAsRead(notificationId);
      
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        // Créer une nouvelle notification avec isRead = true
        final notification = _notifications[index];
        _notifications[index] = AppNotification(
          id: notification.id,
          userId: notification.userId,
          type: notification.type,
          title: notification.title,
          message: notification.message,
          isRead: true,
          data: notification.data,
          createdAt: notification.createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Marquer toutes les notifications comme lues
  Future<void> markAllAsRead() async {
    try {
      await _apiService.markAllNotificationsAsRead();
      
      _notifications = _notifications.map((notification) {
        return AppNotification(
          id: notification.id,
          userId: notification.userId,
          type: notification.type,
          title: notification.title,
          message: notification.message,
          isRead: true,
          data: notification.data,
          createdAt: notification.createdAt,
        );
      }).toList();
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Supprimer une notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _apiService.deleteNotification(notificationId);
      _notifications.removeWhere((n) => n.id == notificationId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications = [];
    notifyListeners();
  }
}
