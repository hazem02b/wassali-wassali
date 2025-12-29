# 📚 Guide de Développement - Wassali App

## Table des Matières
1. [Architecture](#architecture)
2. [Composants Clés](#composants-clés)
3. [Gestion d'État](#gestion-détat)
4. [Routing](#routing)
5. [Styling](#styling)
6. [Bonnes Pratiques](#bonnes-pratiques)

## Architecture

### Structure des Dossiers
```
src/
├── app/
│   ├── components/     # Composants réutilisables
│   ├── contexts/       # Contexts React (état global)
│   ├── hooks/          # Hooks personnalisés
│   ├── pages/          # Pages/Routes
│   └── App.tsx         # Composant racine
├── styles/             # Styles CSS
└── main.tsx           # Point d'entrée
```

### Flux de Données
```
main.tsx
  └── App.tsx (Providers)
      ├── AuthProvider
      ├── BookingProvider
      └── NotificationProvider
          └── Routes (Pages)
```

## Composants Clés

### 1. BottomNav
Navigation principale de l'application

**Usage:**
```tsx
import BottomNav from '../components/BottomNav';

<BottomNav active="home" />
```

**Props:**
- `active`: 'home' | 'search' | 'bookings' | 'messages' | 'profile'

### 2. LoadingSpinner
Indicateur de chargement

**Usage:**
```tsx
import LoadingSpinner from '../components/LoadingSpinner';

<LoadingSpinner size="md" color="text-blue-500" />
```

**Props:**
- `size`: 'sm' | 'md' | 'lg' (défaut: 'md')
- `color`: string (défaut: 'text-[#0066FF]')

### 3. Toast
Notifications temporaires

**Usage:**
```tsx
import { useToast } from '../hooks/useToast';

const { success, error, info, warning } = useToast();

success('Réservation confirmée!');
error('Une erreur est survenue');
```

### 4. NotificationPanel
Panneau de notifications

**Usage:**
```tsx
import NotificationPanel from '../components/NotificationPanel';

const [isOpen, setIsOpen] = useState(false);

<NotificationPanel isOpen={isOpen} onClose={() => setIsOpen(false)} />
```

## Gestion d'État

### AuthContext
Gestion de l'authentification

```tsx
import { useAuth } from '../contexts/AuthContext';

const { user, isAuthenticated, login, logout } = useAuth();

// Se connecter
await login('email@example.com', 'password', 'client');

// Se déconnecter
logout();

// Vérifier si connecté
if (isAuthenticated) {
  // Utilisateur connecté
}
```

### BookingContext
Gestion des réservations

```tsx
import { useBooking } from '../contexts/BookingContext';

const { bookings, addBooking, updateBooking, currentBooking } = useBooking();

// Ajouter une réservation
const newBooking = {
  id: '123',
  transporterId: '1',
  transporterName: 'Mohamed Ali',
  from: 'Tunis',
  to: 'Paris',
  date: 'Dec 25, 2024',
  // ...autres champs
};
addBooking(newBooking);

// Mettre à jour une réservation
updateBooking('123', { status: 'confirmed' });
```

### NotificationContext
Système de notifications

```tsx
import { useNotification } from '../contexts/NotificationContext';

const { notifications, unreadCount, addNotification, markAsRead } = useNotification();

// Ajouter une notification
addNotification({
  title: 'Nouvelle réservation',
  message: 'Vous avez une nouvelle réservation',
  type: 'info'
});

// Marquer comme lue
markAsRead('notification-id');
```

## Routing

### Routes Disponibles

#### Public
- `/` - Landing Page
- `/login` - Connexion
- `/signup-client` - Inscription Client
- `/signup-transporter` - Inscription Transporteur

#### Client
- `/home` - Accueil Client
- `/search` - Recherche de transporteurs
- `/transport/:id` - Détails d'un transport
- `/booking/:id` - Formulaire de réservation
- `/payment` - Page de paiement
- `/booking-confirmation` - Confirmation
- `/my-bookings` - Mes réservations
- `/messages` - Messages
- `/chat` - Discussion
- `/profile` - Profil

#### Transporteur
- `/transporter-dashboard` - Dashboard
- `/create-trip` - Créer un trajet
- `/my-trips` - Mes trajets
- `/transporter-reviews` - Mes avis

### Navigation Programmatique

```tsx
import { useNavigate } from 'react-router-dom';

const navigate = useNavigate();

// Navigation simple
navigate('/home');

// Navigation avec paramètres
navigate(`/transport/${transportId}`);

// Retour en arrière
navigate(-1);

// Remplacement (pas d'historique)
navigate('/home', { replace: true });
```

## Styling

### Tailwind CSS
Utilisation des classes utilitaires

```tsx
// Couleurs principales
<div className="bg-[#0066FF]">      // Bleu principal
<div className="bg-[#FF9500]">      // Orange (transporteur)
<div className="text-gray-600">     // Texte secondaire

// Spacing
<div className="p-6">               // Padding
<div className="mb-4">              // Margin bottom
<div className="space-y-3">         // Espacement vertical entre enfants

// Flexbox
<div className="flex items-center justify-between">
<div className="grid grid-cols-2 gap-4">

// Responsive
<div className="max-w-[390px] mx-auto">  // Largeur max mobile

// Animations
<div className="animate-slide-in">
<div className="transition-all active:scale-98">
```

### Classes Personnalisées

```css
/* Animations */
.animate-slide-in         // Slide de bas en haut
.animate-slide-in-right   // Slide de droite à gauche
.animate-fade-in          // Apparition en fondu
.animate-bounce-in        // Apparition avec rebond

/* Utilitaires */
.safe-area-bottom         // Padding pour encoche iPhone
.scrollbar-hide          // Cacher la scrollbar
```

## Bonnes Pratiques

### 1. Composants

#### ✅ À Faire
```tsx
// Typage strict
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

// Composant fonctionnel
export default function Button({ label, onClick, variant = 'primary' }: ButtonProps) {
  return (
    <button
      onClick={onClick}
      className={variant === 'primary' ? 'bg-blue-500' : 'bg-gray-500'}
    >
      {label}
    </button>
  );
}
```

#### ❌ À Éviter
```tsx
// Pas de typage
function Button(props) {
  return <button>{props.label}</button>;
}

// Logique complexe dans le JSX
return (
  <div>
    {items.map(item => 
      item.active && item.type === 'special' ? 
        <SpecialItem {...item} /> : 
        <RegularItem {...item} />
    )}
  </div>
);
```

### 2. Gestion d'État

#### ✅ À Faire
```tsx
// Utiliser les contexts pour état global
const { user } = useAuth();

// État local pour UI
const [isOpen, setIsOpen] = useState(false);

// Callbacks mémorisés
const handleClick = useCallback(() => {
  // action
}, [dependencies]);
```

#### ❌ À Éviter
```tsx
// Prop drilling excessif
<Parent user={user}>
  <Child user={user}>
    <GrandChild user={user} />
  </Child>
</Parent>

// État global dans useState
const [globalUser, setGlobalUser] = useState();
```

### 3. Performance

#### ✅ À Faire
```tsx
// Lazy loading des routes
const HomePage = lazy(() => import('./pages/HomePage'));

// Mémorisation
const memoizedValue = useMemo(() => expensiveCalculation(data), [data]);

// Éviter les re-renders
const MemoizedComponent = memo(Component);
```

#### ❌ À Éviter
```tsx
// Créer des objets dans le render
<Component config={{ option: true }} />  // ❌

// Mieux:
const config = { option: true };
<Component config={config} />  // ✅
```

### 4. Accessibilité

#### ✅ À Faire
```tsx
// Labels pour inputs
<label htmlFor="email">Email</label>
<input id="email" type="email" />

// Attributs ARIA
<button aria-label="Fermer" onClick={onClose}>
  <X />
</button>

// Navigation au clavier
<button onKeyDown={handleKeyDown}>
```

### 5. Sécurité

#### ✅ À Faire
```tsx
// Validation des inputs
const sanitizedInput = DOMPurify.sanitize(userInput);

// Éviter dangerouslySetInnerHTML
<div>{sanitizedContent}</div>  // ✅
<div dangerouslySetInnerHTML={{__html: content}} />  // ❌

// Vérification des permissions
if (isAuthenticated) {
  // Accès autorisé
}
```

## Debugging

### React DevTools
```bash
# Installer l'extension Chrome/Firefox
# Inspecter les components et leur état
```

### Console Logging
```tsx
// Development only
if (import.meta.env.DEV) {
  console.log('Debug info:', data);
}
```

### Error Boundaries
```tsx
// Capturer les erreurs React
<ErrorBoundary fallback={<ErrorPage />}>
  <App />
</ErrorBoundary>
```

## Testing

### Tests Unitaires
```tsx
import { render, screen } from '@testing-library/react';
import Button from './Button';

test('renders button with label', () => {
  render(<Button label="Click me" onClick={() => {}} />);
  expect(screen.getByText('Click me')).toBeInTheDocument();
});
```

### Tests d'Intégration
```tsx
test('booking flow', async () => {
  render(<App />);
  
  // Naviguer vers recherche
  fireEvent.click(screen.getByText('Search'));
  
  // Sélectionner un transporteur
  fireEvent.click(screen.getByText('Book'));
  
  // Vérifier la confirmation
  await waitFor(() => {
    expect(screen.getByText('Booking Confirmed')).toBeInTheDocument();
  });
});
```

## Déploiement

### Build de Production
```bash
npm run build
```

### Variables d'Environnement
```env
VITE_API_URL=https://api.wassali.com
VITE_STRIPE_KEY=pk_live_xxx
```

### Optimisations
- Compression Gzip/Brotli
- CDN pour assets statiques
- Cache headers appropriés
- Service Worker pour PWA

## Ressources

- [React Documentation](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Tailwind CSS](https://tailwindcss.com)
- [Vite Guide](https://vitejs.dev/guide/)

---

Pour toute question, consultez la documentation complète ou ouvrez une issue sur GitHub.
