import 'package:chat_with_me_now/config/constants/collections.dart';
import 'package:chat_with_me_now/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  late CollectionReference _chats;
  late String _userEmail;
  late String chatId;

  List<MessageModel> massagesList = [];

  void getCollection({required String userEmail, required String friendEmail}) {
    _userEmail = userEmail;
    if (userEmail.toLowerCase().compareTo(friendEmail.toLowerCase()) < 0) {
      chatId = "$userEmail and $friendEmail";
    } else {
      chatId = "$friendEmail and $userEmail";
    }

    _chats = _chats = FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatId)
        .collection(Collections.kMassagesCollection);
  }

  void onSubmitted({
    required String value,
    required TextEditingController controller,
    required ScrollController scrollController,
  }) {
    if (value.isEmpty) {
    } else {
      _chats.add({
        'text': value,
        Collections.kCreatedAtCollection: DateTime.now(),
        'id': _userEmail,
      });
      controller.clear();

      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 1500),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  void getMassages({required String friendEmail, required String userEmail}) {
    getCollection(friendEmail: friendEmail, userEmail: userEmail);
    emit(ChatLoading());
    _chats
        .orderBy(Collections.kCreatedAtCollection, descending: true)
        .snapshots()
        .listen(
          (event) {
            if (event.docs.isEmpty) {
              emit(ChatNoMassagesYetWidget());
            } else if (event.docs.isNotEmpty) {
              massagesList.clear();
              for (int i = 0; i < event.docs.length; i++) {
                massagesList.add(MessageModel.fromJson(event.docs[i]));
              }
              emit(ChatSusses(massagesList: massagesList));
            }
          },
          onError: (error) {
            emit(ChatError());
          },
        );
  }
}
