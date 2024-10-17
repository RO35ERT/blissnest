import 'dart:convert';
import 'package:blissnest/model/journal_request.dart';
import 'package:blissnest/model/journal_response.dart';
import 'package:blissnest/utils/constants.dart';
import 'package:blissnest/utils/request.dart';
import 'package:flutter/material.dart';

class JournalService {
  /// Create a new journal entry
  Future<JournalRequestModel?> createJournal({
    required String text,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'POST',
      endpoint: '$baseUrl/journal', // Adjust the endpoint if necessary
      body: {
        'text': text, // Journal content
      },
      context: context,
    );

    if (response != null && response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return JournalRequestModel.fromJson(
          responseData); // Return the created journal entry
    } else {
      print('Failed to create journal: ${response?.statusCode}');
      return null;
    }
  }

  /// Get all journal entries for the logged-in user
  Future<List<JournalResponseModel>?> getJournalsForUser({
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'GET',
      endpoint: '$baseUrl/journal', // Adjust the endpoint if necessary
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData
          .map((json) => JournalResponseModel.fromJson(json))
          .toList();
    } else {
      print('Failed to fetch journals: ${response?.statusCode}');
      return null;
    }
  }

  /// Update an existing journal entry
  Future<JournalRequestModel?> updateJournal({
    required int id,
    required String text,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'PUT',
      endpoint: '$baseUrl/journal/$id', // Specify journal ID in the URL
      body: {
        'text': text, // Updated journal content
      },
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return JournalRequestModel.fromJson(
          responseData); // Return the updated journal entry
    } else {
      print('Failed to update journal: ${response?.statusCode}');
      return null;
    }
  }

  /// Delete a journal entry
  Future<bool> deleteJournal({
    required int id,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'DELETE',
      endpoint: '$baseUrl/journal/$id', // Specify journal ID in the URL
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      return true; // Journal deleted successfully
    } else {
      print('Failed to delete journal: ${response?.statusCode}');
      return false;
    }
  }
}
