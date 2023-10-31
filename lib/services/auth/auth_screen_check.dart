import 'package:attendance_register/screens/auth/signin_or_signup.dart';
import 'package:attendance_register/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreenCheck extends StatefulWidget {
  const AuthScreenCheck({super.key});

  @override
  State<AuthScreenCheck> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreenCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is logged in
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          //user is not logged in
          else {
            return const SignInOrSignUp();
          }
        },
      ),
    );
  }
}
