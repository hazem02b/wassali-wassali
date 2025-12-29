class AppConstants {
  // App Info
  static const String appName = 'Wassali';
  static const String appTagline = 'Ça arrive!';
  static const String appVersion = '1.0.0';

  // Routes
  static const String routeLanding = '/';
  static const String routeLogin = '/login';
  static const String routeSignupClient = '/signup-client';
  static const String routeSignupTransporter = '/signup-transporter';
  static const String routeHome = '/home';
  static const String routeSearch = '/search';
  static const String routeTripDetails = '/trip-details';
  static const String routeBooking = '/booking';
  static const String routePayment = '/payment';
  static const String routeConfirmation = '/confirmation';
  static const String routeMyBookings = '/my-bookings';
  static const String routeProfile = '/profile';
  static const String routeMessages = '/messages';
  static const String routeChat = '/chat';
  static const String routeTransporterDashboard = '/transporter-dashboard';
  static const String routeCreateTrip = '/create-trip';
  static const String routeMyTrips = '/my-trips';
  static const String routeReviews = '/reviews';

  // Cities Tunisia
  static const List<String> citiesTunisia = [
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
    'Kasserine',
    'Médenine',
    'Nabeul',
    'Tataouine',
    'Béja',
    'Jendouba',
    'Mahdia',
    'Sidi Bouzid',
    'Zaghouan',
    'Siliana',
    'Le Kef',
    'Tozeur',
    'Manouba',
    'Kébili',
  ];

  // Cities Europe
  static const List<String> citiesEurope = [
    // France
    'Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice', 'Nantes',
    'Strasbourg', 'Montpellier', 'Bordeaux', 'Lille', 'Rennes',
    // Allemagne
    'Berlin', 'Munich', 'Frankfurt', 'Hamburg', 'Cologne',
    // Italie
    'Rome', 'Milan', 'Naples', 'Turin', 'Palermo',
    // Espagne
    'Madrid', 'Barcelona', 'Valencia', 'Seville',
    // Belgique
    'Brussels', 'Antwerp', 'Ghent', 'Liège',
    // Pays-Bas
    'Amsterdam', 'Rotterdam', 'The Hague',
    // Suisse
    'Zurich', 'Geneva', 'Basel', 'Bern',
  ];

  // Booking Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusInTransit = 'in_transit';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';

  // Trip Status
  static const String tripStatusActive = 'active';
  static const String tripStatusCompleted = 'completed';
  static const String tripStatusCancelled = 'cancelled';

  // User Types
  static const String userTypeClient = 'client';
  static const String userTypeTransporter = 'transporter';

  // Payment Methods
  static const String paymentCash = 'cash';
  static const String paymentCard = 'card';
  static const String paymentPaypal = 'paypal';

  // Transportable Items
  static const List<String> transportableItems = [
    'Documents',
    'Clothing',
    'Electronics',
    'Food',
    'Medicine',
    'Gifts',
    'Books',
    'Others',
  ];

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPackageWeight = 50; // kg
  static const int minPackageWeight = 1; // kg
  static const double maxPricePerKg = 100.0; // TND
  static const double minPricePerKg = 5.0; // TND

  // Storage Keys
  static const String keyUserId = 'userId';
  static const String keyUserType = 'userType';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';

  // Languages
  static const String langFrench = 'fr';
  static const String langEnglish = 'en';
  static const String langArabic = 'ar';

  // Pagination
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 100;

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration cacheExpiry = Duration(hours: 1);

  // Firebase Collections
  static const String collectionUsers = 'users';
  static const String collectionTrips = 'trips';
  static const String collectionBookings = 'bookings';
  static const String collectionReviews = 'reviews';
  static const String collectionMessages = 'messages';
  static const String collectionNotifications = 'notifications';

  // Notification Types
  static const String notifBookingConfirmed = 'booking_confirmed';
  static const String notifBookingCancelled = 'booking_cancelled';
  static const String notifNewMessage = 'new_message';
  static const String notifTripUpdate = 'trip_update';
  static const String notifPaymentReceived = 'payment_received';
  static const String notifReviewReceived = 'review_received';
}
