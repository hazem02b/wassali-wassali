import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

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
        title: const Text('Help & Support', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            _buildFAQItem(
              'How do I book a transport?',
              'Search for available trips, select one that fits your needs, fill in the booking form with package details and addresses, then proceed to payment.',
            ),
            _buildFAQItem(
              'How does payment work?',
              'You only pay AFTER the transporter accepts your booking. Your money is held securely until delivery is confirmed.',
            ),
            _buildFAQItem(
              'Can I cancel my booking?',
              'Yes, you can cancel before the transporter accepts. After acceptance, contact support for assistance.',
            ),
            _buildFAQItem(
              'How do I track my package?',
              'Go to "My Bookings" to see the status of all your packages. You\'ll receive notifications for status updates.',
            ),
            _buildFAQItem(
              'What items can I transport?',
              'Check the trip details for accepted items. Generally, documents, clothing, electronics, food, and personal items are allowed.',
            ),

            const SizedBox(height: 32),
            const Text('Contact Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email, color: Color(0xFF0066FF)),
                    title: const Text('Email Support'),
                    subtitle: const Text('support@wassali.com'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF10B981)),
                    title: const Text('Call Us'),
                    subtitle: const Text('+212 XXX XXX XXX'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.chat, color: Color(0xFFFF9500)),
                    title: const Text('Live Chat'),
                    subtitle: const Text('Available 9 AM - 6 PM'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(color: Color(0xFF6B7280), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
