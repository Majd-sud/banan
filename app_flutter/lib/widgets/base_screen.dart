import 'package:flutter/material.dart';
import '../auth_flow/bottom_nav.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const BaseScreen({super.key, required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: const AppBottomNav(),
      body: child,
    );
  }
}
