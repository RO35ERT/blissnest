class JournalRequestModel {
  final String text;

  JournalRequestModel({required this.text});

  // Converts a JournalRequestModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }

  // Creates a JournalRequestModel instance from JSON
  factory JournalRequestModel.fromJson(Map<String, dynamic> json) {
    return JournalRequestModel(
      text: json['text'],
    );
  }
}
