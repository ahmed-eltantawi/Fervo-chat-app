import 'dart:developer';

import 'package:chat_with_me_now/Views/chat_view.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:chat_with_me_now/models/friend_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  FriendWidget({super.key, required this.friendModel});

  final FriendModel friendModel;
  late String chatId;
  late String? userEmail;
  @override
  Widget build(BuildContext context) {
    try {
      if (userEmail == null) {
        FirebaseAuth.instance.currentUser?.email;
      } else {
        userEmail = ModalRoute.of(context)!.settings.arguments as String;
      }
    } catch (e) {
      userEmail = FirebaseAuth.instance.currentUser?.email;
    }
    return GestureDetector(
      onTap: () {
        getChatId(userEmail!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChatViewBetweenTwo(
                email: userEmail!,
                chatId: chatId,
                friendName: friendModel.name,
                friendImage: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,

                  backgroundImage:
                      friendModel.image != '' || friendModel.image != null
                      ? NetworkImage(friendModel.image!)
                      : null,
                  radius: 30,
                  child: friendModel.image != '' || friendModel.image != null
                      ? null
                      : Text(
                          friendModel.name[0],
                          style: TextStyle(
                            fontSize: 30,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                ),
              );
            },
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            width: double.infinity,
            height: 80,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,

                      backgroundImage: friendModel.image != null
                          ? NetworkImage(friendModel.image!)
                          : null,
                      radius: 30,
                      child: friendModel.image != ''
                          ? null
                          : Text(
                              friendModel.name[0],
                              style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(
                                  context,
                                ).colorScheme.inversePrimary,
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friendModel.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(friendModel.id, style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),

                Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getChatId(String userEmail) {
    log(userEmail + friendModel.id);
    if (userEmail.toLowerCase().compareTo(friendModel.id.toLowerCase()) < 0) {
      chatId = userEmail + friendModel.id;
    } else {
      chatId = friendModel.id + userEmail;
    }
  }
}
