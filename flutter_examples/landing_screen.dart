// landing_screen.dart - Écran d'accueil
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Sélecteur de langue
                Align(
                  alignment: Alignment.topRight,
                  child: _buildLanguageSelector(),
                ),
                
                SizedBox(height: 60),
                
                // Logo et tagline
                _buildLogo(),
                
                Spacer(),
                
                // Boutons d'action
                _buildActionButtons(context),
                
                SizedBox(height: 32),
                
                // Caractéristiques
                _buildFeatures(),
                
                SizedBox(height: 32),
                
                // Lien de connexion
                _buildLoginLink(context),
                
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
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
          decoration: BoxDecoration(
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
          child: Icon(
            Icons.local_shipping,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Wassali',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
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
          title: 'Continue as Client',
          subtitle: 'Send packages easily',
          color: Colors.white,
          textColor: AppColors.primary,
          onTap: () {
            Navigator.pushNamed(context, '/signup-client');
          },
        ),
        
        SizedBox(height: 16),
        
        // Bouton Transporteur
        _buildButton(
          icon: Icons.local_shipping,
          title: 'Become Transporter',
          subtitle: 'Earn by delivering',
          color: AppColors.secondary,
          textColor: Colors.white,
          onTap: () {
            Navigator.pushNamed(context, '/signup-transporter');
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
          padding: EdgeInsets.all(20),
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
              SizedBox(width: 16),
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
                    SizedBox(height: 4),
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
        _buildFeature(Icons.flash_on, 'Fast'),
        _buildFeature(Icons.attach_money, 'Affordable'),
        _buildFeature(Icons.shield, 'Trusted'),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
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
          'Already have an account?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 8),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text(
            'Login',
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
