import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';
import 'utils/colors.dart';
import 'screens/landing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Firebase
  // Note: Décommentez après avoir exécuté 'flutterfire configure'
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wassali',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingScreen(),
        // Ajoutez d'autres routes ici
      },
      
      // Builder pour les SnackBars globaux
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
