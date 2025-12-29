// Application Constants

export const APP_NAME = 'Wassali';
export const APP_TAGLINE = 'Ça arrive!';
export const APP_VERSION = '1.0.0';

// Colors
export const COLORS = {
  primary: '#0066FF',
  primaryDark: '#0052CC',
  secondary: '#FF9500',
  secondaryDark: '#E68600',
  success: '#10B981',
  error: '#EF4444',
  warning: '#F59E0B',
  info: '#3B82F6',
  gray: {
    50: '#F9FAFB',
    100: '#F3F4F6',
    200: '#E5E7EB',
    300: '#D1D5DB',
    400: '#9CA3AF',
    500: '#6B7280',
    600: '#4B5563',
    700: '#374151',
    800: '#1F2937',
    900: '#111827',
  },
};

// Routes
export const ROUTES = {
  // Public
  LANDING: '/',
  LOGIN: '/login',
  SIGNUP_CLIENT: '/signup-client',
  SIGNUP_TRANSPORTER: '/signup-transporter',

  // Client
  HOME: '/home',
  SEARCH: '/search',
  TRANSPORT_DETAILS: '/transport/:id',
  BOOKING_FORM: '/booking/:id',
  PAYMENT: '/payment',
  BOOKING_CONFIRMATION: '/booking-confirmation',
  MY_BOOKINGS: '/my-bookings',
  PROFILE: '/profile',
  MESSAGES: '/messages',
  CHAT: '/chat',

  // Transporter
  TRANSPORTER_DASHBOARD: '/transporter-dashboard',
  CREATE_TRIP: '/create-trip',
  MY_TRIPS: '/my-trips',
  TRANSPORTER_REVIEWS: '/transporter-reviews',
};

// Cities
export const CITIES_TUNISIA = [
  'Tunis',
  'Sfax',
  'Sousse',
  'Kairouan',
  'Bizerte',
  'Gabès',
  'Ariana',
  'Gafsa',
  'Monastir',
  'Ben Arous',
];

export const CITIES_FRANCE = [
  'Paris',
  'Lyon',
  'Marseille',
  'Toulouse',
  'Nice',
  'Nantes',
  'Strasbourg',
  'Montpellier',
  'Bordeaux',
  'Lille',
];

export const CITIES_EUROPE = [
  ...CITIES_FRANCE,
  'Brussels',
  'Amsterdam',
  'Berlin',
  'Rome',
  'Madrid',
  'Barcelona',
  'Geneva',
  'Zurich',
];

// Transportable Items
export const TRANSPORTABLE_ITEMS = [
  'Documents',
  'Clothes',
  'Electronics',
  'Food (non-perishable)',
  'Books',
  'Furniture',
  'Toys',
  'Cosmetics',
  'Medicines',
  'Accessories',
];

// Payment Methods
export const PAYMENT_METHODS = [
  { id: 'wallet', label: 'Mobile Wallet', available: true },
  { id: 'card', label: 'Credit/Debit Card', available: true },
  { id: 'bank', label: 'Bank Transfer', available: true },
  { id: 'cash', label: 'Cash on Pickup', available: true },
];

// Booking Statuses
export const BOOKING_STATUSES = {
  PENDING: 'pending',
  CONFIRMED: 'confirmed',
  IN_TRANSIT: 'in-transit',
  DELIVERED: 'delivered',
  CANCELLED: 'cancelled',
} as const;

export const BOOKING_STATUS_LABELS = {
  [BOOKING_STATUSES.PENDING]: 'En attente',
  [BOOKING_STATUSES.CONFIRMED]: 'Confirmée',
  [BOOKING_STATUSES.IN_TRANSIT]: 'En transit',
  [BOOKING_STATUSES.DELIVERED]: 'Livrée',
  [BOOKING_STATUSES.CANCELLED]: 'Annulée',
};

