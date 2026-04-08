import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/ranking/data/datasources/ranking_remote_datasource.dart';
import 'package:twelfth_mobile/features/ranking/data/repositories/ranking_repository_impl.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/domain/repositories/i_ranking_repository.dart';
import 'package:twelfth_mobile/features/ranking/domain/usecases/get_club_detail_usecase.dart';
import 'package:twelfth_mobile/features/ranking/domain/usecases/get_ranking_usecase.dart';

final _dioProvider = Provider<Dio>((ref) => DioClient.instance.dio);

final _rankingRemoteDataSourceProvider = Provider<IRankingRemoteDataSource>(
  (ref) => RankingRemoteDataSourceImpl(ref.read(_dioProvider)),
);

final rankingRepositoryProvider = Provider<IRankingRepository>(
  (ref) => RankingRepositoryImpl(ref.read(_rankingRemoteDataSourceProvider)),
);

final _getRankingUseCaseProvider = Provider<GetRankingUseCase>(
  (ref) => GetRankingUseCase(ref.read(rankingRepositoryProvider)),
);

final _getClubDetailUseCaseProvider = Provider<GetClubDetailUseCase>(
  (ref) => GetClubDetailUseCase(ref.read(rankingRepositoryProvider)),
);

// ── Ranking Notifier ──────────────────────────────────────────────────

class RankingNotifier extends AsyncNotifier<List<ClubRanking>> {
  @override
  Future<List<ClubRanking>> build() => _fetch();

  Future<List<ClubRanking>> _fetch() =>
      ref.read(_getRankingUseCaseProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final rankingNotifierProvider =
    AsyncNotifierProvider<RankingNotifier, List<ClubRanking>>(
  RankingNotifier.new,
);

// ── Club Detail Provider ──────────────────────────────────────────────

final clubDetailProvider =
    FutureProvider.family<ClubDetail, int>((ref, clubId) {
  return ref.read(_getClubDetailUseCaseProvider).call(clubId);
});
