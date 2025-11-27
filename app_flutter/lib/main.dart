import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/issue_screen.dart';
import 'screens/card_screen.dart';

// Simple global state (no backend)
class AppState {
  static String? nationalId;
}

void main() {
  runApp(const BananApp());
}

class BananApp extends StatelessWidget {
  const BananApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banān',
      debugShowCheckedModeBanner: false,
      theme: buildBananTheme(),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        OtpScreen.routeName: (_) => const OtpScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        IssueScreen.routeName: (_) => const IssueScreen(),
        CardScreen.routeName: (_) => const CardScreen(),
      },
    );
  }
}
