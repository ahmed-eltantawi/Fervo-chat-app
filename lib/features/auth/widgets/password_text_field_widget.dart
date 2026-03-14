import 'package:chat_with_me_now/core/widgets/custom_form_text_field.dart';
import 'package:chat_with_me_now/features/auth/cubit/password_cubit/password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordTextField extends StatelessWidget {
  PasswordTextField({super.key});
  bool passwordHide = true;

  IconData passwordIcon = Icons.visibility_off_outlined;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasswordCubit, PasswordState>(
      listener: (context, state) {
        if (state is ShowPassword) {
          passwordHide = false;
          passwordIcon = BlocProvider.of<PasswordCubit>(context).passwordIcon;
        } else {
          passwordHide = true;
          passwordIcon = BlocProvider.of<PasswordCubit>(context).passwordIcon;
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: AlignmentGeometry.xy(1, .8),
          children: [
            CustomFormTextField(
              label: 'Password',
              prefixIcon: Icons.lock_outlined,
              textInputAction: TextInputAction.done,
              hide: passwordHide,
              hintText: '********',
              onChanged: (value) {
                BlocProvider.of<PasswordCubit>(context).password = value;
              },
            ),
            IconButton(
              onPressed: BlocProvider.of<PasswordCubit>(
                context,
              ).changeThePasswordState,

              icon: Icon(
                passwordIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}
