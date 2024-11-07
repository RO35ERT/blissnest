import 'package:blissnest/core/appointment.dart';
import 'package:blissnest/core/auth.dart';
import 'package:blissnest/model/appointment.dart';
import 'package:blissnest/model/therapist.dart';
import 'package:blissnest/model/user_model.dart';
import 'package:blissnest/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Appointment> _appointments = [];
  final List<TherapistModel> _therapists = [];
  final AuthService _authService = AuthService();
  final AppointmentService _appointmentService = AppointmentService();
  int patient = 3;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchAppointments();
    _fetchTherapists();
  }

  void setId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      patient = prefs.getInt("id") ?? 3;
    });
  }

  Future<void> _fetchAppointments() async {
    final appointments = await _appointmentService.getAppointmentsByPatientId(
        patientId: patient, context: context);
    if (appointments != null) {
      setState(() {
        _appointments.clear();
        _appointments.addAll(appointments);
      });
    }
  }

  Future<void> _fetchTherapists() async {
    final therapists = await _authService.fetchTherapists(context);
    if (therapists != null) {
      setState(() {
        _therapists.clear();
        _therapists.addAll(therapists);
      });
    }
  }

  Future<void> _fetchUser() async {
    final user = await _authService.fetchCurrentUser(context);
    setState(() {
      _user = user;
    });
  }

  final List<String> _affirmations = [
    '“Believe in yourself and all that you are.”',
    '“You are stronger than you think.”',
    '“Every day is a second chance.”',
    '“You are enough just as you are.”',
    '“Do not let what you cannot do interfere with what you can do.”',
  ];

  final String _tipOfTheDay =
      'Take a 5-minute break every hour to stretch and reset your mind.';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Added space at the top
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Aligns items on the same line
                  children: [
                    _user != null
                        ? Text(
                            'Hello, ${_user?.name}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: peachColor,
                            ),
                          )
                        : const Text(
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
                  height:
                      130, // Set a fixed height for the affirmation container
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
                    for (var appointment in _appointments
                        .take(2)
                        .toList()
                        .reversed) // Show last 2 appointments
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Rounded corners for card
                        ),
                        elevation: 4, // Card elevation
                        margin: const EdgeInsets.symmetric(
                            vertical: 10), // Spacing between cards
                        child: Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Padding inside the card
                          child: Text(
                            "${appointment.title} at ${formatDate(appointment.date)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 25),
                // Therapist Avatars Section (Horizontal Scroll)
                const Text(
                  'Therapists',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90, // Height for avatars
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _therapists.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Show modal when avatar is clicked
                          _showTherapistDetailsModal(
                              context, _therapists[index]);
                        },
                        child: Container(
                          height: 60,
                          margin: const EdgeInsets.only(right: 15),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: peachColor,
                                radius: 25,
                                child: Text(
                                  _therapists[index].name[
                                      0], // First letter of therapist's name
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _therapists[index].name,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Hot Lines Section
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
                        'Emergency',
                        style: TextStyle(
                          fontSize: 16,
                          color: peachColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        _launchInWebView('0987654321');
                      },
                      child: const Text(
                        'Call Center',
                        style: TextStyle(
                          fontSize: 16,
                          color: peachColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        _launchInWebView('1112223333');
                      },
                      child: const Text(
                        'Customer Care',
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
      ),
    );
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("key");
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

  void _showTherapistDetailsModal(
      BuildContext context, TherapistModel therapist) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      child: Text(
                        therapist.name[0], // Display initial in the avatar
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      therapist.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Email: ${therapist.email}",
                  style: const TextStyle(fontSize: 20),
                ),
              ), // Example details
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () => {_launchInWebView(therapist.phone)},
                  child: Text("Phone: ${therapist.phone}",
                      style: const TextStyle(fontSize: 20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Qualification: ${therapist.qualification}",
                    style: const TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text("Facility: ${therapist.facility}",
                    style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
