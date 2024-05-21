import 'package:flutter/material.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> signIn(String email, String password) async {
    final user = await _dbHelper.loginUser(email, password);
    return user != null;
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      await _dbHelper.registerUser(username, email, password);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.signIn(email, password);
    if (success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    final success = await _authService.register(username, email, password);
    if (success) {
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}
