import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(User user) {
    _user = user;
    notifyListeners();
    print("🟢 [DEBUG] User data set in provider: ${user.toJson()}");
  }

  void logout() {
    _user = null;
    notifyListeners();
    print("⚪ [DEBUG] User logged out.");
  }
}
