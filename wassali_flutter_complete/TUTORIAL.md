# 🎬 Tutoriel Vidéo - Créer l'App Wassali de A à Z

## 📺 Table des Matières
1. [Introduction (2 min)](#1-introduction)
2. [Installer Flutter (15 min)](#2-installer-flutter)
3. [Créer le Projet (5 min)](#3-créer-le-projet)
4. [Configurer Firebase (10 min)](#4-configurer-firebase)
5. [Premier Lancement (3 min)](#5-premier-lancement)
6. [Créer l'Écran de Connexion (20 min)](#6-créer-lécran-de-connexion)
7. [Tester l'Authentification (5 min)](#7-tester-lauthentification)

---

## 1. Introduction

### 🎯 Ce que nous allons créer
Une application mobile complète de livraison de colis entre la Tunisie et l'Europe.

### 🛠️ Technologies
- **Flutter** - Framework UI cross-platform
- **Firebase** - Backend (Auth + Database + Storage)
- **Dart** - Langage de programmation

### ⏱️ Temps total
Environ **1h30** pour avoir une app fonctionnelle

### 📦 Ce qui est déjà prêt
- ✅ Tous les modèles de données
- ✅ Services Firebase complets
- ✅ Widgets réutilisables
- ✅ Thème et couleurs
- ✅ Page d'accueil

---

## 2. Installer Flutter

### ⏱️ Durée: 15 minutes

### 📝 Étapes

#### 2.1 Télécharger Flutter (2 min)

```powershell
# Option 1: Téléchargement direct
# Visitez: https://docs.flutter.dev/get-started/install/windows
# Téléchargez flutter_windows_3.x.x-stable.zip

# Option 2: Via Git
cd C:\
git clone https://github.com/flutter/flutter.git -b stable
```

#### 2.2 Extraire Flutter (1 min)

```powershell
# Extrayez le ZIP dans C:\flutter
# OU si vous avez utilisé git, flutter est déjà à C:\flutter
```

#### 2.3 Ajouter au PATH (2 min)

1. Appuyez sur `Win + R`
2. Tapez `sysdm.cpl` et appuyez sur Entrée
3. Onglet "Avancé" → "Variables d'environnement"
4. Dans "Variables système", double-cliquez sur `Path`
5. Cliquez "Nouveau"
6. Ajoutez `C:\flutter\bin`
7. Cliquez "OK" sur toutes les fenêtres

#### 2.4 Vérifier l'installation (2 min)

```powershell
# Fermez et rouvrez PowerShell
flutter --version

# Devrait afficher:
# Flutter 3.x.x • channel stable
```

#### 2.5 Installer Android Studio (8 min)

1. Téléchargez depuis: https://developer.android.com/studio
2. Installez avec les options par défaut
3. Au premier lancement:
   - Next → Next → Finish
   - Install → Finish
4. Ouvrez Android Studio
5. Plus d'actions → SDK Manager
6. SDK Tools → Cochez "Android SDK Command-line Tools"
7. Apply → OK

#### 2.6 Accepter les licences Android (1 min)

```powershell
flutter doctor --android-licenses
# Tapez 'y' pour tout accepter
```

#### 2.7 Vérification finale

```powershell
flutter doctor

# Devrait afficher:
# ✓ Flutter
# ✓ Android toolchain
# ✓ Visual Studio (Windows)
```

### ✅ Checkpoint
Vous avez maintenant Flutter installé et fonctionnel !

---

## 3. Créer le Projet

### ⏱️ Durée: 5 minutes

### 📝 Étapes

#### 3.1 Créer le projet Flutter (2 min)

```powershell
cd C:\Wassaliparceldeliveryapp

# Créer le projet
flutter create wassali_flutter --org com.wassali

# Naviguer dans le projet
cd wassali_flutter
```

#### 3.2 Copier les fichiers sources (2 min)

```powershell
# Copier tous les fichiers lib/
Copy-Item -Path "..\wassali_flutter_complete\lib\*" -Destination ".\lib\" -Recurse -Force

# Copier pubspec.yaml
Copy-Item -Path "..\wassali_flutter_complete\pubspec.yaml" -Destination ".\" -Force
```

#### 3.3 Installer les dépendances (1 min)

```powershell
flutter pub get

# Devrait télécharger ~15 packages
```

### ✅ Checkpoint
Le projet Flutter est créé avec tous les fichiers sources !

---

## 4. Configurer Firebase

### ⏱️ Durée: 10 minutes

### 📝 Étapes

#### 4.1 Installer Firebase CLI (2 min)

```powershell
npm install -g firebase-tools
dart pub global activate flutterfire_cli

# Vérifier
firebase --version
flutterfire --version
```

#### 4.2 Se connecter à Firebase (1 min)

```powershell
firebase login

# Une page web s'ouvre
# Connectez-vous avec votre compte Google
```

#### 4.3 Créer un projet Firebase (2 min)

1. Ouvrez https://console.firebase.google.com/
2. Cliquez "Ajouter un projet"
3. Nom du projet: `Wassali`
4. Désactivez Google Analytics (ou laissez activé)
5. Cliquez "Créer le projet"

#### 4.4 Configurer FlutterFire (2 min)

```powershell
# Dans le dossier wassali_flutter
flutterfire configure

# Sélectionnez:
# - Projet existant: Wassali
# - Plateformes: Android, iOS, Web, Windows
```

Cela crée automatiquement `lib/firebase_options.dart`.

#### 4.5 Activer Authentication (1 min)

1. Dans Firebase Console → Authentication
2. Cliquez "Commencer"
3. Onglet "Sign-in method"
4. Cliquez sur "Email/Password"
5. Activez le premier interrupteur
6. Enregistrer

#### 4.6 Créer Firestore Database (2 min)

1. Dans Firebase Console → Firestore Database
2. Cliquez "Créer une base de données"
3. Mode: **Production**
4. Emplacement: `europe-west1` (Belgique)
5. Activer

#### 4.7 Activer Storage (optionnel, 1 min)

1. Dans Firebase Console → Storage
2. Cliquez "Commencer"
3. Mode: Production
4. Continuer

#### 4.8 Décommenter Firebase dans le code (1 min)

Ouvrez `lib/main.dart` et modifiez:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Décommentez ces lignes:
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### ✅ Checkpoint
Firebase est configuré et connecté à votre app !

---

## 5. Premier Lancement

### ⏱️ Durée: 3 minutes

### 📝 Étapes

#### 5.1 Lancer sur Windows Desktop (1 min)

```powershell
flutter run -d windows

# Attendez la compilation (1-3 minutes la première fois)
```

#### 5.2 Voir l'application (1 min)

Vous devriez voir:
- 🎨 Logo Wassali (camion bleu)
- 🔵 Bouton "Continuer en tant que Client"
- 🟠 Bouton "Devenir Transporteur"
- ⚡ Badges "Rapide, Abordable, Sécurisé"
- 🔗 Lien "Se connecter"

#### 5.3 Tester Hot Reload (1 min)

1. Modifiez le texte dans `lib/screens/landing_screen.dart`
2. Appuyez sur `r` dans le terminal
3. L'app se met à jour instantanément !

### ✅ Checkpoint
Votre application Wassali fonctionne !

---

## 6. Créer l'Écran de Connexion

### ⏱️ Durée: 20 minutes

### 📝 Étapes

#### 6.1 Créer le fichier LoginScreen (1 min)

Créez `lib/screens/login_screen.dart`:

```dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/common_widgets.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppColors.success,
        ),
      );
      // TODO: Naviguer vers HomeScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Titre
                const Text(
                  'Bienvenue !',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Connectez-vous pour continuer',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.gray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'votre@email.com',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalide';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Password
                CustomTextField(
                  controller: _passwordController,
                  label: 'Mot de passe',
                  hint: '••••••••',
                  prefixIcon: Icons.lock,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Au moins 6 caractères requis';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 12),
                
                // Mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Navigation vers reset password
                    },
                    child: const Text('Mot de passe oublié ?'),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Bouton de connexion
                CustomButton(
                  text: 'Se connecter',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
                
                const SizedBox(height: 24),
                
                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.gray300)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OU',
                        style: TextStyle(color: AppColors.gray500),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.gray300)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bouton inscription
                OutlinedButton(
                  onPressed: () {
                    // TODO: Navigation vers signup
                  },
                  child: const Text('Créer un compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### 6.2 Ajouter la route (2 min)

Dans `lib/main.dart`, ajoutez:

```dart
import 'screens/login_screen.dart';

// Dans routes:
routes: {
  '/': (context) => const LandingScreen(),
  '/login': (context) => const LoginScreen(),  // ← Ajouter
},
```

#### 6.3 Connecter le bouton (2 min)

Dans `lib/screens/landing_screen.dart`, modifiez:

```dart
// Dans _buildLoginLink(), remplacez:
onPressed: () {
  Navigator.pushNamed(context, '/login');  // ← Modifier
},
```

#### 6.4 Tester la navigation (1 min)

1. Hot restart: appuyez sur `R`
2. Cliquez sur "Se connecter"
3. Vous devriez voir l'écran de connexion !

### ✅ Checkpoint
L'écran de connexion est créé et fonctionnel !

---

## 7. Tester l'Authentification

### ⏱️ Durée: 5 minutes

### 📝 Étapes

#### 7.1 Créer un compte test (2 min)

1. Ouvrez Firebase Console → Authentication
2. Onglet "Users"
3. Cliquez "Ajouter un utilisateur"
4. Email: `test@wassali.com`
5. Mot de passe: `test123`
6. Cliquez "Ajouter un utilisateur"

#### 7.2 Tester la connexion (2 min)

Dans votre app:
1. Entrez `test@wassali.com`
2. Entrez `test123`
3. Cliquez "Se connecter"
4. Vous devriez voir un message de succès vert !

#### 7.3 Vérifier dans Firebase (1 min)

1. Ouvrez Firebase Console → Authentication
2. Vous devriez voir "Dernière connexion: Il y a quelques secondes"

### ✅ Checkpoint
L'authentification Firebase fonctionne !

---

## 🎉 Félicitations !

Vous avez:
- ✅ Installé Flutter
- ✅ Créé le projet Wassali
- ✅ Configuré Firebase
- ✅ Lancé l'application
- ✅ Créé un écran de connexion
- ✅ Testé l'authentification

### 📚 Prochaines Étapes

1. **Créer l'écran d'inscription:**
   - Copier le modèle de LoginScreen
   - Utiliser `authService.signUp()`
   - Ajouter champs nom et téléphone

2. **Créer l'écran d'accueil:**
   - Afficher les trajets disponibles
   - Utiliser `firestoreService.getTrips()`
   - Afficher avec `TripCard` widget

3. **Ajouter la recherche:**
   - Filtres par ville de départ/arrivée
   - Filtres par date
   - Résultats en temps réel

4. **Créer le système de réservation:**
   - Formulaire de réservation
   - Calcul du prix
   - Paiement

### 🔗 Ressources Utiles

- 📖 [README.md](README.md) - Documentation complète
- 📖 [QUICK_START.md](QUICK_START.md) - Guide de démarrage
- 📖 [PROJECT_STATUS.md](PROJECT_STATUS.md) - État du projet
- 🌐 [Documentation Flutter](https://docs.flutter.dev/)
- 🔥 [Documentation Firebase](https://firebase.google.com/docs/flutter)

### 💬 Besoin d'aide ?

- Consultez les fichiers de documentation
- Vérifiez les exemples dans `flutter_examples/`
- Relisez ce tutoriel étape par étape

---

**Bon développement avec Flutter ! 🚀**

*Wassali - Ça arrive !*
