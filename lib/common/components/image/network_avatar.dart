import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twelfth_mobile/core/constants/color.dart';

class NetworkAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color placeholderColor;

  const NetworkAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.placeholderColor = CustomColor.gray900,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      final localImagePath = _getLocalImagePath(imageUrl!);
      print('[NetworkAvatar] imageUrl: $imageUrl, localPath: $localImagePath');
      if (localImagePath != null) {
        return ClipOval(
          child: localImagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  localImagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => _placeholder(),
                )
              : Image.asset(
                  localImagePath,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                ),
        );
      }

      return ClipOval(
        child: Image.network(
          imageUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: placeholderColor, shape: BoxShape.circle),
  );

  String? _getLocalImagePath(String imageUrl) {
    print('[NetworkAvatar] Checking local image for URL: $imageUrl');

    if (imageUrl.startsWith('local://')) {
      final fileName = imageUrl.substring(8);
      print('[NetworkAvatar] Found local:// scheme, fileName: $fileName');
      if (fileName == 'yonginfc.svg') {
        print('[NetworkAvatar] Converting SVG to PNG for yonginfc');
        return 'assets/images/yonginfc.png';
      }
      return 'assets/images/$fileName';
    }

    if (imageUrl.contains('9171') ||
        imageUrl.toLowerCase().contains('yongin') ||
        imageUrl.contains('teams/9171.png')) {
      print('[NetworkAvatar] Found Yongin FC pattern (ID: 9171), using local PNG');
      return 'assets/images/yonginfc.png';
    }

    return null;
  }
}
