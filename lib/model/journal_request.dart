class JournalRequestModel {
  final int id; // ID of the journal entry
  final String text; // Content of the journal entry

  JournalRequestModel({required this.id, required this.text});

  // Converts a JournalResponseModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  // Creates a JournalResponseModel instance from JSON
  factory JournalRequestModel.fromJson(Map<String, dynamic> json) {
    return JournalRequestModel(
      id: json['id'], // Assuming the ID is an integer
      text: json['text'], // Text content of the journal
    );
  }
}
