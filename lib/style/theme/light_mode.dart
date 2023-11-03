import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade500,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade300,
    inversePrimary: Colors.grey.shade700,
  ),
  // textTheme: ThemeData.light().textTheme.apply(
  //       bodyColor: Colors.grey[800],
  //       displayColor: Colors.black,
  //     ),
);
