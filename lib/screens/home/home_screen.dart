import 'package:attendance_register/screens/home/widgets/custom_appbar.dart';
import 'package:attendance_register/screens/home/widgets/custom_drawer.dart';
import 'package:attendance_register/screens/today/today_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        title: 'Home',
      ),
      drawer: const CustomDrawer(),
      body: const TodayScreen(),
    );
  }
}
