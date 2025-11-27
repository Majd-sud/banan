import 'package:flutter/material.dart';
import '../theme.dart';
import '../main.dart'; // for AppState
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    AppState.nationalId = _idController.text.trim();
    Navigator.of(context).pushNamed(OtpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Banān – Login')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.fingerprint, size: 72, color: bananGreen),
              const SizedBox(height: 24),
              const Text(
                'Enter your National ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'National ID',
                  hintText: '1XXXXXXXXX',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your ID';
                  }
                  if (value.trim().length != 10) {
                    return 'ID must be 10 digits (for demo).';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(onPressed: _submit, child: const Text('Continue')),
            ],
          ),
        ),
      ),
    );
  }
}
