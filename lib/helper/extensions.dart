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
