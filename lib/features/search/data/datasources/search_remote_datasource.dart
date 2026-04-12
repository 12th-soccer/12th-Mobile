import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/search/data/models/search_models.dart';

abstract interface class ISearchRemoteDataSource {
  Future<List<ClubSearchResultModel>> searchClubs(String keyword);

  Future<List<PlayerSearchResultModel>> searchPlayers(String keyword);
}

class SearchRemoteDataSourceImpl implements ISearchRemoteDataSource {
  final Dio _dio;

  const SearchRemoteDataSourceImpl(this._dio);

  Map<String, dynamic> _parseMap(dynamic rawData) {
    if (rawData is String) return jsonDecode(rawData) as Map<String, dynamic>;
    return rawData as Map<String, dynamic>;
  }

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
      final response = await _dio.get(
        ApiEndpoints.clubSearch,
        queryParameters: {'keyword': keyword},
      );
      _logDebug('[Search] 구단 검색 응답 status: ${response.statusCode}');
      final data = _parseMap(response.data);
      final list =
          (data['clubs'] as List<dynamic>?) ??
          (data['content'] as List<dynamic>?) ??
          [];
      if (list.isNotEmpty) {
        _logDebug('[Search] 구단 검색 첫 번째 item 필드: ${(list.first as Map).keys.toList()}');
        _logDebug('[Search] 구단 검색 첫 번째 item: ${list.first}');
      }
      return list
          .map((e) => ClubSearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _logDebug(
        '[Search] 구단 검색 실패 type=${e.type} status=${e.response?.statusCode} path=${e.requestOptions.path}',
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
      final response = await _dio.get(
        ApiEndpoints.playerSearch,
        queryParameters: {'keyword': keyword},
      );
      developer.log(
        '[Search] 선수 검색 응답 status: ${response.statusCode}',
      );
      final data = _parseMap(response.data);
      final list = (data['content'] as List<dynamic>?) ?? [];
      if (list.isNotEmpty) {
        developer.log('[Search] 선수 검색 첫 번째 item 필드: ${(list.first as Map).keys.toList()}');
        developer.log('[Search] 선수 검색 첫 번째 item: ${list.first}');
      }
      return list
          .map(
            (e) => PlayerSearchResultModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      developer.log(
        '[Search] 선수 검색 실패 (DioException)\n  type: ${e.type}\n  status: ${e.response?.statusCode}\n  message: ${e.message}\n  error: ${e.error}\n  URL: ${e.requestOptions.uri}\n  response: ${e.response?.data}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Search] 선수 검색 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
