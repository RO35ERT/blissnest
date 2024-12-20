import 'package:blissnest/presentation/screens/appointment.dart';
import 'package:blissnest/presentation/screens/chat.dart';
import 'package:blissnest/presentation/screens/home_tab.dart';
import 'package:blissnest/presentation/screens/journal.dart';
import 'package:blissnest/presentation/screens/resources.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme/colors.dart'; // Import your custom theme

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens for the different tabs
  final List<Widget> _screens = [
    const HomeTab(),
    const ChatTab(),
    const AppointmentsTab(),
    const JournalTab(),
    const ResourceTab(),
  ];

  // Function to handle tab changes
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: peachColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Let the container show through
          elevation: 0, // Remove BottomNavigationBar's default shadow
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.message),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.calendarCheck),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.book),
              label: 'Journals',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.info),
              label: 'Resources',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor:
              orangeColor, // Highlighted color for the selected tab
          unselectedItemColor: Colors.white, // Unselected icon color
          selectedIconTheme:
              const IconThemeData(size: 24), // Make selected icon larger
          unselectedIconTheme:
              const IconThemeData(size: 24), // Size of unselected icons
          onTap: _onItemTapped,
          showUnselectedLabels: false, // Hide labels for unselected items
        ),
      ),
    );
  }
}
