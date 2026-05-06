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
  Future<List<FavoriteClubModel>> getFavoriteClubs() async {
    try {
      return await _apiClient.get(
        ApiEndpoints.teamFavorite,
        decoder: (data) {
          final list = data as List<dynamic>;
          return list
              .map(
                (e) => FavoriteClubModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<void> addFavoriteClub(int clubId) async {
    try {
      await _apiClient.postVoid(ApiEndpoints.favoriteClub(clubId.toString()));
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavoriteClub(int clubId) async {
    try {
      await _apiClient.deleteVoid(ApiEndpoints.favoriteClub(clubId.toString()));
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<List<FavoritePlayerModel>> getFavoritePlayers() async {
    try {
      return await _apiClient.get(
        ApiEndpoints.playerFavorite,
        decoder: (data) {
          final list = data as List<dynamic>;
          return list
              .map(
                (e) => FavoritePlayerModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<void> addFavoritePlayer(int playerId) async {
    try {
      await _apiClient.postVoid(
        ApiEndpoints.favoritePlayer(playerId.toString()),
      );
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavoritePlayer(int playerId) async {
    try {
      await _apiClient.deleteVoid(
        ApiEndpoints.favoritePlayer(playerId.toString()),
      );
    } on ApiException catch (e) {
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }
}
