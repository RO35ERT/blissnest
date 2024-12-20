import 'package:blissnest/core/appointment.dart';
import 'package:blissnest/core/auth.dart';
import 'package:blissnest/core/rating.dart';
import 'package:blissnest/model/appointment.dart';
import 'package:blissnest/model/user_response.dart';
import 'package:blissnest/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure to add the font_awesome_flutter package

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});

  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  final List<Appointment> _appointments = [];
  final List<UserResponseModel> _therapists = []; // List to hold therapists
  int? selectedTherapist;
  int patient = 3;
  DateTime? selectedDate;
  final AppointmentService _appointmentService = AppointmentService();
  final RatingService _ratingService = RatingService();
  final AuthService _authService = AuthService();
  double rating = 3;

  @override
  void initState() {
    super.initState();
    setId();
    _fetchTherapists();
    _fetchAppointments();
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
    final therapists = await _authService.fetchNonPatients(context);
    if (therapists != null) {
      setState(() {
        _therapists.clear();
        _therapists.addAll(therapists);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointments',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: peachColor,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    return _buildAppointmentCard(
                        context, _appointments[index], index);
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(peachColor),
                ),
                onPressed: () {
                  _showAppointmentDialog(context);
                },
                child: const Text('Add Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, Appointment appointment, int index) {
    bool isOldAppointment = appointment.date.isBefore(DateTime.now());

    return GestureDetector(
      onTap: () {
        if (isOldAppointment) {
          _showRatingBottomSheet(context, appointment);
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Date: ${appointment.date.toLocal()}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                'Status: ${appointment.status}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 5),
              Text(
                appointment.description,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.pen),
                    onPressed: () {
                      _showAppointmentDialog(context,
                          appointment: appointment, index: index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.trash, color: Colors.red),
                    onPressed: () async {
                      await _appointmentService.deleteAppointment(
                          id: appointment.id, context: context);
                      setState(() {
                        _appointments.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDialog(BuildContext context,
      {Appointment? appointment, int? index}) {
    final TextEditingController titleController =
        TextEditingController(text: appointment?.title);
    final TextEditingController dateController = TextEditingController(
        text: appointment?.date.toLocal().toString().split(' ')[0]);
    final TextEditingController descriptionController =
        TextEditingController(text: appointment?.description);
    DateTime selectedDate = appointment?.date ?? DateTime.now();

    // When editing, use the current appointment's therapist if available
    if (appointment != null) {
      selectedTherapist = appointment.doctorId; // Keep current therapist
    }

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index == null ? 'New Appointment' : 'Edit Appointment',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Show therapist selection only for new appointments
                if (index == null)
                  DropdownButton<int>(
                    hint: const Text("Select Therapist"),
                    value: selectedTherapist,
                    items: _therapists.map((UserResponseModel therapist) {
                      return DropdownMenuItem<int>(
                        value: therapist.id,
                        child: Text(therapist.name),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedTherapist = newValue!;
                      });
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Therapist: ${_therapists.firstWhere((t) => t.id == selectedTherapist).name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),

                TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: const InputDecoration(
                    hintText: 'Date (Tap to select)',
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    _selectDate(context, dateController);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (index == null) {
                          // Add new appointment
                          final newAppointment =
                              await _appointmentService.createAppointment(
                            title: titleController.text,
                            date: selectedDate,
                            patientId: patient,
                            doctorId: selectedTherapist!,
                            context: context,
                            description: descriptionController.text,
                          );
                          setState(() {
                            _appointments.add(newAppointment!);
                          });
                        } else {
                          // Update existing appointment, don't change therapist
                          final updatedAppointment =
                              await _appointmentService.updateAppointment(
                            id: appointment!.id.toString(),
                            title: titleController.text,
                            date: selectedDate,
                            context: context,
                            description: descriptionController.text,
                          );
                          setState(() {
                            _appointments[index] = updatedAppointment!;
                          });
                        }

                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate; // Update selected date
        dateController.text =
            pickedDate.toLocal().toString().split(' ')[0]; // Format the date
      });
    }
  }

  void _showRatingBottomSheet(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true, // To ensure the content doesn't get clipped
      builder: (BuildContext context) {
        return Container(
          width: double.infinity, // Set width to take up full screen width
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Rate Your Experience',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: 3, // Default rating
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                      );
                    case 4:
                      return const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      );
                  }
                  return const Icon(Icons.star);
                },
                onRatingUpdate: (r) {
                  rating = r;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(peachColor),
                ),
                onPressed: () {
                  _ratingService.createRating(
                      therapistId: appointment.doctorId,
                      ratingValue: rating,
                      comment: "",
                      context: context);
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
