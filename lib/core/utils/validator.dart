class Validator{
  static bool isValidTimeFormat(String input) {
    final timePattern = RegExp(r'^\d{1,2}h \d{1,2}m$');
    return timePattern.hasMatch(input);
  }
}