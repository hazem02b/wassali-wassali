# Wassali Mobile App - Application Complète

##  Vue d'ensemble

Application mobile Flutter complète pour la plateforme Wassali - livraison de colis entre particuliers.
Utilise Clean Architecture avec Provider pour la gestion d'état.

##  Fonctionnalités Implémentées

###  Authentification
-  Page de connexion (Login)
-  Inscription Client
-  Inscription Transporteur (avec sélection véhicule)
-  Mot de passe oublié
-  Stockage sécurisé des tokens (FlutterSecureStorage)
-  Déconnexion
-  Navigation automatique selon type d'utilisateur

###  Fonctionnalités Client

#### Recherche et Réservation
-  **HomeClientPage** - Page d'accueil avec recherche de trajets
  - Formulaire de recherche (départ, destination, date)
  - Routes populaires
  - Section "Pourquoi Wassali?"
  - Navigation bottom bar

-  **SearchResultsPage** - Résultats de recherche
  - Liste des trajets disponibles
  - Informations transporteur avec note
  - Type de véhicule et disponibilité
  - Navigation vers détails du trajet

-  **TripDetailsPage** - Détails complets d'un trajet
  - Informations complètes du trajet
  - Profil du transporteur avec note
  - Places disponibles
  - Bouton de réservation
  - Chat avec transporteur (préparé)

-  **BookingFormPage** - Formulaire de réservation
  - Sélection du nombre de places
  - Description du colis (optionnel)
  - Poids du colis (optionnel)
  - Choix méthode de paiement (espèces/carte)
  - Calcul automatique du prix total
  - Confirmation de réservation

#### Gestion des Réservations
-  **MyBookingsPage** - Liste des réservations
  - Filtres (toutes, en attente, acceptées, terminées, annulées)
  - Cartes de réservation avec détails
  - Badges de statut colorés
  - Détails complets en modal
  - Annulation de réservation

#### Profil
-  **ProfilePage** - Profil utilisateur
  - Affichage des informations personnelles
  - Modification du profil
  - Upload de photo de profil
  - Note et avis (pour transporteurs)
  - Paramètres (notifications, aide, à propos)
  - Déconnexion

###  Fonctionnalités Transporteur

#### Tableau de Bord
-  **TransporterDashboardPage** - Tableau de bord principal
  - Statistiques (gains, trajets actifs, demandes, trajets terminés)
  - Action rapide : Créer un trajet
  - Liste des demandes de réservation en attente
  - Accepter/Refuser les réservations
  - Trajets à venir
  - Navigation bottom bar

#### Gestion des Trajets
-  **CreateTripPage** - Création de trajet
  - Lieu de départ et destination
  - Sélecteur de date et heure
  - Choix du type de véhicule (voiture, moto, camionnette, camion)
  - Prix par place
  - Nombre de places disponibles
  - Description optionnelle
  - Validation complète

-  **MyTripsPage** - Gestion des trajets
  - Filtres (actifs, terminés, annulés)
  - Cartes de trajet avec toutes les informations
  - Modification de trajet
  - Annulation de trajet
  - Détails complets en modal
  - Bouton flottant pour créer un trajet

##  Packages Utilisés (50+)

