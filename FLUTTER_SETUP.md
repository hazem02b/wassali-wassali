# 📱 Guide de Migration vers Flutter + Firebase

## 🎯 Stack Technique Choisie

### Frontend Mobile
- **Flutter** (Dart)
- **Material Design 3**
- **Provider** ou **Riverpod** pour state management
- **GetX** pour navigation (optionnel)

### Backend & Base de Données
- **Firebase Authentication** - Connexion utilisateurs
- **Cloud Firestore** - Base de données NoSQL
- **Firebase Storage** - Stockage des images
- **Firebase Cloud Messaging (FCM)** - Notifications push
- **Firebase Cloud Functions** - Logique serveur (optionnel)

---

## 🛠️ Étape 1 : Installation de Flutter

### Windows

```bash
# 1. Télécharger Flutter SDK
# Aller sur https://flutter.dev/docs/get-started/install/windows
# Télécharger le ZIP et extraire dans C:\flutter

# 2. Ajouter Flutter au PATH
# Variables d'environnement > Path > Nouveau > C:\flutter\bin

# 3. Vérifier l'installation
flutter doctor

# 4. Installer Android Studio
# https://developer.android.com/studio

# 5. Configurer Flutter
flutter config --android-studio-dir="C:\Program Files\Android\Android Studio"
```

---

## 🔥 Étape 2 : Configuration Firebase

### 1. Créer un Projet Firebase

1. Aller sur https://console.firebase.google.com
2. Cliquer sur "Ajouter un projet"
3. Nom : **Wassali**
4. Activer Google Analytics (optionnel)
5. Créer le projet

### 2. Ajouter une App Android

```bash
# Dans Firebase Console
1. Cliquer sur l'icône Android
2. Nom du package : com.wassali.app
3. Télécharger google-services.json
4. Placer dans android/app/
```

### 3. Ajouter une App iOS (optionnel)

```bash
# Dans Firebase Console
1. Cliquer sur l'icône iOS
2. Bundle ID : com.wassali.app
3. Télécharger GoogleService-Info.plist
4. Placer dans ios/Runner/
```

---

## 📦 Étape 3 : Créer le Projet Flutter

```bash
# Créer le projet Flutter
flutter create wassali_flutter
cd wassali_flutter

# Installer les dépendances Firebase
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore
flutter pub add firebase_storage
flutter pub add firebase_messaging

# Dépendances UI/UX
flutter pub add provider
flutter pub add get
flutter pub add cached_network_image
flutter pub add image_picker
flutter pub add intl
flutter pub add google_fonts

# Lancer l'app
flutter run
```

---

## 📁 Structure du Projet Flutter

```
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   ├── trip_model.dart
│   ├── booking_model.dart
│   ├── message_model.dart
│   └── review_model.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   └── messaging_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── booking_provider.dart
│   └── notification_provider.dart
├── screens/
│   ├── landing_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── booking_screen.dart
│   ├── messages_screen.dart
│   ├── profile_screen.dart
│   └── transporter/
│       ├── dashboard_screen.dart
│       ├── create_trip_screen.dart
│       └── my_trips_screen.dart
├── widgets/
│   ├── bottom_nav.dart
│   ├── custom_button.dart
│   ├── loading_widget.dart
│   └── trip_card.dart
├── utils/
│   ├── constants.dart
│   ├── colors.dart
│   └── validators.dart
└── routes/
    └── app_routes.dart
```

---

## 🗄️ Structure Firestore (Base de Données)

### Collections Firebase

```javascript
// Collection: users
{
  "userId": {
    "email": "user@example.com",
    "name": "Ahmed Ben Ali",
    "phone": "+216 XX XXX XXX",
    "type": "client", // ou "transporter"
    "verified": false,
    "avatar": "url_image",
    "createdAt": Timestamp,
    "totalBookings": 0,
    "totalSpent": 0,
    // Pour transporteurs
    "rating": 4.8,
    "reviews": 156,
    "totalTrips": 45
  }
}

// Collection: trips
{
  "tripId": {
    "transporterId": "userId",
    "transporterName": "Mohamed Ali",
    "from": "Tunis",
    "to": "Paris",
    "date": Timestamp,
    "time": "10:00",
    "pricePerKg": 45,
    "totalCapacity": 100,
    "availableCapacity": 30,
    "status": "active", // active, completed, cancelled
    "transportableItems": ["Documents", "Clothes"],
    "isNegotiable": false,
    "hasInsurance": true,
    "createdAt": Timestamp
  }
}

// Collection: bookings
{
  "bookingId": {
    "tripId": "tripId",
    "clientId": "userId",
    "clientName": "Ahmed",
    "transporterId": "userId",
    "transporterName": "Mohamed",
    "weight": 5,
    "totalPrice": 240,
    "status": "confirmed", // pending, confirmed, in-transit, delivered
    "packageDescription": "Livres et documents",
    "pickupAddress": "123 Ave Habib Bourguiba",
    "deliveryAddress": "45 Rue de la Paix, Paris",
    "paymentMethod": "card",
    "paymentStatus": "completed",
    "createdAt": Timestamp,
    "updatedAt": Timestamp
  }
}

// Collection: messages
{
  "conversationId": "userId1_userId2",
  "messages": [
    {
      "messageId": "msgId",
      "senderId": "userId",
      "text": "Bonjour!",
      "timestamp": Timestamp,
      "read": false
    }
  ],
  "participants": ["userId1", "userId2"],
  "lastMessage": "Bonjour!",
  "lastMessageTime": Timestamp
}

// Collection: reviews
{
  "reviewId": {
    "transporterId": "userId",
    "clientId": "userId",
    "clientName": "Ahmed",
    "bookingId": "bookingId",
    "rating": 5,
    "comment": "Excellent service!",
    "createdAt": Timestamp
  }
}

// Collection: notifications
{
  "notificationId": {
    "userId": "userId",
    "title": "Nouvelle réservation",
    "message": "Vous avez une nouvelle réservation",
    "type": "booking",
    "read": false,
    "relatedId": "bookingId",
    "createdAt": Timestamp
  }
}
```

