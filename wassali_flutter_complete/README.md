# 🚀 Wassali Flutter - Application Mobile Complète

Une application mobile complète de livraison de colis entre la Tunisie et l'Europe, développée avec Flutter et Firebase.

## 📱 À Propos

**Wassali** (qui signifie "Livrez-le!" en arabe tunisien) connecte les clients qui souhaitent envoyer des colis avec des transporteurs voyageant entre la Tunisie et l'Europe.

### Fonctionnalités Principales

#### Pour les Clients 👥
- ✅ Rechercher des trajets disponibles
- ✅ Réserver un espace pour colis
- ✅ Suivre les réservations en temps réel
- ✅ Messagerie avec transporteurs
- ✅ Évaluer les transporteurs
- ✅ Paiement sécurisé

#### Pour les Transporteurs 🚚
- ✅ Créer et gérer des trajets
- ✅ Recevoir des réservations
- ✅ Gérer les colis
- ✅ Recevoir des paiements
- ✅ Messagerie avec clients
- ✅ Dashboard statistiques

---

## 🏗️ Architecture du Projet

```
wassali_flutter_complete/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   │
│   ├── models/                      # Modèles de données
│   │   ├── user_model.dart          # Utilisateur (Client/Transporteur)
│   │   ├── trip_model.dart          # Trajet
│   │   ├── booking_model.dart       # Réservation
│   │   └── other_models.dart        # Reviews, Messages, Notifications
│   │
│   ├── services/                    # Services backend
│   │   ├── auth_service.dart        # Authentification Firebase
│   │   └── firestore_service.dart   # Base de données Firestore
│   │
│   ├── providers/                   # Gestion d'état (Provider)
│   │   ├── auth_provider.dart       # État d'authentification
│   │   ├── booking_provider.dart    # État des réservations
│   │   └── ...
│   │
│   ├── screens/                     # Écrans de l'app
│   │   ├── landing_screen.dart      # Page d'accueil
│   │   ├── login_screen.dart        # Connexion
│   │   ├── home_screen.dart         # Accueil client
│   │   ├── search_screen.dart       # Recherche trajets
│   │   └── ...
│   │
│   ├── widgets/                     # Widgets réutilisables
│   │   ├── common_widgets.dart      # Boutons, spinners, etc.
│   │   ├── trip_card.dart           # Carte de trajet
│   │   └── ...
│   │
│   └── utils/                       # Utilitaires
│       ├── colors.dart              # Palette de couleurs
│       ├── constants.dart           # Constantes de l'app
│       ├── helpers.dart             # Fonctions utilitaires
│       └── theme.dart               # Thème de l'app
│
├── pubspec.yaml                     # Dépendances Flutter
└── README.md                        # Ce fichier
```

---

## 🛠️ Technologies Utilisées

### Frontend (Flutter)
- **Flutter SDK** 3.0+
- **Dart** 3.0+
- **Material Design 3**
- **Google Fonts** (Poppins)

### Backend (Firebase)
- **Firebase Auth** - Authentification email/password
- **Cloud Firestore** - Base de données NoSQL
- **Cloud Storage** - Stockage d'images
- **Cloud Messaging** - Notifications push

### Packages Principaux
```yaml
dependencies:
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  
  # State Management
  provider: ^6.1.1
  
  # UI
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Navigation
  go_router: ^13.0.0
  
  # Utils
  intl: ^0.19.0
  image_picker: ^1.0.7
```

---

## 🚀 Installation et Configuration

### 1. Prérequis

