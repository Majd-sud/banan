import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/bottom_navbar.dart';
import '../providers/user_provider.dart';
import '../widgets/banan_card_widget.dart';

class CreatingDigitalFingerprintScreen extends StatefulWidget {
  static const String routeName = '/creating_digital_fingerprint';

  const CreatingDigitalFingerprintScreen({Key? key}) : super(key: key);

  @override
  State<CreatingDigitalFingerprintScreen> createState() =>
      _CreatingDigitalFingerprintScreenState();
}

class _CreatingDigitalFingerprintScreenState
    extends State<CreatingDigitalFingerprintScreen> {
  bool showCard = false; // التحكم بعرض البطاقة
  String messageText = 'يتم إنشاء بصمتك الرقمية...'; // نص الرسالة

  @override
  void initState() {
    super.initState();

    // تأخير 5 ثواني قبل عرض البطاقة
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showCard = true;
        messageText = 'لقد تم إصدار بصمتك الرقمية';
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      print("=== صفحة إنشاء البصمة الرقمية ===");
      print("اسم المستخدم: ${user.firstName} ${user.lastName}");
      print("رقم الهوية: ${user.idNumber}");
      print("البصمة الرقمية: ${user.digitalFingerprint}");
      print("الحالة: ${user.probabilityAllow == 1 ? 'يسمح' : 'غير مسموح'}");
      print("================================");
    }
  }

  void _saveToWallet() {
    final snackBar = SnackBar(
      content: const Text('تم حفظ البصمة الرقمية في المحفظة الرقمية'),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 66, 160, 71),
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إنشاء بصمتك الرقمية',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF1B8354),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // أيقونة البصمة ثابتة
                  const SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.fingerprint,
                      size: 60,
                      color: Color(0xFF1B8354),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // نص الرسالة
                  Text(
                    messageText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // أزرار العرض والحفظ بعد صدور البصمة
                  if (user != null && showCard)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => Dialog(
                                insetPadding: const EdgeInsets.all(10),
                                backgroundColor: Colors.transparent,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.78,
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: SingleChildScrollView(
                                        child: BananCardWidget(
                                          nationalId: user.idNumber,
                                          fullName:
                                              '${user.firstName} ${user.lastName}',
                                          fingerprintNumber:
                                              user.digitalFingerprint ??
                                              'غير متوفر',
                                          isSaved: true,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          size: 50,
                                          color: Color.fromARGB(
                                            255,
                                            155,
                                            155,
                                            155,
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(ctx).pop(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.remove_red_eye),
                          label: const Text("عرض البطاقة"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B8354),
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _saveToWallet,
                          icon: const Icon(Icons.save),
                          label: const Text("حفظ البطاقة"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B8354),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                  // رسالة في حالة عدم وجود مستخدم
                  if (user == null && !showCard)
                    const Text(
                      "لا توجد بيانات مستخدم متاحة.",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
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

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/bottom_navbar.dart';
// import '../providers/user_provider.dart';
// import '../widgets/banan_card_widget.dart';

// class CreatingDigitalFingerprintScreen extends StatefulWidget {
//   static const String routeName = '/creating_digital_fingerprint';

//   const CreatingDigitalFingerprintScreen({Key? key}) : super(key: key);

//   @override
//   State<CreatingDigitalFingerprintScreen> createState() =>
//       _CreatingDigitalFingerprintScreenState();
// }

// class _CreatingDigitalFingerprintScreenState
//     extends State<CreatingDigitalFingerprintScreen>
//     with SingleTickerProviderStateMixin {
//   bool showCard = false; // التحكم بعرض البطاقة
//   bool showFingerprintIcon = true; // للتحكم بأيقونة البصمة
//   String messageText = 'يتم إنشاء بصمتك الرقمية...'; // نص الرسالة

//   late AnimationController _controller;
//   late Animation<double> _opacityAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // إعداد AnimationController لمدة 800ms
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     // انيميشن للتلاشي (Opacity)
//     _opacityAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

//     // انيميشن للتكبير (Scale)
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

//     // تأخير 5 ثواني قبل عرض البطاقة
//     Future.delayed(const Duration(seconds: 5), () {
//       setState(() {
//         showCard = true;
//         showFingerprintIcon = false; // إخفاء أيقونة البصمة
//         messageText =
//             'لقد تم إصدار بصمتك الرقمية'; // تحديث النص بعد ظهور البطاقة
//       });
//       _controller.forward(); // تشغيل الانيميشن للبطاقة
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final user = userProvider.user;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'إنشاء بصمتك الرقمية',
//             style: TextStyle(color: Colors.white),
//           ),
//           centerTitle: true,
//           backgroundColor: const Color(0xFF1B8354),
//         ),
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               // يسمح بالتمرير في حال كان المحتوى أكثر من الشاشة
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // أيقونة البصمة مع Animation للاختفاء
//                   AnimatedOpacity(
//                     opacity: showFingerprintIcon ? 1 : 0,
//                     duration: const Duration(milliseconds: 800),
//                     child: const SizedBox(
//                       width: 60,
//                       height: 60,
//                       child: Icon(
//                         Icons.fingerprint,
//                         size: 60,
//                         color: Color(0xFF1B8354),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 16),

//                   // نص الرسالة مع تأثير Fade
//                   AnimatedOpacity(
//                     opacity: 1,
//                     duration: const Duration(milliseconds: 500),
//                     child: Text(
//                       messageText,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // عرض البطاقة بعد انتهاء الرسالة
//                   if (user != null && showCard)
//                     AnimatedBuilder(
//                       animation: _controller,
//                       builder: (context, child) {
//                         return Opacity(
//                           opacity: _opacityAnimation.value,
//                           child: Transform.scale(
//                             scale: _scaleAnimation.value,
//                             child: BananCardWidget(user: user),
//                           ),
//                         );
//                       },
//                     )
//                   else if (user == null)
//                     const Text(
//                       "لا توجد بيانات مستخدم متاحة.",
//                       style: TextStyle(fontSize: 14, color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: const BottomCustomNavBar(),
//       ),
//     );
//   }
// }
