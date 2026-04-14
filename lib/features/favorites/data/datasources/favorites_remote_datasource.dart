import 'dart:developer' as developer;
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
      developer.log('[Favorites] 관심 구단 조회 요청');
      return await _apiClient.get(
        ApiEndpoints.clubFavorite,
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
      developer.log('[Favorites] 관심 구단 조회 실패\n  status: ${e.statusCode}\n  response: ${e.responseData}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 구단 조회 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> addFavoriteClub(int clubId) async {
    try {
      developer.log('[Favorites] 관심 구단 등록: clubId=$clubId');
      await _apiClient.postVoid(ApiEndpoints.favoriteClub(clubId.toString()));
      developer.log('[Favorites] 관심 구단 등록 성공');
    } on ApiException catch (e) {
      developer.log('[Favorites] 관심 구단 등록 실패\n  status: ${e.statusCode}\n  response: ${e.responseData}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 구단 등록 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> removeFavoriteClub(int clubId) async {
    try {
      developer.log('[Favorites] 관심 구단 해제: clubId=$clubId');
      await _apiClient.deleteVoid(ApiEndpoints.favoriteClub(clubId.toString()));
      developer.log('[Favorites] 관심 구단 해제 성공');
    } on ApiException catch (e) {
      developer.log('[Favorites] 관심 구단 해제 실패\n  status: ${e.statusCode}\n  response: ${e.responseData}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 구단 해제 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<FavoritePlayerModel>> getFavoritePlayers() async {
    try {
      developer.log('[Favorites] 관심 선수 조회 요청');
      return await _apiClient.get(
        ApiEndpoints.playerInterest,
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
      developer.log('[Favorites] 관심 선수 조회 실패\n  status: ${e.statusCode}\n  response: ${e.responseData}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 선수 조회 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> addFavoritePlayer(int playerId) async {
    try {
      developer.log('[Favorites] 관심 선수 등록: playerId=$playerId');
      await _apiClient.postVoid(
        ApiEndpoints.favoritePlayer(playerId.toString()),
      );
      developer.log('[Favorites] 관심 선수 등록 성공');
    } on ApiException catch (e) {
      developer.log('[Favorites] 관심 선수 등록 실패\n  status: ${e.statusCode}\n  response: ${e.responseData}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 선수 등록 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<void> removeFavoritePlayer(int playerId) async {
    try {
      developer.log('[Favorites] 관심 선수 해제: playerId=$playerId');
      await _apiClient.deleteVoid(
        ApiEndpoints.favoritePlayer(playerId.toString()),
      );
      developer.log('[Favorites] 관심 선수 해제 성공');
    } on ApiException catch (e) {
      developer.log('[Favorites] 관심 선수 해제 실패\n  status: ${e.statusCode}\n  response: ${e.responseData}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 선수 해제 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
