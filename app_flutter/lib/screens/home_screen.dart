import 'package:flutter/material.dart';
import 'issue_screen.dart';
import 'card_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banān Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(IssueScreen.routeName);
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text('Get Digital Fingerprint'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(CardScreen.routeName);
              },
              icon: const Icon(Icons.credit_card),
              label: const Text('View My Banan Card'),
            ),
          ],
        ),
      ),
    );
  }
}
