import 'package:chat_with_me_now/cubits/register/register_cubit.dart';
import 'package:chat_with_me_now/helper/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final bool showError = state is CheckBoxError;
        return Checkbox(
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.maximumDensity,
            vertical: VisualDensity.maximumDensity,
          ),
          value: value,
          onChanged: onChanged,
          checkColor: Theme.of(context).colorScheme.surface,
          activeColor: context.onPrimary,
          side: BorderSide(
            color: showError ? Colors.red : context.onPrimary,
            width: 2.0,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      },
    );
  }
}
