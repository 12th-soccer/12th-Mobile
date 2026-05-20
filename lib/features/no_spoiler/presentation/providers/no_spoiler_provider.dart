import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/no_spoiler/data/datasources/no_spoiler_remote_datasource.dart';
import 'package:twelfth_mobile/features/no_spoiler/data/repositories/no_spoiler_repository_impl.dart';
import 'package:twelfth_mobile/features/no_spoiler/domain/repositories/i_no_spoiler_repository.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _noSpoilerRemoteDataSourceProvider =
    Provider<INoSpoilerRemoteDataSource>(
  (ref) => NoSpoilerRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

final noSpoilerRepositoryProvider = Provider<INoSpoilerRepository>(
  (ref) => NoSpoilerRepositoryImpl(
    ref.read(_noSpoilerRemoteDataSourceProvider),
  ),
);

class NoSpoilerNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() => ref.read(noSpoilerRepositoryProvider).get();

  Future<void> save(bool enabled) async {
    final result =
        await ref.read(noSpoilerRepositoryProvider).save(enabled);
    state = AsyncData(result);
  }
}

final noSpoilerProvider =
    AsyncNotifierProvider<NoSpoilerNotifier, bool>(NoSpoilerNotifier.new);
