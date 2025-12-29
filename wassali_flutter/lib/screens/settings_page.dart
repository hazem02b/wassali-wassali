import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('settings')),
      ),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(lang.t('appearance')),
          SwitchListTile(
            title: Text(lang.t('dark_mode')),
            subtitle: Text(lang.t('dark_mode_desc')),
            value: theme.isDarkMode,
            onChanged: (value) => theme.toggleDarkMode(),
            secondary: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
          ),
          const Divider(),

          // Language Section
          _buildSectionHeader(lang.t('language')),
          _buildLanguageTile(context, 'FR', 'Français', '🇫🇷'),
          _buildLanguageTile(context, 'EN', 'English', '🇬🇧'),
          _buildLanguageTile(context, 'AR', 'العربية', '🇹🇳'),
          const Divider(),

          // Notifications Section
          _buildSectionHeader(lang.t('notifications')),
          SwitchListTile(
            title: Text(lang.t('email_notifications')),
            subtitle: Text(lang.t('email_notifications_desc')),
            value: true,
            onChanged: (value) {
              // TODO: Implement notification settings
            },
            secondary: const Icon(Icons.email_outlined),
          ),
          SwitchListTile(
            title: Text(lang.t('push_notifications')),
            subtitle: Text(lang.t('push_notifications_desc')),
            value: true,
            onChanged: (value) {
              // TODO: Implement notification settings
            },
            secondary: const Icon(Icons.notifications_outlined),
          ),
          const Divider(),

          // About Section
          _buildSectionHeader(lang.t('about')),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(lang.t('app_version')),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(lang.t('terms_conditions')),
            onTap: () {
              // TODO: Show terms and conditions
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(lang.t('privacy_policy')),
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, String code, String name, String flag) {
    final lang = Provider.of<LanguageProvider>(context);
    final isSelected = lang.locale.languageCode.toUpperCase() == code;

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF0066FF))
          : null,
      onTap: () => lang.changeLanguage(code.toLowerCase()),
    );
  }
}
