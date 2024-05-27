import 'package:flutter/material.dart';
import 'package:news_project/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<bool> signIn(String email, String password) async {
    final user = await _dbHelper.loginUser(email, password);
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('UserID', user['UserID']);
      await prefs.setString('Username', user['Username']); // Save username
      await prefs.setString('Email', user['Email']); // Save username
      await prefs.setString('UserRole', user['Role']); // Store the user role
      await prefs.setBool('isLoggedIn', true);
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      await _dbHelper.registerUser(username, email, password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'Username', username); // Save username on registration
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
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String email, String password) async {
    final success = await _authService.register(username, email, password);
    return success;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('UserID');
    await prefs.remove('UserRole'); // Remove the user role
    _isLoggedIn = false;
    notifyListeners();
  }
}
