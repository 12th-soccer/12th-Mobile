import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/features/match/data/models/match_model.dart';

abstract interface class IMatchRemoteDataSource {
  Future<List<MatchModel>> getMatchesByDate(String date);

  Future<MatchModel> getMatchDetail(int matchId);
}

class MatchRemoteDataSourceImpl implements IMatchRemoteDataSource {
  final Dio _dio;

  const MatchRemoteDataSourceImpl(this._dio);

  Map<String, dynamic> _parseMap(dynamic rawData) {
    if (rawData is String) return jsonDecode(rawData) as Map<String, dynamic>;
    return rawData as Map<String, dynamic>;
  }

  @override
  Future<List<MatchModel>> getMatchesByDate(String date) async {
    try {
      developer.log('[Match] 날짜별 경기 조회: date=$date');
      final response = await _dio.get(
        ApiEndpoints.matchByDate,
        queryParameters: {'date': date},
      );
      developer.log(
        '[Match] 날짜별 경기 응답 status: ${response.statusCode} | data: ${response.data}',
      );
      final raw = response.data;
      if (raw == null) return [];
      List<dynamic> list;
      if (raw is List) {
        list = raw;
      } else {
        final data = _parseMap(raw);
        list =
            (data['content'] as List<dynamic>?) ??
            (data['matches'] as List<dynamic>?) ??
            [];
      }
      return list
          .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      developer.log(
        '[Match] 날짜별 경기 실패 (DioException)\n  status: $status\n  URL: ${e.requestOptions.uri}\n  response: ${e.response?.data}',
      );
      if (status == 400 || status == 404) return [];
      rethrow;
    } catch (e, stack) {
      developer.log('[Match] 날짜별 경기 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<MatchModel> getMatchDetail(int matchId) async {
    try {
      developer.log('[Match] 경기 상세 조회: matchId=$matchId');
      final response = await _dio.get(ApiEndpoints.match(matchId.toString()));
      developer.log(
        '[Match] 경기 상세 응답 status: ${response.statusCode} | data: ${response.data}',
      );
      final data = _parseMap(response.data);
      return MatchModel.fromJson(data);
    } on DioException catch (e) {
      developer.log(
        '[Match] 경기 상세 실패 (DioException)\n  status: ${e.response?.statusCode}\n  URL: ${e.requestOptions.uri}\n  response: ${e.response?.data}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Match] 경기 상세 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
