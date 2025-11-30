import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/banan_card_widget.dart';
import '../main.dart';
import '../theme.dart';

class CardScreen extends StatefulWidget {
  static const routeName = '/card';

  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> with SingleTickerProviderStateMixin {
  bool _saved = false;
  late final AnimationController _animController;
  late final Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _buttonScale = Tween<double>(begin: 1.0, end: 0.97).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPressedSave() {
    if (_saved) return;
    setState(() => _saved = true);
    _animController.forward().then((_) => _animController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم الحفظ محلياً (عرض توضيحي)'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onShare() {
    // simple action: copy id to clipboard and show snackbar (replace with share plugin if needed)
    final id = AppState.nationalId ?? '1XXXXXXXXX';
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ رقم الهوية إلى الحافظة')));
  }

  Future<void> _requestCard() async {
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

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    await Future.delayed(const Duration(seconds: 2));
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلبك. سنخطرك عند إصدار البطاقة.')));
  }

  @override
  Widget build(BuildContext context) {
    final id = AppState.nationalId ?? '1XXXXXXXXX';
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('البطاقة الرقمية', style: TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              children: [
                // Card container
                Hero(
                  tag: 'banan_card',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 640),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFF7FBFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: const Color(0xFFE6EEF6)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 18, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // header
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('البطاقة الوطنية', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                      SizedBox(height: 2),
                                      Text('مصادق عليها من قبل الدولة', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(color: bananGreen.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.verified, color: bananGreen, size: 16),
                                      SizedBox(width: 6),
                                      Text('موثّقة', style: TextStyle(color: bananGreen, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          // embedded card widget
                          Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: BananCardWidget(
                                nationalId: id,
                                fullName: 'اسم المستخدم',
                                fingerprintNumber: '12234456779',
                                isSaved: _saved,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // info rows
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('الهوية الوطنية', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    const SizedBox(height: 6),
                                    Text(id, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('البصمة', style: TextStyle(fontSize: 12, color: Colors.black54)),
                                    SizedBox(height: 6),
                                    Text('12234456779', style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // details panel
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFECEFF3)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 6))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('تفاصيل البطاقة', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      const Text(
                        'تُستخدم هذه البطاقة لإتمام الإجراءات والخدمات الحكومية التي تتطلب بصمة، دون الحاجة للذهاب لأجهزة البصمة.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Expanded(child: Text('الحالة', style: TextStyle(color: Colors.black54))),
                          if (_saved)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: Colors.green.shade600, borderRadius: BorderRadius.circular(8)),
                              child: const Text('محفوظة', style: TextStyle(color: Colors.white)),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFF0B4D79), borderRadius: BorderRadius.circular(8)),
                              child: const Text('غير محفوظة', style: TextStyle(color: Colors.white)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // actions row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: ScaleTransition(
                          scale: _buttonScale,
                          child: ElevatedButton.icon(
                            onPressed: _saved ? null : _onPressedSave,
                            icon: Icon(_saved ? Icons.check : Icons.download_rounded, color: Colors.white),
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('احفظ البطاقة', style: TextStyle(fontSize: 15)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _saved ? Colors.green.shade600 : bananGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 6,
                              minimumSize: const Size.fromHeight(52),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _onShare,
                          icon: const Icon(Icons.share_outlined),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text('مشاركة'),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 58,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _requestCard,
                          child: const Icon(Icons.add_card_outlined),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bananGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.zero,
                          ),
                        ),
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