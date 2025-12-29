/// Classe pour gérer les erreurs
class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error == null) {
      return 'Une erreur inconnue s\'est produite';
    }

    String errorString = error.toString();

    // Erreurs réseau communes
    if (errorString.contains('SocketException') ||
        errorString.contains('Failed host lookup')) {
      return 'Pas de connexion internet. Vérifiez votre connexion.';
    }

    if (errorString.contains('TimeoutException') ||
        errorString.contains('Connection timeout')) {
      return 'La requête a expiré. Veuillez réessayer.';
    }

    // Erreurs d'authentification
    if (errorString.contains('401') || errorString.contains('Unauthorized')) {
      return 'Session expirée. Veuillez vous reconnecter.';
    }

    if (errorString.contains('403') || errorString.contains('Forbidden')) {
      return 'Accès refusé. Vous n\'avez pas les permissions nécessaires.';
    }

    if (errorString.contains('404') || errorString.contains('Not found')) {
      return 'Ressource non trouvée.';
    }

    // Erreurs serveur
    if (errorString.contains('500') || errorString.contains('Internal Server Error')) {
      return 'Erreur serveur. Veuillez réessayer plus tard.';
    }

    if (errorString.contains('503') || errorString.contains('Service Unavailable')) {
      return 'Service temporairement indisponible.';
    }

    // Erreurs de validation
    if (errorString.contains('Email already exists')) {
      return 'Cet email est déjà utilisé.';
    }

    if (errorString.contains('Invalid credentials')) {
      return 'Email ou mot de passe incorrect.';
    }

    if (errorString.contains('Password too weak')) {
      return 'Le mot de passe est trop faible.';
    }

    // Message par défaut
    return errorString.length > 100
        ? 'Une erreur s\'est produite. Veuillez réessayer.'
        : errorString;
  }

  static bool isNetworkError(dynamic error) {
    String errorString = error.toString().toLowerCase();
    return errorString.contains('socket') ||
        errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout');
  }

  static bool isAuthError(dynamic error) {
    String errorString = error.toString().toLowerCase();
    return errorString.contains('401') ||
        errorString.contains('unauthorized') ||
        errorString.contains('token') ||
        errorString.contains('session');
  }
}
