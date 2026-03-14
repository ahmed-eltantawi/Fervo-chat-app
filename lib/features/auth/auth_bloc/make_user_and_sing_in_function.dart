import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/constants/collections.dart';
import 'package:chat_with_me_now/Features/auth/isTheEmailExists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> makeUser(
  BuildContext context,
  String email,
  String password,
  String userName, {
  image,
}) async {
  CollectionReference users = FirebaseFirestore.instance.collection(
    Collections.kFriendsCollection,
  );
  if (!await isThisEmailExists(email)) {
    users.add({
      'id': email,
      'name': userName,
      'createdAt': DateTime.now(),
      'image': image ?? '',
    });
  }

  Navigator.pushNamedAndRemoveUntil(
    context,
    HomeView.id,
    (route) => false,
    arguments: email,
  );
}
