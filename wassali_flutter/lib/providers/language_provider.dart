import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider pour gérer la langue de l'application
class LanguageProvider extends ChangeNotifier {
  static const String _key = 'language';
  String _currentLanguage = 'fr'; // Français par défaut
  late SharedPreferences _prefs;

  String get currentLanguage => _currentLanguage;
  Locale get locale => Locale(_currentLanguage);

  LanguageProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _currentLanguage = _prefs.getString(_key) ?? 'fr';
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      await _prefs.setString(_key, languageCode);
      notifyListeners();
    }
  }

  String translate(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  // Alias pour raccourcir l'appel
  String t(String key) => translate(key);
}

/// Traductions complètes FR/EN/AR (copie exacte de la version web)
const Map<String, Map<String, String>> _translations = {
  'fr': {
    // Navigation
    'home': 'Accueil',
    'search': 'Rechercher',
    'trips': 'Trajets',
    'bookings': 'Réservations',
    'messages': 'Messages',
    'profile': 'Profil',
    'settings': 'Paramètres',
    
    // Auth
    'login': 'Connexion',
    'register': 'S\'inscrire',
    'logout': 'Déconnexion',
    'email': 'Email',
    'password': 'Mot de passe',
    'confirmPassword': 'Confirmer le mot de passe',
    'name': 'Nom complet',
    'phone': 'Téléphone',
    'forgotPassword': 'Mot de passe oublié ?',
    'dontHaveAccount': 'Vous n\'avez pas de compte ?',
    'alreadyHaveAccount': 'Vous avez déjà un compte ?',
    'signUp': 'S\'inscrire',
    'client': 'Client',
    'transporter': 'Transporteur',
    'continueAsClient': 'Continuer en tant que client',
    'becomeTransporter': 'Devenir transporteur',
    'sendPackagesEasily': 'Envoyez vos colis facilement',
    'earnByDelivering': 'Gagnez de l\'argent en livrant',
    'welcomeBack': 'Bon retour',
    'loginToAccount': 'Connectez-vous à votre compte',
    'createAccount': 'Créer un compte',
    'signUpAsClient': 'Inscrivez-vous en tant que client',
    'signUpAsTransporter': 'Inscrivez-vous en tant que transporteur',
    'continue': 'Continuer',
    'connecting': 'Connexion...',
    'registering': 'Inscription...',
    'orContinueWith': 'Ou continuer avec',
    'signInWithGoogle': 'Se connecter avec Google',
    
    // Forgot/Reset Password
    'enterEmailForReset': 'Entrez votre email pour recevoir un code de réinitialisation',
    'emailSent': 'Email envoyé !',
    'checkEmailForCode': 'Vérifiez votre email pour le code de réinitialisation',
    'sendResetCode': 'Envoyer le code',
    'resetCode': 'Code de réinitialisation',
    'enterSixDigitCode': 'Entrez le code à 6 chiffres de votre email',
    'resetPassword': 'Réinitialiser le mot de passe',
    'enterCodeAndNewPassword': 'Entrez votre code et nouveau mot de passe',
    'passwordResetSuccess': 'Mot de passe réinitialisé !',
    'redirectingToLogin': 'Redirection vers la connexion...',
    'didntReceiveCode': 'Vous n\'avez pas reçu le code ? Renvoyer',
    'backToLogin': 'Retour à la connexion',
    'sending': 'Envoi...',
    'resetting': 'Réinitialisation...',
    'invalidResetCode': 'Code invalide ou expiré',
    'passwordTooShort': 'Le mot de passe doit contenir au moins 6 caractères',
    'newPassword': 'Nouveau mot de passe',
    
    // Errors
    'incorrectCredentials': 'Email ou mot de passe incorrect',
    'emailAlreadyExists': 'Cet email est déjà utilisé',
    'passwordsDontMatch': 'Les mots de passe ne correspondent pas',
    'fillAllFields': 'Veuillez remplir tous les champs',
    'invalidEmail': 'Email invalide',
    'connectionError': 'Erreur de connexion au serveur',
    
    // Landing
    'tagline': 'Livraison de colis Tunisie-Europe',
    'fast': 'Rapide',
    'affordable': 'Abordable',
    'trusted': 'Fiable',
    
    // Common
    'loading': 'Chargement...',
    'error': 'Erreur',
    'success': 'Succès',
    'cancel': 'Annuler',
    'save': 'Enregistrer',
    'delete': 'Supprimer',
    'edit': 'Modifier',
    'ok': 'OK',
    'yes': 'Oui',
    'no': 'Non',
    'field_required': 'Ce champ est requis',
    'save_changes': 'Enregistrer les modifications',
    'confirm_logout': 'Confirmer la déconnexion',
    'logout_message': 'Êtes-vous sûr de vouloir vous déconnecter?',
    'profile_updated': 'Profil mis à jour avec succès',
    'appearance': 'Apparence',
    'dark_mode': 'Mode sombre',
    'dark_mode_desc': 'Activer le thème sombre',
    'language': 'Langue',
    'notifications': 'Notifications',
    'email_notifications': 'Notifications par email',
    'email_notifications_desc': 'Recevoir des emails pour les mises à jour',
    'push_notifications': 'Notifications push',
    'push_notifications_desc': 'Recevoir des notifications push',
    'about': 'À propos',
    'app_version': 'Version de l\'application',
    'terms_conditions': 'Conditions générales',
    'privacy_policy': 'Politique de confidentialité',
    'no_messages': 'Aucun message',
    'messages_coming_soon': 'La messagerie arrive bientôt',
    'search_trips': 'Rechercher des trajets',
    'from': 'De',
    'to': 'Vers',
    'search_trips_prompt': 'Recherchez un trajet pour commencer',
    'no_trips_found': 'Aucun trajet trouvé',
    'available_space': 'Espace disponible',
    'trip_details': 'Détails du trajet',
    'departure_date': 'Date de départ',
    'price_per_kg': 'Prix par kg',
    'total_space': 'Espace total',
    'status': 'Statut',
    'scheduled': 'Programmé',
    'in_progress': 'En cours',
    'completed': 'Terminé',
    'cancelled': 'Annulé',
    'unknown': 'Inconnu',
    'book_this_trip': 'Réserver ce trajet',
    'weight_kg': 'Poids (kg)',
    'package_description': 'Description du colis',
    'total_price': 'Prix total',
    'confirm_booking': 'Confirmer la réservation',
    'weight_required': 'Le poids est requis',
    'invalid_weight': 'Poids invalide',
    'booking_success': 'Réservation réussie!',
    'retry': 'Réessayer',
    'my_bookings': 'Mes réservations',
    'no_bookings': 'Aucune réservation',
    'book_trip_to_start': 'Réservez un trajet pour commencer',
    'booking': 'Réservation',
    'pending': 'En attente',
    'confirmed': 'Confirmé',
    'weight': 'Poids',
    'total': 'Total',
    'booked_on': 'Réservé le',
    'dashboard': 'Tableau de bord',
    'welcome': 'Bienvenue',
    'transporter_dashboard_subtitle': 'Gérez vos trajets et réservations',
    'total_trips': 'Trajets totaux',
    'rating': 'Note',
    'my_trips': 'Mes trajets',
    'no_trips_yet': 'Aucun trajet pour le moment',
    'create_first_trip': 'Créez votre premier trajet',
    'new_trip': 'Nouveau trajet',
    'create_trip': 'Créer un trajet',
    'new_trip_info': 'Informations du nouveau trajet',
    'fill_trip_details': 'Remplissez les détails de votre trajet',
    'departure_city': 'Ville de départ',
    'arrival_city': 'Ville d\'arrivée',
    'select_date_time': 'Sélectionner date et heure',
    'total_space_kg': 'Espace total (kg)',
    'invalid_number': 'Nombre invalide',
    'select_date': 'Sélectionner une date',
    'trip_created': 'Trajet créé avec succès!',
    'trip_creation_info': 'Les clients pourront voir votre trajet et faire des réservations. Vous serez notifié de toute nouvelle réservation.',
    'wassali': 'Wassali',
    'hello': 'Bonjour',
    'client_welcome_message': 'Trouvez le meilleur trajet pour vos colis',
    'quick_actions': 'Actions rapides',
    'find_best_route': 'Trouvez le meilleur itinéraire',
    'view_your_bookings': 'Voir vos réservations',
    'why_wassali': 'Pourquoi Wassali?',
    'fast_delivery': 'Livraison rapide',
    'best_prices': 'Meilleurs prix',
    'verified_transporters': 'Transporteurs vérifiés',
    'support': 'Support',
    'customer_support': 'Support client 24/7',
    'address': 'Adresse',
  },
  
  'en': {
    // Navigation
    'home': 'Home',
    'search': 'Search',
    'trips': 'Trips',
    'bookings': 'Bookings',
    'messages': 'Messages',
    'profile': 'Profile',
    'settings': 'Settings',
    
    // Auth
    'login': 'Login',
    'register': 'Register',
    'logout': 'Logout',
    'email': 'Email',
    'password': 'Password',
    'confirmPassword': 'Confirm Password',
    'name': 'Full Name',
    'phone': 'Phone',
    'forgotPassword': 'Forgot Password?',
    'dontHaveAccount': 'Don\'t have an account?',
    'alreadyHaveAccount': 'Already have an account?',
    'signUp': 'Sign Up',
    'client': 'Client',
    'transporter': 'Transporter',
    'continueAsClient': 'Continue as Client',
    'becomeTransporter': 'Become a Transporter',
    'sendPackagesEasily': 'Send packages easily',
    'earnByDelivering': 'Earn by delivering',
    'welcomeBack': 'Welcome Back',
    'loginToAccount': 'Login to your account',
    'createAccount': 'Create Account',
    'signUpAsClient': 'Sign up as a client',
    'signUpAsTransporter': 'Sign up as a transporter',
    'continue': 'Continue',
    'connecting': 'Connecting...',
    'registering': 'Registering...',
    'orContinueWith': 'Or continue with',
    'signInWithGoogle': 'Sign in with Google',
    
    // Forgot/Reset Password
    'enterEmailForReset': 'Enter your email to receive a reset code',
    'emailSent': 'Email Sent!',
    'checkEmailForCode': 'Check your email for the reset code',
    'sendResetCode': 'Send Reset Code',
    'resetCode': 'Reset Code',
    'enterSixDigitCode': 'Enter the 6-digit code from your email',
    'resetPassword': 'Reset Password',
    'enterCodeAndNewPassword': 'Enter your code and new password',
    'passwordResetSuccess': 'Password Reset Successfully!',
    'redirectingToLogin': 'Redirecting to login...',
    'didntReceiveCode': 'Didn\'t receive the code? Resend',
    'backToLogin': 'Back to Login',
    'sending': 'Sending...',
    'resetting': 'Resetting...',
    'invalidResetCode': 'Invalid or expired reset code',
    'passwordTooShort': 'Password must be at least 6 characters',
    'newPassword': 'New Password',
    
    // Errors
    'incorrectCredentials': 'Incorrect email or password',
    'emailAlreadyExists': 'This email is already in use',
    'passwordsDontMatch': 'Passwords do not match',
    'fillAllFields': 'Please fill all fields',
    'invalidEmail': 'Invalid email',
    'connectionError': 'Server connection error',
    
    // Landing
    'tagline': 'Parcel delivery Tunisia-Europe',
    'fast': 'Fast',
    'affordable': 'Affordable',
    'trusted': 'Trusted',
    
    // Common
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'cancel': 'Cancel',
    'save': 'Save',
    'delete': 'Delete',
    'edit': 'Edit',
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
  },
  
  'ar': {
    // Navigation
    'home': 'الرئيسية',
    'search': 'بحث',
    'trips': 'الرحلات',
    'bookings': 'الحجوزات',
    'messages': 'الرسائل',
    'profile': 'الملف الشخصي',
    'settings': 'الإعدادات',
    
    // Auth
    'login': 'تسجيل الدخول',
    'register': 'إنشاء حساب',
    'logout': 'تسجيل الخروج',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'confirmPassword': 'تأكيد كلمة المرور',
    'name': 'الاسم الكامل',
    'phone': 'الهاتف',
    'forgotPassword': 'هل نسيت كلمة المرور؟',
    'dontHaveAccount': 'ليس لديك حساب؟',
    'alreadyHaveAccount': 'هل لديك حساب بالفعل؟',
    'signUp': 'إنشاء حساب',
    'client': 'عميل',
    'transporter': 'ناقل',
    'continueAsClient': 'متابعة كعميل',
    'becomeTransporter': 'كن ناقلاً',
    'sendPackagesEasily': 'أرسل الطرود بسهولة',
    'earnByDelivering': 'اربح من خلال التوصيل',
    'welcomeBack': 'مرحباً بعودتك',
    'loginToAccount': 'سجل الدخول إلى حسابك',
    'createAccount': 'إنشاء حساب',
    'signUpAsClient': 'سجل كعميل',
    'signUpAsTransporter': 'سجل كناقل',
    'continue': 'متابعة',
    'connecting': 'جارٍ الاتصال...',
    'registering': 'جارٍ التسجيل...',
    'orContinueWith': 'أو تابع مع',
    'signInWithGoogle': 'تسجيل الدخول بجوجل',
    
    // Forgot/Reset Password
    'enterEmailForReset': 'أدخل بريدك الإلكتروني لتلقي رمز إعادة التعيين',
    'emailSent': 'تم إرسال البريد الإلكتروني!',
    'checkEmailForCode': 'تحقق من بريدك الإلكتروني للحصول على رمز إعادة التعيين',
    'sendResetCode': 'إرسال رمز إعادة التعيين',
    'resetCode': 'رمز إعادة التعيين',
    'enterSixDigitCode': 'أدخل الرمز المكون من 6 أرقام من بريدك الإلكتروني',
    'resetPassword': 'إعادة تعيين كلمة المرور',
    'enterCodeAndNewPassword': 'أدخل الرمز وكلمة المرور الجديدة',
    'passwordResetSuccess': 'تم إعادة تعيين كلمة المرور بنجاح!',
    'redirectingToLogin': 'إعادة التوجيه إلى تسجيل الدخول...',
    'didntReceiveCode': 'لم تستلم الرمز؟ إعادة الإرسال',
    'backToLogin': 'العودة إلى تسجيل الدخول',
    'sending': 'جاري الإرسال...',
    'resetting': 'جاري إعادة التعيين...',
    'invalidResetCode': 'رمز غير صالح أو منتهي الصلاحية',
    'passwordTooShort': 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل',
    'newPassword': 'كلمة المرور الجديدة',
    
    // Errors
    'incorrectCredentials': 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
    'emailAlreadyExists': 'هذا البريد الإلكتروني مستخدم بالفعل',
    'passwordsDontMatch': 'كلمات المرور غير متطابقة',
    'fillAllFields': 'يرجى ملء جميع الحقول',
    'invalidEmail': 'بريد إلكتروني غير صالح',
    'connectionError': 'خطأ في الاتصال بالخادم',
    
    // Landing
    'tagline': 'توصيل الطرود تونس-أوروبا',
    'fast': 'سريع',
    'affordable': 'بأسعار معقولة',
    'trusted': 'موثوق',
    
    // Common
    'loading': 'جارٍ التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'delete': 'حذف',
    'edit': 'تعديل',
    'ok': 'موافق',
    'yes': 'نعم',
    'no': 'لا',
  },
};
