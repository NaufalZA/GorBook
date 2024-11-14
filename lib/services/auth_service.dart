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
      
      // Get registered user data
      final registered = _prefs.getString('registered_$email');
      if (registered == null) {
        return (false, 'User not found');
      }

      final userData = jsonDecode(registered);
      if (userData['password'] != password) {
        return (false, 'Invalid password');
      }
      
      final user = User(
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
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
      
      // Save registered user credentials
      await _prefs.setString('registered_$email', jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      }));
      
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

  Future<List<Map<String, dynamic>>> getUserBookings(String email) async {
    final bookingsJson = _prefs.getString('bookings_$email') ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(bookingsJson));
  }

  Future<void> addBooking(String email, Map<String, dynamic> booking) async {
    final bookings = await getUserBookings(email);
    bookings.add(booking);
    await _prefs.setString('bookings_$email', jsonEncode(bookings));
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getCourtReviews(String courtType) async {
    final reviewsJson = _prefs.getString('reviews_$courtType') ?? '[]';
    return List<Map<String, dynamic>>.from(jsonDecode(reviewsJson));
  }

  Future<void> addReview(String courtType, Map<String, dynamic> review) async {
    final reviews = await getCourtReviews(courtType);
    reviews.add(review);
    await _prefs.setString('reviews_$courtType', jsonEncode(reviews));
    notifyListeners();
  }

  Future<double> getCourtRating(String courtType) async {
    final reviews = await getCourtReviews(courtType);
    if (reviews.isEmpty) return 0;
    final total = reviews.fold(0.0, (sum, item) => sum + (item['rating'] as num));
    return total / reviews.length;
  }
}