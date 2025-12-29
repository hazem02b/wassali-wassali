# 🎯 GUIDE DÉTAILLÉ - Test de l'API Wassali via Swagger UI

**Date:** 24 Décembre 2025  
**URL Swagger:** http://localhost:8000/api/v1/docs

---

## 📋 TABLE DES MATIÈRES

1. [Accéder à Swagger UI](#étape-1-accéder-à-swagger-ui)
2. [Tester l'inscription d'un transporteur](#étape-2-inscription-dun-transporteur)
3. [Copier le token](#étape-3-copier-le-token)
4. [S'authentifier avec Authorize](#étape-4-sauthentifier)
5. [Créer un trajet](#étape-5-créer-un-trajet)
6. [Inscrire un client](#étape-6-inscrire-un-client)
7. [Rechercher des trajets](#étape-7-rechercher-des-trajets)
8. [Créer une réservation](#étape-8-créer-une-réservation)
9. [Tester les autres endpoints](#étape-9-autres-endpoints)

---

## ÉTAPE 1: Accéder à Swagger UI

### Action
1. Ouvrez votre navigateur web (Chrome, Firefox, Edge)
2. Dans la barre d'adresse, tapez:
   ```
   http://localhost:8000/api/v1/docs
   ```
3. Appuyez sur Entrée

### Ce que vous devriez voir
- **Titre:** "Wassali API" en haut de la page
- **Description:** "API backend pour l'application Wassali - Livraison de colis Tunisie-Europe"
- **Version:** 1.0.0
- **Sections:** auth, trips, bookings, reviews

### Interface Swagger
```
┌─────────────────────────────────────────────────────┐
│ Wassali API                              v1.0.0     │
│ API backend pour l'application Wassali              │
├─────────────────────────────────────────────────────┤
│                                                      │
│ ▼ auth - Endpoints d'authentification               │
│   POST   /api/v1/auth/register    Register          │
│   POST   /api/v1/auth/login        Login            │
│   GET    /api/v1/auth/me           Read Users Me    │
│                                                      │
│ ▼ trips - Gestion des trajets                       │
│   GET    /api/v1/trips             Read Trips       │
│   POST   /api/v1/trips             Create Trip      │
│   ...                                                │
│                                                      │
│ ▼ bookings - Gestion des réservations               │
│   ...                                                │
└─────────────────────────────────────────────────────┘
```

---

## ÉTAPE 2: Inscription d'un Transporteur

### Action
1. **Localisez** la section "auth" (tout en haut)
2. **Cliquez** sur `POST /api/v1/auth/register` pour l'ouvrir
   - La ligne devient bleue/verte
3. **Cliquez** sur le bouton "Try it out" (en haut à droite)
   - Le bouton devient gris et le champ devient éditable

### Ce que vous voyez maintenant
```
POST /api/v1/auth/register    Register

Parameters
  No parameters

Request body    application/json
  Example Value    Model

  {
    "email": "user@example.com",
    "password": "string",
    ...
  }
```

### Modifier le JSON
4. **Supprimez** tout le contenu du champ "Request body"
5. **Copiez-collez** exactement ce JSON:

```json
{
  "email": "ahmed@transport.ma",
  "password": "Ahmed123!",
  "first_name": "Ahmed",
  "last_name": "Benali",
  "phone": "+212612345678",
  "role": "transporter"
}
```

### ⚠️ IMPORTANT - Détails du JSON
- **email:** Doit être unique, format email valide
- **password:** 
  - Minimum 8 caractères
  - Au moins 1 majuscule
  - Au moins 1 chiffre
  - Au moins 1 caractère spécial (!@#$%^&*)
- **role:** Soit "client" soit "transporter"
- **phone:** Format international (+212... pour Maroc, +33... pour France)

### Exécuter la requête
6. **Cliquez** sur le bouton bleu "Execute" en bas
7. **Attendez** 1-2 secondes

### Réponse attendue - SUCCÈS (Code 200)
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzM1MDY3...",
  "token_type": "bearer",
  "user": {
    "id": 1,
    "email": "ahmed@transport.ma",
    "first_name": "Ahmed",
    "last_name": "Benali",
    "phone": "+212612345678",
    "role": "transporter",
    "created_at": "2025-12-24T14:30:00.000000"
  }
}
```

### En cas d'erreur

**Erreur 422 - Email déjà utilisé:**
```json
{
  "detail": "Email already registered"
}
```
**Solution:** Changez l'email (ex: ahmed2@transport.ma)

**Erreur 422 - Mot de passe faible:**
```json
{
  "detail": [
    {
      "loc": ["body", "password"],
      "msg": "Password must be at least 8 characters",
      "type": "value_error"
    }
  ]
}
```
**Solution:** Utilisez un mot de passe plus fort

---

## ÉTAPE 3: Copier le Token

### Action
1. Dans la réponse (section "Response body"), localisez le champ `access_token`
2. Le token ressemble à ceci:
   ```
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZXhwIjoxNzM1MDY3...
   ```
3. **Méthode 1 - Copie rapide:**
   - Triple-cliquez sur le token pour le sélectionner entièrement
   - Ctrl+C (Windows) ou Cmd+C (Mac) pour copier

4. **Méthode 2 - Copie manuelle:**
   - Cliquez au début du token
   - Maintenez Shift et cliquez à la fin
   - Ctrl+C pour copier

### ⚠️ IMPORTANT
- Copiez **TOUT** le token (il peut être très long, 200-300 caractères)
- Ne copiez **PAS** les guillemets `"` autour du token
- Ne laissez **PAS** d'espaces au début ou à la fin

### Vérification
Le token doit:
- Commencer par: `eyJ`
- Contenir deux points: `.`
- Se terminer par des lettres/chiffres aléatoires

---

## ÉTAPE 4: S'Authentifier

### Action
1. **Remontez** tout en haut de la page Swagger
2. **Localisez** le bouton "Authorize" (🔓 icône de cadenas)
   - Il se trouve en haut à droite, près du titre
3. **Cliquez** sur "Authorize"

### Fenêtre qui s'ouvre
```
┌─────────────────────────────────────────┐
│ Available authorizations                │
├─────────────────────────────────────────┤
│ OAuth2PasswordBearer (OAuth2, password) │
│                                          │
│ Value:                                   │
│ ┌─────────────────────────────────────┐ │
│ │ Bearer COLLEZ_ICI_LE_TOKEN          │ │
│ └─────────────────────────────────────┘ │
│                                          │
│   [Authorize]  [Close]                  │
└─────────────────────────────────────────┘
```

### Coller le token
4. Dans le champ "Value", tapez: `Bearer ` (avec un espace après)
5. **Collez** le token après "Bearer "
   - Résultat: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
6. **Cliquez** sur "Authorize" (bouton dans la fenêtre)
7. **Cliquez** sur "Close"

### Vérification
- Le cadenas 🔓 devient 🔒 (fermé)
- À côté de "Authorize", vous voyez maintenant "Logout"

### ⚠️ Format EXACT requis
```
Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIi...
^      ^
│      └─ Token (pas de guillemets)
└─ Mot "Bearer" avec majuscule et UN ESPACE après
```

---

## ÉTAPE 5: Créer un Trajet

Maintenant que vous êtes authentifié en tant que transporteur, vous pouvez créer un trajet.

### Action
1. **Trouvez** la section "trips"
2. **Cliquez** sur `POST /api/v1/trips` (Create Trip)
3. **Cliquez** sur "Try it out"
4. **Remplacez** le JSON par:

```json
{
  "origin_city": "Casablanca",
  "origin_country": "Maroc",
  "destination_city": "Paris",
  "destination_country": "France",
  "departure_date": "2025-01-15T10:00:00",
  "arrival_date": "2025-01-16T08:00:00",
  "max_weight": 30,
  "available_weight": 30,
  "price_per_kg": 15,
  "description": "Trajet régulier Casablanca-Paris. Transport sécurisé.",
  "vehicle_info": "Voiture spacieuse, climatisée"
}
```

### Explication des champs
- **origin_city/country:** Ville et pays de départ
- **destination_city/country:** Ville et pays d'arrivée
- **departure_date:** Date/heure départ (format ISO: YYYY-MM-DDTHH:MM:SS)
- **arrival_date:** Date/heure arrivée
- **max_weight:** Poids maximum transportable (kg)
- **available_weight:** Poids encore disponible (kg)
- **price_per_kg:** Prix par kilogramme (€)
- **description:** Description du trajet
- **vehicle_info:** Informations sur le véhicule

5. **Cliquez** sur "Execute"

### Réponse attendue (Code 200)
```json
{
  "id": 1,
  "transporter_id": 1,
  "origin_city": "Casablanca",
  "origin_country": "Maroc",
  "destination_city": "Paris",
  "destination_country": "France",
  "departure_date": "2025-01-15T10:00:00",
  "arrival_date": "2025-01-16T08:00:00",
  "max_weight": 30,
  "available_weight": 30,
  "price_per_kg": 15,
  "description": "Trajet régulier Casablanca-Paris. Transport sécurisé.",
  "vehicle_info": "Voiture spacieuse, climatisée",
  "status": "active",
  "created_at": "2025-12-24T14:35:00.000000"
}
```

### ✅ Notez l'ID du trajet
- Dans la réponse, notez le `"id": 1` (ou autre numéro)
- Vous en aurez besoin pour la réservation

---

## ÉTAPE 6: Inscrire un Client

Pour tester les réservations, nous avons besoin d'un compte client.

### Action
1. **Remontez** à la section "auth"
2. **Cliquez** sur `POST /api/v1/auth/register`
3. **Cliquez** sur "Try it out"
4. **Collez** ce JSON:

```json
{
  "email": "fatima@client.ma",
  "password": "Fatima123!",
  "first_name": "Fatima",
  "last_name": "Zahra",
  "phone": "+212698765432",
  "role": "client"
}
```

5. **Cliquez** sur "Execute"
6. **Copiez** le nouveau `access_token` retourné
7. **Cliquez** sur "Authorize" en haut
8. **Remplacez** l'ancien token par le nouveau:
   ```
   Bearer NOUVEAU_TOKEN_DU_CLIENT
   ```
9. **Cliquez** sur "Authorize" puis "Close"

### ⚠️ Important
Vous êtes maintenant authentifié en tant que CLIENT (plus transporteur).
Les endpoints disponibles changent selon votre rôle.

---

## ÉTAPE 7: Rechercher des Trajets

En tant que client, recherchons les trajets disponibles.

### Action
1. **Trouvez** `GET /api/v1/trips` (Read Trips)
2. **Cliquez** dessus puis "Try it out"
3. **Options de filtrage (optionnel):**
   - `origin_city`: Casablanca
   - `destination_city`: Paris
   - `min_date`: 2025-01-01
   - `max_date`: 2025-12-31
4. **Cliquez** sur "Execute"

### Réponse attendue
```json
[
  {
    "id": 1,
    "transporter_id": 1,
    "origin_city": "Casablanca",
    "destination_city": "Paris",
    "departure_date": "2025-01-15T10:00:00",
    "price_per_kg": 15,
    "available_weight": 30,
    "status": "active",
    ...
  }
]
```

### Analyse
- Vous devriez voir le trajet créé à l'étape 5
- Si la liste est vide, vérifiez les filtres ou créez un nouveau trajet

---

## ÉTAPE 8: Créer une Réservation

Maintenant, réservons de l'espace sur le trajet.

### Action
1. **Trouvez** `POST /api/v1/bookings` (Create Booking)
2. **Cliquez** dessus puis "Try it out"
3. **Collez** ce JSON (adaptez `trip_id` si nécessaire):

```json
{
  "trip_id": 1,
  "weight": 5,
  "item_description": "Colis personnel - vêtements, cadeaux, livres",
  "pickup_address": "123 Rue Mohammed V, Casablanca 20000, Maroc",
  "delivery_address": "45 Avenue des Champs-Élysées, 75008 Paris, France",
  "pickup_contact": "+212612345678",
  "delivery_contact": "+33612345678"
}
```

### Explication
- **trip_id:** ID du trajet (celui noté à l'étape 5)
- **weight:** Poids du colis en kg
- **item_description:** Description détaillée du contenu
- **pickup_address:** Adresse de ramassage complète
- **delivery_address:** Adresse de livraison complète
- **pickup_contact:** Téléphone pour le ramassage
- **delivery_contact:** Téléphone pour la livraison

4. **Cliquez** sur "Execute"

### Réponse attendue (Code 200)
```json
{
  "id": 1,
  "trip_id": 1,
  "user_id": 2,
  "weight": 5,
  "total_price": 75,
  "status": "pending",
  "item_description": "Colis personnel - vêtements, cadeaux, livres",
  "pickup_address": "123 Rue Mohammed V, Casablanca 20000, Maroc",
  "delivery_address": "45 Avenue des Champs-Élysées, 75008 Paris, France",
  "created_at": "2025-12-24T14:40:00.000000"
}
```

### Calcul du prix
- Prix = `weight × price_per_kg`
- Exemple: 5 kg × 15€/kg = 75€

---

## ÉTAPE 9: Autres Endpoints

### 9.1 - Voir Mon Profil

**Endpoint:** `GET /api/v1/auth/me`

**Action:**
1. Cliquez sur l'endpoint
2. "Try it out"
3. "Execute"

**Résultat:** Vos informations complètes

---

### 9.2 - Mes Réservations

**Endpoint:** `GET /api/v1/bookings`

**Action:**
1. Cliquez sur l'endpoint
2. "Try it out"
3. "Execute"

**Résultat:** Liste de toutes vos réservations

---

### 9.3 - Détails d'une Réservation

**Endpoint:** `GET /api/v1/bookings/{booking_id}`

**Action:**
1. Cliquez sur l'endpoint
2. "Try it out"
3. Dans `booking_id`, entrez: `1`
4. "Execute"

**Résultat:** Détails complets de la réservation #1

---

### 9.4 - Modifier une Réservation

**Endpoint:** `PUT /api/v1/bookings/{booking_id}`

**Action:**
1. Cliquez sur l'endpoint
2. "Try it out"
3. `booking_id`: 1
4. JSON:
```json
{
  "weight": 7,
  "item_description": "Colis personnel - vêtements, cadeaux, livres + souvenirs"
}
```
5. "Execute"

**Résultat:** Réservation mise à jour (nouveau prix: 7 × 15 = 105€)

---

### 9.5 - Laisser un Avis

**Endpoint:** `POST /api/v1/reviews`

**Prérequis:** La réservation doit être complétée

**Action:**
1. Cliquez sur l'endpoint
2. "Try it out"
3. JSON:
```json
{
  "trip_id": 1,
  "rating": 5,
  "comment": "Excellent service ! Transport rapide et sécurisé. Je recommande vivement Ahmed."
}
```
4. "Execute"

**rating:** Note de 1 à 5 étoiles

---

### 9.6 - Voir les Avis d'un Trajet

**Endpoint:** `GET /api/v1/reviews/trip/{trip_id}`

**Action:**
1. Cliquez sur l'endpoint
2. "Try it out"
3. `trip_id`: 1
4. "Execute"

**Résultat:** Tous les avis laissés pour ce trajet

---

### 9.7 - Modifier le Statut d'une Réservation (Transporteur)

**Note:** Reconnectez-vous avec le compte transporteur

**Endpoint:** `PUT /api/v1/bookings/{booking_id}/status`

**Action:**
1. Reconnectez-vous avec le token transporteur
2. Cliquez sur l'endpoint
3. "Try it out"
4. `booking_id`: 1
5. JSON:
```json
{
  "status": "confirmed"
}
```
6. "Execute"

**Statuts possibles:**
- `pending` - En attente
- `confirmed` - Confirmée
- `picked_up` - Ramassée
- `in_transit` - En transit
- `delivered` - Livrée
- `cancelled` - Annulée

---

## 🎯 SCÉNARIO COMPLET DE TEST

Voici un scénario complet à suivre:

### Partie 1: Configuration (5 min)
1. ✅ Créer un transporteur
2. ✅ S'authentifier comme transporteur
3. ✅ Créer 2-3 trajets différents

### Partie 2: Client (5 min)
4. ✅ Créer un client
5. ✅ S'authentifier comme client
6. ✅ Rechercher des trajets
7. ✅ Créer une réservation

### Partie 3: Gestion (5 min)
8. ✅ Reconnexion transporteur
9. ✅ Voir les réservations reçues
10. ✅ Confirmer une réservation
11. ✅ Changer le statut en "picked_up"

### Partie 4: Finalisation (3 min)
12. ✅ Marquer comme "delivered"
13. ✅ Reconnexion client
14. ✅ Laisser un avis

---

## 🔍 CODES DE RÉPONSE HTTP

| Code | Signification | Action |
|------|---------------|---------|
| **200** | ✅ Succès | Tout va bien |
| **201** | ✅ Créé | Ressource créée avec succès |
| **400** | ❌ Bad Request | Vérifiez le format JSON |
| **401** | ❌ Non autorisé | Token manquant/invalide/expiré |
| **403** | ❌ Interdit | Vous n'avez pas les permissions |
| **404** | ❌ Non trouvé | Ressource n'existe pas |
| **422** | ❌ Validation | Données invalides (voir détails) |
| **500** | ❌ Erreur serveur | Erreur backend (vérifier logs) |

---

## ❓ DÉPANNAGE

### Problème: "Not authenticated"
**Solution:** 
1. Vérifiez que le cadenas est fermé 🔒
2. Reconnectez-vous avec "Authorize"
3. Vérifiez le format: `Bearer TOKEN`

### Problème: "Token expired"
**Solution:**
1. Reconnectez-vous (les tokens expirent après 30 minutes)
2. Créez un nouveau compte ou utilisez `/login`

### Problème: "Email already registered"
**Solution:**
Changez l'email dans le JSON d'inscription

### Problème: "Validation error"
**Solution:**
Vérifiez le format des données (dates, email, etc.)

### Problème: La page ne charge pas
**Solution:**
1. Vérifiez que le backend tourne
2. Ouvrez: http://localhost:8000/api/v1/docs

---

## 📝 DONNÉES DE TEST PRÊTES À L'EMPLOI

### Transporteur 1
```json
{
  "email": "karim@transport.tn",
  "password": "Karim123!",
  "first_name": "Karim",
  "last_name": "Mansour",
  "phone": "+216123456789",
  "role": "transporter"
}
```

### Transporteur 2
```json
{
  "email": "youssef@voyages.ma",
  "password": "Youssef123!",
  "first_name": "Youssef",
  "last_name": "Alami",
  "phone": "+212687654321",
  "role": "transporter"
}
```

### Client 1
```json
{
  "email": "yasmine@mail.fr",
  "password": "Yasmine123!",
  "first_name": "Yasmine",
  "last_name": "Benali",
  "phone": "+33612345678",
  "role": "client"
}
```

### Client 2
```json
{
  "email": "ali@client.tn",
  "password": "Ali123456!",
  "first_name": "Ali",
  "last_name": "Mezghani",
  "phone": "+216987654321",
  "role": "client"
}
```

### Trajet Tunis → Lyon
```json
{
  "origin_city": "Tunis",
  "origin_country": "Tunisie",
  "destination_city": "Lyon",
  "destination_country": "France",
  "departure_date": "2025-02-01T14:00:00",
  "arrival_date": "2025-02-02T10:00:00",
  "max_weight": 25,
  "available_weight": 25,
  "price_per_kg": 12,
  "description": "Trajet mensuel Tunis-Lyon",
  "vehicle_info": "Camionnette Mercedes"
}
```

### Trajet Sousse → Marseille
```json
{
  "origin_city": "Sousse",
  "origin_country": "Tunisie",
  "destination_city": "Marseille",
  "destination_country": "France",
  "departure_date": "2025-01-20T08:00:00",
  "arrival_date": "2025-01-21T06:00:00",
  "max_weight": 20,
  "available_weight": 20,
  "price_per_kg": 10,
  "description": "Transport rapide et fiable",
  "vehicle_info": "Voiture familiale"
}
```

---

## ✅ CHECKLIST DE TEST

Cochez au fur et à mesure:

- [ ] Swagger UI ouvert
- [ ] Transporteur créé
- [ ] Token transporteur copié
- [ ] Authentification réussie (cadenas fermé)
- [ ] 1er trajet créé
- [ ] 2ème trajet créé (optionnel)
- [ ] Client créé
- [ ] Token client copié
- [ ] Authentification client réussie
- [ ] Recherche de trajets testée
- [ ] Réservation créée
- [ ] Détails réservation consultés
- [ ] Reconnexion transporteur
- [ ] Statut réservation modifié
- [ ] Avis laissé
- [ ] Avis consultés

---

## 🎊 FÉLICITATIONS !

Si vous avez suivi toutes ces étapes, vous avez testé avec succès:
- ✅ L'authentification (inscription, login)
- ✅ La gestion des trajets (création, consultation)
- ✅ La gestion des réservations (création, modification)
- ✅ Le système d'avis
- ✅ Les différents rôles (transporteur/client)

**L'API Wassali fonctionne parfaitement !** 🚀
