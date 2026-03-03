import 'dart:ui';

abstract final class CustomColor {
  static const Color main = Color(0xFFC4C7D4);
  static const Color background = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color gray500 = Color(0xFF939393);
  static const Color gray600 = Color(0xFF787878);
  static const Color gray900 = Color(0xFF414141);
  static const Color gray950 = Color(0xFF1C1C1C);

<<<<<<< Updated upstream:lib/constants/color.dart
  static const List<Color> silverGradient = [
    Color(0xFFFFFFFF),
    Color(0xFF8C92AC),
  ];
}

abstract final class TwelfthGradient {
  static LinearGradient horizontal(List<Color> baseColors) {
    return LinearGradient(
      colors: baseColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
=======
  static const Color red = Color(0xFFFF5C5C);
}
>>>>>>> Stashed changes:lib/core/constants/color.dart
