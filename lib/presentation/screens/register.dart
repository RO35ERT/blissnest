import 'package:blissnest/core/auth.dart';
import 'package:blissnest/model/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../theme/text_styles.dart';
import '../../theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form data
  final String _nrc = '';
  final String _name = '';
  final String _dob = '';
  final String _address = '';
  final String _phone = '';
  final String _email = '';
  final String _password = '';

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = UserRegisterModel(
        nrc: _nrc,
        name: _name,
        dob: _dob,
        address: _address,
        phone: _phone,
        email: _email,
        password: _password,
      );

      Provider.of<AuthProvider>(context, listen: false).registerUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align title to the left
            children: [
              // Title
              Text(
                'Create Your Account',
                style: AppTextStyles.header.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),
              Text(
                'Fill in the details below',
                style: AppTextStyles.body.copyWith(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // NRC Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'NRC',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(
                        10, 10, 0, 10), // Center icon vertically
                    child: FaIcon(
                      FontAwesomeIcons.idCard,
                      size: 22, // Larger icon size
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(
                        10, 10, 0, 10), // Center icon vertically
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 22, // Larger icon size
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Date of Birth Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: FaIcon(
                      FontAwesomeIcons.calendar,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: FaIcon(
                      FontAwesomeIcons.addressBook,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: FaIcon(
                      FontAwesomeIcons.phone,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: FaIcon(
                      FontAwesomeIcons.envelope,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: FaIcon(
                      FontAwesomeIcons.lock,
                      size: 22,
                      color: Colors.grey,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: peachColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    _submitForm(context);
                  },
                  child: Text('Register', style: AppTextStyles.button),
                ),
              ),

              // Already have an account? Login
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
