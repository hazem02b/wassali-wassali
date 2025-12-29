# 🔍 GUIDE DE DÉBOGAGE - Mise à jour du profil

## ✅ Tests Backend Validés

Les tests montrent que le **backend fonctionne parfaitement** :
- ✅ La mise à jour en base de données fonctionne
- ✅ Les données persistent après déconnexion/reconnexion
- ✅ Le test complet a réussi à 100%

## 🧪 Comment tester depuis le frontend

### Étape 1: Ouvrir la Console du Navigateur
1. Ouvrez http://localhost:5173
2. Appuyez sur **F12** pour ouvrir les DevTools
3. Allez dans l'onglet **Console**

### Étape 2: Se connecter
1. Connectez-vous avec votre compte
2. Allez dans **Profil** → **Modifier**

### Étape 3: Modifier le profil
1. Changez votre nom (exemple: "Nouveau Nom Test")
2. Changez votre téléphone (exemple: "+21611223344")
3. Cliquez sur **Enregistrer**

### Étape 4: Vérifier les logs dans la Console
Vous devriez voir ces messages :
```
🔄 Mise à jour du profil... { name: "Nouveau Nom Test", phone: "+21611223344" }
📥 Response status: 200
✅ Données reçues: { id: X, name: "Nouveau Nom Test", phone: "+21611223344", ... }
```

### Étape 5: Vérifier la persistance
1. **Rafraîchir la page** (F5)
   - Le profil devrait toujours afficher les nouvelles données
   
2. **Se déconnecter et se reconnecter**
   - Cliquez sur "Logout"
   - Reconnectez-vous avec votre email et mot de passe
   - Allez dans Profil
   - Les modifications DOIVENT être là !

## ❌ Si ça ne fonctionne pas

### Scénario 1: Erreur dans la Console
Si vous voyez `❌ Erreur API:` dans la console :
- Vérifiez le message d'erreur
- Erreur "Phone number already registered" → Utilisez un autre numéro
- Erreur "Could not validate credentials" → Reconnectez-vous

### Scénario 2: Pas de message dans la Console
Si aucun log n'apparaît :
- Le bouton "Enregistrer" ne fonctionne pas
- Vérifiez que le frontend est bien démarré sur port 5173

### Scénario 3: Message de succès mais données non persistées
Si vous voyez ✅ mais les données disparaissent après rafraîchissement :
1. Vérifiez le **localStorage** :
   - Dans DevTools, allez dans **Application** → **Local Storage**
   - Vérifiez que `user` contient les nouvelles données
   
2. Vérifiez la **base de données** directement :
   ```sql
   SELECT id, name, phone, email FROM users WHERE email = 'votre@email.com';
   ```

## 🔧 Commandes de test rapide

### Test API direct (PowerShell)
```powershell
# 1. Login
$loginBody = @{username="votre@email.com"; password="votremotdepasse"} | ConvertTo-Json
$loginResponse = Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/login" -Method POST -Body $loginBody -ContentType "application/x-www-form-urlencoded"
$token = $loginResponse.access_token

# 2. Mise à jour
$updateBody = @{name="Test Nouveau Nom"; phone="+21699887766"} | ConvertTo-Json
$headers = @{Authorization="Bearer $token"}
Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/me" -Method PUT -Body $updateBody -Headers $headers -ContentType "application/json"

# 3. Vérification
Invoke-RestMethod -Uri "http://localhost:8000/api/v1/auth/me" -Method GET -Headers $headers
```

## 📋 Checklist de vérification

- [ ] Backend actif sur port 8000
- [ ] Frontend actif sur port 5173
- [ ] PostgreSQL en cours d'exécution
- [ ] Console du navigateur ouverte (F12)
- [ ] Connecté avec un compte valide
- [ ] Token présent dans localStorage
- [ ] Numéro de téléphone unique (pas déjà utilisé)

## 📞 Si le problème persiste

Envoyez-moi :
1. **Screenshot de la console** (F12) au moment de l'enregistrement
2. **Le message d'erreur exact** s'il y en a un
3. **Les logs du backend** (dans la fenêtre PowerShell du backend)
