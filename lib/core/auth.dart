import 'dart:convert';
import 'package:blissnest/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

    const baseUrl = "http://192.168.1.212:3001/api/auth"; // Backend URL
    final url = Uri.parse('$baseUrl/register'); // Full registration endpoint

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
}
