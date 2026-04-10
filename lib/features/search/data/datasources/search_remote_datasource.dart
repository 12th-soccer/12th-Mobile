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

  @override
  Future<List<ClubSearchResultModel>> searchClubs(String keyword) async {
    try {
      developer.log('[Search] 구단 검색: keyword=$keyword');
      final response = await _dio.get(
        ApiEndpoints.clubSearch,
        queryParameters: {'keyword': keyword},
      );
      developer.log(
        '[Search] 구단 검색 응답 status: ${response.statusCode} | data: ${response.data}',
      );
      final data = _parseMap(response.data);
      final list =
          (data['clubs'] as List<dynamic>?) ??
          (data['content'] as List<dynamic>?) ??
          [];
      return list
          .map((e) => ClubSearchResultModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      developer.log(
        '[Search] 구단 검색 실패 (DioException)\n  type: ${e.type}\n  status: ${e.response?.statusCode}\n  message: ${e.message}\n  error: ${e.error}\n  URL: ${e.requestOptions.uri}\n  response: ${e.response?.data}',
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
        '[Search] 선수 검색 응답 status: ${response.statusCode} | data: ${response.data}',
      );
      final data = _parseMap(response.data);
      final list = (data['content'] as List<dynamic>?) ?? [];
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
