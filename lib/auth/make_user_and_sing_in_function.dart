import 'package:chat_with_me_now/Views/home_view.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/auth/isTheEmailExists.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> makeUser(context, email, password, userName, {image}) async {
  CollectionReference users = FirebaseFirestore.instance.collection(
    kFriendsCollection,
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
