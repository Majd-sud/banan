import 'package:flutter/material.dart';
import 'bottom_nav.dart';

class NoFingerprintPage extends StatelessWidget {
  const NoFingerprintPage({super.key});

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
            CircularProgressIndicator(color: Colors.green),
            SizedBox(height: 20),
            Text("لا توجد عملية بصم", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
