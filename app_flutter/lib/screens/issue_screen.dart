import 'package:flutter/material.dart';
import '../main.dart';
import 'card_screen.dart';

class IssueScreen extends StatefulWidget {
  static const routeName = '/issue';

  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  bool _loading = false;

  Future<void> _issue() async {
    setState(() => _loading = true);
    // Fake processing delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(CardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final id = AppState.nationalId ?? '1XXXXXXXXX';

    return Scaffold(
      appBar: AppBar(title: const Text('BioPrint')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Icon(Icons.fingerprint, size: 80),
            const SizedBox(height: 16),
            Text(
              'Issue a digital fingerprint for ID:\n$id',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _loading ? null : _issue,
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Issue Digital Fingerprint'),
            ),
          ],
        ),
      ),
    );
  }
}
