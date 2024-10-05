import 'package:blissnest/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Ensure to add the font_awesome_flutter package

class Therapist {
  final String id;
  final String name;

  Therapist({required this.id, required this.name});
}

class Appointment {
  String title;
  DateTime date;
  String therapist;
  String description;
  String status;

  Appointment({
    required this.title,
    required this.date,
    required this.therapist,
    required this.description,
    required this.status,
  });
}

class AppointmentsTab extends StatefulWidget {
  const AppointmentsTab({super.key});

  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  final List<Appointment> _appointments =
      []; // List to hold appointment entries
  final List<Therapist> _therapists = [
    Therapist(id: '1', name: 'Dr. John Smith'),
    Therapist(id: '2', name: 'Dr. Jane Doe'),
    Therapist(id: '3', name: 'Dr. Emily Johnson'),
  ];

  String? selectedTherapist;

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
              const SizedBox(height: 20), // Space below the title
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
                  _showAppointmentDialog(
                      context); // Show dialog for adding new appointment
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
              'Therapist: ${appointment.therapist}',
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
                  onPressed: () {
                    setState(() {
                      _appointments.removeAt(index); // Remove the appointment
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
    String status = appointment?.status ?? 'pending';
    DateTime selectedDate = appointment?.date ?? DateTime.now();

    // Reset selectedTherapist to the current appointment's therapist if editing
    if (appointment != null) {
      selectedTherapist = appointment.therapist;
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
                const SizedBox(height: 15), // Space below the title
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  hint: const Text("Select Therapist"),
                  value: selectedTherapist,
                  items: _therapists.map((Therapist therapist) {
                    return DropdownMenuItem<String>(
                      value: therapist.name,
                      child: Text(therapist.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTherapist = newValue; // Update selected therapist
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  readOnly: true, // Make the TextField read-only
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
                const SizedBox(height: 20), // Space below the dropdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        final newAppointment = Appointment(
                          title: titleController.text,
                          date: selectedDate,
                          therapist:
                              selectedTherapist ?? "No therapist selected",
                          description: descriptionController.text,
                          status: status,
                        );

                        setState(() {
                          if (index == null) {
                            _appointments.add(newAppointment);
                          } else {
                            _appointments[index] = newAppointment;
                          }
                        });

                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
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
        dateController.text =
            pickedDate.toLocal().toString().split(' ')[0]; // Format the date
      });
    }
  }
}
