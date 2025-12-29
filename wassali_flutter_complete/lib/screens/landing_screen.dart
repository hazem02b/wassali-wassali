import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Sélecteur de langue
                Align(
                  alignment: Alignment.topRight,
                  child: _buildLanguageSelector(context),
                ),
                
                const SizedBox(height: 60),
                
                // Logo et tagline
                _buildLogo(),
                
                const Spacer(),
                
                // Boutons d'action
                _buildActionButtons(context),
                
                const SizedBox(height: 32),
                
                // Caractéristiques
                _buildFeatures(),
                
                const SizedBox(height: 32),
                
                // Lien de connexion
                _buildLoginLink(context),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇫🇷', style: TextStyle(fontSize: 20)),
          SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(
            Icons.local_shipping,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Wassali',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ça arrive!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Bouton Client
        _buildButton(
          icon: Icons.package_2,
          title: 'Continuer en tant que Client',
          subtitle: 'Envoyez vos colis facilement',
          color: Colors.white,
          textColor: AppColors.primary,
          onTap: () {
            // Navigator.pushNamed(context, '/signup-client');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navigation vers inscription client'),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Bouton Transporteur
        _buildButton(
          icon: Icons.local_shipping,
          title: 'Devenir Transporteur',
          subtitle: 'Gagnez en transportant',
          color: AppColors.secondary,
          textColor: Colors.white,
          onTap: () {
            // Navigator.pushNamed(context, '/signup-transporter');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navigation vers inscription transporteur'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: textColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: textColor),
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

  Widget _buildFeatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFeature(Icons.flash_on, 'Rapide'),
        _buildFeature(Icons.attach_money, 'Abordable'),
        _buildFeature(Icons.shield, 'Sécurisé'),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Column(
      children: [
        Text(
          'Vous avez déjà un compte?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/login');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navigation vers connexion'),
              ),
            );
          },
          child: const Text(
            'Se connecter',
            style: TextStyle(
              color: Colors.white,
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
