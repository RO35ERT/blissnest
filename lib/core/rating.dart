import 'dart:convert';
import 'package:blissnest/model/therapy_res.dart';
import 'package:blissnest/utils/constants.dart';
import 'package:blissnest/utils/request.dart';
import 'package:flutter/material.dart';

class RatingService {
  /// Create a new rating for a therapist
  Future<bool> createRating({
    required int therapistId,
    required double ratingValue,
    required String comment,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'POST',
      endpoint: '$baseUrl/rating',
      body: {
        'therapistId': therapistId, // ID of the therapist being rated
        'rating': ratingValue, // Rating value
        'comment': comment, // Optional comment
      },
      context: context,
    );

    if (response != null && response.statusCode == 201) {
      return true; // Successfully created rating
    } else {
      print('Failed to create rating: ${response?.statusCode}');
      return false;
    }
  }

  /// Get rating summary for a specific therapist
  Future<TherapistRatingResponse?> getRatingsByTherapistId({
    required int therapistId,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'GET',
      endpoint:
          '$baseUrl/rating/therapists/$therapistId', // Adjust endpoint based on your API
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return TherapistRatingResponse.fromJson(responseData);
    } else {
      print(
          'Failed to fetch therapist rating summary: ${response?.statusCode}');
      return null;
    }
  }
}
