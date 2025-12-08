import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class FingerprintPromptPage extends StatelessWidget {
  const FingerprintPromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppBottomNav(),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("الصفحة الرئيسية"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "اضغط زر تأكيد البصمة (بوابة النفاذ الوطني)",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/nafath-success");
              },
              child: const Text("تأكيد"),
            ),
          ],
        ),
      ),
    );
  }
}
