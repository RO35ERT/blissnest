import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> _affirmations = [
    '“Believe in yourself and all that you are.”',
    '“You are stronger than you think.”',
    '“Every day is a second chance.”',
    '“You are enough just as you are.”',
    '“Do not let what you cannot do interfere with what you can do.”',
  ];

  final List<String> _appointments = [
    'Appointment with Dr. Smith on 2024-10-10 at 10:00 AM',
    'Appointment with Dr. Jones on 2024-10-12 at 2:00 PM',
  ];

  final String _tipOfTheDay =
      'Take a 5-minute break every hour to stretch and reset your mind.';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Added space at the top
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Aligns items on the same line
                children: [
                  const Text(
                    'Hello, John Doe',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: peachColor,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement logout functionality
                      _logout();
                    },
                    icon: const Icon(FontAwesomeIcons.arrowRightFromBracket,
                        color: Colors.white),
                    label: const Text('Logout',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          peachColor, // Set the background color to peach
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              // Daily Affirmations section
              SizedBox(
                height: 130, // Set a fixed height for the affirmation container
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _affirmations.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200, // Set a width for each affirmation card
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: orangeColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _affirmations[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              // Tip of the Day Section
              const Text(
                'Tip of the Day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 100,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _tipOfTheDay,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 15),
              // Upcoming Appointments Section
              const Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var appointment in _appointments)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        appointment,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 25),
              const Text(
                'Hot Lines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      _launchInWebView('1234567890');
                    },
                    child: const Text(
                      '123-456-7890',
                      style: TextStyle(
                        fontSize: 16,
                        color: peachColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      _launchInWebView('0987654321');
                    },
                    child: const Text(
                      '098-765-4321',
                      style: TextStyle(
                        fontSize: 16,
                        color: peachColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      _launchInWebView('1112223333');
                    },
                    child: const Text(
                      '111-222-3333',
                      style: TextStyle(
                        fontSize: 16,
                        color: peachColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    // Implement logout functionality here
    // Placeholder: Show a snackbar for demonstration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully!'),
      ),
    );

    // Navigate to the login screen (example)
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> _launchInWebView(String number) async {
    Uri url = Uri.parse("tel:$number");
    try {
      if (await canLaunchUrl(url)) {
        launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        print("Failed to launch");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
