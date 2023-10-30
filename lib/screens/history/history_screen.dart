import 'package:attendance_register/screens/home/widgets/custom_bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedIndex = 1;
  User? user = FirebaseAuth.instance.currentUser;
  double screenHeight = 0;
  double screenWidth = 0;

  DateTime selectedDate = DateTime.now();
  late FirebaseFirestore firestore;
  List<String> dataList = [];

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023, 10),
      lastDate: DateTime(2999),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        fetchDataFromFirestore();
      });
    }
  }

  Future<void> fetchDataFromFirestore() async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    QuerySnapshot querySnapshot = await firestore
        .collection('Employee')
        .doc(user?.uid)
        .collection('Record')
        .doc(formattedDate)
        .collection('Punches')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      dataList = querySnapshot.docs
          .map((e) {
            if (e.data() != null) {
              Map<String, dynamic> data = e.data()! as Map<String, dynamic>;
              if (data.containsKey('punchIn')) {
                return 'Punch In: ${data['punchIn']} at ${data['completeAddress']}';
              } else if (data.containsKey('punchOut')) {
                return 'Punch Out: ${data['punchOut']} at ${data['completeAddress']}';
              } else {
                return '';
              }
            }
          })
          .toList()
          .cast<String>();
    });
  }

  Widget buildPunchTile(String data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'History',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            LineAwesomeIcons.angle_left,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Attendance History",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: screenWidth / 18,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: screenWidth / 24,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 700,
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return buildPunchTile(dataList[index]);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
