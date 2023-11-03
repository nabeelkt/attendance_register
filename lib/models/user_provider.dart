import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String firstName = '';
  String lastName = '';
  String dateOfBirth = '';
  String email = '';
  String password = '';

  // Update user data
  void updateUserData(String firstName, String lastName, String dateOfBirth,
      String email, String password) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.dateOfBirth = dateOfBirth;
    this.email = email;
    this.password = password;
    notifyListeners();
  }
}
