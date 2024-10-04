import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/colors.dart'; // Import your color theme

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: peachColor,
        actions: [
          TextButton(
            onPressed: () {
              // Implement logout functionality here
              Navigator.pop(context); // Placeholder for logout
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: peachColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daily Affirmations & Positive Reminders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 10),
            // Sample motivational quotes (You can replace these with dynamic content)
            const Text(
              '“Believe in yourself and all that you are.”',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '“You are stronger than you think.”',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick Access to Emergency Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: orangeColor,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                // Implement call functionality here
                // Placeholder: This will open the call log or dial a number
                _makeEmergencyCall(context);
              },
              icon: const FaIcon(FontAwesomeIcons.phone),
              label: const Text('Call Emergency Hotline'),
              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _makeEmergencyCall(BuildContext context) {
    // Implement the function to access the phone dialer
    // For example: using url_launcher or similar package
    // Placeholder: Show a snackbar or toast
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening call log...'),
      ),
    );
  }
}
