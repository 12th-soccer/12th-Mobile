import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/constants/spacing.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';
import 'package:twelfth_mobile/views/fan_finder/fan_finder_constants.dart';
import 'package:twelfth_mobile/views/fan_finder/model/fan_post.dart';
import 'package:twelfth_mobile/views/fan_finder/widgets/age_verification_dialog.dart';
import 'package:twelfth_mobile/views/fan_finder/widgets/fan_post_card.dart';
import 'package:twelfth_mobile/views/fan_finder/widgets/filter_toggle_section.dart';

class FanFinderView extends StatefulWidget {
  const FanFinderView({super.key});

  @override
  State<FanFinderView> createState() => _FanFinderViewState();
}

class _FanFinderViewState extends State<FanFinderView> {
  final Set<String> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showVerification());
  }

  Future<void> _showVerification() async {
    final result = await AgeVerificationDialog.show(context);
    if (!mounted) return;
    if (result == true) {
      // TODO: 포트원 나이 인증 페이지로 이동
    } else {
      context.pop();
    }
  }

  void _onToggleFilter(String item) =>
      setState(() => _selectedFilters.contains(item)
          ? _selectedFilters.remove(item)
          : _selectedFilters.add(item));

  List<FanPost> get _filteredPosts {
    if (_selectedFilters.isEmpty) return mockFanPosts;
    return mockFanPosts
        .where((p) => p.tags.any((t) => _selectedFilters.contains(t)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios, color: CustomColor.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterPanel(),
          const Divider(color: CustomColor.gray800, height: 1),
          Expanded(child: _buildPostList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.fanFinderWrite),
        backgroundColor: CustomColor.main,
        shape: const CircleBorder(),
        child: const Icon(Symbols.add, color: CustomColor.black),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Padding(
      padding: FanFinderConstants.horizontalScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterToggleSection(
            title: '나이',
            options: FanFinderConstants.ageOptions,
            selectedItems: _selectedFilters,
            onToggleItem: _onToggleFilter,
          ),
          const Divider(color: CustomColor.gray800, height: 1),
          FilterToggleSection(
            title: '성별',
            options: FanFinderConstants.genderOptions,
            selectedItems: _selectedFilters,
            onToggleItem: _onToggleFilter,
          ),
          const Divider(color: CustomColor.gray800, height: 1),
          FilterToggleSection(
            title: 'K1',
            options: FanFinderConstants.k1Teams,
            selectedItems: _selectedFilters,
            onToggleItem: _onToggleFilter,
          ),
          const Divider(color: CustomColor.gray800, height: 1),
          FilterToggleSection(
            title: 'K2',
            options: FanFinderConstants.k2Teams,
            selectedItems: _selectedFilters,
            onToggleItem: _onToggleFilter,
          ),
        ],
      ),
    );
  }

  Widget _buildPostList() {
    final posts = _filteredPosts;
    if (posts.isEmpty) {
      return Center(
        child: Text(
          '해당 조건의 모집글이 없습니다',
          style: CustomTextStyle.body1.copyWith(color: CustomColor.gray500),
        ),
      );
    }
    return ListView.builder(
      padding: AppPadding.listV,
      itemCount: posts.length,
      itemBuilder: (context, index) => FanPostCard(
        post: posts[index],
        onTap: () => context.push(
          AppRoutes.fanFinderDetail,
          extra: posts[index],
        ),
      ),
    );
  }
}
