import 'package:attendance_register/core/constants/colors.dart';
import 'package:attendance_register/screens/settings/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  late String profileImageUrl = '';
  @override
  void initState() {
    super.initState();
    fetchProfileImageUrl(); // Call the function to fetch the profile image URL
  }

  Future<void> fetchProfileImageUrl() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Employee')
              .doc(user.uid)
              .get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()!;
        setState(() {
          profileImageUrl =
              data['profileImageUrl'] ?? ''; // Get the profile image URL
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: profileImageUrl.isNotEmpty
                    ? Image.network(
                        profileImageUrl) // Display the profile image using the network image widget
                    : Image.asset(
                        'assets/user/user.png'), // Use a default image if no profile image is available
              ),
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
                  kDivider,
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: ListTile(
                      leading: const Icon(
                        Icons.info,
                      ),
                      title: const Text(
                        'About',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {},
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
                  color: kRed,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kRed,
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
