// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:attendance_register/core/constants/colors.dart';
import 'package:attendance_register/core/constants/constant.dart';
import 'package:attendance_register/utils/components/my_textfield.dart';
import 'package:attendance_register/utils/helper/dob_validator.dart';
import 'package:attendance_register/utils/helper/name_validator.dart';
import 'package:attendance_register/utils/helper/password_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

// ignore: must_be_immutable
class UpdateProfileScreen extends StatefulWidget {
  final Function() onProfileUpdated;
  const UpdateProfileScreen({Key? key, required this.onProfileUpdated})
      : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String imagePath = '';
  late String profileImageUrl = '';
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
// Function to fetch user data
  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch other user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('Employee')
              .doc(user.uid)
              .get();
      if (mounted) {
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data()!;
          setState(() {
            _firstNameController.text = data['first name'];
            _lastNameController.text = data['last name'];
            _dateOfBirthController.text = data['date of birth'];
            _emailController.text = data['email'];
            _passwordController.text = data['password'];
            profileImageUrl = data['profileImageUrl'] ?? '';
          });
        }
      }
    }
  }

  Future<void> updateUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Update the email in Firebase Authentication
        if (_emailController.text != user.email) {
          await user.updateEmail(_emailController.text);
        }
        // Update other user data in Firestore
        await FirebaseFirestore.instance
            .collection('Employee')
            .doc(user.uid)
            .update({
          'first name': _firstNameController.text,
          'last name': _lastNameController.text,
          'date of birth': _dateOfBirthController.text,
          //'email': _emailController.text,
          'password': _passwordController.text,
        });
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
        onDataUpdated();
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
          ),
        );
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path; // Store the path of the selected image
      });
      await uploadImageToFirebase(File(pickedFile.path));
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      // Save the image URL in the database
      await saveImageUrlToDatabase(imageUrl);
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image to Firebase: $e');
      }
    }
  }

  Future<void> saveImageUrlToDatabase(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Employee')
            .doc(user.uid)
            .update({'profileImageUrl': url});
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully'),
          ),
        );
        // Call the refreshData function to update the data
        getUserData();
        // Call updateUserProfile to save the image URL to the database
        await updateUserProfile(); // Updated to await the updateUserProfile function call
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile picture: $e'),
          ),
        );
      }
    }
  }

  void onDataUpdated() {
    // Perform the update logic if needed
    widget.onProfileUpdated();
  }

  @override
  void initState() {
    super.initState();
    // Call the getUserData function to fetch the user data
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            LineAwesomeIcons.angle_left,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: profileImageUrl.isNotEmpty
                          ? Image.network(
                              profileImageUrl) // Display the profile image using the network image widget
                          : imagePath.isEmpty
                              ? const Image(
                                  image: AssetImage(tProfileImage),
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: pickImage,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.withOpacity(0.9),
                        ),
                        child: const Icon(LineAwesomeIcons.alternate_pencil,
                            size: 18.0, color: kBlack),
                      ),
                    ),
                  )
                ],
              ),
              sizedBox50,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: [
                      MyTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        prefixIcon: const Icon(LineAwesomeIcons.user),
                        obscureText: false,
                        validator: FirstNameValidator.validate,
                      ),
                      sizedBox10,
                      MyTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        prefixIcon: const Icon(LineAwesomeIcons.user_1),
                        obscureText: false,
                        validator: LastNameValidator.validate,
                      ),
                      sizedBox10,
                      MyTextField(
                        controller: _dateOfBirthController,
                        label: 'Date of Birth',
                        prefixIcon: const Icon(LineAwesomeIcons.calendar),
                        obscureText: false,
                        validator: DateOfBirthValidator.validate,
                      ),
                      // sizedBox10,
                      // MyTextField(
                      //   controller: _emailController,
                      //   label: 'Email',
                      //   prefixIcon: const Icon(LineAwesomeIcons.envelope_1),
                      //   obscureText: false,
                      //   validator: EmailValidator.validate,
                      // ),
                      sizedBox10,
                      MyTextField(
                        controller: _passwordController,
                        prefixIcon: const Icon(LineAwesomeIcons.lock),
                        label: 'Password',
                        obscureText: true,
                        validator: PasswordValidator.validate,
                      ),
                      sizedBox25,
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            updateUserProfile();
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(
                              color: kBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
