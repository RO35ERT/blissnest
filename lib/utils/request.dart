import 'dart:convert';
import 'package:blissnest/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// General function to handle HTTP requests with authorization
Future<http.Response?> sendHttpRequestWithAuth({
  required String method,
  required String endpoint,
  Map<String, dynamic>? body,
  BuildContext? context,
}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString("access");
  final String? refreshToken = prefs.getString("refresh");

  // Create headers with the Authorization token
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken',
  };

  final url = Uri.parse(endpoint);

  http.Response? response;

  try {
    // Sending the request based on the method
    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await http.put(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await http.delete(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
        break;
      case 'GET':
      default:
        response = await http.get(url, headers: headers);
        break;
    }

    // Check for authorization issues
    if (response.statusCode == 403) {
      // Forbidden, navigate to login
      Navigator.pushReplacementNamed(context!, '/');
      return null;
    } else if (response.statusCode == 401) {
      // Unauthorized, attempt to refresh the token
      final refreshResponse = await refreshAccessToken(refreshToken!, context!);

      if (refreshResponse != null) {
        // Retry the original request with the new access token
        headers['Authorization'] = 'Bearer ${refreshResponse['accessToken']}';

        // Re-send the request
        switch (method.toUpperCase()) {
          case 'POST':
            response = await http.post(
              url,
              headers: headers,
              body: jsonEncode(body),
            );
            break;
          case 'PUT':
            response = await http.put(
              url,
              headers: headers,
              body: jsonEncode(body),
            );
            break;
          case 'DELETE':
            response = await http.delete(
              url,
              headers: headers,
              body: jsonEncode(body),
            );
            break;
          case 'GET':
          default:
            response = await http.get(url, headers: headers);
            break;
        }
      } else {
        return null; // Refresh failed, user is redirected to login
      }
    }

    return response; // Return the final response
  } catch (error) {
    print('Error making HTTP request: $error');
    return null; // Handle network errors
  }
}

// Function to refresh access token
Future<Map<String, String>?> refreshAccessToken(
    String refreshToken, BuildContext context) async {
  final url = Uri.parse('$baseUrl/auth/refresh');
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      // Extract the new access token
      final String newAccessToken = responseData['accessToken'];

      // Save the new access token in SharedPreferences
      prefs.setString('access', newAccessToken);

      return {'accessToken': newAccessToken};
    } else {
      // If refresh token fails, navigate to login
      Navigator.pushReplacementNamed(context, '/');
      return null;
    }
  } catch (error) {
    // Handle network errors
    print('Error refreshing token: $error');
    Navigator.pushReplacementNamed(context, '/');
    return null;
  }
}
