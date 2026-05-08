import 'package:flutter/foundation.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/features/search/data/models/search_models.dart';

abstract interface class ISearchRemoteDataSource {
  Future<List<ClubSearchResultModel>> searchClubs(String keyword);

  Future<List<PlayerSearchResultModel>> searchPlayers(
    String keyword, {
    String? season,
  });
}

class SearchRemoteDataSourceImpl implements ISearchRemoteDataSource {
  final ApiClient _apiClient;

  const SearchRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ClubSearchResultModel>> searchClubs(String keyword) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.searchTeam(keyword),
        decoder: (data) {
          if (data == null) return <ClubSearchResultModel>[];
          final list = _toList(data);
          if (list.isNotEmpty) {
            debugPrint(
              '[Search] club raw keys: ${(list.first as Map<String, dynamic>).keys.toList()}',
            );
          }
          return list
              .map(
                (e) =>
                    ClubSearchResultModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        },
      );
    } on ApiException catch (e) {
      if (e.statusCode == 400 || e.statusCode == 404) return [];
      rethrow;
    }
  }

  @override
  Future<List<PlayerSearchResultModel>> searchPlayers(
    String keyword, {
    String? season,
  }) async {
    final q = keyword.toLowerCase();

    try {
      final results = await _apiClient.get(
        ApiEndpoints.searchPlayer(keyword, season: season),
        decoder: (data) {
          if (data == null) return <PlayerSearchResultModel>[];
          final list = _toList(data);
          if (list.isNotEmpty) {
            final first = list.first as Map<String, dynamic>;
            debugPrint('[Search] player raw keys: ${first.keys.toList()}');
            debugPrint('[Search] player first item: $first');
          }
          return list
              .map(
                (e) =>
                    PlayerSearchResultModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        },
      );
      if (results.isNotEmpty) return results;
    } on ApiException catch (e) {
      if (e.statusCode != 400 && e.statusCode != 404) rethrow;
    }

    debugPrint(
      '[Search] falling back to full player list for keyword: $keyword',
    );
    final allPlayers = <PlayerSearchResultModel>[];

    final fallbackSeason = season ?? DateTime.now().year.toString();
    for (final endpoint in [
      ApiEndpoints.playersKleague1(fallbackSeason),
      ApiEndpoints.playersKleague2(fallbackSeason),
    ]) {
      try {
        final page = await _apiClient.get(
          endpoint,
          decoder: (data) {
            if (data == null) return <PlayerSearchResultModel>[];
            final list = _toList(data);
            return list
                .map(
                  (e) => PlayerSearchResultModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList();
          },
        );
        allPlayers.addAll(page);
      } on ApiException catch (e) {
        if (e.statusCode != 400 && e.statusCode != 404) rethrow;
      }
    }

    return allPlayers.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  List<dynamic> _toList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      return (data['content'] ??
              data['players'] ??
              data['teams'] ??
              data['data'] ??
              [])
          as List<dynamic>;
    }
    return [];
  }
}
