import 'package:twelfth_mobile/features/match/domain/entities/match.dart';
import 'package:twelfth_mobile/features/match/domain/repositories/i_match_repository.dart';

class GetMatchesByDateUseCase {
  final IMatchRepository _repository;

  const GetMatchesByDateUseCase(this._repository);

  Future<List<Match>> call(String date) => _repository.getMatchesByDate(date);
}

class GetMatchDetailUseCase {
  final IMatchRepository _repository;

  const GetMatchDetailUseCase(this._repository);

  Future<Match> call(int matchId) => _repository.getMatchDetail(matchId);
}
