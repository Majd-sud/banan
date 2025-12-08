import 'package:flutter/material.dart';
import '../auth_flow/processing_page.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 2) {
          // 👈 تبويب "السجل / العمليات"
          Navigator.pushNamed(context, '/processing-payment');
        }

        if (index == 1) {
          Navigator.pushReplacementNamed(context, '/home');
        }

        if (index == 0) {
          // صفحة الإعدادات لاحقاً
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "الإعدادات"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: "العمليات",
        ),
      ],
    );
  }
}
