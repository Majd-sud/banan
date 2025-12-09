import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/bottom_navbar.dart';

class OperationsScreen extends StatelessWidget {
  static const String routeName = "/operations";

  const OperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // طباعة بيانات المستخدم عند دخول الصفحة
    if (user != null) {
      print("🟢 [DEBUG] User data on OperationsScreen: ${user.toJson()}");
    } else {
      print("⚠️ [DEBUG] No user data available.");
    }

    final primaryColor = Color(0xFF1B8354); // اللون الأخضر الأساسي

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'عمليات التحقق بالبصمة',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // أيقونة العمليات (بصمة أو دائرة تحميل)
                GestureDetector(
                  onTap: () {
                    print(
                      "🔘 [DEBUG] User tapped on fingerprint process icon.",
                    );
                  },
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: primaryColor, // لون أخضر
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // النص أسفل الأيقونة
                GestureDetector(
                  onTap: () {
                    print("📝 [DEBUG] User tapped on verification message.");
                  },
                  child: const Text(
                    'لديك عملية تبصيم او عملية تسجيل دخول الى منصة ابشر ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomCustomNavBar(),
      ),
    );
  }
}
