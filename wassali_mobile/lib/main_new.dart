import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const WassaliMobileApp());
}

class WassaliMobileApp extends StatelessWidget {
  const WassaliMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wassali',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0066FF)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const LoginPage(),
    );
  }
}
