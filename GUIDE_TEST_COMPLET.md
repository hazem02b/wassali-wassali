# 🚀 Application Wassali - Guide de Test Rapide

## ✅ Serveurs Lancés

- **Backend API** : http://localhost:8000
- **Frontend React** : http://localhost:5173
- **Documentation API** : http://localhost:8000/api/v1/docs

---

## 🧪 Test Complet en 5 Minutes

### 1️⃣ Créer un Compte Transporteur

1. Ouvrez : **http://localhost:5173**
2. Cliquez sur **"S'inscrire"** ou **"Inscription Transporteur"**
3. Remplissez :
   - **Nom** : Ahmed Benali
   - **Email** : ahmed@transport.ma
   - **Téléphone** : +212612345678
   - **Mot de passe** : Ahmed123!
   - **Type** : Transporteur
4. Cliquez sur **"S'inscrire"**

✅ Vous êtes maintenant connecté comme transporteur !

---

### 2️⃣ Créer un Trajet

1. Dans votre espace transporteur, trouvez **"Créer un trajet"**
2. Remplissez :
   - **Départ** : Casablanca, Maroc
   - **Arrivée** : Paris, France
   - **Date départ** : 15/01/2025
   - **Poids disponible** : 30 kg
   - **Prix par kg** : 15 €
   - **Description** : Trajet régulier, colis acceptés
3. Cliquez sur **"Publier le trajet"**

✅ Votre trajet est créé !

---

### 3️⃣ Créer un Compte Client

1. **Déconnectez-vous** (menu en haut à droite)
2. Cliquez sur **"S'inscrire"** ou **"Inscription Client"**
3. Remplissez :
   - **Nom** : Fatima Dubois
   - **Email** : fatima@client.fr
   - **Téléphone** : +33612345678
   - **Mot de passe** : Fatima123!
   - **Type** : Client
4. Cliquez sur **"S'inscrire"**

✅ Vous êtes maintenant connecté comme client !

---

### 4️⃣ Rechercher et Réserver un Trajet

1. Sur la page d'accueil client, utilisez la **barre de recherche** :
   - **De** : Casablanca
   - **Vers** : Paris
   - **Date** : 15/01/2025
2. Cliquez sur **"Rechercher"**
3. Vous devriez voir le trajet créé par Ahmed
4. Cliquez sur **"Réserver"** ou **"Voir détails"**
5. Remplissez :
   - **Poids du colis** : 5 kg
   - **Description** : Vêtements et cadeaux
   - **Adresse collecte** : 123 Rue de la Liberté, Paris
   - **Adresse livraison** : 456 Bd Mohammed V, Casablanca
6. Cliquez sur **"Confirmer la réservation"**

✅ Réservation créée !

---

### 5️⃣ Vérifier dans l'API

Ouvrez : **http://localhost:8000/api/v1/docs**

1. Testez `GET /api/v1/trips` - Vous devriez voir votre trajet
2. Testez `GET /api/v1/auth/register` - Pour créer d'autres utilisateurs

---

## 🎯 Fonctionnalités à Tester

### Pour le Transporteur
- ✅ Créer un trajet
- ✅ Voir mes trajets
- ✅ Gérer les réservations
- ✅ Modifier mon profil
- ✅ Voir les notifications

### Pour le Client
- ✅ Rechercher des trajets
- ✅ Réserver un trajet
- ✅ Voir mes réservations
- ✅ Contacter le transporteur
- ✅ Laisser un avis

---

## 🐛 En Cas de Problème

### L'inscription ne fonctionne pas
- Vérifiez que le **backend est lancé** : http://localhost:8000/health
- Ouvrez la **Console du navigateur** (F12) pour voir les erreurs
- Vérifiez les logs du terminal backend

### Les trajets ne s'affichent pas
- Vérifiez que vous avez créé un trajet avec un transporteur
- Actualisez la page (F5)
- Vérifiez dans l'API : http://localhost:8000/api/v1/docs

### Erreur de connexion
- Vérifiez que l'email et le mot de passe sont corrects
- Le mot de passe doit contenir au moins 8 caractères

---

## 📊 Base de Données

Pour vérifier directement dans PostgreSQL :

```bash
# Se connecter
psql -U wassali_user -d wassali_db

# Voir les utilisateurs
SELECT id, email, first_name, last_name, role FROM users;

# Voir les trajets
SELECT id, origin_city, destination_city, price_per_kg FROM trips;

# Voir les réservations
SELECT id, trip_id, client_id, package_weight, status FROM bookings;
```

---

## 🎨 Captures d'Écran Attendues

1. **Page d'accueil** - Liste des trajets disponibles
2. **Formulaire d'inscription** - Choix Client/Transporteur
3. **Espace transporteur** - Créer un trajet
4. **Recherche de trajets** - Filtres par ville et date
5. **Détails d'un trajet** - Informations complètes
6. **Formulaire de réservation** - Détails du colis

---

**🎉 Profitez de votre application Wassali !**
