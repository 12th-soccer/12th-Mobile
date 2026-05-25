import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PhoneVerificationStatusNotifier extends StateNotifier<bool> {
  static const _storage = FlutterSecureStorage();
  static const _key = 'phone_verification_status';

  PhoneVerificationStatusNotifier() : super(false) {
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final cachedStatus = await _storage.read(key: _key);
    state = cachedStatus == 'true';
  }

  Future<void> setVerified(bool verified) async {
    await _storage.write(key: _key, value: verified.toString());
    state = verified;
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
    state = false;
  }

  bool get isVerified => state;
}

final phoneVerificationStatusProvider =
    StateNotifierProvider<PhoneVerificationStatusNotifier, bool>((ref) {
  return PhoneVerificationStatusNotifier();
});