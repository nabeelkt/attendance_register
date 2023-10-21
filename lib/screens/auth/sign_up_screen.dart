import 'package:attendance_register/core/constants/constant.dart';
import 'package:attendance_register/services/auth/auth_services.dart';
import 'package:attendance_register/utils/components/buttons/log_button.dart';
import 'package:attendance_register/utils/components/my_textfield.dart';
import 'package:attendance_register/utils/helper/dob_validator.dart';
import 'package:attendance_register/utils/helper/email_validator.dart';
import 'package:attendance_register/utils/helper/name_validator.dart';
import 'package:attendance_register/utils/helper/password_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    List<TextEditingController> controllers = [
      _emailController,
      _passwordController,
      _confirmPasswordController,
      _firstNameController,
      _lastNameController,
      _dateOfBirthController,
    ];
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await addUserDetails({
        'first name': _firstNameController.text.trim(),
        'last name': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'date of birth': _dateOfBirthController.text.trim(),
        'password': _passwordController.text.trim(),
      });
    }
  }

  Future addUserDetails(Map<String, String> userDetails) async {
    await FirebaseFirestore.instance.collection('Employee').add(userDetails);
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
                  sizedBox10,
                  MyTextField(
                    controller: _emailController,
                    label: 'Email',
                    prefixIcon: const Icon(LineAwesomeIcons.envelope_1),
                    obscureText: false,
                    validator: EmailValidator.validate,
                  ),
                  sizedBox10,
                  MyTextField(
                    controller: _passwordController,
                    prefixIcon: const Icon(LineAwesomeIcons.lock),
                    label: 'Password',
                    obscureText: true,
                    validator: PasswordValidator.validate,
                  ),
                  sizedBox10,
                  MyTextField(
                    controller: _confirmPasswordController,
                    prefixIcon: const Icon(LineAwesomeIcons.user_lock),
                    label: 'Confirm Password',
                    obscureText: true,
                    validator: ConfirmPasswordValidator.validate,
                  ),
                  sizedBox25,
                  LogButton(
                    text: "Sign Up",
                    onTap: signUp,
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
