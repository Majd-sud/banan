import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class AuthSuccessPage extends StatelessWidget {
  const AuthSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("الصفحة الرئيسية"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fingerprint, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text("تم التحقق بنجاح", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
