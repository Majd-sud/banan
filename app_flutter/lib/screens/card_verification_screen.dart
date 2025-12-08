import 'package:flutter/material.dart';
import '../widgets/banan_card_widget.dart';
import '../main.dart'; // for AppState
import '../theme.dart'; // for bananGreen

class CardVerificationScreen extends StatefulWidget {
  static const routeName = '/card-verification';

  const CardVerificationScreen({super.key});

  @override
  State<CardVerificationScreen> createState() => _CardVerificationScreenState();
}

class _CardVerificationScreenState extends State<CardVerificationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = AppState.nationalId ?? '1XXXXXXXXX';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),

        body: GestureDetector(
          behavior: HitTestBehavior.opaque, // ✅ يلتقط أي ضغطة
          onTap: () {
            Navigator.pushReplacementNamed(context, '/auth-success');
          },

          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed:
                        () => Navigator.pushReplacementNamed(
                          context,
                          '/auth-success',
                        ),
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _scale,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.35),
                          ),
                          child: BananCardWidget(
                            nationalId: id,
                            fullName: 'اسم المستخدم',
                            fingerprintNumber: '12234456779',
                            isSaved: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Icon(
                        Icons.fingerprint,
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'اضغط للمتابعة',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
