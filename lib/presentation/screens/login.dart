import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/text_styles.dart';
import '../../theme/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('Login', style: AppTextStyles.button),
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


// Got it! Here's the refined set of features for the mental health app:

// Refined Mental Health App Features:
// Journaling:

// Space for users to write their thoughts, with optional prompts for inspiration.
// Self-Assessment Tools:

// Mental health questionnaires (GAD-7 for anxiety, PHQ-9 for depression) with personalized insights.
// Daily Affirmations & Positive Reminders:

// Motivational quotes and coping strategies sent daily.
// Resource Library:

// Curated mental health resources, articles, podcasts, and videos.
// Appointments:

// Users can create appointments with therapists.
// The therapists will have the ability to approve, reschedule, or decline the appointment through a web app (to be developed later).
// Professional Support Chat:

// Ability to chat with therapists for professional help.
// Emergency Support:

// Quick access to mental health crisis hotlines or emergency contacts.
// Reminders & Notifications:

// Notifications for appointment reminders, affirmations, and regular check-ins.