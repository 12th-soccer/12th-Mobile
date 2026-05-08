import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/ranking/data/datasources/ranking_remote_datasource.dart';
import 'package:twelfth_mobile/features/ranking/data/repositories/ranking_repository_impl.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/club_ranking.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_detail.dart';
import 'package:twelfth_mobile/features/ranking/domain/entities/player_goal.dart';
import 'package:twelfth_mobile/features/ranking/domain/repositories/i_ranking_repository.dart';
import 'package:twelfth_mobile/features/ranking/domain/usecases/get_club_detail_usecase.dart';
import 'package:twelfth_mobile/features/ranking/domain/usecases/get_ranking_usecase.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _rankingRemoteDataSourceProvider = Provider<IRankingRemoteDataSource>(
  (ref) => RankingRemoteDataSourceImpl(ref.read(_apiClientProvider)),
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

typedef RankingArgs = ({String league, String season});

final rankingProvider = FutureProvider.family<List<ClubRanking>, RankingArgs>((
  ref,
  args,
) {
  return ref.read(_getRankingUseCaseProvider).call(args.league, args.season);
});

final clubDetailProvider = FutureProvider.family<ClubDetail, int>((
  ref,
  clubId,
) {
  return ref.read(_getClubDetailUseCaseProvider).call(clubId);
});

final playerDetailProvider = FutureProvider.family<PlayerDetail, int>((
  ref,
  playerId,
) {
  return ref.read(rankingRepositoryProvider).getPlayerDetail(playerId);
});

final playerGoalsProvider = FutureProvider.family<PlayerGoal?, int>((
  ref,
  playerId,
) {
  return ref.read(rankingRepositoryProvider).getPlayerGoals(playerId);
});
