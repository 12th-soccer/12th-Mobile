import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/match/data/datasources/match_remote_datasource.dart';
import 'package:twelfth_mobile/features/match/data/repositories/match_repository_impl.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_event.dart';
import 'package:twelfth_mobile/features/match/domain/entities/match_lineup.dart';
import 'package:twelfth_mobile/features/match/domain/repositories/i_match_repository.dart';
import 'package:twelfth_mobile/features/match/domain/usecases/match_usecases.dart';

final _apiClientProvider = Provider<ApiClient>(
  (ref) => DioClient.instance.apiClient,
);

final _matchRemoteDataSourceProvider = Provider<IMatchRemoteDataSource>(
  (ref) => MatchRemoteDataSourceImpl(ref.read(_apiClientProvider)),
);

final matchRepositoryProvider = Provider<IMatchRepository>(
  (ref) => MatchRepositoryImpl(ref.read(_matchRemoteDataSourceProvider)),
);

final _getMatchesByDateUseCaseProvider = Provider<GetMatchesByDateUseCase>(
  (ref) => GetMatchesByDateUseCase(ref.read(matchRepositoryProvider)),
);

final _getMatchDetailUseCaseProvider = Provider<GetMatchDetailUseCase>(
  (ref) => GetMatchDetailUseCase(ref.read(matchRepositoryProvider)),
);

final _getMatchEventsUseCaseProvider = Provider<GetMatchEventsUseCase>(
  (ref) => GetMatchEventsUseCase(ref.read(matchRepositoryProvider)),
);

final _getMatchLineupsUseCaseProvider = Provider<GetMatchLineupsUseCase>(
  (ref) => GetMatchLineupsUseCase(ref.read(matchRepositoryProvider)),
);

typedef MatchesByDateArgs = ({String date, String leagueType});

final matchesByDateProvider =
    FutureProvider.family<List<Match>, MatchesByDateArgs>((ref, args) {
  return ref
      .read(_getMatchesByDateUseCaseProvider)
      .call(args.date, args.leagueType);
});

final matchDetailProvider = FutureProvider.family<Match, int>((ref, matchId) {
  return ref.read(_getMatchDetailUseCaseProvider).call(matchId);
});

final matchEventsProvider = FutureProvider.family<List<MatchEvent>, int>((
  ref,
  matchId,
) {
  return ref.read(_getMatchEventsUseCaseProvider).call(matchId);
});

final matchLineupsProvider = FutureProvider.family<List<MatchLineup>, int>((
  ref,
  matchId,
) {
  return ref.read(_getMatchLineupsUseCaseProvider).call(matchId);
});
