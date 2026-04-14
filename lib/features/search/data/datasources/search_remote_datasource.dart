import 'dart:developer' as developer;
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/search/data/models/search_models.dart';

abstract interface class ISearchRemoteDataSource {
  Future<List<ClubSearchResultModel>> searchClubs(String keyword);

  Future<List<PlayerSearchResultModel>> searchPlayers(String keyword);
}

class SearchRemoteDataSourceImpl implements ISearchRemoteDataSource {
  final ApiClient _apiClient;

  const SearchRemoteDataSourceImpl(this._apiClient);

  void _logDebug(String message) {
    assert(() {
      developer.log(message, name: 'SearchRemoteDataSource');
      return true;
    }());
  }

  @override
  Future<List<ClubSearchResultModel>> searchClubs(String keyword) async {
    try {
      _logDebug('[Search] 구단 검색 요청');
      return await _apiClient.get(
        ApiEndpoints.clubSearch,
        queryParameters: {'keyword': keyword},
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final list =
              (json['clubs'] as List<dynamic>?) ??
              (json['content'] as List<dynamic>?) ??
              [];
          if (list.isNotEmpty) {
            _logDebug('[Search] 구단 검색 첫 번째 item 필드: ${(list.first as Map).keys.toList()}');
            _logDebug('[Search] 구단 검색 첫 번째 item: ${list.first}');
          }
          return list
              .map(
                (e) => ClubSearchResultModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      _logDebug(
        '[Search] 구단 검색 실패 type=${e.type} status=${e.statusCode} uri=${e.uri}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Search] 구단 검색 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<PlayerSearchResultModel>> searchPlayers(String keyword) async {
    try {
      developer.log('[Search] 선수 검색: keyword=$keyword');
      return await _apiClient.get(
        ApiEndpoints.playerSearch,
        queryParameters: {'keyword': keyword},
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final list = (json['content'] as List<dynamic>?) ?? [];
          if (list.isNotEmpty) {
            developer.log('[Search] 선수 검색 첫 번째 item 필드: ${(list.first as Map).keys.toList()}');
            developer.log('[Search] 선수 검색 첫 번째 item: ${list.first}');
          }
          return list
              .map(
                (e) => PlayerSearchResultModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      developer.log(
        '[Search] 선수 검색 실패 (ApiException)\n  type: ${e.type}\n  status: ${e.statusCode}\n  message: ${e.message}\n  URL: ${e.uri}\n  response: ${e.responseData}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Search] 선수 검색 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
