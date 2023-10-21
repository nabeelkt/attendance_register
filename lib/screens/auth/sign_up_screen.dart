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

class SignUpScreen extends StatefulWidget {
  final Function()? onPressed;
  const SignUpScreen({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                color: Colors.white,
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
                    'Let\'s create an account for you!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  sizedBox25,
                  MyTextField(
                    controller: emailController,
                    label: 'Email',
                    prefixIcon: const Icon(LineAwesomeIcons.envelope_1),
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
                  MyTextField(
                    controller: confirmPasswordController,
                    prefixIcon: const Icon(LineAwesomeIcons.lock),
                    label: 'Confirm Password',
                    obscureText: true,
                    validator: PasswordValidator.validate,
                  ),
                  sizedBox25,
                  LogButton(
                    text: "Sign Up",
                    onTap: signUserUp,
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
                        'Already have an account?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onPressed,
                        child: const Text(
                          'Login now',
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
