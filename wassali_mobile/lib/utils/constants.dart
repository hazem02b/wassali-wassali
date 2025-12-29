import 'package:flutter/material.dart';

/// Constantes de l'application
class AppConstants {
  // Informations de l'app
  static const String appName = 'Wassali';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Envoyez vos colis entre la Tunisie et l\'Europe';

  // Couleurs principales
  static const Color primaryColor = Color(0xFF0066FF);
  static const Color secondaryColor = Color(0xFF00D4AA);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color infoColor = Color(0xFF3B82F6);

  // Villes Tunisie
  static const List<String> tunisianCities = [
    'Tunis',
    'Sfax',
    'Sousse',
    'Kairouan',
    'Bizerte',
    'Gabès',
    'Ariana',
    'Gafsa',
    'Monastir',
    'Ben Arous',
    'Kasserine',
    'Médenine',
    'Nabeul',
    'Tataouine',
    'Béja',
    'Jendouba',
    'Kef',
    'Mahdia',
    'Manouba',
    'Sidi Bouzid',
    'Siliana',
    'Tozeur',
    'Zaghouan',
    'Kebili',
  ];

  // Villes France
  static const List<String> frenchCities = [
    'Paris',
    'Marseille',
    'Lyon',
    'Toulouse',
    'Nice',
    'Nantes',
    'Strasbourg',
    'Montpellier',
    'Bordeaux',
    'Lille',
    'Rennes',
    'Reims',
    'Le Havre',
    'Saint-Étienne',
    'Toulon',
    'Grenoble',
    'Dijon',
    'Nîmes',
    'Angers',
    'Villeurbanne',
  ];

  // Autres villes européennes
  static const List<String> europeanCities = [
    'Bruxelles',
    'Amsterdam',
    'Berlin',
    'Rome',
    'Madrid',
    'Barcelone',
    'Londres',
    'Genève',
    'Zurich',
    'Vienne',
  ];

  // Pays
  static const List<String> countries = [
    'Tunisie',
    'France',
    'Belgique',
    'Pays-Bas',
    'Allemagne',
    'Italie',
    'Espagne',
    'Suisse',
    'Autriche',
    'Royaume-Uni',
  ];

  // Types d'articles transportables
  static const List<String> packageTypes = [
    'Documents',
    'Vêtements',
    'Électronique',
    'Alimentation (non périssable)',
    'Cosmétiques',
    'Livres',
    'Jouets',
    'Médicaments',
    'Artisanat',
    'Autre',
  ];

  // Types de véhicules
  static const List<String> vehicleTypes = [
    'Voiture',
    'Camionnette',
    'Camion',
    'Moto',
    'Avion',
  ];

  // Statuts des réservations
  static const Map<String, String> bookingStatuses = {
    'pending': 'En attente',
    'accepted': 'Accepté',
    'in_transit': 'En transit',
    'delivered': 'Livré',
    'cancelled': 'Annulé',
  };

  // Statuts des trajets
  static const Map<String, String> tripStatuses = {
    'active': 'Actif',
    'completed': 'Terminé',
    'cancelled': 'Annulé',
  };

  // Durées
  static const Duration toastDuration = Duration(seconds: 3);
  static const Duration apiTimeout = Duration(seconds: 30);

  // Limites
  static const double minWeight = 0.5; // kg
  static const double maxWeight = 100; // kg
  static const double minPrice = 1; // €/kg
  static const double maxPrice = 100; // €/kg

  // Regex patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp phoneRegex = RegExp(
    r'^\+?[\d\s\-\(\)]{8,}$',
  );

  // Messages d'erreur
  static const String networkError =
      'Erreur de connexion. Vérifiez votre internet.';
  static const String serverError =
      'Erreur serveur. Veuillez réessayer plus tard.';
  static const String unknownError =
      'Une erreur inconnue s\'est produite.';

  // Messages de succès
  static const String loginSuccess = 'Connexion réussie !';
  static const String registerSuccess = 'Inscription réussie !';
  static const String updateSuccess = 'Modification réussie !';
  static const String deleteSuccess = 'Suppression réussie !';
  static const String bookingSuccess = 'Réservation créée avec succès !';
  static const String tripSuccess = 'Trajet créé avec succès !';
}
