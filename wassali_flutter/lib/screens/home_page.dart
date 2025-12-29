import 'package:flutter/material.dart';

/// Page d'accueil placeholder (à développer)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wassali - Accueil'),
      ),
      body: const Center(
        child: Text('Page d\'accueil - À développer'),
      ),
    );
  }
}
