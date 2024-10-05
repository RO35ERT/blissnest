import 'dart:convert';
import 'package:blissnest/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> registerUser(UserRegisterModel user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    const baseUrl = "http://192.168.1.212:3001/api/auth";

    final url = Uri.parse('$baseUrl/register'); // Replace with actual URL

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        // Registration successful
        final responseData = jsonDecode(response.body);
        print('User registered successfully: ${responseData['userId']}');
      } else {
        // Handle error response
        final responseData = jsonDecode(response.body);
        _errorMessage = responseData['message'];
      }
    } catch (error) {
      _errorMessage = 'Could not register user. Please try again later.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
