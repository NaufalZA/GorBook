import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  User? _currentUser;
  late SharedPreferences _prefs;
  
  bool get isAuthenticated => _isAuthenticated;
  User? get currentUser => _currentUser;
  
  // Initialize shared preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userJson = _prefs.getString('user');
    if (userJson != null) {
      _currentUser = User.fromJson(jsonDecode(userJson));
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> _saveUserData(User user) async {
    await _prefs.setString('user', jsonEncode(user.toJson()));
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<(bool, String)> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return (false, 'Email and password cannot be empty');
      }
      
      // TODO: Implement actual authentication with backend
      final user = User(
        name: "John Doe",
        email: email,
        phone: "+62 123 4567 890",
      );
      await _saveUserData(user);
      return (true, 'Login successful');
    } catch (e) {
      return (false, 'Login failed: ${e.toString()}');
    }
  }

  Future<(bool, String)> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
        return (false, 'All fields must be filled');
      }
      
      // TODO: Implement actual signup with backend
      final user = User(
        name: name,
        email: email,
        phone: phone,
      );
      await _saveUserData(user);
      return (true, 'Registration successful');
    } catch (e) {
      return (false, 'Registration failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _prefs.remove('user');
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}