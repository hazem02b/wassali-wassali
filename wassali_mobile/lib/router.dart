import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_client_page.dart';
import 'screens/signup_transporter_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/reset_password_page.dart';
import 'screens/home_client_page.dart';
import 'screens/my_bookings_page.dart';
import 'screens/search_results_page.dart';
import 'screens/booking_form_page.dart';
import 'screens/trip_details_page.dart';
import 'screens/client_profile_page.dart';
import 'screens/edit_profile_page.dart';
import 'screens/settings_page.dart';
import 'screens/change_password_page.dart';
import 'screens/payment_page.dart';
import 'screens/payment_methods_page.dart';
import 'screens/booking_confirmation_page.dart';
import 'screens/help_support_page.dart';
import 'screens/leave_review_page.dart';
import 'screens/my_reviews_page.dart';
import 'screens/transporter_dashboard_page.dart';
import 'screens/create_trip_page.dart';
import 'screens/my_trips_page.dart';
import 'screens/transporter_profile_page.dart';
import 'screens/my_transporter_profile_page.dart';
import 'screens/transporter_reviews_page.dart';
import 'screens/transporter_help_page.dart';
import 'screens/messages_page.dart';
import 'screens/chat_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Landing & Auth
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup-client',
      builder: (context, state) => const SignupClientPage(),
    ),
    GoRoute(
      path: '/signup-transporter',
      builder: (context, state) => const SignupTransporterPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) => const ResetPasswordPage(),
    ),

    // Client Pages
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeClientPage(),
    ),
    GoRoute(
      path: '/my-bookings',
      builder: (context, state) => const MyBookingsPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return SearchResultsPage(
          from: extra?['from'] ?? '',
          to: extra?['to'] ?? '',
          date: extra?['date'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/trip/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TripDetailsPage(tripId: id);
      },
    ),
    GoRoute(
      path: '/booking/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BookingFormPage(tripId: id);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ClientProfilePage(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfilePage(),
    ),

    // Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordPage(),
    ),

    // Payment
    GoRoute(
      path: '/payment/:bookingId',
      builder: (context, state) {
        final bookingId = int.parse(state.pathParameters['bookingId']!);
        final extra = state.extra as Map<String, dynamic>?;
        return PaymentPage(
          bookingId: bookingId,
          amount: extra?['amount'] ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: '/payment-methods',
      builder: (context, state) => const PaymentMethodsPage(),
    ),
    GoRoute(
      path: '/booking-confirmation/:bookingId',
      builder: (context, state) {
        final bookingId = int.parse(state.pathParameters['bookingId']!);
        return BookingConfirmationPage(bookingId: bookingId);
      },
    ),

    // Reviews
    GoRoute(
      path: '/leave-review/:bookingId',
      builder: (context, state) {
        final bookingId = int.parse(state.pathParameters['bookingId']!);
        final extra = state.extra as Map<String, dynamic>?;
        return LeaveReviewPage(
          bookingId: bookingId,
          transporterId: extra?['transporterId'] ?? 0,
          transporterName: extra?['transporterName'] ?? 'Transporter',
        );
      },
    ),
    GoRoute(
      path: '/my-reviews',
      builder: (context, state) => const MyReviewsPage(),
    ),

    // Transporter Pages
    GoRoute(
      path: '/transporter-dashboard',
      builder: (context, state) => const TransporterDashboardPage(),
    ),
    GoRoute(
      path: '/create-trip',
      builder: (context, state) => const CreateTripPage(),
    ),
    GoRoute(
      path: '/my-trips',
      builder: (context, state) => const MyTripsPage(),
    ),
    GoRoute(
      path: '/transporter-profile/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TransporterProfilePage(transporterId: id);
      },
    ),
    GoRoute(
      path: '/my-transporter-profile',
      builder: (context, state) => const MyTransporterProfilePage(),
    ),
    GoRoute(
      path: '/transporter-reviews/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return TransporterReviewsPage(transporterId: id);
      },
    ),

    // Messages
    GoRoute(
      path: '/messages',
      builder: (context, state) => const MessagesPage(),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final conversationId = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        return ChatPage(
          conversationId: conversationId,
          otherUserName: extra?['otherUserName'] ?? 'User',
          otherUserId: extra?['otherUserId'],
        );
      },
    ),

    // Help
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpSupportPage(),
    ),
    GoRoute(
      path: '/transporter-help',
      builder: (context, state) => const TransporterHelpPage(),
    ),
  ],
);
