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

  final TextEditingController _nrcController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _nrcController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final user = UserRegisterModel(
      nrc: _nrcController.text,
      name: _nameController.text,
      dob: _dobController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: "Patient",
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: authProvider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
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
                      controller: _nrcController,
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
                      controller: _nameController,
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
                      controller: _dobController,
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
                      controller: _addressController,
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
                      controller: _phoneController,
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
                      controller: _emailController,
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
                      controller: _passwordController,
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

                    if (!authProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          // Check if success is not null, otherwise display error message
                          child: authProvider.success != null
                              ? Text(
                                  authProvider.success!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                  ),
                                )
                              : authProvider.errorMessage !=
                                      null // Check for error message
                                  ? Text(
                                      authProvider.errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16.0,
                                      ),
                                    )
                                  : const SizedBox(), // Empty widget if neither success nor error
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
