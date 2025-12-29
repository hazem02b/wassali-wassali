import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  final _apiService = ApiService();
  String _searchQuery = '';
  List<Map<String, dynamic>> _conversations = [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    try {
      setState(() {
        _loading = true;
        _error = '';
      });

      print('📱 Chargement des conversations...');
      final conversations = await _apiService.getConversations();
      print('✅ Conversations chargées: ${conversations.length}');
      
      setState(() {
        _conversations = conversations;
        _loading = false;
      });
    } catch (e) {
      print('❌ Erreur conversations: $e');
      setState(() {
        _error = 'Impossible de charger les conversations. Vérifiez que le serveur est actif.';
        _loading = false;
      });
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'À l\'instant';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}j';
      } else {
        return DateFormat('dd/MM').format(dateTime);
      }
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredConversations = _conversations.where((conv) {
      final name = conv['other_user_name']?.toString() ?? '';
      return name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Messages', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search conversations',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(_error),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadConversations,
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      )
                    : filteredConversations.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.message_outlined, size: 64, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                const Text(
                                  'Pas de messages',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Commencez une conversation avec un transporteur',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadConversations,
                            child: ListView.builder(
                              itemCount: filteredConversations.length,
                              itemBuilder: (context, index) {
                                final conv = filteredConversations[index];
                                final firstLetter = conv['other_user_name']?.toString().substring(0, 1).toUpperCase() ?? 'U';
                                
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB))),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      context.push(
                                        '/chat/${conv['conversation_id']}',
                                        extra: {
                                          'otherUserName': conv['other_user_name'],
                                          'otherUserId': conv['other_user_id'],
                                        },
                                      );
                                    },
                                    leading: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 24,
                                          backgroundColor: const Color(0xFF0066FF),
                                          child: Text(
                                            firstLetter,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (conv['is_online'] == true)
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10B981),
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    title: Text(
                                      conv['other_user_name'] ?? 'Unknown',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      conv['last_message'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(color: Color(0xFF6B7280)),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          _formatTimestamp(conv['last_message_time'] ?? ''),
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                                        ),
                                        if ((conv['unread_count'] ?? 0) > 0) ...[
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF0066FF),
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                            child: Text(
                                              conv['unread_count'].toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}