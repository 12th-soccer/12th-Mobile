import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/recruitment/data/datasources/recruitment_remote_datasource.dart';
import 'package:twelfth_mobile/features/recruitment/data/repositories/recruitment_repository_impl.dart';
import 'package:twelfth_mobile/features/recruitment/domain/entities/recruitment.dart';
import 'package:twelfth_mobile/features/recruitment/domain/repositories/i_recruitment_repository.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _recruitmentDataSourceProvider = Provider<IRecruitmentRemoteDataSource>(
  (ref) => RecruitmentRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

final recruitmentRepositoryProvider = Provider<IRecruitmentRepository>(
  (ref) => RecruitmentRepositoryImpl(ref.read(_recruitmentDataSourceProvider)),
);

class RecruitmentListNotifier extends AsyncNotifier<List<Recruitment>> {
  int _page = 0;
  static const _size = 10;
  bool _hasMore = true;

  @override
  Future<List<Recruitment>> build() async {
    _page = 0;
    _hasMore = true;
    return _fetchPage(0);
  }

  Future<List<Recruitment>> _fetchPage(int page) {
    return ref
        .read(recruitmentRepositoryProvider)
        .getRecruitments(page: page, size: _size);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    _page = 0;
    _hasMore = true;
    state = await AsyncValue.guard(() => _fetchPage(0));
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    final current = state.valueOrNull ?? [];
    final next = await _fetchPage(_page + 1);
    if (next.isEmpty || next.length < _size) _hasMore = false;
    if (next.isNotEmpty) {
      _page++;
      state = AsyncData([...current, ...next]);
    }
  }
}

final recruitmentListProvider =
    AsyncNotifierProvider<RecruitmentListNotifier, List<Recruitment>>(
  RecruitmentListNotifier.new,
);

final recruitmentDetailProvider =
    FutureProvider.family<Recruitment, String>((ref, id) {
  return ref.read(recruitmentRepositoryProvider).getRecruitmentDetail(id);
});

Future<void> createRecruitment(WidgetRef ref, Recruitment recruitment) async {
  await ref
      .read(recruitmentRepositoryProvider)
      .createRecruitment(recruitment);

  await ref.read(recruitmentListProvider.notifier).refresh();
}

Future<void> joinRecruitment(WidgetRef ref, String id) {
  return ref.read(recruitmentRepositoryProvider).joinRecruitment(id);
}

Future<void> createNoticeRoom(WidgetRef ref, String recruitmentId, String description) {
  return ref.read(recruitmentRepositoryProvider).createNoticeRoom(recruitmentId, description);
}
