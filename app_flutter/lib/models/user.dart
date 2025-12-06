class User {
  final String firstName;
  final String lastName;
  final String idNumber;
  final int age;
  final bool hasRealFingerprint;
  final bool serviceSuspension;
  final String? digitalFingerprint;
  final int probabilityAllow; // 1 = مسموح، 0 = غير مسموح
  final String? decision; // "allow" أو "deny"
  final String? status; // "found" أو "not_found"
  final String? message; // الرسالة من الباك اند

  User({
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.age,
    required this.hasRealFingerprint,
    required this.serviceSuspension,
    this.digitalFingerprint,
    required this.probabilityAllow,
    this.decision,
    this.status,
    this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      idNumber: json['id_number'].toString(),
      age: json['age'] ?? 0,
      hasRealFingerprint:
          json['has_real_fingerprint'] == 1 ||
          json['has_real_fingerprint'] == true,
      serviceSuspension:
          json['service_suspension'] == 1 || json['service_suspension'] == true,
      digitalFingerprint: json['digital_fingerprint']?.toString(),
      probabilityAllow: json['probability_allow'] ?? 0,
      decision: json['decision']?.toString(),
      status: json['status']?.toString(),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'id_number': idNumber,
    'age': age,
    'has_real_fingerprint': hasRealFingerprint,
    'service_suspension': serviceSuspension,
    'digital_fingerprint': digitalFingerprint,
    'probability_allow': probabilityAllow,
    'decision': decision,
    'status': status,
    'message': message,
  };
}

// class User {
//   final String firstName;
//   final String lastName;
//   final String idNumber;
//   final int age;
//   final bool hasRealFingerprint;
//   final bool serviceSuspension;
//   final String? digitalFingerprint;

//   User({
//     required this.firstName,
//     required this.lastName,
//     required this.idNumber,
//     required this.age,
//     required this.hasRealFingerprint,
//     required this.serviceSuspension,
//     this.digitalFingerprint,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       firstName: json['first_name'] ?? '',
//       lastName: json['last_name'] ?? '',
//       idNumber: json['id_number'].toString(),
//       age: json['age'] ?? 0,
//       hasRealFingerprint:
//           json['has_real_fingerprint'] == 1 ||
//           json['has_real_fingerprint'] == true,
//       serviceSuspension:
//           json['service_suspension'] == 1 || json['service_suspension'] == true,
//       digitalFingerprint: json['digital_fingerprint']?.toString(),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'first_name': firstName,
//     'last_name': lastName,
//     'id_number': idNumber,
//     'age': age,
//     'has_real_fingerprint': hasRealFingerprint,
//     'service_suspension': serviceSuspension,
//     'digital_fingerprint': digitalFingerprint,
//   };
// }
