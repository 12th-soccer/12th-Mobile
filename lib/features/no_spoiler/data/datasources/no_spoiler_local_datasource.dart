import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _noSpoilerKey = 'no_spoiler_enabled';

abstract interface class INoSpoilerLocalDataSource {
  Future<bool> get();
  Future<void> save(bool enabled);
}

class NoSpoilerLocalDataSourceImpl implements INoSpoilerLocalDataSource {
  const NoSpoilerLocalDataSourceImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<bool> get() async {
    final value = await _storage.read(key: _noSpoilerKey);
    return value == 'true';
  }

  @override
  Future<void> save(bool enabled) =>
      _storage.write(key: _noSpoilerKey, value: enabled.toString());
}
