import 'dart:async';
import 'package:blissnest/core/journal.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart'; // Import your color theme
import 'package:blissnest/model/journal_response.dart';

class JournalTab extends StatefulWidget {
  const JournalTab({super.key});

  @override
  _JournalTabState createState() => _JournalTabState();
}

class _JournalTabState extends State<JournalTab> {
  final JournalService _journalService = JournalService();
  List<JournalResponseModel> _journalEntries = []; // Store journal entries

  @override
  void initState() {
    super.initState();
    _fetchJournals(); // Fetch journal entries when the tab is initialized
  }

  Future<void> _fetchJournals() async {
    final journals = await _journalService.getJournalsForUser(context: context);
    if (journals != null) {
      setState(() {
        _journalEntries = journals;
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
                'Journal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: peachColor, // Customize your title color
                ),
              ),
              const SizedBox(height: 20), // Space below the title
              Expanded(
                child: ListView.builder(
                  itemCount: _journalEntries.length,
                  itemBuilder: (context, index) {
                    return _buildJournalEntryCard(
                      context,
                      entry: _journalEntries[index],
                      index: index,
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _showJournalEntryDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: peachColor, // Button color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Add New Journal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJournalEntryCard(BuildContext context,
      {required JournalResponseModel entry, required int index}) {
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
              entry.text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Created at: ${entry.createdAt}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showJournalEntryDialog(context,
                        entry: entry.text, index: index);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    final success = await _journalService.deleteJournal(
                      id: entry
                          .id, // Assuming you have an ID in your response model
                      context: context,
                    );
                    if (success) {
                      setState(() {
                        _journalEntries.removeAt(index);
                      });
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJournalEntryDialog(BuildContext context,
      {String? entry, int? index}) {
    final TextEditingController controller = TextEditingController(text: entry);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  peachColor.withOpacity(0.8),
                  Colors.white
                ], // Gradient background
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20), // Padding inside the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  index == null ? 'New Journal Entry' : 'Edit Journal Entry',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15), // Space below the title
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write your journal entry here...',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded edges for input
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: peachColor),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Space below the text field
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (index == null) {
                          // Create new journal entry
                          final journalEntry =
                              await _journalService.createJournal(
                            text: controller.text,
                            context: context,
                          );
                          if (journalEntry != null) {
                            setState(() {
                              _fetchJournals();
                            });
                          }
                        } else {
                          // Update existing journal entry
                          final updatedJournalEntry =
                              await _journalService.updateJournal(
                            id: _journalEntries[index]
                                .id, // Assuming you have an ID
                            text: controller.text,
                            context: context,
                          );
                          if (updatedJournalEntry != null) {
                            setState(() {
                              _fetchJournals();
                            });
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Save',
                        style:
                            TextStyle(color: peachColor), // Save button color
                      ),
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
}
