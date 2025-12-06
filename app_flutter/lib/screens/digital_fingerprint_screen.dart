import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/bottom_navbar.dart';
import 'creating_digital_fingerprint.dart';

class DigitalFingerprintScreen extends StatelessWidget {
  static const String routeName = "/digital_fingerprint";

  const DigitalFingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الوصول للمستخدم الحالي عبر Provider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    const primaryColor = Color(0xFF1B8354);

    // طباعة بيانات المستخدم والصفحة بالإنجليزي للـ debug
    if (user != null) {
      print("🟢 [DEBUG] Digital Fingerprint Page");
      print("🟢 [DEBUG] Current User Data: ${user.toJson()}");
    } else {
      print("⚠️ [DEBUG] Digital Fingerprint Page: No user data available");
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'بصمتك الرقمية',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: () {
                // السماح بالانتقال فقط إذا probabilityAllow == 1
                if (user != null && user.probabilityAllow == 1) {
                  Navigator.pushNamed(
                    context,
                    CreatingDigitalFingerprintScreen.routeName,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "لا يمكنك طلب البصمة الرقمية، حالتك المدنية منافية للشروط.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(Icons.add_card, size: 60, color: primaryColor),
                  ),
                  const SizedBox(height: 16),
                  // الترحيب بالمستخدم
                  if (user != null)
                    Text(
                      'مرحبًا، ${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 8),
                  // رسالة حالة البصمة الرقمية بناءً على probabilityAllow
                  if (user != null)
                    Text(
                      user.probabilityAllow == 1
                          ? 'يمكنك اصدار بصمتك الرقمية'
                          : 'لا يمكنك إصدار بصمتك الرقمية، حالتك المدنية منافية لشروط إصدار البصمة الرقمية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: user.probabilityAllow == 1
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 12),
                  // النص الثابت
                  // const Text(
                  //   'اصدر بصمتك الرقمية',
                  //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomCustomNavBar(),
      ),
    );
  }
}
