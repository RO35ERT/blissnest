import 'package:blissnest/core/message.dart';
import 'package:blissnest/model/therapist.dart';
import 'package:blissnest/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blissnest/core/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatMessage {
  String text;
  bool isSentByUser;

  ChatMessage({required this.text, required this.isSentByUser});

  @override
  String toString() {
    return 'ChatMessage(text: $text, isSentByUser: $isSentByUser)';
  }
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List<ChatMessage> _messages = [];
  final AuthService _authService = AuthService();
  final List<TherapistModel> _therapists = [];
  final TextEditingController _messageController = TextEditingController();
  TherapistModel? _selectedTherapist;
  int patient = 3;
  late IO.Socket socket;
  final messageService = MessageService();

  @override
  void initState() {
    super.initState();
    _setIdAndConnectSocket();
    _fetchTherapists();
  }

  Future<void> _setIdAndConnectSocket() async {
    await setId(); // Set the patient ID
    _connectSocket(); // Connect to the socket after setting patient ID
  }

  Future<void> _fetchMessages(int id) async {
    setState(() {
      _messages = [];
    });
    try {
      final fetchedMessages = await messageService.fetchMessages(
        id,
        patient,
        context,
      );
      print(fetchedMessages);
      setState(() {
        _messages = fetchedMessages; // Set the fetched messages
      });
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> setId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      patient = prefs.getInt("id") ?? 3;
    });
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

  void _connectSocket() {
    try {
      socket = IO.io('http://10.0.2.2:3001', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();

      socket.on('connect', (_) {
        print('Connected to socket server');
      });

      socket.on('private_message', (data) {
        setState(() {
          _messages.insert(
              0, ChatMessage(text: data['content'], isSentByUser: false));
        });
      });

      socket.on('disconnect', (_) {
        print('Disconnected from socket server');
      });
    } catch (e) {
      print("Error connecting to socket: $e");
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.dispose();
    super.dispose();
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

  Widget _buildTherapistAvatar(TherapistModel therapist) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTherapist = therapist;
          _messages.clear();
        });

        _fetchMessages(therapist.id);
        // Emit an event to identify the user with the server
        socket.emit('identify', patient);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: peachColor,
              radius: 25,
              child: Text(
                therapist.name[0], // First letter of therapist's name
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment:
          message.isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isSentByUser ? peachColor : Colors.grey.shade300,
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

  void _sendMessage() {
    if (_messageController.text.isNotEmpty && _selectedTherapist != null) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(text: _messageController.text, isSentByUser: true),
        );
        // Emit the message to the server
        socket.emit('private_message', {
          'content': _messageController.text,
          'toUserId': _selectedTherapist!.id,
          'fromUserId': patient,
        });

        messageService.sendMessage(
            receiverId: _selectedTherapist!.id,
            messageContent: _messageController.text,
            senderId: patient,
            context: context);
        _messageController.clear(); // Clear the input field
      });
    }
  }
}
