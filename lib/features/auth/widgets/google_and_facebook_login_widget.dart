import 'package:chat_with_me_now/config/constants/images.dart';
import 'package:chat_with_me_now/features/auth/bloc/auth_bloc.dart';
import 'package:chat_with_me_now/features/auth/widgets/sign_in_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleAndFacebookSingInWidget extends StatelessWidget {
  const GoogleAndFacebookSingInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SingInIcons(
          image: Assets.imagesGoogleIcon,
          onTap: () async {
            BlocProvider.of<AuthBloc>(
              context,
            ).add(GoogleLoginEvent(context: context));
          },
        ),
        SizedBox(width: 20),
        SingInIcons(
          image: Assets.imagesFacebookIcon,
          onTap: () async {
            BlocProvider.of<AuthBloc>(
              context,
            ).add(FacebookLoginEvent(context: context));
          },
        ),
      ],
    );
  }
}
