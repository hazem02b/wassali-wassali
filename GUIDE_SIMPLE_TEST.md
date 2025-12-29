# 🎯 GUIDE ULTRA-SIMPLE - Comment Tester l'API Wassali

## ⚠️ AVANT DE COMMENCER

Vous devez avoir **2 fenêtres ouvertes**:
1. ✅ **Fenêtre PowerShell BLEUE** avec le serveur (déjà ouverte)
2. ✅ **Navigateur web** (Chrome, Firefox, Edge)

---

## 📺 ÉTAPE 1: Ouvrir Swagger UI

### Action:
1. Ouvrez votre **navigateur web** (Chrome, Firefox ou Edge)
2. Dans la barre d'adresse en haut, tapez:
   ```
   localhost:8000/api/v1/docs
   ```
3. Appuyez sur **Entrée**

### ✅ Ce que vous DEVEZ voir:

```
┌─────────────────────────────────────────────────────────────┐
│  Wassali API                                     v1.0.0     │
│  API backend pour l'application Wassali                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  🔽 auth - Authentication                                    │
│     POST   /api/v1/auth/register                            │
│     POST   /api/v1/auth/login                               │
│     GET    /api/v1/auth/me                                  │
│                                                              │
│  🔽 trips                                                    │
│     GET    /api/v1/trips                                    │
│     POST   /api/v1/trips                                    │
│                                                              │
│  🔽 bookings                                                 │
│     ...                                                      │
└─────────────────────────────────────────────────────────────┘
```

**Si vous NE voyez PAS cette page:**
- Vérifiez que la fenêtre PowerShell BLEUE est toujours ouverte
- Retapez bien: `localhost:8000/api/v1/docs`

---

## 📺 ÉTAPE 2: Créer un Utilisateur

### Action:

**1. Trouvez la ligne qui dit:**
```
POST /api/v1/auth/register    Register
```

**2. CLIQUEZ sur cette ligne**
   - Elle va s'ouvrir et devenir verte/bleue

**3. Vous voyez maintenant:**
```
┌─────────────────────────────────────────────────────────────┐
│ POST /api/v1/auth/register    Register                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│ Register a new user                                         │
│                                                              │
│ Parameters                                                  │
│   No parameters                                             │
│                                                              │
│ Request body   application/json                             │
│                                                              │
│   [ Try it out ]  ← CLIQUEZ ICI                            │
│                                                              │
│   {                                                         │
│     "email": "user@example.com",                           │
│     "password": "string",                                   │
│     ...                                                     │
│   }                                                         │
└─────────────────────────────────────────────────────────────┘
```

**4. CLIQUEZ sur le bouton "Try it out"**
   - Le bouton devient gris
   - Le grand rectangle blanc devient éditable (vous pouvez écrire dedans)

**5. EFFACEZ tout le texte dans le grand rectangle**
   - Cliquez dans le rectangle
   - Faites Ctrl+A (pour tout sélectionner)
   - Appuyez sur Delete

**6. COPIEZ-COLLEZ ce texte EXACT dans le rectangle:**

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

**⚠️ IMPORTANT:** 
- Copiez TOUT (les accolades { } aussi)
- Ne changez RIEN

**7. CLIQUEZ sur le gros bouton bleu "Execute"**

---

## 📺 ÉTAPE 3: Voir le Résultat

### Après avoir cliqué "Execute", descendez un peu

### ✅ SI ÇA MARCHE (Code 201):

Vous verrez:
```
┌─────────────────────────────────────────────────────────────┐
│ Server response                                             │
│                                                              │
│ Code: 201                                                   │
│ ✅ Successful Response                                       │
│                                                              │
│ Response body                                               │
│ {                                                           │
│   "access_token": "eyJhbGciOiJIUzI1NiIsInR...",           │
│   "token_type": "bearer",                                   │
│   "user": {                                                 │
│     "id": 1,                                                │
│     "email": "ahmed@transport.ma",                         │
│     "first_name": "Ahmed",                                 │
│     ...                                                     │
│   }                                                         │
│ }                                                           │
└─────────────────────────────────────────────────────────────┘
```

**🎉 BRAVO! Ça marche!**
→ Passez à l'ÉTAPE 4

---

### ❌ SI ÇA NE MARCHE PAS:

#### Erreur 500 (Internal Server Error)
```
Code: 500
Error: Internal Server Error
```

**→ Regardez la fenêtre PowerShell BLEUE**
- Elle affiche l'erreur EXACTE
- Copiez l'erreur et envoyez-la moi

#### Erreur 400 (Email déjà enregistré)
```
Code: 400
{
  "detail": "Email already registered"
}
```

**Solution:** Changez l'email dans le JSON:
```json
{
  "email": "ahmed2@transport.ma",    ← Changez ici
  "password": "Ahmed123!",
  ...
}
```

---

## 📺 ÉTAPE 4: Copier le Token

**SI l'inscription a marché (Code 201):**

### 1. Trouvez le "access_token" dans la réponse

Il ressemble à ça:
```
"access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIx..."
```

### 2. Sélectionnez TOUT le token

**Méthode facile:**
- Cliquez 3 fois rapidement sur le token
- Il sera sélectionné en bleu
- Faites Ctrl+C pour copier

