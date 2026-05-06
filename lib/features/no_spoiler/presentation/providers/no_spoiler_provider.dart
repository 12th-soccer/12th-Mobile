import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twelfth_mobile/features/no_spoiler/data/datasources/no_spoiler_local_datasource.dart';
import 'package:twelfth_mobile/features/no_spoiler/data/repositories/no_spoiler_repository_impl.dart';
import 'package:twelfth_mobile/features/no_spoiler/domain/repositories/i_no_spoiler_repository.dart';

final _noSpoilerLocalDataSourceProvider = Provider<INoSpoilerLocalDataSource>(
  (ref) => const NoSpoilerLocalDataSourceImpl(FlutterSecureStorage()),
);

final noSpoilerRepositoryProvider = Provider<INoSpoilerRepository>(
  (ref) => NoSpoilerRepositoryImpl(ref.read(_noSpoilerLocalDataSourceProvider)),
);

class NoSpoilerNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.read(noSpoilerRepositoryProvider).get();

  Future<void> save(bool enabled) async {
    await ref.read(noSpoilerRepositoryProvider).save(enabled);
    state = AsyncData(enabled);
  }
}

final noSpoilerProvider =
    AsyncNotifierProvider<NoSpoilerNotifier, bool>(NoSpoilerNotifier.new);
