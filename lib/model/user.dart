class UserRegisterModel {
  String nrc;
  String name;
  String dob;
  String address;
  String phone;
  String email;
  String password;
  String role;

  UserRegisterModel({
    required this.nrc,
    required this.name,
    required this.dob,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.role,
  });

  // Convert the model to a JSON map to send it via the API
  Map<String, dynamic> toJson() {
    return {
      'nrc': nrc,
      'name': name,
      'dob': dob,
      'address': address,
      'phone': phone,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
