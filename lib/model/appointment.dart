class Appointment {
  final int id;
  final String title;
  final DateTime date;
  final String status;
  final String description;
  final int doctorId;
  final int patientId;

  Appointment({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.description,
    required this.doctorId,
    required this.patientId,
  });

  // Factory constructor to create an instance of Appointment from a JSON map
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      description: json['description'],
      doctorId: json['doctorId'],
      patientId: json['patientId'],
    );
  }

  // Method to convert an Appointment instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
      'doctorId': doctorId,
      'patientId': patientId,
    };
  }
}
