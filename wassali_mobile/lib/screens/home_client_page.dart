import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'my_bookings_page.dart';
import 'search_results_page.dart';

/// HomeClientPage - COPIE EXACTE de HomeClient.tsx
class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  final _apiService = ApiService();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  
  String? _userName;
  List<Map<String, String>> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _apiService.getCurrentUserLocal();
      setState(() {
        _userName = user['name'];
      });
    } catch (e) {
      // Ignorer l'erreur, l'utilisateur verra "Guest"
    }
  }

  void _handleSearch() {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      return;
    }

    // Ajouter aux recherches récentes
    setState(() {
      _recentSearches.insert(0, {
        'from': _fromController.text,
        'to': _toController.text,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      });
      if (_recentSearches.length > 5) {
        _recentSearches = _recentSearches.sublist(0, 5);
      }
    });

    // Navigation vers résultats de recherche
    context.push(
      '/search',
      extra: {
        'from': _fromController.text,
        'to': _toController.text,
        'date': '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Header avec gradient bleu - EXACTEMENT comme le web
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header avec nom et avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour, ${_userName ?? 'Guest'}!',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Où souhaitez-vous envoyer votre colis ?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFBFDBFE),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push('/profile');
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _userName?.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0066FF),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Formulaire de recherche
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        children: [
                          // Champ "De"
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _fromController,
                              decoration: const InputDecoration(
                                hintText: 'De',
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Champ "À"
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _toController,
                              decoration: const InputDecoration(
                                hintText: 'À',
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: Color(0xFF9CA3AF),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Boutons de filtre - EXACTEMENT comme le web
                          Row(
                            children: [
                              _buildFilterButton(Icons.calendar_today, 'Date'),
                              const SizedBox(width: 8),
                              _buildFilterButton(Icons.scale, 'Poids'),
                              const SizedBox(width: 8),
                              _buildFilterButton(Icons.euro, 'Prix'),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Bouton de recherche blanc - EXACTEMENT comme le web
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0066FF),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Rechercher des transporteurs',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Recherches récentes
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recherches récentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_recentSearches.isEmpty)
                    const Text(
                      'Aucune recherche récente',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    )
                  else
                    ...(_recentSearches.map((search) => _buildRecentSearchCard(search))),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation - Placeholder
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0066FF),
        unselectedItemColor: const Color(0xFF9CA3AF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Déjà sur Home, ne rien faire
              break;
            case 1:
              context.push('/my-bookings');
              break;
            case 2:
              context.push('/messages');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildFilterButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 4),
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

  Widget _buildRecentSearchCard(Map<String, String> search) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _fromController.text = search['from']!;
              _toController.text = search['to']!;
            });
            // Scroll to top
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFF3F4F6)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Recherche récente',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
