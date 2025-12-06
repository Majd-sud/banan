import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ

class BananCardWidget extends StatelessWidget {
  final User? user; // المستخدم يُمرر من الخارج
  final bool debugMode; // 🔍 تفعيل أو تعطيل الـ Debug

  const BananCardWidget({Key? key, this.user, this.debugMode = false})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Text(
        "لا توجد بيانات للمستخدم.",
        style: TextStyle(color: Colors.red),
      );
    }

    // ============================
    // إضافة تاريخ الإصدار والانتهاء
    // ============================
    final DateTime issueDate = DateTime.now();
    final DateTime expiryDate = DateTime(
      issueDate.year + 1,
      issueDate.month,
      issueDate.day,
    );
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    final String issueDateStr = formatter.format(issueDate);
    final String expiryDateStr = formatter.format(expiryDate);

    return Container(
      constraints: BoxConstraints(
        minHeight: 475.2, // تحديد الارتفاع الأدنى
        maxHeight: 600, // تحديد الارتفاع الأقصى
        maxWidth: 300, // عرض ثابت للبطاقة
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B8354),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      // تصميم البطاقة
      child: SingleChildScrollView(
        // السماح بالتمرير في حالة امتلاء البطاقة
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // اللوجو في الأعلى
            SizedBox(
              width: 200,
              child: Image.asset("images/logo_app.png", fit: BoxFit.contain),
            ),
            const SizedBox(height: 20), // مسافة بين الشعار والبيانات
            // عرض بيانات المستخدم
            _buildRow("الاسم", "${user!.firstName} ${user!.lastName}"),
            _buildRow("ID", user!.idNumber),
            _buildRow(
              "البصمة الرقمية",
              user!.digitalFingerprint ?? 'غير متوفرة',
            ),
            _buildRow(
              "الحالة",
              user!.probabilityAllow == 1 ? 'نشطة' : 'غير مسموح',
            ),

            // ============================
            // إضافة تاريخ الإصدار والانتهاء
            // ============================
            _buildRow("تاريخ الإصدار", issueDateStr),
            _buildRow("تاريخ الانتهاء", expiryDateStr),

            // _buildRow("العمر", user!.age.toString()), // العمر
            // _buildRow(
            //   "تعليق الخدمة",
            //   user!.serviceSuspension ? 'معلق' : 'نشط',
            // ); // تعليق الخدمة
            // _buildRow("القرار", user!.decision ?? 'غير محدد'); // القرار
            // _buildRow("الحالة", user!.status ?? 'غير محددة'); // الحالة
            // _buildRow("الرسالة", user!.message ?? 'لا توجد'); // الرسالة
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لعرض صف البيانات بشكل مرتب
  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              color: Color.fromARGB(200, 255, 255, 255),
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}




    // ============================
    //تصميم اخرى للبطاقة ء
    // ============================




// import 'package:flutter/material.dart';
// import '../models/user.dart';
// import 'package:intl/intl.dart'; // لتنسيق التاريخ

// class BananCardWidget extends StatelessWidget {
//   final User? user; // المستخدم يُمرر من الخارج
//   final bool debugMode; // 🔍 تفعيل أو تعطيل الـ Debug

//   const BananCardWidget({Key? key, this.user, this.debugMode = false})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Text(
//         "لا توجد بيانات للمستخدم.",
//         style: TextStyle(color: Colors.red),
//       );
//     }

//     // ============================
//     // إضافة تاريخ الإصدار والانتهاء
//     // ============================
//     final DateTime issueDate = DateTime.now();
//     final DateTime expiryDate = DateTime(
//       issueDate.year + 1,
//       issueDate.month,
//       issueDate.day,
//     );
//     final DateFormat formatter = DateFormat('yyyy/MM/dd');
//     final String issueDateStr = formatter.format(issueDate);
//     final String expiryDateStr = formatter.format(expiryDate);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ============================
//         // ⭐ البطاقة الأساسية
//         // ============================
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: const Color(0xFF1B8354),
//             borderRadius: BorderRadius.circular(12), // منحني خفيف للأطراف
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 6,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),

//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // البيانات على اليسار
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildRow("الاسم", "${user!.firstName} ${user!.lastName}"),
//                     _buildRow("ID", user!.idNumber),
//                     _buildRow(
//                       "البصمة الرقمية",
//                       user!.digitalFingerprint ?? 'غير متوفرة',
//                     ),
//                     // _buildRow(
//                     //   "البصمة الحقيقية",
//                     //   user!.hasRealFingerprint ? 'نعم' : 'لا',
//                     // ),
//                     _buildRow(
//                       "الحالة",
//                       user!.probabilityAllow == 1 ? 'يسمح' : 'غير مسموح',
//                     ),

//                     // ============================
//                     // إضافة تاريخ الإصدار والانتهاء
//                     // ============================
//                     _buildRow("تاريخ الإصدار", issueDateStr),
//                     _buildRow("تاريخ الانتهاء", expiryDateStr),

//                     // _buildRow("العمر", user!.age.toString()),

//                     // _buildRow(
//                     //   "تعليق الخدمة",
//                     //   user!.serviceSuspension ? 'معلق' : 'نشط',
//                     // ),
//                     // _buildRow("القرار", user!.decision ?? 'غير محدد'),

//                     // _buildRow("الحالة", user!.status ?? 'غير محددة'),
//                     // _buildRow("الرسالة", user!.message ?? 'لا توجد'),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 10),

//               // اللوجو على اليمين
//               SizedBox(
//                 width: 150,
//                 child: Image.asset("images/logo_app.png", fit: BoxFit.contain),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 16),
//       ],
//     );
//   }

//   // دالة مساعدة لعرض صف البيانات بشكل مرتب
//   Widget _buildRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 4,
//             child: Text(
//               "$title:",
//               style: const TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: Text(
//               value,
//               style: const TextStyle(color: Colors.white, fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
