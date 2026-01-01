# 📱 Guide de Test sur Android Studio

## ✅ Prérequis

### Backend
- ✅ Backend démarré sur `http://localhost:8000`
- ✅ Toutes les APIs fonctionnent
- ✅ Base de données SQLite configurée

### Android Studio
- Android Studio installé
- Android SDK configuré
- Émulateur Android ou device physique

## 🔧 Configuration

### 1. Configuration API (Déjà faite ✅)

Le fichier `api_config.dart` a été mis à jour avec:
- **URL pour émulateur:** `http://10.0.2.2:8000/api/v1`
- **Préfixe API:** `/api/v1` (correct)
- **Tous les endpoints:** Configurés

### 2. Démarrer le Backend

```bash
cd C:\Users\HAZEM\Wassaliparceldeliveryapp\backend
python start.py
```

Vérifier que le backend tourne:
```bash
curl http://localhost:8000/health
```

Résultat attendu:
```json
{"status":"healthy","service":"Wassali API","version":"1.0.0"}
```

## 🚀 Lancer l'App sur Android Studio

### Option 1: Utiliser l'émulateur Android

1. **Ouvrir Android Studio**
   ```
   Ouvrir le dossier: C:\Users\HAZEM\Wassaliparceldeliveryapp\wassali_mobile_app
   ```

2. **Créer/Lancer un émulateur**
   - Menu: `Tools > Device Manager`
   - Créer un nouvel AVD (Android Virtual Device) ou utiliser un existant
   - Recommandé: Pixel 7 avec Android 13 (API 33)

3. **Installer les dépendances**
   ```bash
   cd C:\Users\HAZEM\Wassaliparceldeliveryapp\wassali_mobile_app
   flutter pub get
   ```

4. **Lancer l'application**
   ```bash
   flutter run
   ```
   
   Ou dans Android Studio:
   - Cliquer sur le bouton ▶️ (Run)
   - Sélectionner l'émulateur

### Option 2: Utiliser un device physique

1. **Activer le mode développeur** sur votre Android
   - Paramètres > À propos du téléphone
   - Taper 7 fois sur "Numéro de build"

2. **Activer le débogage USB**
   - Paramètres > Options développeur
   - Activer "Débogage USB"

3. **Connecter le téléphone** en USB

4. **Trouver l'adresse IP de votre PC**
   ```bash
   ipconfig
   ```
   Chercher "IPv4 Address" (ex: 192.168.1.100)

5. **Mettre à jour api_config.dart**
   ```dart
   static const String baseUrl = 'http://192.168.1.100:8000/api/v1';
   ```

6. **Lancer l'app**
   ```bash
   flutter run
   ```

## 🧪 Tester les Fonctionnalités

### 1. Test Inscription Client
- Ouvrir l'app
- Aller sur "S'inscrire"
- Remplir le formulaire:
  - Email: `test@wassali.tn`
  - Mot de passe: `Test123!`
  - Nom: `Ahmed Test`
  - Téléphone: `+216 98 123 456`
  - Rôle: Client
- Cliquer sur "S'inscrire"

**Résultat attendu:** ✅ Compte créé, redirection vers login

### 2. Test Connexion
- Email: `test@wassali.tn`
- Mot de passe: `Test123!`
- Cliquer sur "Se connecter"

**Résultat attendu:** ✅ Connexion réussie, redirection vers home

### 3. Test Création d'Envoi
- Cliquer sur "Nouvel envoi"
- Remplir:
  - Adresse de collecte: `Tunis, Tunisie`
  - Adresse de livraison: `Paris, France`
  - Description: `Colis test`
  - Poids: `5.0` kg
  - Taille: `Moyen`
  - Prix: `25` TND
- Cliquer sur "Créer"

**Résultat attendu:** ✅ Envoi créé, visible dans "Mes envois"

### 4. Test Liste Transporteurs
- Menu > Transporteurs
- Voir la liste des transporteurs disponibles

**Résultat attendu:** ✅ Liste affichée (peut être vide)

## ⚠️ Résolution de Problèmes

### Problème: "Connection refused"

**Cause:** Le backend n'est pas accessible depuis l'émulateur

**Solution:**
1. Vérifier que le backend tourne: `curl http://localhost:8000/health`
2. Vérifier que l'URL est `10.0.2.2` dans `api_config.dart`
3. Redémarrer l'émulateur

### Problème: "404 Not Found"

**Cause:** Mauvais préfixe d'API

**Solution:**
- Vérifier que `baseUrl = 'http://10.0.2.2:8000/api/v1'`
- Vérifier que les endpoints commencent par `/`

### Problème: "422 Unprocessable Entity"

**Cause:** Mauvais format de données

**Solution:**
- Vérifier que le champ est `name` et non `full_name`
- Vérifier que le rôle est `client` et non `customer`
- Vérifier que le login inclut le champ `role`

### Problème: Hot reload ne fonctionne pas

**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

## 📊 Vérification Backend depuis l'Émulateur

Depuis le terminal de l'émulateur (ou adb shell):

```bash
# Tester la connexion
curl http://10.0.2.2:8000/health

# Tester l'inscription
curl -X POST http://10.0.2.2:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@test.tn","password":"Test123!","name":"Test","phone":"+216 98111222","role":"client"}'
```

## 🔍 Logs de Débogage

### Voir les logs Flutter
```bash
flutter logs
```

### Voir les logs de l'émulateur
Dans Android Studio:
- Menu: `View > Tool Windows > Logcat`
- Filtrer par votre package name: `com.example.wassali`

### Voir les logs du backend
Dans le terminal où le backend tourne, vous verrez:
```
INFO: 10.0.2.2:xxxxx - "POST /api/v1/auth/register HTTP/1.1" 201
INFO: 10.0.2.2:xxxxx - "POST /api/v1/auth/login HTTP/1.1" 200
```

## ✅ Checklist Avant de Tester

- [ ] Backend démarré (`python start.py`)
- [ ] Backend accessible (`curl http://localhost:8000/health`)
- [ ] Flutter dependencies installées (`flutter pub get`)
- [ ] Émulateur lancé ou device connecté
- [ ] `api_config.dart` configuré avec `10.0.2.2`
- [ ] App lancée (`flutter run`)

## 🎯 Fonctionnalités à Tester

### Authentification
- [ ] Inscription client
- [ ] Inscription transporteur
- [ ] Connexion
- [ ] Déconnexion
- [ ] Voir profil

### Envois (Parcels)
- [ ] Créer un envoi
- [ ] Voir mes envois
- [ ] Voir détails d'un envoi
- [ ] Modifier un envoi
- [ ] Supprimer un envoi

### Transporteurs
- [ ] Voir liste transporteurs
- [ ] Voir détails transporteur

### Voyages (si transporteur)
- [ ] Créer un voyage
- [ ] Voir mes voyages
- [ ] Voir détails voyage

---

**Prêt à tester!** 🚀

Si vous rencontrez un problème, vérifiez:
1. Le backend tourne bien
2. L'URL dans `api_config.dart` est correcte
3. Les logs de l'émulateur et du backend
