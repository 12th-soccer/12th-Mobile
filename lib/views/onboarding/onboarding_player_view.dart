import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/constants/color.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/router/router_paths.dart';

class _Player {
  final String name;
  final String team;
  const _Player(this.name, this.team);
}

const _allPlayers = [
  _Player('서진수', '대전 하나 시티즌'),
  _Player('이시우', '충남 아산 FC'),
  _Player('이승우', '전북 현대 모터스 FC'),
  _Player('고승범', '수원 삼성 블루윙즈'),
  _Player('유강현', '대전 하나 시티즌'),
  _Player('조현우', '울산 HD'),
  _Player('백가온', '부산 아이파크'),
  _Player('하정우', '수원 FC'),
  _Player('세징야', '대구 FC'),
  _Player('주닝요', '포항 스틸러스'),
  _Player('이현식', '김천 상무'),
  _Player('신상은', '제주 SK'),
  _Player('무고사', '인천 유나이티즈'),
  _Player('모따', 'FC 안양'),
  _Player('조영욱', 'FC 서울'),
  _Player('주세종', '광주 FC'),
  _Player('안태현', '부천 FC 1995'),
  _Player('김현오', '경남 FC'),
  _Player('이정택', '김천 상무'),
  _Player('이건희', '수원 삼성 블루윙즈'),
];

class OnboardingPlayerView extends StatefulWidget {
  const OnboardingPlayerView({super.key});

  @override
  State<OnboardingPlayerView> createState() => _OnboardingPlayerViewState();
}

class _OnboardingPlayerViewState extends State<OnboardingPlayerView> {
  final _searchController = TextEditingController();
  String? _selectedPlayer;

  List<_Player> get _filteredPlayers {
    final query = _searchController.text;
    if (query.isEmpty) return [];
    return _allPlayers
        .where((p) => p.name.contains(query))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNext() {
    context.push(AppRoutes.onboardingTeam, extra: _selectedPlayer);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPlayers;
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
                Text('좋아하는 선수가 있으세요?', style: CustomTextStyle.heading1),
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
                    hintText: '선수 이름으로 검색하세요.',
                    prefixIcon: Icon(
                      Symbols.search,
                      color: CustomColor.gray600,
                      size: 20,
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 44),
                  ),
                  onChanged: (_) {
                    setState(() {
                      if (_selectedPlayer != null &&
                          !_filteredPlayers.any((p) => p.name == _selectedPlayer)) {
                        _selectedPlayer = null;
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
                        final player = filtered[index];
                        final isSelected = _selectedPlayer == player.name;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedPlayer = isSelected ? null : player.name;
                          }),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColor.gray900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${player.name} ',
                                          style: CustomTextStyle.body1,
                                        ),
                                        TextSpan(
                                          text: player.team,
                                          style: CustomTextStyle.body2.copyWith(
                                            color: CustomColor.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
