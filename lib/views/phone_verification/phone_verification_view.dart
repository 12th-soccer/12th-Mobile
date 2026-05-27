import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:twelfth_mobile/core/constants/color.dart';
import 'package:twelfth_mobile/constants/text_style.dart';
import 'package:twelfth_mobile/common/components/button/elevated_button.dart';
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

  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendVerificationCode() async {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+82${phoneNumber.startsWith('0') ? phoneNumber.substring(1) : phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {
          _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          _showErrorSnackBar('인증번호 전송에 실패했습니다. 전화번호를 확인해 주세요.');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
          _showSuccessSnackBar('인증번호가 전송되었습니다.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('오류가 발생했습니다. 다시 시도해 주세요.');
    }
  }

  Future<void> _verifyCode() async {
    if (_verificationId == null || _codeController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _codeController.text.trim(),
      );

      await _signInWithCredential(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('인증번호가 올바르지 않습니다.');
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();

      if (idToken != null) {
        await _sendToBackend(idToken);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('인증에 실패했습니다. 다시 시도해 주세요.');
    }
  }

  Future<void> _sendToBackend(String idToken) async {
    try {
      await ref.read(phoneVerificationProvider.notifier).verifyPhone(idToken);

      if (mounted) {
        _showSuccessSnackBar('전화번호 인증이 완료되었습니다.');
        // 인증 완료 후 이전 페이지로 돌아가기 (팬파인더 페이지)
        context.pop(true);
      }
    } catch (e) {
      _showErrorSnackBar('서버 인증에 실패했습니다. 다시 시도해 주세요.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      context.showErrorSnackBar(message);
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      context.showSuccessSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneVerificationState = ref.watch(phoneVerificationProvider);

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
                  hintText: '010-1234-5678',
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
                    onTap: _isLoading ? null : () {
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
                  child: (_isLoading || phoneVerificationState.isLoading)
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