import 'package:flutter/material.dart';
import '../widgets/banan_card_widget.dart';
import '../main.dart';

class CardScreen extends StatefulWidget {
  static const routeName = '/card';

  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  bool _saved = false;

  void _saveToWallet() {
    setState(() => _saved = true);
    // In real app: integrate with Google Wallet / local storage.
  }

  @override
  Widget build(BuildContext context) {
    final id = AppState.nationalId ?? '1XXXXXXXXX';

    return Scaffold(
      appBar: AppBar(title: const Text('My Banan Card')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            BananCardWidget(
              nationalId: id,
              fullName: 'Demo User',
              fingerprintNumber: '12234456779',
              isSaved: _saved,
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _saved ? null : _saveToWallet,
              icon: const Icon(Icons.account_balance_wallet),
              label: Text(_saved ? 'Saved on device (demo)' : 'Save to Wallet'),
            ),
          ],
        ),
      ),
    );
  }
}
