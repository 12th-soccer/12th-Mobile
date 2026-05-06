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

  @override
  Future<List<ClubSearchResultModel>> searchClubs(String keyword) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.teamSearch,
        queryParameters: {'keyword': keyword},
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final list =
              (json['clubs'] as List<dynamic>?) ??
              (json['content'] as List<dynamic>?) ??
              [];
          return list
              .map(
                (e) => ClubSearchResultModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
        },
      );
    } on ApiException catch (_) {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<PlayerSearchResultModel>> searchPlayers(String keyword) async {
    try {
      return await _apiClient.get(
        ApiEndpoints.playerSearch,
        queryParameters: {'keyword': keyword},
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          final list = (json['content'] as List<dynamic>?) ?? [];
          return list
              .map(
                (e) => PlayerSearchResultModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList();
        },
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
