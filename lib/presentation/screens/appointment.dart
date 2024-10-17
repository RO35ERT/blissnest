import 'dart:ffi';

import 'package:blissnest/core/appointment.dart';
import 'package:blissnest/core/auth.dart';
import 'package:blissnest/model/appointment.dart';
import 'package:blissnest/model/user_model.dart';
import 'package:blissnest/model/user_response.dart';
import 'package:blissnest/theme/colors.dart';
import 'package:flutter/material.dart';
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
  final AuthService _authService = AuthService();

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
    print(therapists);
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
    return Card(
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

    // Reset selectedTherapist to the current appointment's therapist if editing
    if (appointment != null) {
      selectedTherapist = 0;
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
                DropdownButton<int>(
                  hint: const Text("Select Therapist"),
                  value: selectedTherapist,
                  items: _therapists.map((UserResponseModel therapist) {
                    return DropdownMenuItem<int>(
                      value: therapist.id, // Assuming name field exists
                      child: Text(therapist.name),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedTherapist = newValue!;
                    });
                  },
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
                                  description: descriptionController.text);
                          setState(() {
                            _appointments.add(newAppointment!);
                          });
                        } else {
                          final newA =
                              await _appointmentService.updateAppointment(
                                  id: "0",
                                  title: titleController.text,
                                  date: selectedDate,
                                  context: context,
                                  description: descriptionController.text);
                          setState(() {
                            _appointments[index] = newA!;
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
}
