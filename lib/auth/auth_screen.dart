import 'package:attendance_register/screens/home_screen.dart';
import 'package:attendance_register/screens/signin_or_signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
