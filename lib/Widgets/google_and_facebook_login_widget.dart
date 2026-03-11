import 'package:chat_with_me_now/Widgets/sing_in_icon.dart';
import 'package:chat_with_me_now/cubits/login_cubit/login_cubit.dart';
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
          image: 'assets/images/google icon.png',
          onTap: () async {
            await BlocProvider.of<LoginCubit>(
              context,
            ).googleLogin(context: context);
          },
        ),
        SizedBox(width: 20),
        SingInIcons(
          image: 'assets/images/facebook-icon.png',
          onTap: () async {
            await BlocProvider.of<LoginCubit>(
              context,
            ).facebookLogin(context: context);
          },
        ),
      ],
    );
  }
}
