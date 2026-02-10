import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/helper/user_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> registerFunction({context, email, password, userName}) async {
  UserCredential userCredential = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: password);

  CollectionReference users = FirebaseFirestore.instance.collection(
    kFriendsCollection,
  );
  await userLogin(context, email, password);
  users.add({
    'id': email,
    'name': userName,
    'createdAt': DateTime.now(),
    'image': '',
  });

  Navigator.pushNamedAndRemoveUntil(
    context,
    HomeView.id,
    (route) => false,
    arguments: email,
  );
}
