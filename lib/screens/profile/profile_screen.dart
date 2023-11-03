import 'package:attendance_register/core/constants/colors.dart';
import 'package:attendance_register/core/constants/constant.dart';
import 'package:attendance_register/screens/profile/update_profile_screen.dart';
import 'package:attendance_register/screens/profile/widget/profile_menu.dart';
import 'package:attendance_register/screens/settings/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String firstName = '';
  late String lastName = '';
  late String email = '';
  late String displayName = '';
  late String profileImageUrl = '';
  @override
  void initState() {
    super.initState();
    // Call the getUserData function to fetch the user data
    getUserData;
  }

  // Function to fetch user data
  Future<void> get getUserData async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch user data from Firestore
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection('Employee')
                .doc(user.uid)
                .get();
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data()!;
          setState(() {
            firstName = data['first name'] ?? '';
            lastName = data['last name'] ?? '';
            email = data['email'] ?? '';
            displayName = '$firstName $lastName';
            profileImageUrl = data['profileImageUrl'] ?? '';
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching user data: $e');
        }
      }
    }
  }

  // Refresh function to update the data when changes are made
  void refreshData() {
    setState(() {
      // Call the getUserData function to update the data
      getUserData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: profileImageUrl.isNotEmpty
                            ? Image.network(profileImageUrl)
                            : Image.asset(tProfileImage),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateProfileScreen(
                            onProfileUpdated: () {
                              // Call the refreshData function to update the data
                              refreshData();
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: kBlack,
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                // Menu
                ProfileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                  title: "About",
                  icon: LineAwesomeIcons.info,
                  onPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
