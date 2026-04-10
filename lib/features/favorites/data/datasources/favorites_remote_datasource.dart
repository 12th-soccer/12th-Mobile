import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
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
  final Dio _dio;
  const FavoritesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<FavoriteClubModel>> getFavoriteClubs() async {
    try {
      developer.log('[Favorites] 관심 구단 조회 요청');
      final response = await _dio.get(ApiEndpoints.clubFavorite);
      developer.log('[Favorites] 응답 status: ${response.statusCode}');
      final rawData = response.data;
      final List<dynamic> list = rawData is String
          ? jsonDecode(rawData) as List<dynamic>
          : rawData as List<dynamic>;
      return list
          .map((e) => FavoriteClubModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      developer.log('[Favorites] 관심 구단 조회 실패\n  status: ${e.response?.statusCode}\n  response: ${e.response?.data}');
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
      await _dio.post(ApiEndpoints.favoriteClub(clubId.toString()));
      developer.log('[Favorites] 관심 구단 등록 성공');
    } on DioException catch (e) {
      developer.log('[Favorites] 관심 구단 등록 실패\n  status: ${e.response?.statusCode}\n  response: ${e.response?.data}');
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
      await _dio.delete(ApiEndpoints.favoriteClub(clubId.toString()));
      developer.log('[Favorites] 관심 구단 해제 성공');
    } on DioException catch (e) {
      developer.log('[Favorites] 관심 구단 해제 실패\n  status: ${e.response?.statusCode}\n  response: ${e.response?.data}');
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
      final response = await _dio.get(ApiEndpoints.playerInterest);
      developer.log('[Favorites] 관심 선수 응답 status: ${response.statusCode}');
      final rawData = response.data;
      final List<dynamic> list = rawData is String
          ? jsonDecode(rawData) as List<dynamic>
          : rawData as List<dynamic>;
      return list
          .map((e) => FavoritePlayerModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      developer.log('[Favorites] 관심 선수 조회 실패\n  status: ${e.response?.statusCode}\n  response: ${e.response?.data}');
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
      await _dio.post(ApiEndpoints.favoritePlayer(playerId.toString()));
      developer.log('[Favorites] 관심 선수 등록 성공');
    } on DioException catch (e) {
      developer.log('[Favorites] 관심 선수 등록 실패\n  status: ${e.response?.statusCode}\n  response: ${e.response?.data}');
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
      await _dio.delete(ApiEndpoints.favoritePlayer(playerId.toString()));
      developer.log('[Favorites] 관심 선수 해제 성공');
    } on DioException catch (e) {
      developer.log('[Favorites] 관심 선수 해제 실패\n  status: ${e.response?.statusCode}\n  response: ${e.response?.data}');
      rethrow;
    } catch (e, stack) {
      developer.log('[Favorites] 관심 선수 해제 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
