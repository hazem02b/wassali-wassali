import 'package:intl/intl.dart';

class Helpers {
  // Format date
  static String formatDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format, 'fr_FR').format(date);
  }

  // Format time
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Get relative time (e.g., "Il y a 2 heures")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Il y a $years ${years == 1 ? "an" : "ans"}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Il y a $months mois';
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} ${difference.inDays == 1 ? "jour" : "jours"}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} ${difference.inHours == 1 ? "heure" : "heures"}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"}';
    } else {
      return 'À l\'instant';
    }
  }

  // Format price
  static String formatPrice(double price, {String currency = 'TND'}) {
    return '${price.toStringAsFixed(2)} $currency';
  }

  // Calculate booking total
  static double calculateBookingTotal({
    required double weight,
    required double pricePerKg,
    bool hasInsurance = false,
  }) {
    double total = weight * pricePerKg;
    if (hasInsurance) {
      total += total * 0.05; // 5% insurance fee
    }
    return total;
  }

  // Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate phone (Tunisia format)
  static bool isValidPhone(String phone) {
    // Format: +216 XX XXX XXX or XX XXX XXX
    final phoneRegex = RegExp(r'^(\+216)?[2-9]\d{7}$');
    return phoneRegex.hasMatch(phone.replaceAll(' ', ''));
  }

  // Validate password strength
  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null; // Valid
  }

  // Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // Get booking status color
  static String getBookingStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'En attente';
      case 'confirmed':
        return 'Confirmé';
      case 'in_transit':
        return 'En transit';
      case 'delivered':
        return 'Livré';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  // Get payment method text
  static String getPaymentMethodText(String method) {
    switch (method) {
      case 'cash':
        return 'Espèces';
      case 'card':
        return 'Carte bancaire';
      case 'paypal':
        return 'PayPal';
      default:
        return method;
    }
  }

  // Truncate text
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generate random ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Check if date is in the past
  static bool isPastDate(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Show snackbar helper
  static void showSuccessMessage(String message) {
    // Will be implemented with BuildContext
  }

  static void showErrorMessage(String message) {
    // Will be implemented with BuildContext
  }
}