### Core
- flutter_sdk: 3.10.4+
- provider: ^6.1.2 (gestion d'état)
- dio: ^5.7.0 (HTTP client)
- socket_io_client: ^3.0.0 (WebSocket)

### Storage & Cache
- flutter_secure_storage: ^9.2.2
- shared_preferences: ^2.3.3
- hive: ^2.2.3

### UI & Theming
- google_fonts: ^6.2.1
- flutter_svg: ^2.0.10+1
- carousel_slider: ^5.0.0
- shimmer: ^3.0.0
- flutter_staggered_animations: ^1.1.1

### Maps & Location
- google_maps_flutter: ^2.9.0
- geolocator: ^13.0.2
- geocoding: ^3.0.0

### Media
- image_picker: ^1.1.2
- image_cropper: ^8.0.2
- file_picker: ^8.1.6

### Charts & Data Viz
- fl_chart: ^0.69.2

### Utilities
- intl: ^0.19.0 (dates, formatage)
- timeago: ^3.7.0
- flutter_rating_bar: ^4.0.1
- pin_code_fields: ^8.0.1
- qr_flutter: ^4.1.0

### Notifications
- flutter_local_notifications: ^18.0.1

##  Architecture

`
lib/
 core/
    config/
       api_config.dart          # Configuration API endpoints
    constants/
       app_constants.dart       # Constantes de l'app
    theme/
       app_theme.dart           # Thème Material 3
    network/
        api_service.dart         # Service HTTP avec Dio
        websocket_service.dart   # Service WebSocket

 data/
    models/
        user_model.dart          # Modèle utilisateur
        trip_model.dart          # Modèle trajet
        booking_model.dart       # Modèle réservation

 presentation/
    providers/
       auth_provider.dart       # Provider d'authentification
   
    pages/
        splash_page.dart                      # Écran de démarrage
        welcome_page.dart                     # Onboarding
        login_page.dart                       # Connexion
        signup_page.dart                      # Inscription client
        signup_transporter_page.dart          # Inscription transporteur
        forgot_password_page.dart             # Mot de passe oublié
       
       # Pages Client
        home_client_page.dart                 # Accueil client
        search_results_page.dart              # Résultats de recherche
        trip_details_page.dart                # Détails du trajet
        booking_form_page.dart                # Formulaire de réservation
        my_bookings_page.dart                 # Mes réservations
       
       # Pages Transporteur
        transporter_dashboard_page.dart       # Tableau de bord transporteur
        create_trip_page.dart                 # Créer un trajet
        my_trips_page.dart                    # Mes trajets
       
       # Commun
        profile_page.dart                     # Profil utilisateur

 main.dart
`

##  Design

### Palette de Couleurs
- **Primary**: #6366F1 (Indigo)
- **Secondary**: #8B5CF6 (Purple)
- **Accent**: #EC4899 (Pink)
- **Success**: Vert
- **Warning**: Orange
- **Error**: Rouge

### Thème
- Material 3
- Mode clair et sombre
- Google Fonts (Inter family)
- Coins arrondis (12px par défaut)
- Élévations subtiles

##  API Backend

### Base URL
- **Development**: http://localhost:8000
- **WebSocket**: ws://localhost:8000/ws

### Endpoints Configurés

#### Authentification
- POST /auth/login
- POST /auth/register
- POST /auth/register-transporter
- POST /auth/forgot-password
- POST /auth/reset-password

#### Utilisateurs
- GET /users/me
- PUT /users/me
- POST /users/upload-photo

#### Trajets
- GET /trips/search
- POST /trips
- GET /trips/{id}
- PUT /trips/{id}
- DELETE /trips/{id}
- GET /trips/my-trips

#### Réservations
- POST /bookings
- GET /bookings/my-bookings
- PUT /bookings/{id}/accept
- PUT /bookings/{id}/reject
- DELETE /bookings/{id}

#### Messaging
- POST /conversations
- GET /conversations
- POST /conversations/{id}/messages
- GET /conversations/{id}/messages

#### Notifications
- GET /notifications
- PUT /notifications/{id}/read

#### Paiements
- POST /payments/create-payment-intent
- POST /payments/confirm

##  Prochaines Étapes

### Fonctionnalités à Implémenter
1. **Messaging** 
   - Chat en temps réel entre client et transporteur
   - Notifications de nouveaux messages

2. **Notifications Push**
   - Firebase Cloud Messaging
   - Notifications locales

3. **Maps Integration**
   - Affichage de l'itinéraire sur Google Maps
   - Tracking en temps réel

4. **Paiements**
   - Intégration Stripe/autre gateway
   - Historique des paiements

5. **Avis et Notes**
   - Système de notation transporteur/client
   - Commentaires après trajet

6. **Filtres Avancés**
   - Filtrer par prix, type de véhicule, note
   - Tri des résultats

7. **Localisation**
   - Support multilingue (FR, AR, EN)
   - Traductions i18n

### Optimisations
- Connexion au backend réel (remplacer données démo)
- Gestion d'erreurs plus robuste
- Tests unitaires et d'intégration
- CI/CD pipeline
- Performance monitoring

##  Données de Démonstration

Actuellement, l'application utilise des données de démonstration pour :
- Trajets dans SearchResultsPage
- Réservations dans MyBookingsPage
- Trajets dans MyTripsPage (transporteur)
- Demandes de réservation dans TransporterDashboard

Ces données seront remplacées par des appels API réels une fois le backend connecté.

##  Configuration Requise

### Développement
- Flutter SDK: >=3.10.4
- Dart SDK: >=3.0.0
- Android Studio / VS Code
- Xcode (pour iOS)

### Build
- Android: minSdkVersion 21
- iOS: iOS 12.0+

##  Plateformes Supportées
-  Android
-  iOS
-  Web (avec ajustements)

##  État du Projet

### Complété 
- Architecture Clean complète
- Authentification complète
- Toutes les pages UI client
- Toutes les pages UI transporteur
- Navigation et routing
- Thème Material 3
- Gestion d'état avec Provider
- Configuration API complète
- WebSocket service

### En Cours 
- Connexion backend réel
- Tests

### À Faire 
- Messaging
- Notifications push
- Maps integration
- Paiements
- Avis et notes

---

**Version**: 1.0.0 (Complete UI Implementation)
**Date**: Janvier 2026
**Auteur**: Wassali Team
