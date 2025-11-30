// ...existing code...
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/banan_card_widget.dart';
import 'card_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  Future<void> _requestCard(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الطلب'),
        content: const Text('هل تريد طلب نسخة رسمية من البطاقة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('طلب')),
        ],
      ),
    );
    if (confirmed != true) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال طلبك. سنخطرك عند إصدار البطاقة.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [bananGreen.withOpacity(0.98), bananGreen.withOpacity(0.75)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('مرحبًا بك', style: textStyle.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            Text('اضغط على البطاقة لعرض التفاصيل أو استخدم الأزرار أدناه.', style: textStyle.bodyMedium?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const Icon(Icons.credit_card, color: Colors.white, size: 36),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Card preview + two buttons (عرض / اطلب)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(CardScreen.routeName),
                        child: const BananCardWidget(
                          nationalId: '1234567890',
                          fullName: 'أحمد محمد',
                          fingerprintNumber: 'FP-001',
                          isSaved: true,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Two buttons side-by-side
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => Navigator.of(context).pushNamed(CardScreen.routeName),
                              icon: const Icon(Icons.visibility),
                              label: const Text('عرض البطاقة'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bananGreen,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _requestCard(context),
                              icon: const Icon(Icons.add_card_outlined, color: bananGreen),
                              label: const Text('اطلب البطاقة', style: TextStyle(color: bananGreen)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: BorderSide(color: bananGreen),
                                foregroundColor: bananGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Short info box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ماذا يحدث بعد الطلب؟', style: textStyle.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text('• سترسل الجهة المختصة طلبك.\n• ستستلم إشعارًا عند إصدار البطاقة.', style: textStyle.bodyMedium),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ...existing code...