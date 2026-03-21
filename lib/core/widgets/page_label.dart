import 'package:flutter/material.dart';

class PageLabel extends StatelessWidget {
  const PageLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
