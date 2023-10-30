import 'package:attendance_register/screens/home/widgets/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            LineAwesomeIcons.angle_left,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: const Center(child: Text('Settings Feature is coming soon')),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
