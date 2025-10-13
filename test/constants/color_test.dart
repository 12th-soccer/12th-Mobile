import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twelfth_mobile/constants/color.dart';

void main() {
  group('TwelfthColor', () {
    test('main color has correct value', () {
      expect(TwelfthColor.main, equals(const Color(0xFFC4C7D4)));
    });

    test('background color has correct value', () {
      expect(TwelfthColor.background, equals(const Color(0xFF1A1A1A)));
    });

    test('white color has correct value', () {
      expect(TwelfthColor.white, equals(const Color(0xFFFFFFFF)));
    });

    test('black color has correct value', () {
      expect(TwelfthColor.black, equals(const Color(0xFF000000)));
    });

    test('gray500 color has correct value', () {
      expect(TwelfthColor.gray500, equals(const Color(0xFF939393)));
    });

    test('gray900 color has correct value', () {
      expect(TwelfthColor.gray900, equals(const Color(0xFF414141)));
    });

    test('gray950 color has correct value', () {
      expect(TwelfthColor.gray950, equals(const Color(0xFF1C1C1C)));
    });

    test('silverGradient has correct colors', () {
      expect(TwelfthColor.silverGradient.length, equals(2));
      expect(TwelfthColor.silverGradient[0], equals(const Color(0xFFFFFFFF)));
      expect(TwelfthColor.silverGradient[1], equals(const Color(0xFF8C92AC)));
    });

    test('all colors are unique', () {
      final colors = [
        TwelfthColor.main,
        TwelfthColor.background,
        TwelfthColor.white,
        TwelfthColor.black,
        TwelfthColor.gray500,
        TwelfthColor.gray900,
        TwelfthColor.gray950,
      ];

      final uniqueColors = colors.toSet();
      expect(uniqueColors.length, equals(colors.length));
    });
  });

  group('TwelfthGradient', () {
    test('horizontal creates LinearGradient with correct properties', () {
      const colors = [Color(0xFFFF0000), Color(0xFF0000FF)];
      final gradient = TwelfthGradient.horizontal(colors);

      expect(gradient, isA<LinearGradient>());
      expect(gradient.colors, equals(colors));
      expect(gradient.begin, equals(Alignment.topLeft));
      expect(gradient.end, equals(Alignment.bottomRight));
    });

    test('horizontal works with single color', () {
      const colors = [Color(0xFFFF0000)];
      final gradient = TwelfthGradient.horizontal(colors);

      expect(gradient.colors.length, equals(1));
      expect(gradient.colors[0], equals(const Color(0xFFFF0000)));
    });

    test('horizontal works with multiple colors', () {
      const colors = [
        Color(0xFFFF0000),
        Color(0xFF00FF00),
        Color(0xFF0000FF),
        Color(0xFFFFFF00),
      ];
      final gradient = TwelfthGradient.horizontal(colors);

      expect(gradient.colors.length, equals(4));
      expect(gradient.colors, equals(colors));
    });

    test('horizontal with silverGradient creates correct gradient', () {
      final gradient = TwelfthGradient.horizontal(TwelfthColor.silverGradient);

      expect(gradient.colors.length, equals(2));
      expect(gradient.colors[0], equals(const Color(0xFFFFFFFF)));
      expect(gradient.colors[1], equals(const Color(0xFF8C92AC)));
      expect(gradient.begin, equals(Alignment.topLeft));
      expect(gradient.end, equals(Alignment.bottomRight));
    });
  });
}