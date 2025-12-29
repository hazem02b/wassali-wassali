# Guide d'implémentation OAuth Google pour Wassali

## 📋 Vue d'ensemble

Ce guide vous explique comment configurer l'authentification Google OAuth 2.0 pour permettre aux utilisateurs de se connecter avec leur compte Google.

---

## 🔧 ÉTAPE 1 : Configuration Google Cloud Console

### 1.1 Créer un projet Google Cloud

1. Allez sur [Google Cloud Console](https://console.cloud.google.com/)
2. Connectez-vous avec votre compte Google
3. Cliquez sur "Sélectionner un projet" → "Nouveau projet"
4. Nommez votre projet : `Wassali` ou `wassali-auth`
5. Cliquez sur "Créer"

### 1.2 Activer les APIs nécessaires

1. Dans le menu hamburger ☰, allez dans **APIs & Services** → **Bibliothèque**
2. Recherchez "**People API**" (l'API moderne pour les profils Google)
3. Cliquez dessus et cliquez sur **ACTIVER**
4. (Optionnel) Vous pouvez aussi activer "**Google+ API**" mais ce n'est plus nécessaire avec People API

⚠️ **Note** : Si vous ne trouvez pas "Google Identity", ce n'est pas grave. People API suffit pour OAuth.

### 1.3 Créer des identifiants OAuth 2.0

1. Allez dans **APIs & Services** → **Identifiants**
2. Cliquez sur **+ CRÉER DES IDENTIFIANTS** → **ID client OAuth 2.0**
3. Si demandé, configurez l'écran de consentement OAuth :
   - Type d'utilisateur : **Externe**
   - Nom de l'application : **Wassali**
   - Email d'assistance utilisateur : votre email
   - Logo : (optionnel)
   - Domaine autorisé : `localhost` (pour le dev)
   - Informations de contact du développeur : votre email
   - Cliquez sur **Enregistrer et continuer**
   - Champs d'application : Cliquez sur **Ajouter ou supprimer des champs d'application**
     - Sélectionnez : `email`, `profile`, `openid`
   - Cliquez sur **Enregistrer et continuer**
   - Utilisateurs de test : Ajoutez votre email
   - Cliquez sur **Enregistrer et continuer**

4. Revenez à **Identifiants** → **+ CRÉER DES IDENTIFIANTS** → **ID client OAuth 2.0**
5. Type d'application : Choisissez **Application Web** (même si notre interface est mobile-first, c'est une app web React)
6. Nom : `Wassali Web Client`
7. **Origines JavaScript autorisées** :
   ```
   http://localhost:5173
   http://127.0.0.1:5173
   ```
8. **URI de redirection autorisés** :
   ```
   http://localhost:5173/auth/google/callback
   http://localhost:8000/api/v1/auth/google/callback
   ```
9. Cliquez sur **Créer**

### 1.4 Récupérer les identifiants

Vous recevrez :
- **Client ID** : ressemble à `123456789-abc.apps.googleusercontent.com`
- **Client Secret** : ressemble à `GOCSPX-abc123def456`

⚠️ **IMPORTANT** : Copiez ces deux valeurs, vous en aurez besoin !

---

## 🔐 ÉTAPE 2 : Configuration Backend

### 2.1 Installer les dépendances Python

Ouvrez un terminal dans le dossier `backend` et exécutez :

```powershell
cd backend
.\venv\Scripts\activate
pip install google-auth google-auth-oauthlib google-auth-httplib2
```

### 2.2 Ajouter les variables d'environnement

Créez ou modifiez le fichier `backend/.env` :

```env
# Existant...
DATABASE_URL=postgresql://postgres:votre_password@localhost:5432/wassali
SECRET_KEY=votre_secret_key

# NOUVEAU - Google OAuth
GOOGLE_CLIENT_ID=VOTRE_CLIENT_ID_ICI.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=VOTRE_CLIENT_SECRET_ICI
GOOGLE_REDIRECT_URI=http://localhost:8000/api/v1/auth/google/callback
```

⚠️ Remplacez `VOTRE_CLIENT_ID_ICI` et `VOTRE_CLIENT_SECRET_ICI` par vos vraies valeurs.

### 2.3 Mettre à jour `requirements.txt`

Ajoutez ces lignes dans `backend/requirements.txt` :

```
google-auth==2.27.0
google-auth-oauthlib==1.2.0
google-auth-httplib2==0.2.0
```

---

## 📱 ÉTAPE 3 : Configuration Frontend

### 3.1 Créer le fichier de configuration

Créez `src/app/config/google.config.ts` :

```typescript
export const GOOGLE_CONFIG = {
  CLIENT_ID: import.meta.env.VITE_GOOGLE_CLIENT_ID || '',
  REDIRECT_URI: `${window.location.origin}/auth/google/callback`,
  SCOPES: [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ].join(' ')
};
```

### 3.2 Ajouter la variable d'environnement

Créez ou modifiez le fichier `.env` à la racine du projet :

```env
VITE_API_URL=http://localhost:8000/api/v1
VITE_GOOGLE_CLIENT_ID=VOTRE_CLIENT_ID_ICI.apps.googleusercontent.com
```

---

## 🚀 ÉTAPE 4 : Test de la configuration

### 4.1 Vérifier les fichiers créés

✅ `backend/.env` contient `GOOGLE_CLIENT_ID` et `GOOGLE_CLIENT_SECRET`  
✅ `.env` à la racine contient `VITE_GOOGLE_CLIENT_ID`  
✅ Les dépendances Python sont installées

### 4.2 Redémarrer les serveurs

**Backend :**
```powershell
cd backend
.\venv\Scripts\activate
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**Frontend :**
```powershell
npm run dev
```

### 4.3 Tester la connexion

1. Allez sur http://localhost:5173/login
2. Cliquez sur le bouton "Se connecter avec Google"
3. Une popup Google devrait s'ouvrir
4. Connectez-vous avec votre compte Google
5. Vous devriez être redirigé vers l'application

---

## 🔍 Dépannage

### Erreur "redirect_uri_mismatch"
➡️ Vérifiez que l'URI de redirection dans Google Cloud Console correspond exactement à celle utilisée dans votre code.

### Erreur "invalid_client"
➡️ Vérifiez que votre `GOOGLE_CLIENT_ID` et `GOOGLE_CLIENT_SECRET` sont corrects dans le fichier `.env`.

### Le bouton Google ne fait rien
➡️ Ouvrez la console du navigateur (F12) et vérifiez les erreurs JavaScript.

### Erreur CORS
➡️ Assurez-vous que `http://localhost:5173` est dans les origines autorisées du backend.

---

## 📝 Prochaines étapes après la configuration

Une fois la configuration Google Cloud terminée et les variables d'environnement ajoutées :

1. Redémarrez le backend et le frontend
2. Les fichiers de code seront automatiquement mis à jour
3. Le bouton Google sera fonctionnel
4. Les utilisateurs pourront se connecter avec Google

---

## 🔒 Sécurité en Production

Pour déployer en production :

1. Créez de nouveaux identifiants OAuth pour votre domaine de production
2. Ajoutez votre domaine dans les origines autorisées :
   ```
   https://votredomaine.com
   https://www.votredomaine.com
   ```
3. Ajoutez les URI de redirection de production :
   ```
   https://votredomaine.com/auth/google/callback
   https://api.votredomaine.com/api/v1/auth/google/callback
   ```
4. Stockez les secrets dans des variables d'environnement sécurisées (pas dans le code)
5. Passez l'écran de consentement en mode "Production" dans Google Cloud Console

---

## ❓ Besoin d'aide ?

Si vous rencontrez des problèmes :
1. Vérifiez les logs du backend dans le terminal
2. Vérifiez la console du navigateur (F12 → Console)
3. Assurez-vous que toutes les variables d'environnement sont correctement définies
4. Vérifiez que les URI de redirection correspondent exactement

---

**Une fois que vous avez terminé la configuration Google Cloud Console, dites-moi et je mettrai à jour le code pour activer OAuth Google !**