Assurez-vous d'avoir installé:
- Flutter SDK 3.0+ ([Guide d'installation](FLUTTER_INSTALLATION_GUIDE.md))
- Android Studio / VS Code
- Git
- Node.js (pour Firebase CLI)

### 2. Vérifier Flutter

```bash
flutter doctor
```

Tous les éléments importants doivent afficher ✓.

### 3. Cloner le Projet

```bash
cd C:\Wassaliparceldeliveryapp
# Le dossier wassali_flutter_complete est déjà créé
```

### 4. Installer les Dépendances

```bash
cd wassali_flutter_complete
flutter pub get
```

### 5. Configurer Firebase

#### a) Créer un projet Firebase
1. Allez sur [Firebase Console](https://console.firebase.google.com/)
2. Cliquez "Ajouter un projet"
3. Nom: **Wassali**

#### b) Installer Firebase CLI
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

#### c) Connecter Firebase
```bash
firebase login
flutterfire configure
```

Sélectionnez:
- ✓ Android
- ✓ iOS  
- ✓ Web
- ✓ Windows

Cela créera automatiquement `firebase_options.dart`.

#### d) Activer les services Firebase

Dans la console Firebase:

**Authentication:**
- Accédez à Authentication > Sign-in method
- Activez "Email/Password"

**Firestore Database:**
- Accédez à Firestore Database
- "Create database" en mode Production
- Région: europe-west1 (Belgique)

**Storage:**
- Accédez à Storage
- "Get started"

### 6. Décommenter Firebase dans main.dart

Ouvrez `lib/main.dart` et décommentez:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

---

## ▶️ Lancer l'Application

### Windows Desktop (Plus rapide pour tester)
```bash
flutter run -d windows
```

### Android Emulator
```bash
# Lister les émulateurs
flutter emulators

# Créer un émulateur (si nécessaire)
flutter emulators --create

# Lancer un émulateur
flutter emulators --launch <nom_emulateur>

# Lancer l'app
flutter run
```

### Chrome (Web)
```bash
flutter run -d chrome
```

---

## 📊 Base de Données Firestore

### Collections

#### `users`
```json
{
  "email": "user@example.com",
  "name": "Nom Utilisateur",
  "phone": "+21612345678",
  "type": "client|transporter",
  "verified": false,
  "rating": 4.5,
  "reviews": 10,
  "totalBookings": 5,
  "totalSpent": 250.0,
  "createdAt": Timestamp
}
```

#### `trips`
```json
{
  "transporterId": "userId",
  "transporterName": "Nom",
  "from": "Tunis",
  "to": "Paris",
  "date": Timestamp,
  "time": "10:00",
  "pricePerKg": 15.0,
  "totalCapacity": 50,
  "availableCapacity": 30,
  "status": "active",
  "hasInsurance": true,
  "isNegotiable": false,
  "createdAt": Timestamp
}
```

#### `bookings`
```json
{
  "tripId": "tripId",
  "clientId": "userId",
  "transporterId": "userId",
  "packageDescription": "Vêtements",
  "weight": 5.0,
  "totalPrice": 75.0,
  "status": "pending|confirmed|in_transit|delivered|cancelled",
  "paymentCompleted": false,
  "createdAt": Timestamp,
  "updatedAt": Timestamp
}
```

Voir [FLUTTER_SETUP.md](FLUTTER_SETUP.md) pour le schéma complet.

---

## 🎨 Design System

### Couleurs
```dart
Primary: #0066FF (Bleu)
Secondary: #FF9500 (Orange)
Success: #10B981 (Vert)
Error: #EF4444 (Rouge)
Warning: #F59E0B (Jaune)
```

### Typographie
- **Police:** Poppins (Google Fonts)
- **Tailles:** 10-32px

---

## 🔐 Sécurité

### Règles Firestore (à configurer)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Trips
    match /trips/{tripId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
        && request.resource.data.transporterId == request.auth.uid;
      allow update, delete: if request.auth.uid == resource.data.transporterId;
    }
    
    // Bookings
    match /bookings/{bookingId} {
      allow read: if request.auth != null 
        && (request.auth.uid == resource.data.clientId 
        || request.auth.uid == resource.data.transporterId);
      allow create: if request.auth != null;
      allow update: if request.auth.uid == resource.data.clientId 
        || request.auth.uid == resource.data.transporterId;
    }
  }
}
```

---

## 📦 Build & Déploiement

### Android APK
```bash
flutter build apk --release
```
Fichier généré: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (pour Play Store)
```bash
flutter build appbundle --release
```

### iOS (nécessite Mac + Xcode)
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

---

## 🧪 Tests

```bash
# Analyser le code
flutter analyze

# Formater le code
dart format lib/

# Tests (à implémenter)
flutter test
```

---

## 📝 Commandes Utiles

```bash
# Hot reload (pendant l'exécution)
r

# Hot restart (pendant l'exécution)
R

# Nettoyer le projet
flutter clean
flutter pub get

# Voir les devices
flutter devices

# Générer des icônes
flutter pub run flutter_launcher_icons

# Mise à jour des dépendances
flutter pub upgrade
```

---

## 🐛 Résolution de Problèmes

### Erreur "Firestore not initialized"
- Vérifiez que Firebase est bien initialisé dans `main.dart`
- Relancez `flutterfire configure`

### Erreur de build Android
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Hot reload ne fonctionne pas
```bash
# Redémarrer avec
R
```

---

## 📚 Ressources

- [Documentation Flutter](https://docs.flutter.dev/)
- [Firebase Flutter](https://firebase.google.com/docs/flutter/setup)
- [Guide d'installation complet](FLUTTER_INSTALLATION_GUIDE.md)
- [Configuration Firebase détaillée](FLUTTER_SETUP.md)

---

## 👥 Contributions

Ce projet est un template de démarrage. Pour contribuer:
1. Forkez le repo
2. Créez une branche (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. Push (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrez une Pull Request

---

## 📄 Licence

MIT License - Vous êtes libre d'utiliser ce code pour vos projets.

---

## 📞 Support

Pour toute question:
- Consultez les guides d'installation
- Vérifiez la documentation Firebase
- Ouvrez une issue GitHub

---

**Fait avec ❤️ en Flutter**

*Wassali - Ça arrive!*
