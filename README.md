# 📦 Wassali - Application de Livraison de Colis

> **Ça arrive !** - Connectez la Tunisie à l'Europe pour vos envois de colis

Une application mobile moderne et complète pour faciliter l'envoi de colis entre la Tunisie et l'Europe. Wassali met en relation des clients ayant besoin d'envoyer des colis avec des transporteurs effectuant des trajets réguliers.

## 🌟 Aperçu du Projet

Wassali est une Progressive Web App (PWA) développée avec React, TypeScript et Vite, offrant une expérience mobile native pour :
- **Les Clients** : Trouver et réserver des transporteurs de confiance
- **Les Transporteurs** : Monétiser leurs trajets en transportant des colis

## ✨ Fonctionnalités Principales

### Pour les Clients 👥
- ✅ Recherche avancée de transporteurs (origine, destination, date, prix)
- ✅ Profils vérifiés avec système de notation
- ✅ Réservation et paiement en ligne sécurisé
- ✅ Suivi de colis en temps réel
- ✅ Messagerie intégrée avec les transporteurs
- ✅ Historique des envois
- ✅ Gestion de profil et adresses sauvegardées
- ✅ Notifications en temps réel

### Pour les Transporteurs 🚚
- ✅ Création et gestion de trajets
- ✅ Tableau de bord avec statistiques détaillées
- ✅ Gestion des réservations et demandes
- ✅ Système d'évaluation et avis clients
- ✅ Messagerie avec les clients
- ✅ Revenus et historique des trajets
- ✅ Badge de vérification

## 🛠️ Technologies

- **Frontend**: React 18 + TypeScript
- **Build Tool**: Vite
- **Routing**: React Router v6
- **Styling**: Tailwind CSS
- **UI Components**: Radix UI, Material UI
- **Icons**: Lucide React
- **Date Handling**: date-fns
- **Animations**: Motion, CSS Animations
- **PWA**: Manifest + Service Worker ready

## 📁 Structure du Projet

```
src/
├── app/
│   ├── components/        # Composants réutilisables
│   ├── contexts/          # Context API (Auth, Booking, Notifications)
│   ├── hooks/             # Custom hooks
│   ├── pages/             # 17 pages complètes
│   ├── types/             # Types TypeScript
│   ├── constants/         # Constantes de l'app
│   ├── utils/             # Fonctions utilitaires
│   └── App.tsx
├── styles/                # Styles CSS + animations
└── main.tsx
```

## 🚀 Installation et Démarrage

### Prérequis
- Node.js 18+ 
- npm ou yarn

### Installation

```bash
# Cloner le repository
git clone https://github.com/votre-username/wassali-app.git

# Accéder au dossier
cd wassali-app

# Installer les dépendances
npm install
```

### Développement

```bash
# Lancer le serveur de développement
npm run dev

# L'application sera accessible sur http://localhost:5173
```

### Production

```bash
# Créer le build de production
npm run build

# Prévisualiser le build
npm run preview
```

## 📱 Pages Disponibles

### Pages Publiques
- `/` - Page d'accueil
- `/login` - Connexion
- `/signup-client` - Inscription client
- `/signup-transporter` - Inscription transporteur

### Espace Client
- `/home` - Accueil client
- `/search` - Recherche de transporteurs
- `/transport/:id` - Détails d'un transport
- `/booking/:id` - Formulaire de réservation
- `/payment` - Paiement
- `/booking-confirmation` - Confirmation
- `/my-bookings` - Mes réservations
- `/messages` - Messagerie
- `/chat` - Discussion
- `/profile` - Profil

### Espace Transporteur
- `/transporter-dashboard` - Tableau de bord
- `/create-trip` - Créer un trajet
- `/my-trips` - Mes trajets
- `/transporter-reviews` - Mes avis

## 🎨 Design System

### Couleurs
- **Client** : Bleu (#0066FF)
- **Transporteur** : Orange (#FF9500)
- **Success** : Vert (#10B981)
- **Error** : Rouge (#EF4444)

### Responsive
- Mobile-first design
- Largeur max : 390px (format mobile)
- Optimisé pour tous les écrans

## 📚 Documentation

Consultez les guides détaillés :
- [📖 Documentation Complète](./DOCUMENTATION.md)
- [👨‍💻 Guide Développeur](./DEVELOPER_GUIDE.md)
- [👤 Guide Utilisateur](./USER_GUIDE.md)
- [📋 Résumé du Projet](./PROJECT_SUMMARY.md)

## 🧪 Tests

```bash
# Lancer les tests (à configurer)
npm test

# Tests avec couverture
npm run test:coverage
```

## 🌍 Internationalisation

Support multilingue :
- 🇫🇷 Français (par défaut)
- 🇹🇳 Arabe
- 🇬🇧 Anglais

## 🔐 Sécurité

- Authentification sécurisée
- Paiements cryptés (SSL)
- Validation des données
- Protection CSRF
- Headers de sécurité

## 📈 Performance

- Code splitting automatique
- Lazy loading des routes
- Optimisation des images
- Cache et compression
- PWA pour fonctionnement hors ligne

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 🗺️ Roadmap

- [ ] Intégration API backend
- [ ] Notifications push
- [ ] Géolocalisation temps réel
- [ ] Carte interactive
- [ ] Système de fidélité
- [ ] Application mobile native (React Native)
- [ ] Support multi-devises
- [ ] Dashboard admin

## 📄 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Auteurs

- **Votre Nom** - *Développeur Principal* - [GitHub](https://github.com/votre-username)

## 🙏 Remerciements

- Design original : [Figma Community](https://www.figma.com/design/PhGBzpuXlREHYJPjJNZKxB/Wassali-Parcel-Delivery-App)
- Icons : [Lucide Icons](https://lucide.dev)
- UI Components : [Radix UI](https://radix-ui.com) & [shadcn/ui](https://ui.shadcn.com)
- Communauté React et TypeScript

## 📞 Support

- 📧 Email : support@wassali.com
- 💬 Discord : [Rejoindre notre serveur](#)
- 📱 Téléphone : +216 XX XXX XXX

## 🔗 Liens Utiles

- [Site Web](https://wassali.com)
- [Documentation API](#)
- [Blog](#)
- [Status Page](#)

---

<div align="center">

**Fait avec ❤️ pour la communauté Tuniso-Européenne**

[⭐ Star](https://github.com/votre-username/wassali-app) • [🐛 Report Bug](https://github.com/votre-username/wassali-app/issues) • [✨ Request Feature](https://github.com/votre-username/wassali-app/issues)

</div>
  