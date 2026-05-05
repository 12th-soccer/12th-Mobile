import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/features/auth/presentation/providers/auth_provider.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileHeader(ref),
            _buildMenuList(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    final userInfoAsync = ref.watch(userInfoProvider);

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
          AppSpacing.h12,
          userInfoAsync.when(
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: CustomColor.white,
                strokeWidth: 2,
              ),
            ),
            error: (_, __) => Text(
              '정보를 불러올 수 없습니다',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
            ),
            data: (data) => Text(data.email, style: CustomTextStyle.heading2),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Symbols.schedule,
          label: '알림 설정',
          onTap: () => context.push(AppRoutes.notifications),
        ),
        _buildMenuItem(
          icon: Symbols.visibility_off,
          label: '노 스포일러',
          onTap: () => context.push(AppRoutes.noSpoiler),
        ),
        _buildMenuItem(
          icon: Symbols.exit_to_app,
          label: '로그아웃',
          onTap: () async {
            await ref.read(authNotifierProvider.notifier).logout();
            if (context.mounted) context.go(AppRoutes.login);
          },
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
