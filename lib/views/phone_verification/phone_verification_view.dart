import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/phone_verification/presentation/providers/phone_verification_provider.dart';
import 'package:twelfth_mobile/core/components/text_form_field/text_form_field.dart';
import 'package:twelfth_mobile/core/extensions/snackbar_extension.dart';

class PhoneVerificationView extends ConsumerStatefulWidget {
  const PhoneVerificationView({super.key});

  @override
  ConsumerState<PhoneVerificationView> createState() =>
      _PhoneVerificationViewState();
}

class _PhoneVerificationViewState extends ConsumerState<PhoneVerificationView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String get _normalizedPhone =>
      _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

  Future<void> _sendVerificationCode() async {
    final phone = _normalizedPhone;
    if (phone.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(phoneVerificationProvider.notifier).sendCode(phone);
      if (!mounted) return;
      setState(() => _codeSent = true);
      _showSuccessSnackBar('인증번호가 전송되었습니다.');
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = switch (e.statusCode) {
        400 => '올바른 전화번호 형식이 아닙니다.',
        _ => '문자 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.',
      };
      _showErrorSnackBar(msg);
    } catch (_) {
      if (!mounted) return;
      _showErrorSnackBar('문자 발송에 실패했습니다. 잠시 후 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode() async {
    final phone = _normalizedPhone;
    final code = _codeController.text.trim();
    if (phone.isEmpty || code.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(phoneVerificationProvider.notifier)
          .verifyCode(phone: phone, code: code);
      if (!mounted) return;
      _showSuccessSnackBar('전화번호 인증이 완료되었습니다.');
      context.pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      final msg = switch (e.statusCode) {
        400 => '인증번호가 올바르지 않습니다.',
        401 => '인증번호가 만료되었거나 올바르지 않습니다.',
        _ => '인증에 실패했습니다. 다시 시도해 주세요.',
      };
      _showErrorSnackBar(msg);
    } catch (_) {
      if (!mounted) return;
      _showErrorSnackBar('인증에 실패했습니다. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) context.showErrorSnackBar(message);
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) context.showSuccessSnackBar(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background,
      appBar: AppBar(
        backgroundColor: CustomColor.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '전화번호 인증',
          style: CustomTextStyle.heading2.copyWith(color: CustomColor.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '모임 참여를 위해\n전화번호 인증이 필요합니다',
              style: CustomTextStyle.heading1.copyWith(color: CustomColor.white),
            ),
            const SizedBox(height: 8),
            Text(
              '안전한 모임 환경을 위해 전화번호 인증을 진행합니다.',
              style: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
            ),
            const SizedBox(height: 40),

            if (!_codeSent) ...[
              Text(
                '전화번호',
                style: CustomTextStyle.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CustomColor.white,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '01012345678',
                  hintStyle: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CustomColor.gray500),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CustomColor.main),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TwelfthElevatedButton(
                  onPressed: _isLoading ? null : _sendVerificationCode,
                  backgroundColor: CustomColor.main,
                  child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(CustomColor.black),
                        ),
                      )
                    : Text(
                        '인증번호 전송',
                        style: CustomTextStyle.heading2.copyWith(color: CustomColor.black),
                      ),
                ),
              ),
            ] else ...[
              Text(
                '인증번호',
                style: CustomTextStyle.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CustomColor.white,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '6자리 인증번호 입력',
                  hintStyle: CustomTextStyle.body2.copyWith(color: CustomColor.gray500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CustomColor.gray500),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: CustomColor.main),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '인증번호를 받지 못했나요?',
                    style: CustomTextStyle.body3.copyWith(color: CustomColor.gray500),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _codeSent = false;
                              _codeController.clear();
                            });
                          },
                    child: Text(
                      '재전송',
                      style: CustomTextStyle.body3.copyWith(
                        color: CustomColor.main,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TwelfthElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  backgroundColor: CustomColor.main,
                  child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(CustomColor.black),
                        ),
                      )
                    : Text(
                        '인증 완료',
                        style: CustomTextStyle.heading2.copyWith(color: CustomColor.black),
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
