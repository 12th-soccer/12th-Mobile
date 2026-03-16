import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildMenuList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: CustomColor.gray500,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 12),
          Text('USER', style: CustomTextStyle.heading2),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Symbols.schedule,
          label: '알림 설정',
          onTap: () => context.push(AppRoutes.notifications),
        ),
        _buildMenuItem(
          icon: Symbols.exit_to_app,
          label: '로그아웃',
          onTap: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: CustomColor.white, size: 22),
            const SizedBox(width: 12),
            Text(label, style: CustomTextStyle.body1),
          ],
        ),
      ),
    );
  }
}