**OU utilisez la souris:**
- Cliquez au début du token (après `"access_token": "`)
- Ne lâchez PAS le clic, glissez jusqu'à la fin
- Copiez avec Ctrl+C

### ⚠️ ATTENTION:
- Ne copiez PAS les guillemets `"`
- Copiez UNIQUEMENT: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- Le token est TRÈS LONG (200+ caractères)

---

## 📺 ÉTAPE 5: S'Authentifier

### 1. Remontez en HAUT de la page

### 2. Trouvez le bouton "Authorize" 🔓

Il est **en haut à droite**, à côté du titre "Wassali API"

```
┌─────────────────────────────────────────────────────────────┐
│ Wassali API                    [ Authorize 🔓 ]  ← ICI     │
└─────────────────────────────────────────────────────────────┘
```

### 3. CLIQUEZ sur "Authorize"

Une fenêtre s'ouvre:
```
┌──────────────────────────────────────────────┐
│ Available authorizations                     │
│                                               │
│ OAuth2PasswordBearer                         │
│                                               │
│ Value:                                       │
│ ┌──────────────────────────────────────────┐ │
│ │                                          │ │  ← Grand rectangle
│ └──────────────────────────────────────────┘ │
│                                               │
│     [ Authorize ]    [ Close ]               │
└──────────────────────────────────────────────┘
```

### 4. Dans le grand rectangle, tapez EXACTEMENT:

```
Bearer 
```
(Le mot "Bearer" avec un ESPACE après)

### 5. Puis COLLEZ votre token (Ctrl+V)

Résultat final:
```
Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIx...
```

### 6. CLIQUEZ sur "Authorize" (bouton dans la fenêtre)

### 7. CLIQUEZ sur "Close"

### ✅ Vérification:
Le cadenas doit être FERMÉ maintenant: 🔒

---

## 📺 ÉTAPE 6: Créer un Trajet

### 1. Trouvez la section "trips" (descendez un peu)

### 2. Trouvez la ligne:
```
POST /api/v1/trips    Create Trip
```

### 3. CLIQUEZ dessus puis sur "Try it out"

### 4. EFFACEZ tout et COLLEZ:

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
  "description": "Trajet régulier",
  "vehicle_info": "Voiture"
}
```

### 5. CLIQUEZ sur "Execute"

### ✅ Si ça marche (Code 201):

Vous verrez:
```json
{
  "id": 1,
  "origin_city": "Casablanca",
  "destination_city": "Paris",
  "price_per_kg": 15,
  ...
}
```

**🎉 BRAVO! Vous avez créé un trajet!**

---

## 📺 ÉTAPE 7: Créer un Client

### 1. Remontez à la section "auth"

### 2. CLIQUEZ sur POST /api/v1/auth/register

### 3. "Try it out"

### 4. COLLEZ ce JSON:

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

### 5. "Execute"

### 6. COPIEZ le nouveau token

### 7. CLIQUEZ sur "Authorize" 🔒 en haut

### 8. REMPLACEZ l'ancien token par le nouveau:
```
Bearer NOUVEAU_TOKEN_ICI
```

### 9. "Authorize" puis "Close"

**Maintenant vous êtes connecté en tant que CLIENT**

---

## 📺 ÉTAPE 8: Créer une Réservation

### 1. Trouvez la section "bookings"

### 2. Trouvez:
```
POST /api/v1/bookings    Create Booking
```

### 3. "Try it out"

### 4. COLLEZ:

```json
{
  "trip_id": 1,
  "weight": 5,
  "item_description": "Colis personnel",
  "pickup_address": "123 Rue Mohammed V, Casablanca",
  "delivery_address": "45 Avenue des Champs-Élysées, Paris"
}
```

### 5. "Execute"

### ✅ Si ça marche:

```json
{
  "id": 1,
  "trip_id": 1,
  "weight": 5,
  "total_price": 75,
  "status": "pending",
  ...
}
```

**Prix = 5 kg × 15€/kg = 75€**

---

## 🎯 RÉSUMÉ - Ce que vous avez fait:

1. ✅ Ouvert Swagger UI
2. ✅ Créé un transporteur (Ahmed)
3. ✅ Copié le token
4. ✅ S'authentifier avec "Authorize"
5. ✅ Créé un trajet (Casablanca → Paris)
6. ✅ Créé un client (Fatima)
7. ✅ Changé de token
8. ✅ Créé une réservation

---

## ❓ EN CAS DE PROBLÈME

### "Je ne trouve pas Authorize"
→ C'est en HAUT À DROITE de la page, à côté du titre

### "Erreur 401 - Not authenticated"
→ Vous avez oublié de cliquer sur "Authorize"
→ Ou le token est mal copié

### "Erreur 500"
→ Regardez la fenêtre PowerShell BLEUE
→ Copiez l'erreur et envoyez-la moi

### "La page ne charge pas"
→ Vérifiez que la fenêtre PowerShell BLEUE est toujours ouverte
→ Retapez: `localhost:8000/api/v1/docs`

---

## 📞 BESOIN D'AIDE?

**Dites-moi:**
1. À quelle ÉTAPE vous êtes bloqué?
2. Quel CODE vous voyez (200, 201, 400, 500)?
3. Quel MESSAGE d'erreur s'affiche?

**Je vais vous aider!** 🚀
