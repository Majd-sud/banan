import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';

// Providers
import 'providers/user_provider.dart';

// Existing screens
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/issue_screen.dart';
import 'screens/card_screen.dart';
import 'screens/card_verification_screen.dart';

// New backend / fingerprint flow screens
import 'screens/digital_fingerprint_screen.dart';
import 'screens/operations_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/creating_digital_fingerprint.dart';

// Authentication flow screens
import 'auth_flow/processing_page.dart';
import 'auth_flow/fingerprint_prompt.dart';
import 'auth_flow/no_fingerprint.dart';
import 'auth_flow/banan_success.dart';
import 'auth_flow/auth_success.dart';

// Simple global state (still used by OtpScreen)
class AppState {
  static String? nationalId;
}

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: const BananApp(),
    ),
  );
}

class BananApp extends StatelessWidget {
  const BananApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banān',
      debugShowCheckedModeBanner: false,
      theme: buildBananTheme(),

      // Start at login
      initialRoute: LoginScreen.routeName,

      routes: {
        // =======================
        // Core app screens
        // =======================
        LoginScreen.routeName: (_) => const LoginScreen(),
        OtpScreen.routeName: (_) => const OtpScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        IssueScreen.routeName: (_) => const IssueScreen(),
        CardScreen.routeName: (_) => const CardScreen(),
        CardVerificationScreen.routeName: (_) => const CardVerificationScreen(),

        // New backend / fingerprint screens
        DigitalFingerprintScreen.routeName: (_) =>
            const DigitalFingerprintScreen(),
        CreatingDigitalFingerprintScreen.routeName: (_) =>
            const CreatingDigitalFingerprintScreen(),
        OperationsScreen.routeName: (_) => const OperationsScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),

        // =======================
        // New Authentication Flow
        // =======================

        // أول صفحة (generic processing)
        "/processing": (_) => const ProcessingPage(
          message: "جاري تنفيذ العملية...",
          nextPage: "/processing-login",
        ),

        // معالجة تسجيل الدخول
        "/processing-login": (_) => const ProcessingPage(
          message: "عملية تسجيل دخول الى منصة أبشر",
          nextPage:
              CardVerificationScreen.routeName, // بعد ثانيتين نروح للبطاقة
        ),

        // أول صفحة لما نضغط تبويب العمليات في الـ bottom nav
        "/processing-payment": (_) => const ProcessingPage(
          message: "في انتظار عمليات التحقق بالبصمة الرقمية",
          nextPage: "/processing-login",
        ),

        "/fingerprint-prompt": (_) => const FingerprintPromptPage(),
        "/no-fingerprint": (_) => const NoFingerprintPage(),
        "/nafath-success": (_) => const NafathSuccessPage(),
        "/auth-success": (_) => const AuthSuccessPage(),
      },
    );
  }
}
