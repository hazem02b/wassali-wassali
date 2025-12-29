# 🚀 Guide de Démarrage Rapide - Wassali Mobile

## Étape 1 : Préparation

### 1.1 Vérifier Flutter
```bash
flutter doctor
```

### 1.2 Aller dans le dossier du projet
```bash
cd wassali_mobile
```

### 1.3 Installer les dépendances
```bash
flutter pub get
```

---

## Étape 2 : Configuration

### 2.1 Configurer l'URL de l'API

Ouvrir [lib/services/api_service.dart](lib/services/api_service.dart)

**Pour émulateur Android :**
```dart
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';
```

**Pour appareil physique :**
```dart
// Remplacer 192.168.1.100 par votre IP local
static const String baseUrl = 'http://192.168.1.100:8000/api/v1';
```

**Pour trouver votre IP :**
- Windows : `ipconfig` dans le terminal
- Mac/Linux : `ifconfig` dans le terminal
- Chercher l'adresse IPv4

---

## Étape 3 : Lancer le Backend

```bash
# Ouvrir un nouveau terminal
cd backend

# Lancer le serveur FastAPI
python main.py

# Vérifier que le serveur est accessible sur http://localhost:8000
```

---

## Étape 4 : Lancer l'Application

### 4.1 Vérifier les appareils disponibles
```bash
flutter devices
```

### 4.2 Lancer l'app
```bash
# Sur l'appareil par défaut
flutter run

# Ou sur un appareil spécifique
flutter run -d <device-id>
```

---

## Étape 5 : Tester l'Application

### Test 1 : Créer un compte client

1. Sur la page d'accueil, cliquer sur **"Commencer"**
2. Cliquer sur **"Se connecter"**
3. Cliquer sur **"S'inscrire"** (en bas)
4. Sélectionner **"Client"**
5. Remplir le formulaire :
   - Prénom : `Mohamed`
   - Nom : `Benali`
   - Email : `mohamed@test.com`
   - Téléphone : `+216 12 345 678`
   - Mot de passe : `Test123!`
6. Cliquer sur **"S'inscrire"**

### Test 2 : Rechercher un trajet

1. Sur la page d'accueil client
2. Remplir :
   - De : `Tunis`
   - Vers : `Paris`
   - Date : Aujourd'hui
3. Cliquer sur **"Rechercher"**
4. Voir les résultats

### Test 3 : Créer un compte transporteur

1. Se déconnecter
2. Revenir à la page de connexion
3. Sélectionner **"Transporteur"**
4. S'inscrire avec :
   - Prénom : `Ahmed`
   - Nom : `Transport`
   - Email : `ahmed@transport.com`
   - Téléphone : `+33 6 12 34 56 78`
   - Mot de passe : `Transport123!`
   - Type de véhicule : `Voiture`

### Test 4 : Créer un trajet (transporteur)

1. Sur le dashboard transporteur
2. Cliquer sur **"Créer un trajet"**
3. Remplir :
   - Ville de départ : `Tunis`
   - Pays : `Tunisie`
   - Ville d'arrivée : `Paris`
   - Pays : `France`
   - Date de départ : Demain
   - Poids max : `30 kg`
   - Prix par kg : `15 €`
4. Créer le trajet

---

## 🐛 Résolution de Problèmes

### Problème : "Connection refused" ou "Network error"

**Cause** : L'app ne peut pas se connecter au backend

**Solutions** :
1. Vérifier que le backend est lancé (`python main.py`)
2. Vérifier l'URL dans `api_service.dart`
3. Pour appareil physique : 
   - Utiliser l'IP locale (pas `localhost`)
   - Vérifier que téléphone et PC sont sur le même réseau WiFi

### Problème : "401 Unauthorized"

**Cause** : Token expiré ou invalide

**Solution** : Se déconnecter et se reconnecter

### Problème : Écran blanc au démarrage

**Cause** : Erreur de compilation

**Solutions** :
```bash
# Nettoyer et rebuild
flutter clean
flutter pub get
flutter run
```

### Problème : "Waiting for another flutter command to release the startup lock"

**Solution** :
```bash
# Supprimer le fichier de lock
rm -f /path/to/flutter/bin/cache/lockfile

# Windows
del "%LOCALAPPDATA%\flutter\bin\cache\lockfile"
```

---

## 📱 Raccourcis Utiles

Pendant que l'app tourne :
- **r** : Hot reload (recharger le code)
- **R** : Hot restart (redémarrer l'app)
- **v** : Ouvrir DevTools
- **q** : Quitter

---

## 🔍 Déboguer

### Voir les logs
```bash
flutter logs
```

### Inspecter l'UI
```bash
flutter run --trace-skia
```

### Analyser les performances
```bash
flutter run --profile
```

---

## 📦 Build de Production

### Android APK
```bash
flutter build apk --release

# L'APK sera dans :
# build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (pour Google Play)
```bash
flutter build appbundle --release

# L'AAB sera dans :
# build/app/outputs/bundle/release/app-release.aab
```

---

## 🎯 Fonctionnalités à Tester

### Pour Client
- [x] Inscription / Connexion
- [x] Recherche de trajets
- [x] Voir détails d'un trajet
- [x] Créer une réservation
- [x] Voir mes réservations
- [x] Laisser un avis
- [x] Messagerie
- [x] Profil
- [x] Changer mot de passe

### Pour Transporteur
- [x] Inscription / Connexion
- [x] Dashboard avec statistiques
- [x] Créer un trajet
- [x] Voir mes trajets
- [x] Gérer les réservations
- [x] Voir mes avis
- [x] Messagerie
- [x] Profil

---

## 📞 Aide

En cas de problème :
1. Vérifier la [documentation Flutter](https://docs.flutter.dev)
2. Consulter [README.md](README.md) complet
3. Vérifier les logs : `flutter logs`

---

**Bon développement ! 🚀**
