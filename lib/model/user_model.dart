class UserModel {
  final String nrc;
  final String name;
  final DateTime dob;
  final String address;
  final String phone;
  final String email;
  final String role;

  UserModel({
    required this.nrc,
    required this.name,
    required this.dob,
    required this.address,
    required this.phone,
    required this.email,
    required this.role,
  });

  // Convert a UserRegisterModel instance to a Map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'nrc': nrc,
      'name': name,
      'dob': dob.toIso8601String(), // Convert DateTime to String
      'address': address,
      'phone': phone,
      'email': email,
      'role': role,
    };
  }

  // Create a UserRegisterModel instance from a Map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nrc: json['nrc'],
      name: json['name'],
      dob: DateTime.parse(json['dob']), // Convert String to DateTime
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      role: json['role'],
    );
  }
}
