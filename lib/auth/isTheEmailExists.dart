import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isThisEmailExists(String email) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    log("Error checking email: ${e.toString()}");
    return false;
  }
}
