import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.hide = false,
    required this.textInputAction,
    required this.prefixIcon,
  });
  final IconData prefixIcon;
  final String hintText;
  final Function(String)? onChanged;
  final bool hide;
  final TextInputAction textInputAction;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.tertiary,
      ),
      child: TextFormField(
        textInputAction: textInputAction,

        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
        obscureText: hide,
        validator: (value) {
          if (value!.isEmpty) {
            return "Field is required";
          }

          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: InputBorder.none,

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
          hint: Text(
            hintText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
