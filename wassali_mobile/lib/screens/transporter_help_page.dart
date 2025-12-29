import 'package:flutter/material.dart';

class TransporterHelpPage extends StatefulWidget {
  const TransporterHelpPage({super.key});

  @override
  State<TransporterHelpPage> createState() => _TransporterHelpPageState();
}

class _TransporterHelpPageState extends State<TransporterHelpPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _expandedFaq;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Comment publier un trajet?',
      'answer': 'Allez sur "Créer", remplissez les détails du trajet (origine, destination, date, capacité, prix), sélectionnez les types de colis acceptés, et publiez. Votre trajet sera visible pour tous les clients.'
    },
    {
      'question': 'Quelle est la commission sur mes revenus?',
      'answer': 'Wassali prélève une commission de 10% sur chaque trajet complété. Vous recevez 90% du prix total payé par le client.'
    },
    {
      'question': 'Comment recevoir mes paiements?',
      'answer': 'Les paiements sont automatiquement transférés sur votre compte bancaire ou portefeuille mobile 48h après la livraison confirmée du colis.'
    },
    {
      'question': 'Puis-je annuler un trajet?',
      'answer': 'Oui, vous pouvez annuler un trajet depuis votre tableau de bord. Si des réservations existent, les clients seront notifiés et remboursés automatiquement.'
    },
    {
      'question': 'Comment fonctionne l\'assurance?',
      'answer': 'Vous pouvez proposer une option d\'assurance (5-10% du prix). En cas de dommage ou perte, l\'assurance couvre jusqu\'à 500€. Wassali gère toutes les réclamations.'
    },
    {
      'question': 'Quels documents sont nécessaires?',
      'answer': 'Vous devez fournir: carte d\'identité valide, permis de conduire, carte grise du véhicule, et justificatif de domicile. La vérification prend 24-48h.'
    },
    {
      'question': 'Comment augmenter mes réservations?',
      'answer': 'Maintenez un bon rating (>4.5), proposez des prix compétitifs, publiez régulièrement des trajets, activez l\'assurance, et répondez rapidement aux messages.'
    },
    {
      'question': 'Que faire si le client ne se présente pas?',
      'answer': 'Attendez 15 minutes au point de rendez-vous. Si le client ne vient pas, signalez dans l\'app. Vous recevrez 50% du paiement comme compensation.'
    },
  ];

  final List<Map<String, dynamic>> _contactMethods = [
    {
      'icon': Icons.phone,
      'title': 'Support téléphonique',
      'value': '+216 XX XXX XXX',
      'color': Color(0xFF10B981),
    },
    {
      'icon': Icons.email,
      'title': 'Support email',
      'value': 'transporter@wassali.tn',
      'color': Color(0xFF0066FF),
    },
    {
      'icon': Icons.message,
      'title': 'Chat en direct',
      'value': 'Disponible 24/7',
      'color': Color(0xFF9333EA),
    },
  ];

  final List<Map<String, dynamic>> _quickLinks = [
    {
      'icon': Icons.trending_up,
      'title': 'Augmenter mes revenus',
      'description': 'Conseils pour optimiser vos gains',
      'color': Color(0xFFFF9500),
    },
    {
      'icon': Icons.shield,
      'title': 'Consignes de sécurité',
      'description': 'Protégez-vous et vos clients',
      'color': Color(0xFF10B981),
    },
    {
      'icon': Icons.attach_money,
      'title': 'Informations paiement',
      'description': 'Comment gérer vos revenus',
      'color': Color(0xFF0066FF),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _faqs.where((faq) {
      final query = _searchQuery.toLowerCase();
      return faq['question']!.toLowerCase().contains(query) ||
             faq['answer']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: const Color(0xFFFF9500),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF9500), Color(0xFFE68600)],
                  ),
                ),
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aide & Support',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ressources pour transporteurs',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFEBD6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Rechercher dans l\'aide...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF9500), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Links
                const Text(
                  'Liens rapides',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ..._quickLinks.map((link) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: link['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(link['icon'], color: link['color']),
                    ),
                    title: Text(
                      link['title'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      link['description'],
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
                    onTap: () {},
                  ),
                )),

                const SizedBox(height: 24),

                // Contact Methods
                const Text(
                  'Nous contacter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ..._contactMethods.map((method) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: method['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(method['icon'], color: method['color']),
                    ),
                    title: Text(
                      method['title'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      method['value'],
                      style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
                    onTap: () {},
                  ),
                )),

                const SizedBox(height: 24),

                // FAQs
                const Text(
                  'Questions fréquentes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                if (filteredFaqs.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Aucun résultat trouvé',
                        style: TextStyle(color: Color(0xFF6B7280)),
                      ),
                    ),
                  )
                else
                  ...filteredFaqs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final faq = entry.value;
                    final isExpanded = _expandedFaq == index;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              faq['question']!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: const Color(0xFF9CA3AF),
                            ),
                            onTap: () {
                              setState(() {
                                _expandedFaq = isExpanded ? null : index;
                              });
                            },
                          ),
                          if (isExpanded)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              decoration: const BoxDecoration(
                                border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
                              ),
                              child: Text(
                                faq['answer']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
