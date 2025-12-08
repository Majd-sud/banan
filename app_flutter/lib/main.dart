import 'package:flutter/material.dart';
import 'theme.dart';

// Existing screens
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/home_screen.dart';
import 'screens/issue_screen.dart';
import 'screens/card_screen.dart';

// NEW authentication flow screens
import 'auth_flow/processing_page.dart';
import 'auth_flow/fingerprint_prompt.dart';
import 'auth_flow/no_fingerprint.dart';
import 'auth_flow/banan_success.dart';
import 'auth_flow/auth_success.dart';
import 'screens/card_verification_screen.dart';

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

      // Your app still starts at Login
      initialRoute: LoginScreen.routeName,

      routes: {
        // =======================
        // Existing app screens
        // =======================
        LoginScreen.routeName: (_) => const LoginScreen(),
        OtpScreen.routeName: (_) => const OtpScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        IssueScreen.routeName: (_) => const IssueScreen(),
        CardScreen.routeName: (_) => const CardScreen(),
        CardVerificationScreen.routeName:
            (_) => const CardVerificationScreen(), // 👈 NEWr
        // =======================
        // New Authentication Flow
        // =======================

        // لو ما تحتاجينه من زر ثاني تقدرين تحذفينه
        "/processing":
            (_) => const ProcessingPage(
              message: "جاري تنفيذ العملية...",
              nextPage: "/processing-login",
            ),

        // ⬅️ هذي الصفحة الثانية من الفلو (بعد الدفع)
        "/processing-login":
            (_) => const ProcessingPage(
              message: "عملية تسجيل دخول الى منصة ابشر",
              nextPage:
                  CardVerificationScreen.routeName, // بعد ثانيتين نروح للبطاقة
            ),

        // ⬅️ هذي أول صفحة لما نضغط تبويب العمليات في الـ bottom nav
        "/processing-payment":
            (_) => const ProcessingPage(
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
