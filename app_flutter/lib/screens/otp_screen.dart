import 'package:flutter/material.dart';
import '../main.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp';

  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  String? _error;

  void _verify() {
    // For demo: accept "1234" only
    if (_otpController.text.trim() == '1234') {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(HomeScreen.routeName, (r) => false);
    } else {
      setState(() => _error = 'Wrong code. Use 1234 for demo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = AppState.nationalId ?? 'your ID';

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Code')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('We sent a code to the phone linked to:\n$id'),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Code',
                hintText: '1234',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            ElevatedButton(onPressed: _verify, child: const Text('Verify')),
          ],
        ),
      ),
    );
  }
}
