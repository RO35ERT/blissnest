import 'package:blissnest/utils/constants.dart';
import 'package:blissnest/utils/request.dart';
import 'package:flutter/material.dart';

class MessageService {
  Future<void> sendMessage({
    required int receiverId,
    required String messageContent,
    required int senderId,
    required BuildContext context,
  }) async {
    try {
      final response = await sendHttpRequestWithAuth(
        method: 'POST',
        endpoint: '$baseUrl/messages',
        body: {
          'receiverId': receiverId,
          'content': messageContent,
          'senderId': senderId,
        },
        context: context,
      );

      // Check if the request was successful
      if (response!.statusCode == 201) {
        print('Message sent successfully');
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
        print('Error: ${response.body}');
      }
    } catch (error) {
      print('Error while sending message: $error');
    }
  }
}
