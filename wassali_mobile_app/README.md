# Wassali Mobile App 

Application mobile Flutter complète pour la plateforme Wassali - Service de livraison de colis entre particuliers en Tunisie.

##  Fonctionnalités

### Pour les Clients
-  Recherche de trajets par ville et date
-  Consultation des détails de trajet avec profil transporteur
-  Réservation de places avec description du colis
-  Suivi de mes réservations (en attente, acceptées, terminées)
-  Gestion du profil utilisateur

### Pour les Transporteurs
-  Tableau de bord avec statistiques (gains, trajets actifs, demandes)
-  Création de trajets avec sélection du véhicule
-  Gestion de mes trajets (actifs, terminés, annulés)
-  Acceptation/Refus des demandes de réservation
-  Profil transporteur avec note et avis

##  Architecture

- **Clean Architecture** avec séparation des couches
- **Provider** pour la gestion d'état
- **Material 3** pour le design
- **Dio** pour les requêtes HTTP
- **Socket.IO** pour le temps réel
- **Flutter Secure Storage** pour les tokens

##  Installation

### Prérequis
- Flutter SDK >=3.10.4
- Dart SDK >=3.0.0
- Android Studio / VS Code
- Backend Wassali en cours d'exécution

### Étapes

1. **Cloner le projet**
\\\ash
cd wassali_mobile_app
\\\

2. **Installer les dépendances**
\\\ash
flutter pub get
\\\

3. **Configurer l'API Backend**
Modifier l'adresse dans \lib/core/config/api_config.dart\ si nécessaire :
\\\dart
static const String baseUrl = 'http://localhost:8000';
static const String wsUrl = 'ws://localhost:8000/ws';
\\\

4. **Lancer l'application**
\\\ash
flutter run
\\\

##  Structure du Projet

\\\
lib/
 core/
    config/          # Configuration API
    constants/       # Constantes
    theme/           # Thème Material 3
    network/         # Services HTTP & WebSocket
 data/
    models/          # Modèles de données
 presentation/
    providers/       # Providers (state management)
    pages/           # Pages de l'application
 main.dart
\\\

##  Design System

### Couleurs
- **Primary**: Indigo (#6366F1)
- **Secondary**: Purple (#8B5CF6)
- **Accent**: Pink (#EC4899)

### Typographie
- **Font**: Inter (Google Fonts)
- **Tailles**: 12px à 42px selon le contexte

##  Authentification

L'app supporte 2 types d'utilisateurs :
1. **Client** - Recherche et réserve des trajets
2. **Transporteur** - Crée des trajets et accepte des réservations

Les tokens sont stockés de manière sécurisée via Flutter Secure Storage.

##  Packages Principaux

- **provider**: ^6.1.2 - Gestion d'état
- **dio**: ^5.7.0 - Client HTTP
- **socket_io_client**: ^3.0.0 - WebSocket temps réel
- **flutter_secure_storage**: ^9.2.2 - Stockage sécurisé
- **google_fonts**: ^6.2.1 - Polices Google
- **intl**: ^0.19.0 - Internationalisation
- **image_picker**: ^1.1.2 - Sélection d'images
- **google_maps_flutter**: ^2.9.0 - Cartes Google

[Voir pubspec.yaml pour la liste complète]

##  Tests

\\\ash
# Lancer les tests
flutter test

# Analyser le code
flutter analyze
\\\

##  Données de Démonstration

Actuellement, l'application utilise des données de démonstration pour :
- Les trajets disponibles
- Les réservations
- Le tableau de bord transporteur

Ces données seront remplacées par des appels API réels une fois le backend connecté.

##  Plateformes Supportées

-  Android (minSdkVersion 21)
-  iOS (iOS 12.0+)
-  Web (nécessite des ajustements)

##  Prochaines Fonctionnalités

- [ ] Chat en temps réel entre client et transporteur
- [ ] Notifications push (Firebase)
- [ ] Affichage de l'itinéraire sur Google Maps
- [ ] Système de paiement intégré
- [ ] Avis et notes après trajet
- [ ] Support multilingue (FR/AR/EN)

##  Documentation

Consulter les fichiers suivants pour plus de détails :
- \WASSALI_MOBILE_APP_GUIDE.md\ - Guide complet de l'architecture
- \AUTHENTICATION_COMPLETED.md\ - Détails de l'authentification
- \WASSALI_MOBILE_COMPLETE.md\ - Documentation complète

##  Contribution

Ce projet fait partie de la plateforme Wassali. Pour contribuer :
1. Créer une branche depuis \main\
2. Implémenter les changements
3. Tester avec \lutter test\ et \lutter analyze\
4. Créer une Pull Request

##  License

Propriétaire - Wassali Team  2026

##  Auteurs

Wassali Development Team

---

**Version**: 1.0.0
**Dernière mise à jour**: Janvier 2026
