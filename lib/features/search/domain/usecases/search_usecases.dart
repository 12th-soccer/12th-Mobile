import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/repositories/i_search_repository.dart';

class SearchClubsUseCase {
  final ISearchRepository _repository;

  const SearchClubsUseCase(this._repository);

  Future<List<ClubSearchResult>> call(String keyword) =>
      _repository.searchClubs(keyword);
}

class SearchPlayersUseCase {
  final ISearchRepository _repository;

  const SearchPlayersUseCase(this._repository);

  Future<List<PlayerSearchResult>> call(String keyword) =>
      _repository.searchPlayers(keyword);
}
