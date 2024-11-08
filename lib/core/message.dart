import 'dart:convert';

import 'package:blissnest/model/message.dart';
import 'package:blissnest/presentation/screens/chat.dart';
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

  Future<List<ChatMessage>> fetchMessages(
      int userId, int currentUserId, BuildContext context) async {
    try {
      final response = await sendHttpRequestWithAuth(
        endpoint: '$baseUrl/messages/$userId',
        method: "GET",
        context: context,
      );

      if (response!.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        data.sort((a, b) => DateTime.parse(a['createdAt'])
            .compareTo(DateTime.parse(b['createdAt'])));

        return data.map<ChatMessage>((msg) {
          final isSentByUser = msg['senderId'] == currentUserId;
          return ChatMessage(
            text: msg['content'],
            isSentByUser: isSentByUser,
          );
        }).toList();
      } else {
        print('Failed to fetch messages: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }
}
