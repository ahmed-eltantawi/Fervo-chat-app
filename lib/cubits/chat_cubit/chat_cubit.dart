import 'package:chat_with_me_now/constants/collections.dart';
import 'package:chat_with_me_now/models/massage_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  late CollectionReference _massages;
  late String _userEmail;
  List<MassageModel> massagesList = [];

  CollectionReference getChatId({
    required String userEmail,
    required String friendEmail,
  }) {
    String chatId;
    _userEmail = userEmail;
    if (userEmail.toLowerCase().compareTo(friendEmail.toLowerCase()) < 0) {
      chatId = userEmail + friendEmail;
    } else {
      chatId = friendEmail + userEmail;
    }

    _massages = FirebaseFirestore.instance.collection(chatId);
    return _massages;
  }

  void onSubmitted({
    required String value,
    required TextEditingController controller,
    required ScrollController scrollController,
  }) {
    if (value.isEmpty) {
    } else {
      _massages.add({
        'text': value,
        kCreatedAtCollection: DateTime.now(),
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
    getChatId(friendEmail: friendEmail, userEmail: userEmail);
    emit(ChatLoading());
    _massages
        .orderBy(kCreatedAtCollection, descending: true)
        .snapshots()
        .listen(
          (event) {
            if (event.docs.isEmpty) {
              emit(ChatNoMassagesYetWidget());
            } else if (event.docs.isNotEmpty) {
              massagesList.clear();
              for (int i = 0; i < event.docs.length; i++) {
                massagesList.add(MassageModel.fromJson(event.docs[i]));
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
