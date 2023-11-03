import 'package:attendance_register/core/constants/colors.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String label;
  final Widget prefixIcon;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;

  const MyTextField({
    Key? key,
    required this.label,
    required this.prefixIcon,
    required this.controller,
    this.validator,
    required this.obscureText,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: TextFormField(
        style: const TextStyle(color: kBlack),
        controller: widget.controller,
        decoration: InputDecoration(
          labelText: widget.label,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
        obscureText: widget.obscureText ? _obscureText : false,
        validator: widget.validator,
      ),
    );
  }
}
