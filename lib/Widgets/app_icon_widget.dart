import 'package:chat_with_me_now/helper/consts.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
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
            color: context.onPrimary.withValues(alpha: 0.5),
            boxShadow: [
              BoxShadow(
                color: context.onPrimary.withValues(alpha: 0.5),
                spreadRadius: 0.5,
                blurRadius: 15,
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(35),
          ),
          child: Image.asset(kAppIcon),
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
