import 'package:attendance_register/core/constants/colors.dart';
import 'package:attendance_register/core/constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late double screenWidth;
  //bool isPunchedIn = false;
  late String currentDocumentId;
  //String punchInTime = '--/--';
  //String punchOutTime = '--/--';
  late String punchInTime = '--/--';
  late String punchOutTime = '--/--';
  late SharedPreferences prefs;
  late bool isPunchedIn;
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _retrievePunchTimes();
      isPunchedIn = prefs.getBool('isPunchedIn') ?? false;
    });
  }

  void _retrievePunchTimes() {
    setState(() {
      punchInTime = prefs.getString('punchInTime') ?? '--/--';
      punchOutTime = prefs.getString('punchOutTime') ?? '--/--';
    });
  }

  void _savePunchInStatus(bool status) {
    prefs.setBool('isPunchedIn', status);
  }

  void _savePunchInTime(String time) {
    prefs.setString('punchInTime', time);
  }

  void _savePunchOutTime(String time) {
    prefs.setString('punchOutTime', time);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userID = user.uid;
      print('User ID: $userID');
    } else {
      print('No user currently signed in.');
    }

    String displayName =
        user != null ? user.displayName ?? 'No Name Found' : 'No Name Found';
    screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Welcome',
              style: TextStyle(
                fontFamily: 'NexaRegular',
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              displayName,
              style: TextStyle(
                fontFamily: 'NexaBold',
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsetsDirectional.only(top: 30),
            child: Text(
              'Today\'s Status',
              style: TextStyle(
                fontFamily: 'NexaBold',
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 30),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                )
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Punch In',
                        style: TextStyle(
                          fontFamily: 'NexaRegular',
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        punchInTime,
                        style: TextStyle(
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Punch Out',
                        style: TextStyle(
                          fontFamily: 'NexaRegular',
                          fontSize: screenWidth / 20,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        punchOutTime,
                        style: TextStyle(
                          fontFamily: 'NexaBold',
                          fontSize: screenWidth / 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                text: DateTime.now().day.toString(),
                style: TextStyle(
                  color: kPrimary,
                  fontSize: screenWidth / 18,
                  fontFamily: "NexaBold",
                ),
                children: [
                  TextSpan(
                    text: DateFormat(' MMMM yyyy').format(DateTime.now()),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: screenWidth / 20,
                      fontFamily: "NexaBold",
                    ),
                  ),
                ],
              ),
            ),
          ),
          sizedBox10,
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: screenWidth / 20,
                      fontFamily: "NexaRegular",
                    ),
                  ),
                );
              }),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Builder(
              builder: (context) {
                final GlobalKey<SlideActionState> key = GlobalKey();
                return SlideAction(
                  text:
                      isPunchedIn ? 'Slide to Punch Out' : 'Slide to Punch In',
                  textStyle: TextStyle(
                    color: kPrimary,
                    fontSize: screenWidth / 20,
                    fontFamily: 'NexaRegular',
                  ),
                  outerColor: Colors.white,
                  innerColor: kPrimary,
                  key: key,
                  onSubmit: () async {
                    String formattedTime =
                        DateFormat('hh:mm a').format(DateTime.now());
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(DateTime.now());

                    if (isPunchedIn) {
                      await FirebaseFirestore.instance
                          .collection('Employee')
                          .doc(user!.uid)
                          .collection('Record')
                          .doc(formattedDate)
                          .collection('Punches')
                          .add({
                        'punchOut': formattedTime,
                      });
                      setState(() {
                        isPunchedIn = false; // Toggle the punch-in status
                        punchOutTime = formattedTime; // Update punch-out time
                      });
                      _savePunchOutTime(formattedTime);
                      _savePunchInStatus(false);
                    } else {
                      await FirebaseFirestore.instance
                          .collection('Employee')
                          .doc(user!.uid)
                          .collection('Record')
                          .doc(formattedDate)
                          .collection('Punches')
                          .add({
                        'punchIn': formattedTime,
                      });
                      setState(() {
                        isPunchedIn = true; // Toggle the punch-in status
                        punchInTime = formattedTime; // Update punch-in time
                      });
                      _savePunchInTime(formattedTime);
                      _savePunchInStatus(true);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
