import 'package:chat_with_me_now/helper/consts.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final bool showErrorOfCheckBox;
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.showErrorOfCheckBox,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.maximumDensity,
        vertical: VisualDensity.maximumDensity,
      ),
      value: value,
      onChanged: onChanged,
      checkColor: Theme.of(context).colorScheme.onPrimary,
      activeColor: kPrimaryColor,
      side: BorderSide(
        color: showErrorOfCheckBox ? Colors.red : kPrimaryColor,
        width: 2.0,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    );
  }
}
