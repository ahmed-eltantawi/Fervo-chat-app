import 'package:chat_with_me_now/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextOtp extends StatelessWidget {
  const CustomTextOtp({
    super.key,
    required this.onChanged,
    required this.controller,
  });
  final Function onChanged;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.onPrimary, width: 1.3),
        boxShadow: [
          BoxShadow(
            color: context.onPrimary.withValues(alpha: 0.15),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(0, 0),
          ),
        ],
      ),
      height: 68,
      width: 64,
      child: TextFormField(
        controller: controller,
        onChanged: (value) {
          onChanged(value);

          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
        cursorColor: Theme.of(context).colorScheme.inversePrimary,
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(
            fontFamily: 'San Francisco',
            color: context.onPrimary.withOpacity(0.6),
          ),

          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 35),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
