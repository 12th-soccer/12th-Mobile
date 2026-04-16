import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';

abstract interface class ISearchRepository {
  Future<List<ClubSearchResult>> searchClubs(String keyword);

  Future<List<PlayerSearchResult>> searchPlayers(String keyword);
}
