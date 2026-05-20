import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/favorites/data/models/favorite_club_model.dart';
import 'package:twelfth_mobile/features/favorites/data/models/favorite_player_model.dart';

abstract interface class IFavoritesRemoteDataSource {
  Future<List<FavoriteClubModel>> getFavoriteClubs();
  Future<void> addFavoriteClub(int clubId);
  Future<void> removeFavoriteClub(int clubId);
  Future<List<FavoritePlayerModel>> getFavoritePlayers();
  Future<void> addFavoritePlayer(int playerId);
  Future<void> removeFavoritePlayer(int playerId);
}

class FavoritesRemoteDataSourceImpl implements IFavoritesRemoteDataSource {
  final ApiClient _apiClient;
  const FavoritesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<FavoriteClubModel>> getFavoriteClubs() => _apiClient.get(
        ApiEndpoints.favoriteTeams,
        decoder: (data) => (data as List<dynamic>)
            .map((e) => FavoriteClubModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Future<void> addFavoriteClub(int clubId) =>
      _apiClient.postVoid(ApiEndpoints.favoriteTeam(clubId.toString()));

  @override
  Future<void> removeFavoriteClub(int clubId) =>
      _apiClient.deleteVoid(ApiEndpoints.favoriteTeam(clubId.toString()));

  @override
  Future<List<FavoritePlayerModel>> getFavoritePlayers() => _apiClient.get(
        ApiEndpoints.favoritePlayers,
        decoder: (data) => (data as List<dynamic>)
            .map((e) => FavoritePlayerModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Future<void> addFavoritePlayer(int playerId) =>
      _apiClient.postVoid(ApiEndpoints.favoritePlayerRegister(playerId.toString()));

  @override
  Future<void> removeFavoritePlayer(int playerId) =>
      _apiClient.deleteVoid(ApiEndpoints.favoritePlayer(playerId.toString()));
}
