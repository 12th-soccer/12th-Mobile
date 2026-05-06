import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _noSpoilerKey = 'no_spoiler_enabled';
const _storage = FlutterSecureStorage();

final noSpoilerProvider =
    AsyncNotifierProvider<NoSpoilerNotifier, bool>(NoSpoilerNotifier.new);

class NoSpoilerNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final value = await _storage.read(key: _noSpoilerKey);
    return value == 'true';
  }

  Future<void> save(bool enabled) async {
    await _storage.write(key: _noSpoilerKey, value: enabled.toString());
    state = AsyncData(enabled);
  }
}
