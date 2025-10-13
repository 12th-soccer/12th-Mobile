import 'package:flutter_test/flutter_test.dart';
import 'package:twelfth_mobile/constants/twelfth_assets.dart';

void main() {
  group('TwelfthAssets', () {
    test('logo path is correct', () {
      expect(TwelfthAssets.logo, equals('assets/images/logo.svg'));
    });

    test('google path is correct', () {
      expect(TwelfthAssets.google, equals('assets/images/google.svg'));
    });

    test('kakao path is correct', () {
      expect(TwelfthAssets.kakao, equals('assets/images/kakao.svg'));
    });

    test('youtube path is correct', () {
      expect(TwelfthAssets.youtube, equals('assets/images/youtube.svg'));
    });

    test('instagram path is correct', () {
      expect(TwelfthAssets.instagram, equals('assets/images/instagram.svg'));
    });

    test('all assets have .svg extension', () {
      final assets = [
        TwelfthAssets.logo,
        TwelfthAssets.google,
        TwelfthAssets.kakao,
        TwelfthAssets.youtube,
        TwelfthAssets.instagram,
      ];

      for (final asset in assets) {
        expect(asset.endsWith('.svg'), isTrue, reason: '$asset should end with .svg');
      }
    });

    test('all assets are in assets/images directory', () {
      final assets = [
        TwelfthAssets.logo,
        TwelfthAssets.google,
        TwelfthAssets.kakao,
        TwelfthAssets.youtube,
        TwelfthAssets.instagram,
      ];

      for (final asset in assets) {
        expect(asset.startsWith('assets/images/'), isTrue,
            reason: '$asset should be in assets/images/ directory');
      }
    });

    test('all asset paths are unique', () {
      final assets = [
        TwelfthAssets.logo,
        TwelfthAssets.google,
        TwelfthAssets.kakao,
        TwelfthAssets.youtube,
        TwelfthAssets.instagram,
      ];

      final uniqueAssets = assets.toSet();
      expect(uniqueAssets.length, equals(assets.length),
          reason: 'All asset paths should be unique');
    });

    test('asset names match file names', () {
      expect(TwelfthAssets.logo.contains('logo'), isTrue);
      expect(TwelfthAssets.google.contains('google'), isTrue);
      expect(TwelfthAssets.kakao.contains('kakao'), isTrue);
      expect(TwelfthAssets.youtube.contains('youtube'), isTrue);
      expect(TwelfthAssets.instagram.contains('instagram'), isTrue);
    });
  });
}