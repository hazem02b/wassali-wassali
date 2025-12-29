# 🧪 Guide de Test - Application Mobile Wassali

## Prérequis

✅ Backend FastAPI lancé sur http://localhost:8000  
✅ Flutter installé (`flutter doctor`)  
✅ Appareil/émulateur connecté (`flutter devices`)

---

## 🚀 Lancer l'Application

### 1. Installer les dépendances
```bash
cd wassali_mobile
flutter pub get
```

### 2. Configurer l'URL API

**Fichier** : `lib/services/api_service.dart` ligne 11

```dart
// Pour ÉMULATEUR ANDROID
static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

// Pour APPAREIL PHYSIQUE (remplacer par votre IP)
static const String baseUrl = 'http://192.168.1.100:8000/api/v1';

// Pour SIMULATEUR iOS
static const String baseUrl = 'http://localhost:8000/api/v1';
```

**Trouver votre IP** :
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig

# Chercher l'adresse IPv4 (ex: 192.168.1.100)
```

### 3. Lancer le backend
```bash
# Dans un terminal séparé
cd backend
python main.py

# Vérifier : http://localhost:8000/api/v1/docs
```

### 4. Lancer l'app Flutter
```bash
cd wassali_mobile
flutter run

# Ou sur un appareil spécifique
flutter run -d <device-id>
```

---

## 📋 Scénarios de Test

### Scénario 1 : Inscription et Connexion Client

#### 1.1 Inscription Client
1. Ouvrir l'app
2. Cliquer sur **"Commencer"**
3. Cliquer sur **"Se connecter"**
4. En bas, cliquer sur **"S'inscrire"**
5. Sélectionner **"Client"**
6. Remplir :
   ```
   Prénom : Mohamed
   Nom : Benali
   Email : mohamed.client@test.com
   Téléphone : +216 12 345 678
   Mot de passe : Client123!
   Confirmer : Client123!
   ```
7. Cliquer **"S'inscrire"**
8. ✅ Vérifier : Redirection vers Home Client

#### 1.2 Connexion Client
1. Se déconnecter (Menu → Déconnexion)
2. Cliquer **"Se connecter"**
3. Sélectionner **"Client"**
4. Entrer :
   ```
   Email : mohamed.client@test.com
   Mot de passe : Client123!
   ```
5. Cliquer **"Se connecter"**
6. ✅ Vérifier : Message "Connexion réussie !" + Redirection

---

### Scénario 2 : Recherche et Réservation

#### 2.1 Rechercher des trajets
1. Sur la Home Client
2. Remplir le formulaire :
   ```
   De : Tunis
   Vers : Paris
   Date : [Choisir une date]
   ```
3. Cliquer **"Rechercher"**
4. ✅ Vérifier : Liste des trajets disponibles

#### 2.2 Voir les détails d'un trajet
1. Dans les résultats, cliquer sur un trajet
2. ✅ Vérifier : 
   - Informations complètes du trajet
   - Informations du transporteur
   - Avis du transporteur
   - Bouton "Réserver"

#### 2.3 Créer une réservation
1. Sur la page détails du trajet
2. Cliquer **"Réserver"**
3. Remplir le formulaire :
   ```
   Poids : 5
   Description : Vêtements
   Adresse de collecte : 123 Rue de Tunis
   Adresse de livraison : 456 Rue de Paris
   Téléphone collecte : +216 12 345 678
   Téléphone livraison : +33 6 12 34 56 78
   ```
4. Cliquer **"Continuer"**
5. ✅ Vérifier : Redirection vers paiement
6. Confirmer le paiement
7. ✅ Vérifier : Message de confirmation + Numéro de suivi

#### 2.4 Voir mes réservations
1. Menu → **"Mes Réservations"**
2. ✅ Vérifier : La nouvelle réservation apparaît
3. Cliquer sur la réservation
4. ✅ Vérifier : Détails complets + Statut

---

### Scénario 3 : Inscription et Connexion Transporteur

#### 3.1 Inscription Transporteur
1. Se déconnecter
2. Aller sur **"Se connecter"**
3. Sélectionner **"Transporteur"**
4. Cliquer **"S'inscrire"**
5. Remplir :
   ```
   Prénom : Ahmed
   Nom : Transport
   Email : ahmed.transport@test.com
   Téléphone : +33 6 12 34 56 78
   Mot de passe : Transport123!
   Type de véhicule : Voiture
   ```
6. Cliquer **"S'inscrire"**
7. ✅ Vérifier : Redirection vers Dashboard Transporteur

---

### Scénario 4 : Créer et Gérer des Trajets

#### 4.1 Créer un trajet
1. Sur le Dashboard Transporteur
2. Cliquer **"Créer un trajet"**
3. Remplir :
   ```
   Ville de départ : Tunis
   Pays de départ : Tunisie
   Ville d'arrivée : Paris
   Pays d'arrivée : France
   Date de départ : [Demain]
   Heure : 10:00
   Date d'arrivée : [Après-demain]
   Heure : 08:00
   Poids maximum : 30
   Prix par kg : 15
   Type de véhicule : Voiture
   Description : Trajet régulier
   ```
4. Cliquer **"Créer le trajet"**
5. ✅ Vérifier : Message "Trajet créé avec succès !"

#### 4.2 Voir mes trajets
1. Menu → **"Mes Trajets"**
2. ✅ Vérifier : Le nouveau trajet apparaît
3. Cliquer sur le trajet
4. ✅ Vérifier : 
   - Détails complets
   - Boutons Modifier/Supprimer
   - Liste des réservations

#### 4.3 Modifier un trajet
1. Sur la page du trajet
2. Cliquer **"Modifier"**
3. Changer le prix : `18 €/kg`
4. Cliquer **"Enregistrer"**
5. ✅ Vérifier : Message de confirmation + Prix mis à jour

#### 4.4 Gérer une réservation
1. Sur le trajet avec réservations
2. Cliquer sur une réservation
3. Voir les détails
4. Cliquer **"Accepter"**
5. ✅ Vérifier : Statut change en "Accepté"

---

### Scénario 5 : Système d'Avis

#### 5.1 Laisser un avis (Client)
1. Se connecter en tant que client
2. Menu → **"Mes Réservations"**
3. Cliquer sur une réservation livrée
4. Cliquer **"Laisser un avis"**
5. Remplir :
   ```
   Note : 5 étoiles
   Commentaire : Excellent service, rapide et fiable !
   ```
6. Cliquer **"Envoyer"**
7. ✅ Vérifier : Message de confirmation

#### 5.2 Voir les avis (Transporteur)
1. Se connecter en tant que transporteur
2. Menu → **"Mes Avis"**
3. ✅ Vérifier : Le nouvel avis apparaît
4. ✅ Vérifier : Note moyenne mise à jour

---

### Scénario 6 : Messagerie

#### 6.1 Envoyer un message
1. Se connecter en tant que client
2. Sur une réservation, cliquer **"Contacter"**
3. Ou Menu → **"Messages"**
4. Sélectionner une conversation
5. Taper un message : `Bonjour, à quelle heure la collecte ?`
6. Cliquer **"Envoyer"**
7. ✅ Vérifier : Message envoyé

#### 6.2 Recevoir un message
1. Se connecter en tant que transporteur
2. Menu → **"Messages"**
3. ✅ Vérifier : Badge de notification (si nouveau message)
4. Ouvrir la conversation
5. ✅ Vérifier : Messages affichés
6. Répondre
7. ✅ Vérifier : Message envoyé

---

### Scénario 7 : Profil Utilisateur

#### 7.1 Voir le profil
1. Menu → **"Profil"**
2. ✅ Vérifier : Toutes les informations affichées

#### 7.2 Modifier le profil
1. Sur la page profil
2. Cliquer **"Modifier"**
3. Changer :
   ```
   Téléphone : +216 98 765 432
   Adresse : Nouvelle adresse
   ```
4. Cliquer **"Enregistrer"**
5. ✅ Vérifier : Message "Modification réussie !"

#### 7.3 Changer le mot de passe
1. Menu → **"Paramètres"**
2. Cliquer **"Changer le mot de passe"**
3. Remplir :
   ```
   Ancien : Client123!
   Nouveau : NewClient123!
   Confirmer : NewClient123!
   ```
4. Cliquer **"Changer"**
5. ✅ Vérifier : Message de confirmation
6. Se déconnecter et reconnecter avec nouveau mot de passe

---

### Scénario 8 : Notifications

#### 8.1 Voir les notifications
1. Cliquer sur l'icône de notification (en haut à droite)
2. ✅ Vérifier : Liste des notifications
3. ✅ Vérifier : Badge avec nombre de non-lues

#### 8.2 Marquer comme lu
1. Cliquer sur une notification non lue
2. ✅ Vérifier : Notification marquée comme lue
3. ✅ Vérifier : Badge décremente

---

### Scénario 9 : Mot de Passe Oublié

#### 9.1 Demander une réinitialisation
1. Sur la page de connexion
2. Cliquer **"Mot de passe oublié ?"**
3. Entrer email : `mohamed.client@test.com`
4. Sélectionner type : **Client**
5. Cliquer **"Envoyer"**
6. ✅ Vérifier : Message "Email envoyé"

#### 9.2 Réinitialiser le mot de passe
1. Entrer le code reçu par email
2. Entrer nouveau mot de passe
3. Confirmer
4. ✅ Vérifier : Redirection vers login
5. Se connecter avec nouveau mot de passe

---

## ✅ Checklist de Test

### Authentification
- [ ] Inscription client
- [ ] Inscription transporteur
- [ ] Connexion client
- [ ] Connexion transporteur
- [ ] Déconnexion
- [ ] Mot de passe oublié
- [ ] Réinitialisation mot de passe
- [ ] Changement mot de passe

### Client
- [ ] Recherche de trajets
- [ ] Voir détails trajet
- [ ] Créer réservation
- [ ] Voir mes réservations
- [ ] Laisser un avis
- [ ] Voir mes avis
- [ ] Modifier profil

### Transporteur
- [ ] Dashboard avec stats
- [ ] Créer un trajet
- [ ] Voir mes trajets
- [ ] Modifier un trajet
- [ ] Supprimer un trajet
- [ ] Gérer réservations
- [ ] Voir mes avis
- [ ] Modifier profil

### Messagerie
- [ ] Voir conversations
- [ ] Envoyer message
- [ ] Recevoir message
- [ ] Notifications messages

### Notifications
- [ ] Voir notifications
- [ ] Marquer comme lu
- [ ] Badge de compteur

### Général
- [ ] Navigation entre les pages
- [ ] Retour en arrière
- [ ] Messages d'erreur
- [ ] Messages de succès
- [ ] Chargement (spinners)
- [ ] Validation des formulaires

---

## 🐛 Tests d'Erreur

### Test 1 : Connexion avec mauvais mot de passe
1. Essayer de se connecter avec un mauvais mot de passe
2. ✅ Vérifier : Message d'erreur "Email ou mot de passe incorrect"

### Test 2 : Email déjà utilisé
1. Essayer de s'inscrire avec un email existant
2. ✅ Vérifier : Message "Cet email est déjà utilisé"

### Test 3 : Champs invalides
1. Essayer de soumettre un formulaire avec :
   - Email invalide
   - Téléphone invalide
   - Mot de passe faible
2. ✅ Vérifier : Messages de validation affichés

### Test 4 : Backend déconnecté
1. Arrêter le backend
2. Essayer une action (login, recherche)
3. ✅ Vérifier : Message "Pas de connexion internet"

### Test 5 : Token expiré
1. Se connecter
2. Attendre expiration du token (ou le supprimer manuellement)
3. Essayer une action
4. ✅ Vérifier : Redirection vers login

---

## 📊 Rapport de Test

| Fonctionnalité | Statut | Notes |
|----------------|--------|-------|
| Inscription | ⬜ |  |
| Connexion | ⬜ |  |
| Recherche | ⬜ |  |
| Réservation | ⬜ |  |
| Trajets | ⬜ |  |
| Avis | ⬜ |  |
| Messages | ⬜ |  |
| Notifications | ⬜ |  |
| Profil | ⬜ |  |

**Légende** : ⬜ Non testé | ✅ OK | ❌ Erreur

---

## 🔍 Logs et Débogage

### Voir les logs
```bash
flutter logs
```

### Logs API (dans le code)
L'API service affiche déjà des logs :
- 📤 Requête sortante
- ✅ Réponse OK
- ❌ Erreur

### DevTools
```bash
flutter run
# Puis dans le terminal, taper : v
# DevTools s'ouvre dans le navigateur
```

---

## 📞 Support

Si un test échoue :
1. Vérifier les logs : `flutter logs`
2. Vérifier le backend : http://localhost:8000/api/v1/docs
3. Vérifier l'URL dans `api_service.dart`
4. Consulter [README.md](wassali_mobile/README.md)

---

**Bon test ! 🧪**
