class TherapistModel {
  final String name;
  final String phone;
  final String email;
  final int id;
  final String qualification;
  final String facility;

  TherapistModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      required this.facility,
      required this.qualification});

  // Create a UserRegisterModel instance from a Map
  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    return TherapistModel(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
        qualification: json['qualification'],
        facility: json['facility']);
  }
}
