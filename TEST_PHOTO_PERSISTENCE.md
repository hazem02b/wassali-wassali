# Test de la Persistance de la Photo

## Étapes de Test

### 1. Télécharger une Photo
1. Connectez-vous à l'application
2. Allez dans **Profil** (en bas à droite)
3. Cliquez sur **Modifier le profil**
4. Cliquez sur **Choisir une photo**
5. Sélectionnez une photo
6. Vérifiez que la photo apparaît dans le preview
7. Cliquez sur **Enregistrer**

### 2. Vérifier l'Affichage de la Photo
La photo devrait maintenant apparaître dans:
- ✅ **Page d'accueil** (en haut à droite)
- ✅ **Page Profil** (photo de profil en grand)
- ✅ **Modifier le profil** (preview de la photo)
- ✅ **Résultats de recherche** (si vous êtes transporteur)
- ✅ **Tableau de bord transporteur** (en haut à droite)

### 3. Test de Persistance après Déconnexion
1. **Déconnectez-vous** de l'application
2. **Reconnectez-vous** avec vos identifiants
3. Vérifiez que **la photo est toujours visible** dans toutes les pages

### 4. Vérification dans localStorage
Ouvrez la console du navigateur (F12) et tapez:
```javascript
console.log(localStorage.getItem('userAvatar'))
```
Vous devriez voir une longue chaîne commençant par `data:image/...`

## Stockage de la Photo

La photo est actuellement stockée dans **localStorage** sous forme de base64:
- **Clé**: `userAvatar`
- **Format**: `data:image/jpeg;base64,/9j/4AAQ...` (très long)
- **Persistance**: Même après déconnexion/reconnexion

## Note Importante

⚠️ **Limite de localStorage**: Environ 5-10 MB selon le navigateur

Pour les photos de grande taille, il est recommandé de:
1. Compresser l'image avant upload
2. Ou utiliser un stockage serveur (API backend)

## Si la Photo Disparaît

Vérifiez dans la console:
```javascript
// Voir si l'avatar est dans localStorage
console.log('Avatar in localStorage:', !!localStorage.getItem('userAvatar'))

// Voir si l'avatar est dans user
const user = JSON.parse(localStorage.getItem('user') || '{}')
console.log('Avatar in user:', !!user.avatar)

// Voir la taille de l'avatar
const avatar = localStorage.getItem('userAvatar')
console.log('Avatar size:', avatar ? (avatar.length / 1024).toFixed(2) + ' KB' : 'No avatar')
```

## Mode Sombre - Test de Lisibilité

### Activer le Mode Sombre
1. Allez dans **Paramètres**
2. Activez **Mode Sombre**

### Vérifier la Lisibilité du Texte
Tous les textes doivent être **clairs et lisibles** en mode sombre:
- ✅ Page d'accueil
- ✅ Page Profil
- ✅ Modifier le profil
- ✅ Résultats de recherche
- ✅ Tableau de bord transporteur
- ✅ Paramètres

**Le texte doit être blanc/gris clair sur fond sombre**

## Résultats Attendus

✅ La photo est uploadée et affichée immédiatement  
✅ La photo persiste après rafraîchissement de la page  
✅ La photo persiste après déconnexion/reconnexion  
✅ La photo apparaît dans toutes les pages  
✅ Le mode sombre fonctionne partout  
✅ Tous les textes sont lisibles en mode sombre  
