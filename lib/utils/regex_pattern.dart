class RegexPattern {

  static final RegExp digits = RegExp(r'[0-9]');
  static final RegExp letters = RegExp(r'[a-zA-Z]');
  static final RegExp specialCharactersWithoutDot = RegExp(r'[!@#$%^&*(),?":{}|<>]');
  static final RegExp specialCharactersWithDot = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final RegExp whiteSpace = RegExp(r'\s+\b|\b\s|\s|\b');
}