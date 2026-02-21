import 'package:flutter/material.dart';

class HorizontalTextLine extends StatelessWidget {
  const HorizontalTextLine({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
              height: 5,
            ),
          ),
        ),

        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
              height: 5,
            ),
          ),
        ),
      ],
    );
  }
}
