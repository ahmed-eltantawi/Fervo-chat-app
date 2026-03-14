import 'package:chat_with_me_now/config/constants/images.dart';
import 'package:chat_with_me_now/core/helpers/app_image.dart.dart';
import 'package:chat_with_me_now/core/models/friend_model.dart';
import 'package:flutter/material.dart';

class NoMessagesWidget extends StatelessWidget {
  const NoMessagesWidget({super.key, required this.friendModel});

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
