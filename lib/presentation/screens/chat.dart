import 'package:blissnest/model/therapist.dart';
import 'package:blissnest/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blissnest/core/auth.dart';

class ChatMessage {
  String text;
  bool isSentByUser;

  ChatMessage({required this.text, required this.isSentByUser});
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<ChatMessage> _messages = [];
  final AuthService _authService = AuthService();
  final List<TherapistModel> _therapists = [];
  final TextEditingController _messageController = TextEditingController();
  TherapistModel? _selectedTherapist; // Track the selected therapist

  @override
  void initState() {
    super.initState();
    _fetchTherapists();
  }

  Future<void> _fetchTherapists() async {
    final therapists = await _authService.fetchTherapists(context);
    if (therapists != null) {
      setState(() {
        _therapists.clear();
        _therapists.addAll(therapists);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chat',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: peachColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTherapistAvatarList(),
            const SizedBox(height: 10),
            if (_selectedTherapist != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Chatting with ${_selectedTherapist!.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                reverse:
                    true, // Start at the bottom to show most recent messages
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // Build therapist avatars in a horizontal list
  Widget _buildTherapistAvatarList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _therapists.length,
        itemBuilder: (context, index) {
          return _buildTherapistAvatar(_therapists[index]);
        },
      ),
    );
  }

  // Build each therapist avatar widget
  Widget _buildTherapistAvatar(TherapistModel therapist) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTherapist = therapist; // Select the therapist
          _messages.clear(); // Clear chat when switching to a new therapist
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor:
                  peachColor, // Or any color you prefer for the avatar background
              radius: 25,
              child: Text(
                therapist.name[0], // First letter of the therapist's name
                style: const TextStyle(
                  color: Colors.white, // Set the text color
                  fontSize: 18, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              therapist.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // Build each chat message bubble
  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment:
          message.isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isSentByUser
              ? peachColor
              : Colors
                  .grey.shade300, // Different colors for sent/received messages
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  // Build message input field with send button
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(FontAwesomeIcons.paperPlane, color: peachColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // Handle sending a message
  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _selectedTherapist != null) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            text: _messageController.text,
            isSentByUser: true,
          ),
        );
        _messageController
            .clear(); // Clear the input field after sending the message
      });
    }
  }
}
