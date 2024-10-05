extension StringExtension on String {
  String toTitleCase() {
    return split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}