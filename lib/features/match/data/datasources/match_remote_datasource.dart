import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/match/data/models/match_event_model.dart';
import 'package:twelfth_mobile/features/match/data/models/match_lineup_model.dart';
import 'package:twelfth_mobile/features/match/data/models/match_model.dart';

abstract interface class IMatchRemoteDataSource {
  Future<List<MatchModel>> getMatchesByDate(String date, String leagueType);
  Future<MatchModel> getMatchDetail(int matchId);
  Future<List<MatchEventModel>> getMatchEvents(int matchId);
  Future<List<MatchLineupModel>> getMatchLineups(int matchId);
}

class MatchRemoteDataSourceImpl implements IMatchRemoteDataSource {
  final ApiClient _apiClient;

  const MatchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<MatchModel>> getMatchesByDate(String date, String leagueType) async {
    try {
      final endpoint = leagueType == 'K2'
          ? ApiEndpoints.matchDateKleague2(date)
          : ApiEndpoints.matchDateKleague1(date);
      return await _apiClient.get(
        endpoint,
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
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MatchModel> getMatchDetail(int matchId) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.match(matchId.toString()),
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final matchJson = json['match'] as Map<String, dynamic>? ?? json;
          return MatchModel.fromJson(matchJson);
        },
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
        ApiEndpoints.match(matchId.toString()),
        decoder: (data) {
          if (data == null) return <MatchEventModel>[];
          final json = data as Map<String, dynamic>;
          final list = json['events'] as List<dynamic>? ?? [];
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

  @override
  Future<List<MatchLineupModel>> getMatchLineups(int matchId) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.match(matchId.toString()),
        decoder: (data) {
          if (data == null) return <MatchLineupModel>[];
          final json = data as Map<String, dynamic>;
          final list = json['lineups'] as List<dynamic>? ?? [];
          return list
              .map((e) => MatchLineupModel.fromJson(e as Map<String, dynamic>))
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
