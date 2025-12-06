import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// استيراد الـ Providers
import 'providers/user_provider.dart';

// استيراد الشاشات
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/digital_fingerprint_screen.dart';
import 'screens/operations_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/creating_digital_fingerprint.dart';

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
      title: 'تطبيق بنان',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        DigitalFingerprintScreen.routeName: (_) =>
            const DigitalFingerprintScreen(),
        CreatingDigitalFingerprintScreen.routeName: (_) =>
            const CreatingDigitalFingerprintScreen(),
        OperationsScreen.routeName: (_) => const OperationsScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF1B8354),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B8354),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B8354),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
