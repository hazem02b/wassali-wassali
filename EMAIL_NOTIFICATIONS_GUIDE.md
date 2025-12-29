# 📧 Guide de Configuration des Emails et Notifications

## ✅ Fonctionnalités Implémentées

### 1. **Système d'Emails (SMTP)**

#### Emails automatiques envoyés :
- ✉️ **Email de bienvenue** - Lors de l'inscription
- ✉️ **Confirmation de réservation** - Quand une réservation est créée
- ✉️ **Réservation acceptée** - Quand le transporteur accepte
- ✉️ **Changement de mot de passe** - Après modification du mot de passe
- ✉️ **Nouveau message** - Notification de message reçu

### 2. **Notifications en Temps Réel (WebSocket)**

- 🔔 Notifications push instantanées
- 💬 Messages en temps réel
- 📞 Notifications d'appels entrants
- 📦 Mises à jour de réservations

### 3. **Système d'Appels Audio/Vidéo (WebRTC)**

- 📞 Appels vocaux
- 📹 Appels vidéo
- 🎤 Contrôle micro/caméra
- 🔇 Mute/unmute

---

## 🔧 Configuration des Emails (Gmail)

### Option 1: Gmail avec mot de passe d'application (RECOMMANDÉ)

1. **Activer la validation en 2 étapes** sur votre compte Gmail :
   - https://myaccount.google.com/security
   - Section "Validation en 2 étapes"

2. **Générer un mot de passe d'application** :
   - https://myaccount.google.com/apppasswords
   - Sélectionnez "Mail" et "Ordinateur Windows"
   - Copiez le mot de passe généré (16 caractères)

3. **Configurer le fichier `.env`** :
```env
# Email Configuration
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=votre.email@gmail.com
SMTP_PASSWORD=xxxx xxxx xxxx xxxx
FROM_EMAIL=noreply@wassali.com
FROM_NAME=Wassali
```

### Option 2: Services Email Professionnels

#### **SendGrid** (Recommandé pour production)
```env
SMTP_SERVER=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=YOUR_SENDGRID_API_KEY
FROM_EMAIL=noreply@wassali.com
FROM_NAME=Wassali
```

#### **Mailgun**
```env
SMTP_SERVER=smtp.mailgun.org
SMTP_PORT=587
SMTP_USERNAME=postmaster@mg.votredomaine.com
SMTP_PASSWORD=YOUR_MAILGUN_PASSWORD
FROM_EMAIL=noreply@wassali.com
FROM_NAME=Wassali
```

---

## 📱 Configuration des Appels (Optionnel)

### Avec Twilio (Pour SMS/Appels téléphoniques)

1. **Créer un compte Twilio** : https://www.twilio.com/try-twilio

2. **Obtenir vos credentials** :
   - Account SID
   - Auth Token  
   - Phone Number

3. **Ajouter au `.env`** :
```env
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_PHONE_NUMBER=+33123456789
```

---

## 🧪 Test des Fonctionnalités

### 1. Tester l'envoi d'emails

```python
# Dans backend/
python test_email.py
```

### 2. Tester les WebSockets

Ouvrez la console navigateur (F12) et vous verrez :
- ✅ WebSocket connecté
- 📨 Notifications reçues en temps réel

### 3. Tester les appels

Dans une page avec messagerie :
- Cliquez sur l'icône téléphone
- Permet d'appeler l'autre utilisateur
- WebRTC peer-to-peer

---

## 📝 Utilisation dans le Code

### Envoyer un email depuis le backend

```python
from app.core.email import email_service

# Email de bienvenue
email_service.send_welcome_email(
    to_email="user@example.com",
    name="Jean Dupont"
)

# Email de confirmation réservation
email_service.send_booking_confirmation(
    to_email="user@example.com",
    name="Jean Dupont",
    booking_id=123,
    from_location="Paris",
    to_location="Tunis",
    date="25/12/2025",
    price=150.00
)
```

### Envoyer une notification WebSocket

```python
from app.core.notifications import notification_manager

# Notification de nouveau message
await notification_manager.send_message_notification(
    user_id=user_id,
    sender_name="Marie",
    sender_id=sender_id,
    message_preview="Bonjour, j'ai une question..."
)

# Notification d'appel
await notification_manager.send_call_notification(
    user_id=user_id,
    caller_name="Jean",
    caller_id=caller_id,
    call_type="voice"  # ou "video"
)
```

### Utiliser le service d'appels (Frontend)

```typescript
import { callService } from '../services/call.service';

// Initier un appel
await callService.initiateCall({
  type: 'voice', // ou 'video'
  callerName: 'Jean Dupont',
  callerId: 123
});

// Toggle micro
callService.toggleMicrophone();

// Terminer l'appel
callService.endCall();
```

---

## 🚀 Pour l'Application Mobile (Flutter)

Tous les services sont prêts pour le mobile :

1. **Emails** : Automatiques côté backend ✅
2. **WebSocket** : Compatible avec Flutter WebSocket ✅
3. **Appels** : WebRTC fonctionne sur mobile ✅

### Packages Flutter recommandés :

```yaml
dependencies:
  web_socket_channel: ^2.4.0  # WebSocket
  flutter_webrtc: ^0.9.0      # Appels vidéo
  flutter_local_notifications: ^16.0.0  # Notifications
```

---

## 🎯 Prochaines Étapes

1. ✅ **Configurer Gmail** avec mot de passe d'application
2. ✅ **Tester les emails** en créant un compte
3. ✅ **Tester les notifications** en temps réel
4. ✅ **Préparer Flutter** avec les packages nécessaires

L'application est maintenant **complète et prête pour le mobile** ! 🎉
