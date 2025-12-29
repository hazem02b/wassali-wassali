import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    // Load preferences from storage
    // TODO: Load from shared preferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildToggleItem(
                    icon: Icons.notifications,
                    iconColor: const Color(0xFF0066FF),
                    title: 'Notifications',
                    subtitle: 'Receive push notifications',
                    value: _notifications,
                    onChanged: (value) => setState(() => _notifications = value),
                  ),
                  const Divider(height: 1),
                  _buildToggleItem(
                    icon: _darkMode ? Icons.dark_mode : Icons.light_mode,
                    iconColor: const Color(0xFF9333EA),
                    title: 'Dark Mode',
                    subtitle: 'Switch to dark theme',
                    value: _darkMode,
                    onChanged: (value) => setState(() => _darkMode = value),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD1FAE5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.language, color: Color(0xFF059669)),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Language', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text('Select language', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                            ],
                          ),
                        ),
                        DropdownButton<String>(
                          value: _language,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'fr', child: Text('Français')),
                            DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          ],
                          onChanged: (value) => setState(() => _language = value ?? 'en'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text('Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildNavigationItem(
                    icon: Icons.lock,
                    iconColor: const Color(0xFFFF9500),
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      // TODO: Navigate to change password
                    },
                  ),
                  const Divider(height: 1),
                  _buildNavigationItem(
                    icon: Icons.shield,
                    iconColor: const Color(0xFFDC2626),
                    title: 'Privacy Settings',
                    subtitle: 'Manage your privacy',
                    onTap: () {
                      // TODO: Navigate to privacy settings
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildNavigationItem(
                    icon: Icons.info,
                    iconColor: const Color(0xFF6B7280),
                    title: 'App Version',
                    subtitle: '1.0.0',
                    onTap: null,
                  ),
                  const Divider(height: 1),
                  _buildNavigationItem(
                    icon: Icons.description,
                    iconColor: const Color(0xFF6B7280),
                    title: 'Terms of Service',
                    subtitle: 'Read our terms',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildNavigationItem(
                    icon: Icons.privacy_tip,
                    iconColor: const Color(0xFF6B7280),
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy policy',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0066FF),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}