---

## 🔐 Règles de Sécurité Firestore

```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    
    // Trips collection
    match /trips/{tripId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.transporterId;
      allow update, delete: if request.auth != null 
        && request.auth.uid == resource.data.transporterId;
    }
    
    // Bookings collection
    match /bookings/{bookingId} {
      allow read: if request.auth != null 
        && (request.auth.uid == resource.data.clientId 
            || request.auth.uid == resource.data.transporterId);
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.clientId;
      allow update: if request.auth != null 
        && (request.auth.uid == resource.data.clientId 
            || request.auth.uid == resource.data.transporterId);
    }
    
    // Messages collection
    match /messages/{conversationId} {
      allow read, write: if request.auth != null 
        && request.auth.uid in resource.data.participants;
    }
    
    // Reviews collection
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null 
        && request.auth.uid == request.resource.data.clientId;
    }
    
    // Notifications collection
    match /notifications/{notificationId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == resource.data.userId;
    }
  }
}
```

---

## 🎨 Exemple de Code Flutter

### main.dart

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/landing_screen.dart';
import 'providers/auth_provider.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wassali',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        useMaterial3: true,
      ),
      home: LandingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### AuthService (Firebase Authentication)

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Sign Up
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String type,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Créer le document utilisateur dans Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'phone': phone,
        'type': type,
        'verified': false,
        'createdAt': FieldValue.serverTimestamp(),
        'totalBookings': 0,
        'totalSpent': 0,
      });
      
      return userCredential;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  
  // Sign In
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  
  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  // Current User
  User? get currentUser => _auth.currentUser;
  
  // Auth State Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
```

### FirestoreService (Database Operations)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Get Trips
  Stream<QuerySnapshot> getTrips({String? from, String? to}) {
    Query query = _db.collection('trips').where('status', isEqualTo: 'active');
    
    if (from != null) {
      query = query.where('from', isEqualTo: from);
    }
    if (to != null) {
      query = query.where('to', isEqualTo: to);
    }
    
    return query.orderBy('date', descending: false).snapshots();
  }
  
  // Create Booking
  Future<void> createBooking({
    required String tripId,
    required String clientId,
    required Map<String, dynamic> bookingData,
  }) async {
    await _db.collection('bookings').add({
      ...bookingData,
      'tripId': tripId,
      'clientId': clientId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
  // Get User Bookings
  Stream<QuerySnapshot> getUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('clientId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
```

---

## 🚀 Commandes Flutter Utiles

```bash
# Créer le projet
flutter create wassali_flutter

# Installer les dépendances
flutter pub get

# Lancer sur émulateur Android
flutter run

# Lancer sur émulateur iOS (Mac uniquement)
flutter run -d ios

# Build APK Android
flutter build apk --release

# Build App Bundle (pour Google Play)
flutter build appbundle --release

# Nettoyer le projet
flutter clean

# Vérifier la santé du projet
flutter doctor

# Voir les devices connectés
flutter devices
```

---

## 📱 Configuration Android

### android/app/build.gradle

```gradle
android {
    defaultConfig {
        applicationId "com.wassali.app"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.0.0')
}

apply plugin: 'com.google.gms.google-services'
```

### android/build.gradle

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

---

## ✅ Checklist Migration

- [ ] Installer Flutter SDK
- [ ] Installer Android Studio
- [ ] Créer projet Firebase
- [ ] Créer projet Flutter
- [ ] Configurer Firebase
- [ ] Installer dépendances
- [ ] Créer structure de dossiers
- [ ] Implémenter authentification
- [ ] Créer écrans principaux
- [ ] Configurer Firestore
- [ ] Implémenter navigation
- [ ] Tester sur émulateur
- [ ] Build APK

---

## 🎓 Ressources d'Apprentissage

- [Documentation Flutter](https://flutter.dev/docs)
- [Firebase pour Flutter](https://firebase.flutter.dev/)
- [FlutterFire Documentation](https://firebase.google.com/docs/flutter/setup)
- [Tutoriels Flutter](https://flutter.dev/learn)

---

Prêt à créer l'application mobile Wassali avec Flutter + Firebase ! 🚀
