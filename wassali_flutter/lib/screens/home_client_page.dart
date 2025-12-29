import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import 'search_results_page.dart';
import 'my_bookings_page.dart';
import 'messages_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

/// Page d'accueil client - Copie EXACTE de HomeClient.tsx
class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  int _selectedIndex = 0;
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  List<Map<String, String>> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    // TODO: Charger depuis le stockage local
    setState(() {
      _recentSearches = [
        {'from': 'Tunis', 'to': 'Paris'},
        {'from': 'Paris', 'to': 'Lyon'},
      ];
    });
  }

  void _handleSearch() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      return;
    }

    // Sauvegarder la recherche
    setState(() {
      _recentSearches.insert(0, {
        'from': _fromController.text,
        'to': _toController.text,
      });
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
    });

    // Navigation vers la page de recherche
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          from: _fromController.text,
          to: _toController.text,
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    final authProvider = Provider.of<AuthProvider>(context);
    final lang = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec gradient bleu
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête avec nom et avatar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${lang.t('hello')}, ${user?['name'] ?? 'Guest'}!',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lang.t('whereToSend'),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFBBDDFF),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _selectedIndex = 3); // Go to profile
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              child: Text(
                                (user?['name'] ?? 'G')[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0066FF),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Formulaire de recherche - exactement comme le web
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1F2937) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? const Color(0xFF374151) : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          children: [
                            // From input
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _fromController,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF111827),
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: lang.t('from'),
                                  hintStyle: TextStyle(
                                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // To input
                            Container(
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _toController,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF111827),
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: lang.t('to'),
                                  hintStyle: TextStyle(
                                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.location_on,
                                    color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Filter buttons row - 3 boutons comme le web
                      Row(
                        children: [
                          _FilterButton(
                            icon: Icons.calendar_today,
                            label: lang.t('date'),
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          _FilterButton(
                            icon: Icons.scale,
                            label: lang.t('weight'),
                            onTap: () {},
                          ),
                          const SizedBox(width: 8),
                          _FilterButton(
                            icon: Icons.attach_money,
                            label: lang.t('price'),
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Search button - BLANC avec texte BLEU comme le web
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleSearch,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0066FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            lang.t('searchTransporters'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recent searches section - EXACTEMENT comme le web avec icône location et "Aujourd'hui"
            if (_recentSearches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.t('recentSearches'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...(_recentSearches.map((search) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1F2937) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _fromController.text = search['from']!;
                                _toController.text = search['to']!;
                                _handleSearch();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE6F0FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF0066FF),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${search['from']} → ${search['to']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? Colors.white : const Color(0xFF111827),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                size: 12,
                                                color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                "Aujourd'hui",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))),
                  ],
                ),
              ),

            const SizedBox(height: 100), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final List<Widget> pages = [
      _buildHomePage(),
      const MyBookingsPage(),
      const MessagesPage(),
      const ProfilePage(),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavBarItem(
                  icon: Icons.home,
                  label: lang.t('home'),
                  isSelected: _selectedIndex == 0,
                  onTap: () => setState(() => _selectedIndex = 0),
                ),
                _NavBarItem(
                  icon: Icons.receipt_long,
                  label: lang.t('bookings'),
                  isSelected: _selectedIndex == 1,
                  onTap: () => setState(() => _selectedIndex = 1),
                ),
                _NavBarItem(
                  icon: Icons.message,
                  label: lang.t('messages'),
                  isSelected: _selectedIndex == 2,
                  onTap: () => setState(() => _selectedIndex = 2),
                ),
                _NavBarItem(
                  icon: Icons.person,
                  label: lang.t('profile'),
                  isSelected: _selectedIndex == 3,
                  onTap: () => setState(() => _selectedIndex = 3),
                ),
                _NavBarItem(
                  icon: Icons.settings,
                  label: lang.t('settings'),
                  isSelected: _selectedIndex == 4,
                  onTap: () => setState(() => _selectedIndex = 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF0066FF).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF0066FF)
                  : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? const Color(0xFF0066FF)
                    : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
