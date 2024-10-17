class JournalResponseModel {
  final String text;
  final DateTime createdAt;
  final int? id;

  JournalResponseModel({required this.text, required this.createdAt, this.id});

  factory JournalResponseModel.fromJson(Map<String, dynamic> json) {
    return JournalResponseModel(
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      id: json['id'],
    );
  }
}
