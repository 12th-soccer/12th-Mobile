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
            data: (data) => Column(
              children: [
                Text(
                  data.username?.isNotEmpty == true ? data.username! : '닉네임',
                  style: CustomTextStyle.heading2.copyWith(
                    color: data.hasUsername ? CustomColor.white : CustomColor.gray500,
                  ),
                ),
                AppSpacing.h4,
                Text(
                  data.email,
                  style: CustomTextStyle.body3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildMenuItem(
          icon: Symbols.badge,
          label: '닉네임 수정',
          onTap: () => context.push(AppRoutes.editUsername),
        ),
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
        _buildMenuItem(
          icon: Symbols.person_remove,
          label: '회원 탈퇴',
          color: CustomColor.red,
          onTap: () => _showDeleteAccountDialog(context, ref),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CustomColor.gray900,
        title: Text('회원 탈퇴', style: CustomTextStyle.heading2),
        content: Text(
          '탈퇴하면 계정 및 관련 데이터가 삭제됩니다.\n정말 탈퇴하시겠습니까?',
          style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '취소',
              style: CustomTextStyle.body1.copyWith(color: CustomColor.gray500),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authNotifierProvider.notifier).deleteAccount();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: Text(
              '탈퇴',
              style: CustomTextStyle.body1.copyWith(color: CustomColor.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = CustomColor.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            AppSpacing.w12,
            Text(
              label,
              style: CustomTextStyle.body1.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
