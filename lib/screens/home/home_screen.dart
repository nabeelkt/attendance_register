import 'package:attendance_register/screens/home/widgets/custom_appbar.dart';
import 'package:attendance_register/screens/home/widgets/custom_bottom_navigation.dart';
import 'package:attendance_register/screens/home/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          'HomeScreen',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
