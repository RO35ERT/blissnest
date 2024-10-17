class JournalResponseModel {
  final String text;
  final DateTime createdAt;

  JournalResponseModel({required this.text, required this.createdAt});

  factory JournalResponseModel.fromJson(Map<String, dynamic> json) {
    return JournalResponseModel(
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
