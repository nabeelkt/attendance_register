import 'package:attendance_register/screens/sign_in_screen.dart';
import 'package:attendance_register/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class SignInOrSignUp extends StatefulWidget {
  const SignInOrSignUp({super.key});

  @override
  State<SignInOrSignUp> createState() => _LoginOrRegisterScreen();
}

class _LoginOrRegisterScreen extends State<SignInOrSignUp> {
  //initially show login page
  bool showLogInPage = true;
//toggle between login page and register page
  void togglePages() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return SignInScreen(
        onTap: togglePages,
      );
    } else {
      return SignUpScreen(
        onTap: togglePages,
      );
    }
  }
}
