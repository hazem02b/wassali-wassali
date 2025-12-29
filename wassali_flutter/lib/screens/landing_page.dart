import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import 'login_page.dart';
import 'signup_client_page.dart';
import 'signup_transporter_page.dart';

/// Page d'accueil - Landing Page (copie exacte de la version web)
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final t = languageProvider.t;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0066FF), // Bleu primaire
              Color(0xFF0052CC), // Bleu plus foncé
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Sélecteur de langue en haut à droite
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _LanguageSelector(),
                  ],
                ),
                
                const SizedBox(height: 60),
                
                // Logo et tagline
                Column(
                  children: [
                    // Logo Wassali (cercle blanc avec texte)
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'W',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0066FF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      t('tagline'),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Boutons de sélection de type d'utilisateur
                Column(
                  children: [
                    // Bouton Client
                    _UserTypeCard(
                      title: t('continueAsClient'),
                      subtitle: t('sendPackagesEasily'),
                      icon: Icons.local_shipping_outlined,
                      color: Colors.white,
                      textColor: const Color(0xFF0066FF),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignupClientPage()),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bouton Transporteur
                    _UserTypeCard(
                      title: t('becomeTransporter'),
                      subtitle: t('earnByDelivering'),
                      icon: Icons.directions_car_outlined,
                      color: const Color(0xFFFF9500),
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignupTransporterPage()),
                        );
                      },
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Features (badges)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _FeatureBadge(
                      icon: Icons.bolt,
                      label: t('fast'),
                    ),
                    _FeatureBadge(
                      icon: Icons.attach_money,
                      label: t('affordable'),
                    ),
                    _FeatureBadge(
                      icon: Icons.shield_outlined,
                      label: t('trusted'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Lien vers connexion
                Column(
                  children: [
                    Text(
                      t('alreadyHaveAccount'),
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        );
                      },
                      child: Text(
                        t('login'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget pour les cartes de sélection d'utilisateur
class _UserTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _UserTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: textColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget pour les badges de fonctionnalités
class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sélecteur de langue
class _LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return PopupMenuButton<String>(
      initialValue: languageProvider.currentLanguage,
      onSelected: (value) {
        languageProvider.changeLanguage(value);
      },
      icon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languageProvider.currentLanguage.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'fr',
          child: Row(
            children: [
              Text('🇫🇷', style: TextStyle(fontSize: 20)),
              SizedBox(width: 12),
              Text('Français'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              Text('🇬🇧', style: TextStyle(fontSize: 20)),
              SizedBox(width: 12),
              Text('English'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'ar',
          child: Row(
            children: [
              Text('🇹🇳', style: TextStyle(fontSize: 20)),
              SizedBox(width: 12),
              Text('العربية'),
            ],
          ),
        ),
      ],
    );
  }
}
