import 'package:twelfth_mobile/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_player.dart';
import 'package:twelfth_mobile/features/favorites/domain/repositories/i_favorites_repository.dart';

class FavoritesRepositoryImpl implements IFavoritesRepository {
  final IFavoritesRemoteDataSource _dataSource;

  const FavoritesRepositoryImpl(this._dataSource);

  @override
  Future<List<FavoriteClub>> getFavoriteClubs() async {
    final models = await _dataSource.getFavoriteClubs();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addFavoriteClub(int clubId) =>
      _dataSource.addFavoriteClub(clubId);

  @override
  Future<void> removeFavoriteClub(int clubId) =>
      _dataSource.removeFavoriteClub(clubId);

  @override
  Future<List<FavoritePlayer>> getFavoritePlayers() async {
    final models = await _dataSource.getFavoritePlayers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addFavoritePlayer(int playerId) =>
      _dataSource.addFavoritePlayer(playerId);

  @override
  Future<void> removeFavoritePlayer(int playerId) =>
      _dataSource.removeFavoritePlayer(playerId);
}
