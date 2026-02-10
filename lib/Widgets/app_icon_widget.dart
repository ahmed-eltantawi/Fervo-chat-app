import 'package:chat_with_me_now/helper/consts.dart';
import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundImage: AssetImage(kAppIcon), radius: 80),
        SizedBox(height: 10),
        Text(
          'Fervo Chat',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontFamily: 'Pacifico',
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
