import 'package:attendance_register/core/constants/colors.dart';
import 'package:attendance_register/screens/history/history_screen.dart';
import 'package:attendance_register/screens/profile/profile_screen.dart';
import 'package:attendance_register/screens/settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

void logout() {
  FirebaseAuth.instance.signOut();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset('assets/user/user.png'),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.home,
                      ),
                      title: const Text(
                        'Home',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // Update the UI based on the item selected
                      },
                    ),
                  ),
                  kDivider,
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                      ),
                      title: const Text(
                        'Profile',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  kDivider,
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.history,
                      ),
                      title: const Text(
                        'History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  kDivider,
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.settings,
                      ),
                      title: const Text(
                        'Settings',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            kDivider,
            // logout button
            const Padding(
              padding: EdgeInsets.only(
                left: 25,
                bottom: 25,
              ),
              child: ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                onTap: logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
