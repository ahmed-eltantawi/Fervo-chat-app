import 'package:chat_with_me_now/constants/images.dart';
import 'package:chat_with_me_now/helper/get_image_function.dart';
import 'package:chat_with_me_now/models/friend_model.dart';
import 'package:flutter/material.dart';

class NoMassagesWidget extends StatelessWidget {
  const NoMassagesWidget({super.key, required this.friendModel});

  final FriendModel friendModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppImage(image: Assets.imagesNoMassageYet, height: 350),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Start a massage with "),
            Text(
              friendModel.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(" now"),
          ],
        ),
      ],
    );
  }
}
