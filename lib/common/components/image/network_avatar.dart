import 'package:flutter/material.dart';
import 'package:twelfth_mobile/constants/color.dart';

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
}
