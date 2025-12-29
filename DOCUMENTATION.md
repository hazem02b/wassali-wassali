# 📦 Wassali - Application de Livraison de Colis

Une application mobile moderne pour la livraison de colis entre la Tunisie et l'Europe, développée avec React, TypeScript et Vite.

## 🌟 Fonctionnalités

### Pour les Clients
- ✅ Recherche de transporteurs disponibles
- ✅ Réservation et paiement en ligne
- ✅ Suivi des colis en temps réel
- ✅ Historique des réservations
- ✅ Messagerie avec les transporteurs
- ✅ Gestion du profil et des adresses
- ✅ Système de notification

### Pour les Transporteurs
- ✅ Création et gestion des trajets
- ✅ Tableau de bord avec statistiques
- ✅ Gestion des réservations
- ✅ Système d'évaluation et avis
- ✅ Messagerie avec les clients
- ✅ Historique des trajets

## 🚀 Technologies Utilisées

- **React 18** - Framework UI
- **TypeScript** - Typage statique
- **Vite** - Build tool ultra-rapide
- **React Router** - Navigation
- **Tailwind CSS** - Styling
- **Radix UI** - Composants UI accessibles
- **Lucide React** - Icônes
- **Material UI** - Composants additionnels
- **date-fns** - Manipulation des dates
- **Motion** - Animations fluides

## 📁 Structure du Projet

```
src/
├── app/
│   ├── components/        # Composants réutilisables
│   │   ├── BottomNav.tsx
│   │   ├── LanguageSelector.tsx
│   │   ├── LoadingSpinner.tsx
│   │   ├── Toast.tsx
│   │   └── NotificationPanel.tsx
│   ├── contexts/          # Contextes React
│   │   ├── AuthContext.tsx
│   │   ├── BookingContext.tsx
│   │   └── NotificationContext.tsx
│   ├── hooks/             # Hooks personnalisés
│   │   └── useToast.tsx
│   ├── pages/             # Pages de l'application
│   │   ├── LandingPage.tsx
│   │   ├── LoginPage.tsx
│   │   ├── SignupClient.tsx
│   │   ├── SignupTransporter.tsx
│   │   ├── HomeClient.tsx
│   │   ├── SearchResults.tsx
│   │   ├── TransportDetails.tsx
│   │   ├── BookingForm.tsx
│   │   ├── PaymentPage.tsx
│   │   ├── BookingConfirmation.tsx
│   │   ├── MyBookings.tsx
│   │   ├── ClientProfile.tsx
│   │   ├── MessagesPage.tsx
│   │   ├── ChatPage.tsx
│   │   ├── TransporterDashboard.tsx
│   │   ├── CreateTrip.tsx
│   │   ├── MyTrips.tsx
│   │   └── TransporterReviews.tsx
│   └── App.tsx
├── styles/
│   ├── index.css
│   ├── tailwind.css
│   └── theme.css
└── main.tsx
```

## 🎨 Design System

### Couleurs Principales
- **Bleu Principal**: #0066FF (Client)
- **Orange**: #FF9500 (Transporteur)
- **Gris Clair**: #F3F4F6 (Fond)
- **Blanc**: #FFFFFF

### Typographie
- Police par défaut du système
- Tailles responsives

## 🛠️ Installation

```bash
# Cloner le repository
git clone https://github.com/votre-username/wassali-app.git

# Installer les dépendances
cd wassali-app
npm install

# Lancer le serveur de développement
npm run dev

# Build pour production
npm run build
```

## 📱 Progressive Web App (PWA)

L'application est configurée comme une PWA:
- Installation sur l'écran d'accueil
- Fonctionne hors ligne (avec service worker)
- Expérience native sur mobile

## 🔐 Authentification

Le système d'authentification utilise React Context pour:
- Gestion de l'état utilisateur
- Connexion/Déconnexion
- Routes protégées
- Profils Client et Transporteur

## 💬 Messagerie

Système de messagerie en temps réel:
- Conversations 1-à-1
- Statut en ligne
- Notifications de nouveaux messages
- Historique des conversations

## 📊 Gestion d'État

### Contexts Disponibles
- **AuthContext**: Authentification et profil utilisateur
- **BookingContext**: Gestion des réservations
- **NotificationContext**: Système de notifications

### Hooks Personnalisés
- **useToast**: Affichage de messages toast
- **useAuth**: Accès à l'authentification
- **useBooking**: Gestion des réservations
- **useNotification**: Gestion des notifications

## 🎯 Fonctionnalités Avancées

### Recherche et Filtres
- Recherche par ville de départ/arrivée
- Filtres par date, poids, prix
- Résultats en temps réel

### Système de Paiement
Multiple options de paiement:
- Carte bancaire
- Portefeuille mobile
- Virement bancaire
- Paiement en espèces

### Évaluations et Avis
- Système d'étoiles (1-5)
- Commentaires détaillés
- Distribution des notes
- Moyennes calculées

## 📈 Optimisations

- **Code Splitting**: Chargement optimisé des pages
- **Lazy Loading**: Chargement différé des images
- **Optimisation des images**: Compression et formats modernes
- **Minification**: CSS et JS minifiés pour production
- **Cache**: Mise en cache des ressources statiques

## 🌍 Internationalisation

Support multilingue:
- Français (par défaut)
- Arabe
- Anglais

## 🧪 Tests

```bash
# Lancer les tests
npm test

# Tests avec couverture
npm run test:coverage
```

## 📝 Développement

### Conventions de Code
- Utiliser TypeScript strict mode
- Composants fonctionnels avec hooks
- Nommage en PascalCase pour composants
- camelCase pour fonctions et variables

### Git Workflow
```bash
# Créer une branche pour nouvelle feature
git checkout -b feature/nom-feature

# Commit avec message descriptif
git commit -m "feat: description de la feature"

# Push et créer une PR
git push origin feature/nom-feature
```

## 🚀 Déploiement

### Netlify
```bash
npm run build
# Upload le dossier dist/ sur Netlify
```

### Vercel
```bash
npm run build
vercel --prod
```

## 📄 License

Ce projet est sous licence MIT.

## 👥 Contributeurs

- Votre Nom - Développeur Principal

## 📞 Support

Pour toute question ou support:
- Email: support@wassali.com
- Issues: GitHub Issues

## 🔮 Roadmap

- [ ] Intégration API backend
- [ ] Notifications push
- [ ] Géolocalisation en temps réel
- [ ] Carte interactive des trajets
- [ ] Système de fidélité
- [ ] Chat vidéo
- [ ] Application mobile native (React Native)

## 🙏 Remerciements

- Design original: Figma Community
- Icônes: Lucide Icons
- Composants UI: Radix UI & shadcn/ui

---

Made with ❤️ for the Tunisian-European community
