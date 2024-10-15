import 'package:blissnest/core/auth.dart';
import 'package:blissnest/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/text_styles.dart';
import '../../theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  void checkStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool("key");
    if (loggedIn != null && loggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final loginModel = UserLoginModel(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final result = await _authService.loginUser(loginModel);

    if (result == "Login Successful") {
      // Navigate to the home screen or any other page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = result;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    // Welcome Message
                    Text(
                      'Welcome Back',
                      style: AppTextStyles.header.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please login to continue',
                      style: AppTextStyles.body.copyWith(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.fromLTRB(
                              10, 10, 0, 10), // Center icon vertically
                          child: FaIcon(
                            FontAwesomeIcons.envelope,
                            size: 22, // Increased size
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
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.fromLTRB(
                              10, 10, 0, 10), // Center icon vertically
                          child: FaIcon(
                            FontAwesomeIcons.lock,
                            size: 22, // Increased size
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

                    // Login Button
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
                          _login();
                        },
                        child: Text('Login', style: AppTextStyles.button),
                      ),
                    ),

                    if (!_isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          // Check if success is not null, otherwise display error message
                          child: _errorMessage != null
                              ? Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16.0,
                                  ),
                                )
                              : const SizedBox(), // Empty widget if neither success nor error
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Register Link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text(
                          'Don\'t have an account? Register here.',
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


// Mental health questionnaires (GAD-7 for anxiety, PHQ-9 for depression) with personalized insights.
