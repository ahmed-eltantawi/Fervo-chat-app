class MessageModel {
  String massage;
  String id;

  MessageModel({required this.massage, required this.id});
  factory MessageModel.fromJson(json) {
    return MessageModel(massage: json['text'], id: json['id']);
  }
}