export const BOOKING_STATUS_COLORS = {
  [BOOKING_STATUSES.PENDING]: 'yellow',
  [BOOKING_STATUSES.CONFIRMED]: 'blue',
  [BOOKING_STATUSES.IN_TRANSIT]: 'purple',
  [BOOKING_STATUSES.DELIVERED]: 'green',
  [BOOKING_STATUSES.CANCELLED]: 'red',
};

// Trip Types
export const TRIP_TYPES = [
  { id: 'one-time', label: 'One Time', description: 'Single trip' },
  { id: 'weekly', label: 'Weekly', description: 'Every week' },
  { id: 'monthly', label: 'Monthly', description: 'Every month' },
];

// Languages
export const LANGUAGES = [
  { code: 'fr', label: 'Français', flag: '🇫🇷' },
  { code: 'ar', label: 'العربية', flag: '🇹🇳' },
  { code: 'en', label: 'English', flag: '🇬🇧' },
];

// Validation Rules
export const VALIDATION = {
  EMAIL_REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  PHONE_REGEX: /^\+?[0-9]{8,15}$/,
  PASSWORD_MIN_LENGTH: 8,
  WEIGHT_MIN: 0.1,
  WEIGHT_MAX: 100,
  PRICE_MIN: 1,
  PRICE_MAX: 1000,
};

// API Configuration
export const API_CONFIG = {
  BASE_URL: import.meta.env.VITE_API_URL || 'http://localhost:3000/api',
  TIMEOUT: 30000,
  RETRY_ATTEMPTS: 3,
};

// Local Storage Keys
export const STORAGE_KEYS = {
  AUTH_TOKEN: 'wassali_auth_token',
  USER_DATA: 'wassali_user_data',
  LANGUAGE: 'wassali_language',
  THEME: 'wassali_theme',
  RECENT_SEARCHES: 'wassali_recent_searches',
};

// Date Formats
export const DATE_FORMATS = {
  SHORT: 'MMM dd',
  LONG: 'MMMM dd, yyyy',
  WITH_TIME: 'MMM dd, yyyy HH:mm',
  TIME_ONLY: 'HH:mm',
};

// Pagination
export const PAGINATION = {
  DEFAULT_PAGE_SIZE: 10,
  MAX_PAGE_SIZE: 50,
};

// Features Flags
export const FEATURES = {
  CHAT_ENABLED: true,
  NOTIFICATIONS_ENABLED: true,
  PAYMENTS_ENABLED: true,
  REVIEWS_ENABLED: true,
  GEOLOCATION_ENABLED: false,
  VIDEO_CALL_ENABLED: false,
};

// Social Media
export const SOCIAL_LINKS = {
  FACEBOOK: 'https://facebook.com/wassali',
  INSTAGRAM: 'https://instagram.com/wassali',
  TWITTER: 'https://twitter.com/wassali',
};

// Support
export const SUPPORT = {
  EMAIL: 'support@wassali.com',
  PHONE: '+216 XX XXX XXX',
  WHATSAPP: '+216 XX XXX XXX',
};

// Terms & Privacy
export const LEGAL_LINKS = {
  TERMS: '/terms-of-service',
  PRIVACY: '/privacy-policy',
  FAQ: '/faq',
};

// Animation Durations (ms)
export const ANIMATION = {
  FAST: 150,
  NORMAL: 300,
  SLOW: 500,
  TOAST: 3000,
};

// Maximum file sizes (bytes)
export const FILE_SIZE = {
  AVATAR: 2 * 1024 * 1024, // 2MB
  PACKAGE_PHOTO: 5 * 1024 * 1024, // 5MB
  ATTACHMENT: 10 * 1024 * 1024, // 10MB
};

// Allowed file types
export const ALLOWED_FILE_TYPES = {
  IMAGE: ['image/jpeg', 'image/png', 'image/webp'],
  DOCUMENT: ['application/pdf', 'application/msword'],
};
