import 'package:chat_with_me_now/core/models/friend_model.dart';
import 'package:chat_with_me_now/core/models/message_model.dart';
import 'package:chat_with_me_now/core/widgets/error_widget.dart';
import 'package:chat_with_me_now/features/chat/cubit/chat_cubit.dart';
import 'package:chat_with_me_now/features/chat/widgets/chat_bubble.dart';
import 'package:chat_with_me_now/features/chat/widgets/message_text_field_widget.dart';
import 'package:chat_with_me_now/features/chat/widgets/no_messages_yet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatViewBetweenTwo extends StatelessWidget {
  ChatViewBetweenTwo({
    super.key,
    required this.userEmail,
    required this.friendModel,
  });
  static String id = 'ChatViewBetweenTwo';
  final String userEmail;
  final FriendModel friendModel;
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> massagesList = [];

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatCubit>(
      context,
    ).getMassages(friendEmail: friendModel.id, userEmail: userEmail);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,

        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(friendModel.name, style: TextStyle(fontSize: 23)),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSusses) {
                  massagesList = state.massagesList;
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is ChatNoMassagesYetWidget) {
                  return FittedBox(
                    child: NoMessagesWidget(friendModel: friendModel),
                  );
                } else if (state is ChatSusses) {
                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: massagesList.length,
                    itemBuilder: (context, index) {
                      return massagesList[index].id == userEmail
                          ? MyChatBubble(massage: massagesList[index])
                          : FriendChatBubble(massage: massagesList[index]);
                    },
                  );
                } else {
                  return CustomErrorWidget();
                }
              },
            ),
          ),
          MessageTextFieldWidget(scrollController: _scrollController),
        ],
      ),
    );
  }
}
