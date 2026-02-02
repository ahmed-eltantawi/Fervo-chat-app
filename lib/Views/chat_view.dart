import 'dart:developer';

import 'package:chat_with_me_now/Widgets/bubble_chat.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  ChatView({super.key});
  CollectionReference massages = FirebaseFirestore.instance.collection(
    kMassagesCollection,
  );
  TextEditingController controller = TextEditingController();

  static String id = 'ChatView';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: massages.get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('Something went wrong');
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          log('Loading');
          return Text("Loading");
        }

        // if (snapshot.hasData) log(snapshot.data!.docs[0]['text'].toString());

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: kPrimaryColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(kAppIcon, height: 65),
                Text(
                  "Chat",
                  style: TextStyle(color: Colors.white, fontSize: 23),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return BubbleChat(massage: 'Heallo world');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 30,
                  top: 16,
                ),
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    massages.add({'text': value});
                    controller.clear();
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.send),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
