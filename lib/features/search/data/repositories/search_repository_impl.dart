import 'package:twelfth_mobile/features/search/data/datasources/search_remote_datasource.dart';
import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/repositories/i_search_repository.dart';

class SearchRepositoryImpl implements ISearchRepository {
  final ISearchRemoteDataSource _dataSource;

  const SearchRepositoryImpl(this._dataSource);

  @override
  Future<List<ClubSearchResult>> searchClubs(String keyword) async {
    final models = await _dataSource.searchClubs(keyword);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<PlayerSearchResult>> searchPlayers(String keyword) async {
    final models = await _dataSource.searchPlayers(keyword);
    return models.map((m) => m.toEntity()).toList();
  }
}
