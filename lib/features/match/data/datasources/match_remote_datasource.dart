import 'dart:developer' as developer;
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/match/data/models/match_event_model.dart';
import 'package:twelfth_mobile/features/match/data/models/match_model.dart';

abstract interface class IMatchRemoteDataSource {
  Future<List<MatchModel>> getMatchesByDate(String date);

  Future<MatchModel> getMatchDetail(int matchId);

  Future<List<MatchEventModel>> getMatchEvents(int matchId);
}

class MatchRemoteDataSourceImpl implements IMatchRemoteDataSource {
  final ApiClient _apiClient;

  const MatchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<MatchModel>> getMatchesByDate(String date) async {
    try {
      developer.log('[Match] 날짜별 경기 조회: date=$date');
      return await _apiClient.get(
        ApiEndpoints.matchByDate,
        queryParameters: {'date': date},
        decoder: (data) {
          if (data == null) return <MatchModel>[];
          final List<dynamic> list;
          if (data is List<dynamic>) {
            list = data;
          } else {
            final json = data as Map<String, dynamic>;
            list =
                (json['content'] as List<dynamic>?) ??
                (json['matches'] as List<dynamic>?) ??
                [];
          }
          return list
              .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } on ApiException catch (e) {
      final status = e.statusCode;
      developer.log(
        '[Match] 날짜별 경기 실패 (ApiException)\n  status: $status\n  URL: ${e.uri}\n  response: ${e.responseData}',
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
      return await _apiClient.get(
        ApiEndpoints.match(matchId.toString()),
        decoder: (data) => MatchModel.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException catch (e) {
      developer.log(
        '[Match] 경기 상세 실패 (ApiException)\n  status: ${e.statusCode}\n  URL: ${e.uri}\n  response: ${e.responseData}',
      );
      rethrow;
    } catch (e, stack) {
      developer.log('[Match] 경기 상세 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }

  @override
  Future<List<MatchEventModel>> getMatchEvents(int matchId) async {
    try {
      developer.log('[Match] 경기 이벤트 조회: matchId=$matchId');
      return await _apiClient.get(
        ApiEndpoints.event(matchId.toString()),
        decoder: (data) {
          if (data == null) return <MatchEventModel>[];
          final list = data as List<dynamic>;
          return list
              .map((e) => MatchEventModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );
    } on ApiException catch (e) {
      final status = e.statusCode;
      developer.log(
        '[Match] 경기 이벤트 실패 (ApiException)\n  status: $status\n  URL: ${e.uri}\n  response: ${e.responseData}',
      );
      if (status == 400 || status == 404) return [];
      rethrow;
    } catch (e, stack) {
      developer.log('[Match] 경기 이벤트 실패 (Exception)\n  $e\n$stack');
      rethrow;
    }
  }
}
