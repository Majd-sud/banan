import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

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

  Future<void> _submitLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final nationalId = _idController.text.trim();
    setState(() => _loading = true);
    print("🟢 [DEBUG] Entered National ID: $nationalId");

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/verify_national_id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'national_id': nationalId}),
      );

      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ [DEBUG] Data received: $data");

        if (data['status'] == 'found') {
          final user = User.fromJson(data);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("المستخدم غير موجود.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Backend error: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Cannot reach backend: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    const logo = 'images/n_logo.png';
    const primaryColor = Color(0xFF1B8354);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'تسجيل الدخول',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شعار نفاذ أعلى الصفحة
                  Image.asset(logo, width: 180, height: 84),
                  const SizedBox(height: 40),

                  // حقل إدخال الهوية الوطنية
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _idController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الهوية الوطنية',
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF1B8354),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال رقم الهوية';
                        }
                        if (value.length != 10) {
                          return 'رقم الهوية يجب أن يكون 10 أرقام';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // زر متابعة
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submitLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "متابعة",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // النص أسفل الزر
                  const Text(
                    'سيتم تسجيل دخولك عبر نفاذ. بالضغط على زر متابعة، فإنك توافق على سياسة الشروط والأحكام.',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
