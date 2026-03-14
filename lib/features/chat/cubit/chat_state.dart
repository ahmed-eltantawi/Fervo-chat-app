part of 'chat_cubit.dart';

abstract class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatSendMassage extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatNoMassagesYetWidget extends ChatState {}

final class ChatSusses extends ChatState {
  List<MessageModel> massagesList;
  ChatSusses({required this.massagesList});
}

final class ChatError extends ChatState {}
