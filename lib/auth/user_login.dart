import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> userLogin(
  BuildContext context,
  String email,
  String password,
) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}
