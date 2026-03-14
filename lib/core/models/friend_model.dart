class FriendModel {
  final String name;
  final String id;
  String? image;

  FriendModel({required this.name, required this.id, this.image});

  factory FriendModel.fromJson(json) {
    return FriendModel(
      name: json['name'],
      id: json['id'],
      image: json['image'],
    );
  }
}
