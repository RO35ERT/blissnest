import 'dart:convert';
import 'package:blissnest/model/login_model.dart';
import 'package:blissnest/model/user.dart';
import 'package:blissnest/model/user_model.dart';
import 'package:blissnest/model/user_response.dart';
import 'package:blissnest/utils/constants.dart';
import 'package:blissnest/utils/request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool _isLoading = false;
  String? _errorMessage;
  String? _success;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get success => _success;

  /// Register a new user
  Future<String?> registerUser(UserRegisterModel user) async {
    _isLoading = true;
    _errorMessage = null;
    _success = null;

    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return "Account Created";
      } else {
        final responseData = jsonDecode(response.body);
        return responseData['message'] ??
            'Registration failed. Please try again.';
      }
    } catch (error) {
      return 'Could not register user. Please try again later.';
    } finally {
      _isLoading = false;
    }
  }

  /// Login the user
  Future<String?> loginUser(UserLoginModel user) async {
    _isLoading = true;
    _errorMessage = null;
    _success = null;

    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract access token
        final String accessToken = responseData['accessToken'];
        final String refreshToken = responseData['refreshToken'];
        final int id = responseData['id'];

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("key", true);
        prefs.setString("access", accessToken);
        prefs.setString("refresh", refreshToken);
        prefs.setInt("id", id);

        return "Login Successful";
      } else {
        final responseData = jsonDecode(response.body);
        return responseData['message'];
      }
    } catch (error) {
      return 'Could not log in. Please try again later.';
    } finally {
      _isLoading = false;
    }
  }

  /// Fetch current logged-in user
  Future<UserModel?> fetchCurrentUser(BuildContext context) async {
    final response = await sendHttpRequestWithAuth(
        method: 'GET', endpoint: '$baseUrl/auth/user', context: context);

    if (response != null && response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return UserModel.fromJson(responseData);
    } else {
      return null; // Handle failure
    }
  }

  Future<List<UserResponseModel>?> fetchNonPatients() async {
    final response = await sendHttpRequestWithAuth(
      method: 'GET',
      endpoint: '$baseUrl/auth/non-patients',
    );

    if (response != null && response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      // Convert the response to a list of UserModel instances
      return responseData
          .map((user) => UserResponseModel.fromJson(user))
          .toList();
    } else {
      return null; // Handle failure
    }
  }
}
