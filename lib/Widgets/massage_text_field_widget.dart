import 'package:chat_with_me_now/cubits/chat_cubit/chat_cubit.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MassageTextFieldWidget extends StatelessWidget {
  MassageTextFieldWidget({super.key, required this.scrollController});
  final ScrollController scrollController;
  String massage = '';
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30, top: 16),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          BlocProvider.of<ChatCubit>(context).onSubmitted(
            value: value,
            controller: controller,
            scrollController: scrollController,
          );
          massage = '';
        },
        onChanged: (value) {
          massage = value;
        },
        decoration: InputDecoration(
          hintText: 'Sent Massage',
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              BlocProvider.of<ChatCubit>(context).onSubmitted(
                value: massage,
                controller: controller,
                scrollController: scrollController,
              );
              massage = '';
            },
          ),

          border: OutlineInputBorder(
            borderSide: BorderSide(color: context.onPrimary),
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: context.onPrimary),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
