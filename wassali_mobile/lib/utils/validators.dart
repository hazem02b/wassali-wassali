/// Classe de validation pour les formulaires
class Validators {
  /// Valider un email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }

    return null;
  }

  /// Valider un mot de passe
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }

    return null;
  }

  /// Valider un numéro de téléphone
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    // Accepte les formats: +33612345678, 0612345678, etc.
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{8,}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Numéro de téléphone invalide';
    }

    return null;
  }

  /// Valider un nom (prénom ou nom de famille)
  static String? name(String? value, {String field = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '$field est requis';
    }

    if (value.length < 2) {
      return '$field doit contenir au moins 2 caractères';
    }

    return null;
  }

  /// Valider un champ requis
  static String? required(String? value, {String field = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '$field est requis';
    }

    return null;
  }

  /// Valider un nombre (poids, prix, etc.)
  static String? number(String? value, {String field = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '$field est requis';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }

    if (number <= 0) {
      return '$field doit être supérieur à 0';
    }

    return null;
  }

  /// Valider un poids
  static String? weight(String? value) {
    return number(value, field: 'Le poids');
  }

  /// Valider un prix
  static String? price(String? value) {
    return number(value, field: 'Le prix');
  }

  /// Confirmer un mot de passe
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer le mot de passe';
    }

    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  /// Valider une adresse
  static String? address(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'adresse est requise';
    }

    if (value.length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }

    return null;
  }
}
