// ignore_for_file: use_build_context_synchronously

import 'package:attendance_register/core/constants/colors.dart';
import 'package:attendance_register/core/constants/constant.dart';
import 'package:attendance_register/services/auth/auth_services.dart';
import 'package:attendance_register/utils/components/buttons/log_button.dart';
import 'package:attendance_register/utils/components/my_textfield.dart';
import 'package:attendance_register/utils/helper/email_validator.dart';
import 'package:attendance_register/utils/helper/password_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  final Function()? onTap;
  const SignInScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<SignInScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showErrorMessage(e.code);
      }
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blueGrey,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(
                color: kWhite,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  sizedBox25,
                  Icon(
                    Icons.fingerprint,
                    size: 50,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  sizedBox25,
                  const Text(
                    "A T T E N D  M E",
                    style: TextStyle(fontSize: 20),
                  ),
                  sizedBox25,
                  const Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  sizedBox25,
                  MyTextField(
                    controller: emailController,
                    prefixIcon: const Icon(LineAwesomeIcons.envelope_1),
                    label: 'Email',
                    obscureText: false,
                    validator: EmailValidator.validate,
                  ),
                  sizedBox10,
                  MyTextField(
                    controller: passwordController,
                    prefixIcon: const Icon(LineAwesomeIcons.lock),
                    label: 'Password',
                    obscureText: true,
                    validator: PasswordValidator.validate,
                  ),
                  sizedBox10,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ForgotPasswordScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  sizedBox25,
                  LogButton(
                    text: "Sign In",
                    onTap: signUserIn,
                  ),
                  sizedBox50,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    child: SignInButton(
                      buttonType: ButtonType.google,
                      onPressed: () => AuthService().signInWithGoogle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You don\'t have an account?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      sizeBox4,
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
