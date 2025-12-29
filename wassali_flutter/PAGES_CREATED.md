# Application Mobile Flutter - Wassali

## Pages Créées

### 📱 Pages d'Authentification
1. **LandingPage** - Page d'accueil avec choix Client/Transporteur
2. **LoginPage** - Connexion avec toggle Client/Transporteur
3. **SignupClientPage** - Inscription client
4. **SignupTransporterPage** - Inscription transporteur
5. **ForgotPasswordPage** - Demande de réinitialisation de mot de passe
6. **ResetPasswordPage** - Réinitialisation avec code 6 chiffres

### 👥 Pages Communes
7. **ProfilePage** - Profil utilisateur (édition, logout)
8. **SettingsPage** - Paramètres (dark mode, langue, notifications)
9. **MessagesPage** - Page de messages (placeholder)

### 🛍️ Pages Client
10. **ClientDashboardPage** - Dashboard principal avec navigation
    - Home (accueil avec actions rapides)
    - Bookings (mes réservations)
    - Messages
    - Profile
    - Settings

11. **SearchTripsPage** - Recherche de trajets
12. **TripDetailsPage** - Détails d'un trajet + formulaire de réservation
13. **MyBookingsPage** - Liste des réservations du client

### 🚚 Pages Transporteur
14. **TransporterDashboardPage** - Dashboard principal avec navigation
    - Dashboard (statistiques + liste des trajets)
    - Messages
    - Profile
    - Settings

15. **CreateTripPage** - Création d'un nouveau trajet

## 🔧 Providers
- **ThemeProvider** - Gestion du thème (light/dark mode)
- **LanguageProvider** - Gestion de la langue (FR/EN/AR)
- **AuthProvider** - Gestion de l'authentification et utilisateur connecté

## 🌐 API Service
- **ApiService** - Communication avec le backend
  - Authentification (register, login, logout)
  - Gestion profil (getCurrentUser, updateProfile, changePassword)
  - Trajets (getTrips, searchTrips, createTrip)
  - Réservations (getMyBookings, createBooking)
  - Réinitialisation mot de passe (forgotPassword, resetPassword)

## 🎨 Fonctionnalités
✅ Dark Mode complet
✅ Support multilingue (FR/EN/AR)
✅ Navigation par rôle (Client vs Transporteur)
✅ Authentification complète avec JWT
✅ Formulaires avec validation
✅ Design responsive
✅ Thème cohérent avec couleurs:
  - Client: Bleu (#0066FF)
  - Transporteur: Orange (#FF9500)

## 📊 Statistiques
- **15 pages complètes**
- **3 providers**
- **1 service API complet**
- **200+ clés de traduction**
- **Connexion backend: http://10.0.2.2:8000/api/v1**

## 🚀 Pour Lancer
```bash
cd wassali_flutter
flutter pub get
flutter run -d emulator-5554
```

## 📝 Notes
- L'application mobile est une **réplique exacte** de l'application web
- Même backend FastAPI partagé entre web et mobile
- Même base de données PostgreSQL (wassali_db)
- Stockage sécurisé des tokens JWT avec flutter_secure_storage
