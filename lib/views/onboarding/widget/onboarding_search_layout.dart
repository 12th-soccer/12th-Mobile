import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:twelfth_mobile/common/components/app_bar/twelfth_app_bar.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import '../constants/onboarding_constants.dart';

class OnboardingSearchLayout<T> extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final bool isSearching;
  final List<T> results;
  final Widget Function(T item, bool isSelected) itemBuilder;
  final bool Function(T item) isSelected;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Function(T item) onTapItem;

  const OnboardingSearchLayout({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.isSearching,
    required this.results,
    required this.itemBuilder,
    required this.isSelected,
    required this.onChanged,
    required this.onSubmitted,
    required this.onPrev,
    required this.onNext,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: const TwelfthAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: OnboardingUI.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnboardingUI.gapH32,
                Text(title, style: OnboardingUI.heading),
                OnboardingUI.gapH8,
                Text(
                  '모든 설문은 비공개이며, 나중에 설정할 수 있어요.',
                  style: OnboardingUI.subText,
                ),
                OnboardingUI.gapH10,
                CustomTextFormField(
                  controller: controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: Icon(
                      Symbols.search,
                      color: CustomColor.gray600,
                      size: 20,
                    ),
                    suffixIcon: isSearching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: CustomColor.gray500,
                              ),
                            ),
                          )
                        : null,
                  ),
                  onChanged: onChanged,
                  onFieldSubmitted: onSubmitted,
                ),
                OnboardingUI.gapH8,
                if (results.isNotEmpty)
                  Expanded(
                    child: ListView.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, __) => OnboardingUI.gapH8,
                      itemBuilder: (_, index) {
                        final item = results[index];
                        return GestureDetector(
                          onTap: () => onTapItem(item),
                          child: itemBuilder(item, isSelected(item)),
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
                        onPressed: onPrev,
                        child: const Text('이전'),
                      ),
                    ),
                    OnboardingUI.gapW10,
                    Expanded(
                      child: TwelfthElevatedButton(
                        gradient: TwelfthGradient.horizontal(
                          CustomColor.silverGradient,
                        ),
                        textColor: CustomColor.black,
                        onPressed: onNext,
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
