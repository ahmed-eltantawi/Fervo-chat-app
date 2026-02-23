import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}",
        )
        .join(' ');
  }
}

extension AppColors on BuildContext {
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;
}
