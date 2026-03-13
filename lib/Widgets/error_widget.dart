import 'package:chat_with_me_now/constants/images.dart';
import 'package:chat_with_me_now/helper/get_image_function.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppImage(image: Assets.imagesError, width: 250, fit: BoxFit.contain),
          const Text(
            'There is some thing wrong, try again',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 300),
        ],
      ),
    );
  }
}
