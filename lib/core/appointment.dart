import 'dart:convert';
import 'package:blissnest/model/appointment.dart';
import 'package:blissnest/utils/constants.dart';
import 'package:blissnest/utils/request.dart';
import 'package:flutter/material.dart';

class AppointmentService {
  /// Create a new appointment
  Future<Appointment?> createAppointment({
    required String title,
    required DateTime date,
    required String description,
    required int doctorId,
    required int patientId,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'POST',
      endpoint: '$baseUrl/appointment/user',
      body: {
        'title': title,
        'date': date.toIso8601String(),
        'description': description,
        'doctorId': doctorId,
        'patientId': patientId,
      },
      context: context,
    );

    if (response != null && response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Appointment.fromJson(
          responseData); // Return the created appointment
    } else {
      print('Failed to create appointment: ${response?.statusCode}');
      return null;
    }
  }

  /// Get appointments by patientId
  Future<List<Appointment>?> getAppointmentsByPatientId({
    required int patientId,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'GET',
      endpoint: '$baseUrl/appointment/get',
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Appointment.fromJson(json)).toList();
    } else {
      print(
          'Failed to fetch appointments for patientId $patientId: ${response?.statusCode}');
      return null;
    }
  }

  /// Update an existing appointment
  Future<Appointment?> updateAppointment({
    required String id,
    required String title,
    required DateTime date,
    required String description,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'PUT',
      endpoint: '$baseUrl/appointment/$id',
      body: {
        'title': title,
        'date': date.toIso8601String(),
        'description': description,
      },
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Appointment.fromJson(
          responseData); // Return the updated appointment
    } else {
      print('Failed to update appointment: ${response?.statusCode}');
      return null;
    }
  }

  /// Delete an appointment
  Future<bool> deleteAppointment({
    required int id,
    required BuildContext context,
  }) async {
    final response = await sendHttpRequestWithAuth(
      method: 'DELETE',
      endpoint: '$baseUrl/appointment/$id',
      context: context,
    );

    if (response != null && response.statusCode == 200) {
      return true; // Appointment deleted successfully
    } else {
      print('Failed to delete appointment: ${response?.statusCode}');
      return false;
    }
  }
}
