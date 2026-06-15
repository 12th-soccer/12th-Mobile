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
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(color: placeholderColor, shape: BoxShape.circle),
              child: const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: CustomColor.white),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _placeholder();
          },
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: placeholderColor, shape: BoxShape.circle),
    child: Icon(
      Icons.person,
      size: size * 0.6,
      color: CustomColor.gray500,
    ),
  );

  String? _getLocalImagePath(String imageUrl) {

    if (imageUrl.startsWith('local://')) {
      final fileName = imageUrl.substring(8);
      if (fileName == 'yonginfc.svg') {
        return 'assets/images/yonginfc.png';
      }
      return 'assets/images/$fileName';
    }

    if (imageUrl.contains('9171') ||
        imageUrl.toLowerCase().contains('yongin') ||
        imageUrl.contains('teams/9171.png')) {
      return 'assets/images/yonginfc.png';
    }

    return null;
  }
}
