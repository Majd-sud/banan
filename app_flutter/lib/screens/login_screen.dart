// ...existing code...
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
  bool _loading = false;

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  Future<void> _mockNafathLogin() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    AppState.nationalId = '1A23456789';
    setState(() => _loading = false);
    if (context.mounted) Navigator.of(context).pushNamed(OtpScreen.routeName);
  }

  void _submitManual() {
    if (!_formKey.currentState!.validate()) return;
    AppState.nationalId = _idController.text.trim();
    Navigator.of(context).pushNamed(OtpScreen.routeName);
  }

  @override
  Widget build(BuildContext context) { 
    // updated asset name
    const assetLogo = '/assets/images/logo.png';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white, 
        appBar: AppBar(
          title: const Text('تسجيل الدخول'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      // use the provided transparent IAM_logo.png
                      Image.asset(
                        assetLogo,
                        width: 180,
                        height: 84,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.login, size: 72, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'سجّل دخولك عبر نفاذ للوصول إلى بطاقتك الرقمية والخدمات',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: _loading ? null : _mockNafathLogin,
                  icon: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Image.asset(assetLogo, width: 22, height: 22, errorBuilder: (_, __, ___) => const Icon(Icons.login, size: 20, color: Colors.white)),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('تسجيل الدخول عبر نفاذ', style: TextStyle(fontSize: 16)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bananGreen, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),

                const SizedBox(height: 14),
                const Center(child: Text('أو أدخل هويتك يدويًا', style: TextStyle(color: Colors.black54))),

                const SizedBox(height: 12),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _idController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'الهوية الوطنية',
                          hintText: '1XXXXXXXXX',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال رقم الهوية';
                          }
                          if (value.trim().length != 10) {
                            return 'طول الهوية يجب أن يكون 10 أرقام.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _submitManual,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bananGreen, 
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('متابعة', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                const Text(
                  'ملاحظة: لا يمكن استخدام التطبيق دون تسجيل هوية أو الدخول عبر نفاذ.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
