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
      final season = date.split('-').first;
      return await _apiClient.get(
        ApiEndpoints.matchByDate(season, date),
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
      if (status == 400 || status == 404) return [];
      rethrow;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<MatchModel> getMatchDetail(int matchId) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.match(matchId.toString()),
        decoder: (data) =>
            MatchModel.fromJson(data as Map<String, dynamic>),
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<MatchEventModel>> getMatchEvents(int matchId) async {
    try {
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
      if (status == 400 || status == 404) return [];
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
