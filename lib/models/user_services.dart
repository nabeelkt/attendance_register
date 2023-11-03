import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserServices {
  static Future<String> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    String displayName = '';
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await FirebaseFirestore.instance
                .collection('Employee')
                .doc(user.uid)
                .get();
        if (documentSnapshot.exists) {
          Map<String, dynamic> data = documentSnapshot.data()!;
          String firstName = data['first name'] ?? '';
          String lastName = data['last name'] ?? '';
          displayName = '$firstName $lastName';
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching user data: $e');
        }
      }
    }
    return displayName;
  }
}
