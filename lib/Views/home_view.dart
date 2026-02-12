import 'package:chat_with_me_now/Views/drawer_view.dart';
import 'package:chat_with_me_now/Widgets/friend_widget.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/models/friend_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  static String id = 'HomeView';

  final CollectionReference friends = FirebaseFirestore.instance.collection(
    kFriendsCollection,
  );

  List<FriendModel> friendList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: friends.orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.hasData) {
          friendList.clear();
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            friendList.add(FriendModel.fromJson(snapshot.data!.docs[i]));
          }
        }
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,

          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,

            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'H O M E',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),

          drawer: DrawerView(),
          body: snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return FriendWidget(friendModel: friendList[index]);
                    },
                  ),
                ),
        );
      },
    );
  }
}
