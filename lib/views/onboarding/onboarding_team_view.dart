import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

const _allTeams = [
  /// K리그 1
  '부천 FC 1995',
  'FC 안양',
  '광주 FC',
  '울산 HD FC',
  'FC 서울',
  '대전 하나 시티즌',
  '김천 상무',
  '전북 현대 모터스 FC',
  '포항 스틸러스',
  '제주 SK',
  '인천 유나이티드',
  '강원 FC',

  /// K리그 2
  '수원 FC',
  '대구 FC',
  '수원 삼성 블루윙즈',
  '부산 아이파크',
  '전남 드래곤즈',
  '안산 그리너스',
  '충남 아산 FC',
  '화성 FC',
  '서울 이랜드 FC',
  '김포 FC',
  '성남 FC',
  '용인 FC',
  '청주 FC',
  '천안 시티',
  '파주 프론티어',
  '경남 FC',
  '김해 FC 2008'
];

class OnboardingTeamView extends StatefulWidget {
  final String? player;

  const OnboardingTeamView({super.key, this.player});

  @override
  State<OnboardingTeamView> createState() => _OnboardingTeamViewState();
}

class _OnboardingTeamViewState extends State<OnboardingTeamView> {
  final _searchController = TextEditingController();
  String? _selectedTeam;

  List<String> get _filteredTeams {
    final query = _searchController.text;
    if (query.isEmpty) return [];
    return _allTeams
        .where((t) => t.contains(query))
        .toList()
      ..sort((a, b) => a.compareTo(b));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNext() {
    context.push(AppRoutes.onboardingComplete);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTeams;
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text('좋아하는 구단이 있으세요?', style: CustomTextStyle.heading1),
                const SizedBox(height: 8),
                Text(
                  '모든 설문은 비공개이며, 나중에 설정할 수 있어요.',
                  style: CustomTextStyle.body2.copyWith(
                    color: CustomColor.gray500,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: '구단 이름으로 검색하세요.',
                    prefixIcon: Icon(
                      Symbols.search,
                      color: CustomColor.gray600,
                      size: 20,
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 44),
                  ),
                  onChanged: (_) {
                    setState(() {
                      if (_selectedTeam != null &&
                          !_filteredTeams.contains(_selectedTeam)) {
                        _selectedTeam = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                if (filtered.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      padding: const EdgeInsets.only(bottom: 8),
                      itemBuilder: (context, index) {
                        final team = filtered[index];
                        final isSelected = _selectedTeam == team;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedTeam = isSelected ? null : team;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: CustomColor.gray900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(team, style: CustomTextStyle.body1),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? CustomColor.black
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? CustomColor.white
                                          : CustomColor.gray600,
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: isSelected
                                      ? Icon(
                                          Symbols.check,
                                          size: 14,
                                          color: CustomColor.white,
                                          weight: 700,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: TwelfthElevatedButton(
                        isOutlined: true,
                        onPressed: () => context.pop(),
                        child: const Text('이전'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TwelfthElevatedButton(
                        gradient: TwelfthGradient.horizontal(
                          CustomColor.silverGradient,
                        ),
                        textColor: CustomColor.black,
                        onPressed: _onNext,
                        child: const Text('다음'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
