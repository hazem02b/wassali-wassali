# 🔔 Système de Notifications Wassali

## 📋 Vue d'ensemble

Le système de notifications est un **service singleton** qui permet d'afficher des **toasts** (notifications temporaires) dans toute l'application.

---

## 🚀 Comment utiliser

### 1. Import du service

```typescript
import { NotificationService } from '../contexts/NotificationService';
```

### 2. Afficher une notification

```typescript
// Notification de succès
NotificationService.success('Bravo!', 'Votre profil a été mis à jour');

// Notification d'erreur
NotificationService.error('Erreur', 'Impossible de se connecter au serveur');

// Notification d'avertissement
NotificationService.warning('Attention', 'Votre session va expirer dans 5 minutes');

// Notification d'information
NotificationService.info('Info', 'Nouvelle mise à jour disponible');
```

---

## 🎨 Types de notifications

### ✅ Success (Vert)
```typescript
NotificationService.success(
  'Opération réussie!',
  'Vos modifications ont été enregistrées'
);
```

### ❌ Error (Rouge)
```typescript
NotificationService.error(
  'Échec de connexion',
  'Vérifiez vos identifiants'
);
```

### ⚠️ Warning (Jaune)
```typescript
NotificationService.warning(
  'Attention',
  'Cette action est irréversible'
);
```

### ℹ️ Info (Bleu)
```typescript
NotificationService.info(
  'Nouveau message',
  'Vous avez reçu 3 nouveaux messages'
);
```

---

## 🔧 Fonctionnalités avancées

### Notification avec action

```typescript
NotificationService.add({
  type: 'info',
  title: 'Mise à jour disponible',
  message: 'Version 2.0 disponible',
  action: {
    label: 'Mettre à jour',
    onClick: () => {
      // Code pour mettre à jour
      window.location.reload();
    }
  }
});
```

### Gestion des notifications

```typescript
// Marquer comme lu
NotificationService.markAsRead('notification-id');

// Marquer toutes comme lues
NotificationService.markAllAsRead();

// Supprimer une notification
NotificationService.remove('notification-id');

// Supprimer toutes
NotificationService.clear();

// Compter les non-lues
const unreadCount = NotificationService.getUnreadCount();
```

---

## 📱 Exemples d'utilisation dans l'app

### 1. Changement de mot de passe

```typescript
const handleChangePassword = async () => {
  try {
    await apiService.changePassword(token, passwords);
    
    NotificationService.success(
      'Mot de passe modifié!',
      'Votre mot de passe a été mis à jour avec succès'
    );
    
    navigate('/settings');
  } catch (error) {
    NotificationService.error(
      'Erreur',
      'Impossible de modifier le mot de passe'
    );
  }
};
```

### 2. Mise à jour du profil

```typescript
const handleUpdateProfile = async () => {
  try {
    await apiService.updateProfile(token, userData);
    
    NotificationService.success(
      'Profil mis à jour!',
      'Vos informations ont été enregistrées'
    );
  } catch (error) {
    NotificationService.error(
      'Échec de la mise à jour',
      error.message
    );
  }
};
```

### 3. Création de réservation

```typescript
const handleBookTrip = async () => {
  try {
    const booking = await apiService.createBooking(tripData);
    
    NotificationService.success(
      'Réservation confirmée!',
      `Votre colis sera livré le ${booking.delivery_date}`
    );
    
    navigate('/my-bookings');
  } catch (error) {
    NotificationService.error(
      'Réservation échouée',
      'Veuillez réessayer plus tard'
    );
  }
};
```

### 4. Connexion/Déconnexion

```typescript
// Connexion réussie
const handleLogin = async () => {
  try {
    const response = await apiService.login(credentials);
    
    NotificationService.success(
      'Bienvenue!',
      `Connecté en tant que ${response.user.name}`
    );
    
    navigate('/home');
  } catch (error) {
    NotificationService.error(
      'Connexion échouée',
      'Email ou mot de passe incorrect'
    );
  }
};

// Déconnexion
const handleLogout = () => {
  logout();
  NotificationService.info(
    'À bientôt!',
    'Vous avez été déconnecté avec succès'
  );
  navigate('/');
};
```

### 5. Upload de photo

