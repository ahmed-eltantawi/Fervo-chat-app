import 'package:chat_with_me_now/helper/consts.dart';
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
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withValues(alpha: 0.2),
                spreadRadius: 5,
                blurRadius: 7,
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
            color: kPrimaryColor,
            fontFamily: 'Pacifico',
          ),
        ),
        // Text(
        //   'Fervo Chat',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 45,
        //     color: kPrimaryColor,
        //   ),
        // ),
        SizedBox(height: 10),
      ],
    );
  }
}
