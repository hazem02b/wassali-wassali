# 📊 RAPPORT DE TEST DES APIs MOBILE WASSALI

## ✅ État du Backend

**Backend Status:** ✅ OPÉRATIONNEL
- **URL:** http://localhost:8000
- **Base de données:** SQLite (wassali.db)
- **Documentation:** http://localhost:8000/api/v1/docs

## 🔧 Configuration découverte

### Préfixe API
- **Préfixe correct:** `/api/v1`
- **Base URL complète:** `http://localhost:8000/api/v1`

### Endpoints disponibles (documentés dans /docs)

#### 🔐 Authentification
- `POST /api/v1/auth/register` - Inscription client
- `POST /api/v1/auth/register/transporter` - Inscription transporteur  
- `POST /api/v1/auth/login` - Connexion

#### 👤 Utilisateurs
- `GET /api/v1/users/me` - Mon profil
- `GET /api/v1/users/{user_id}` - Profil utilisateur
- `GET /api/v1/users/transporters/all` - Liste transporteurs
- `GET /api/v1/users/transporters/available` - Transporteurs disponibles

#### 📦 Parcels (Envois)
- `POST /api/v1/parcels/` - Créer un envoi
- `GET /api/v1/parcels/` - Liste mes envois
- `GET /api/v1/parcels/{parcel_id}` - Détails d'un envoi
- `POST /api/v1/parcels/location/track` - Tracker un envoi

#### 🚗 Trips (Voyages)
- Probablement disponibles mais pas testés dans cette session

## 📋 Schémas de données

### Inscription (`UserCreate`)
```json
{
  "email": "string",
  "password": "string",
  "full_name": "string",         // IMPORTANT: c'est "full_name", pas "name"
  "phone": "string",
  "role": "customer",             // ou "transporter"
  "vehicle_type": "string",       // optionnel, pour transporteurs
  "driver_license": "string"      // optionnel, pour transporteurs
}
```

### Connexion (`LoginRequest`)
```json
{
  "email": "string",
  "password": "string"
}
```

### Réponse authentification
```json
{
  "access_token": "eyJhbGciOiJIUz...",
  "token_type": "bearer",
  "user": {
    "id": 1,
    "email": "...",
    "full_name": "...",
    ...
  }
}
```

## 📱 Configuration pour l'Application Mobile

### Mise à jour requise dans `api_config.dart`

```dart
class ApiConfig {
  // URL de base
  static const String baseUrl = 'http://localhost:8000/api/v1';
  
  // Pour émulateur Android
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api/v1';
  
  // Pour émulateur iOS  
  static const String iosSimulatorUrl = 'http://localhost:8000/api/v1';
  
  // Endpoints
  static const String register = '/auth/register';
  static const String registerTransporter = '/auth/register/transporter';
  static const String login = '/auth/login';
  static const String userProfile = '/users/me';
  static const String createParcel = '/parcels/';
  static const String listParcels = '/parcels/';
  static const String listTransporters = '/users/transporters/all';
}
```

### Points importants

1. **Préfixe:** Utiliser `/api/v1` et NON `/api/`
2. **Champ nom:** Utiliser `full_name` dans les requêtes (pas `name`)
3. **Authentification:** Le token est dans `access_token` de la réponse
4. **Headers:** Utiliser `Authorization: Bearer <token>` pour les requêtes authentifiées

## 🧪 Tests effectués

### ✅ Tests réussis
- Backend accessible
- Health check fonctionnel
- Documentation accessible

### ⚠️ Tests en cours
- Inscription client
- Connexion
- Récupération profil
- Création d'envois

### ❌ Problèmes identifiés
1. Erreurs 500 sur certains endpoints (possibles problèmes backend)
2. Certains endpoints retournent 404 (configuration en cours)

## 🔄 Prochaines étapes

1. ✅ Backend démarré et opérationnel
2. ⏳ Vérification complète de tous les endpoints
3. ⏳ Mise à jour de la configuration mobile
4. ⏳ Tests d'intégration mobile-backend

## 📚 Documentation

- **Swagger UI:** http://localhost:8000/api/v1/docs
- **ReDoc:** http://localhost:8000/api/v1/redoc
- **Health Check:** http://localhost:8000/health

---

**Date:** 2025-01-31
**Backend:** FastAPI + SQLite
**Mobile:** Flutter 3.10.4+