```typescript
const handlePhotoUpload = async (file: File) => {
  if (file.size > 5 * 1024 * 1024) {
    NotificationService.warning(
      'Fichier trop volumineux',
      'La taille maximale est de 5 MB'
    );
    return;
  }

  try {
    const photoUrl = await uploadPhoto(file);
    
    NotificationService.success(
      'Photo uploadée!',
      'Votre photo de profil a été mise à jour'
    );
  } catch (error) {
    NotificationService.error(
      'Upload échoué',
      'Impossible de télécharger la photo'
    );
  }
};
```

### 6. Paiement

```typescript
const handlePayment = async () => {
  NotificationService.info(
    'Traitement en cours',
    'Nous traitons votre paiement...'
  );

  try {
    await apiService.processPayment(paymentData);
    
    NotificationService.success(
      'Paiement réussi!',
      'Votre commande a été confirmée'
    );
  } catch (error) {
    NotificationService.error(
      'Paiement refusé',
      'Vérifiez vos informations de paiement'
    );
  }
};
```

---

## 🎯 Bonnes pratiques

### ✅ À FAIRE

1. **Messages courts et clairs**
   ```typescript
   NotificationService.success('Profil mis à jour!', 'Vos modifications ont été enregistrées');
   ```

2. **Toujours informer l'utilisateur**
   ```typescript
   try {
     await saveData();
     NotificationService.success('Succès', 'Données enregistrées');
   } catch {
     NotificationService.error('Erreur', 'Impossible d\'enregistrer');
   }
   ```

3. **Utiliser le bon type**
   - Success: Opération réussie
   - Error: Erreur/échec
   - Warning: Avertissement
   - Info: Information générale

### ❌ À ÉVITER

1. **Messages trop longs**
   ```typescript
   // ❌ Trop long
   NotificationService.info('Titre', 'Ceci est un très long message qui explique...');
   
   // ✅ Court et précis
   NotificationService.info('Mise à jour', 'Version 2.0 disponible');
   ```

2. **Trop de notifications**
   ```typescript
   // ❌ Spam
   NotificationService.success('OK', 'Champ 1 validé');
   NotificationService.success('OK', 'Champ 2 validé');
   NotificationService.success('OK', 'Champ 3 validé');
   
   // ✅ Une seule notification
   NotificationService.success('Formulaire validé', 'Tous les champs sont corrects');
   ```

---

## 🎨 Personnalisation

Les notifications sont automatiquement stylées selon le **dark mode** :

```typescript
// Mode clair: fond blanc, texte noir
// Mode sombre: fond gris foncé, texte blanc
```

Durée d'affichage: **5 secondes** (auto-suppression)

Position: **Haut à droite** de l'écran

Animation: **Slide-in depuis la droite**

---

## 🔍 Exemple complet (EditProfile)

```typescript
import { useState } from 'react';
import { NotificationService } from '../contexts/NotificationService';

const EditProfile = () => {
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);

    // Validation
    if (!name || !phone) {
      NotificationService.warning(
        'Champs requis',
        'Veuillez remplir tous les champs'
      );
      setLoading(false);
      return;
    }

    try {
      // Appel API
      const response = await apiService.updateProfile(token, {
        name,
        phone,
        address
      });

      // Succès
      NotificationService.success(
        'Profil mis à jour!',
        'Vos informations ont été enregistrées'
      );

      // Mise à jour contexte
      updateUser(response.data);

      // Redirection
      navigate('/profile');
    } catch (error) {
      // Erreur
      NotificationService.error(
        'Erreur',
        error.message || 'Impossible de mettre à jour le profil'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    // ... JSX
  );
};
```

---

## 📊 Suivi des notifications

Les notifications sont **persistées dans localStorage** :

```typescript
// Automatique - pas besoin de gérer manuellement
localStorage.setItem('notifications', JSON.stringify(notifications));
```

Au chargement de l'app, les notifications non lues sont **restaurées** automatiquement.

---

## 🚀 Intégration dans toute l'app

Le composant `<NotificationToast />` est déjà ajouté dans `App.tsx` :

```tsx
<div className="app-container">
  <NotificationToast />  {/* ✅ Déjà intégré */}
  <Routes>
    {/* ... */}
  </Routes>
</div>
```

**Vous n'avez qu'à appeler le service n'importe où dans l'app!** 🎉

