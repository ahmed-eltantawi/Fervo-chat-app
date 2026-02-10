import 'package:chat_with_me_now/Widgets/chat_bubble.dart';
import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/models/massage_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChatViewBetweenTwo extends StatefulWidget {
  const ChatViewBetweenTwo({
    super.key,
    required this.chatId,
    required this.email,
    required this.friendName,
    required this.friendImage,
  });
  static String id = 'ChatViewBetweenTwo';
  final String chatId;
  final String email;
  final String friendName;
  final CircleAvatar friendImage;

  @override
  State<ChatViewBetweenTwo> createState() => _ChatViewState();
}

@override
class _ChatViewState extends State<ChatViewBetweenTwo> {
  final ScrollController _scrollController = ScrollController();
  late CollectionReference massages = FirebaseFirestore.instance.collection(
    widget.chatId,
  );
  String massage = '';
  TextEditingController controller = TextEditingController();

  List<MassageModel> massagesList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: massages
          .orderBy(kCreatedAtCollection, descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.hasData) {
          massagesList.clear();
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            massagesList.add(MassageModel.fromJson(snapshot.data!.docs[i]));
          }
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,

            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(widget.friendName, style: TextStyle(fontSize: 23)),
          ),
          body: snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : massagesList.isEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset(
                            "assets/images/no_massage_yet.json",
                            height: 350,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Start a massage with "),
                              Text(
                                widget.friendName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(" now"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    MassageTextField(context),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return massagesList[index].id == widget.email
                              ? MyChatBubble(massage: massagesList[index])
                              : FriendChatBubble(massage: massagesList[index]);
                        },
                      ),
                    ),
                    MassageTextField(context),
                  ],
                ),
        );
      },
    );
  }

  Padding MassageTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 16),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          onSubmitted(value);
        },
        onChanged: (value) {
          massage = value;
        },
        decoration: InputDecoration(
          hintText: 'Sent Massage',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              onSubmitted(massage);
            },
          ),

          border: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void onSubmitted(String value) {
    if (value.isEmpty) {
    } else {
      massages.add({
        'text': value,
        kCreatedAtCollection: DateTime.now(),
        'id': widget.email,
      });
      controller.clear();

      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 3000),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
    massage = '';
  }
}
