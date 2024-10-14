import 'dart:convert';
import 'package:blissnest/model/login_model.dart';
import 'package:blissnest/model/user.dart';
import 'package:blissnest/model/user_model.dart';
import 'package:blissnest/utils/constants.dart';
import 'package:blissnest/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _success;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get success => _success;

  Future<void> registerUser(UserRegisterModel user) async {
    _isLoading = true; // Start the loading process
    _errorMessage = null; // Clear any previous errors
    _success = null;

    notifyListeners(); // Notify listeners to show loading spinner or other UI changes

    final url =
        Uri.parse('$baseUrl/auth/register'); // Full registration endpoint

    try {
      // Send HTTP POST request to register user
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        }, // Setting the content type to JSON
        body: jsonEncode(user.toJson()), // Convert user model to JSON
      );

      // Check for successful registration
      if (response.statusCode == 201) {
        _success = "Account Created";
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage =
            responseData['message'] ?? 'Registration failed. Please try again.';
      }
    } catch (error) {
      _errorMessage = 'Could not register user. Please try again later.';
    }

    _isLoading = false; // Stop the loading process
    notifyListeners(); // Notify listeners to hide the spinner or update the UI
  }

  Future<void> loginUser(UserLoginModel user, BuildContext context) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message
    _success = null; // Reset success message
    notifyListeners();

    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        _success = "";
        final responseData = jsonDecode(response.body);

        // Extract access token
        final String accessToken = responseData['accessToken'];
        final String refreshToken = responseData['refreshToken'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("key", true);
        prefs.setString("access", accessToken);
        prefs.setString("refresh", refreshToken);
      } else {
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'];
      }
    } catch (error) {
      _errorMessage = 'Could not log in. Please try again later.';
    }

    _isLoading = false;
    notifyListeners();
  }

  UserModel? _user;

  UserModel? get user => _user;

  Future<void> fetchCurrentUser(BuildContext context) async {
    final response = await sendHttpRequestWithAuth(
      method: 'GET',
      endpoint: '$baseUrl/auth/user',
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      // Parse the response
      final responseData = jsonDecode(response.body);
      // Assuming you have a UserModel that matches your user data structure
      _user = UserModel.fromJson(responseData);
      notifyListeners();
    } else {
      // Handle error
      print('Failed to fetch user: ${response?.statusCode}');
    }
  }
}
