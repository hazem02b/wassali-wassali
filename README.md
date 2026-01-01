# Application Wassali - Livraison de Colis

Application mobile complète de livraison de colis avec système de covoiturage.

##  Architecture

- **Frontend Mobile**: Flutter (38 pages, Clean Architecture)
- **Backend API**: FastAPI (Python)
- **Base de données**: SQLite

##  Fonctionnalités

### Mobile App (Flutter)
- Authentification (Client & Transporteur)
- Recherche de trajets
- Réservation de colis
- Chat en temps réel
- Géolocalisation
- Profil utilisateur
- Historique des trajets
- Évaluations et avis
- Paiements intégrés
- Notifications push

### Backend (FastAPI)
- API RESTful complète
- Authentification JWT
- WebSocket pour le chat
- Gestion des utilisateurs
- Gestion des trajets
- Système de réservations
- Messagerie
- Évaluations

##  Installation

### Backend
\\\ash
cd backend
pip install -r requirements.txt
python start.py
\\\

### Mobile
\\\ash
cd wassali_mobile_app
flutter pub get
flutter run
\\\

##  Configuration

Le backend utilise SQLite par défaut. Configuration dans \.env\:
\\\
DATABASE_URL=sqlite:///./wassali.db
SECRET_KEY=votre_cle_secrete
\\\

##  Packages Flutter

- Provider (State Management)
- Dio (HTTP Client)
- GoRouter (Navigation)
- Geolocator (Géolocalisation)
- Flutter Secure Storage
- Socket.io Client
- Et 50+ packages...

##  API Endpoints

- \POST /api/v1/auth/register/client\ - Inscription client
- \POST /api/v1/auth/login\ - Connexion
- \GET /api/v1/auth/me\ - Profil utilisateur
- \GET /api/v1/trips\ - Liste des trajets
- \POST /api/v1/bookings\ - Créer une réservation
- Et plus...

##  License

MIT
