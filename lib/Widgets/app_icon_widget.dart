import 'package:chat_with_me_now/constants/images.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:chat_with_me_now/helper/get_image_function.dart';
import 'package:flutter/material.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: 90,
          decoration: BoxDecoration(
            color: context.onPrimary,
            boxShadow: [
              BoxShadow(
                color: context.onPrimary.withValues(alpha: 0.4),
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(35),
          ),
          child: AppImage(image: Assets.imagesAppIcon),
        ),
        SizedBox(height: 10),
        Text(
          'Fervo Chat',
          style: TextStyle(
            fontSize: 35,
            color: context.onPrimary,
            fontFamily: 'Pacifico',
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
