class Message {
  final String content;
  final int fromUserId;
  final int toUserId;

  Message(
      {required this.content,
      required this.fromUserId,
      required this.toUserId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      fromUserId: json['senderId'],
      toUserId: json['receiverId'],
    );
  }
}
