import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';

abstract interface class INoSpoilerRemoteDataSource {
  Future<bool> get();
  Future<bool> save(bool enabled);
}

class NoSpoilerRemoteDataSourceImpl implements INoSpoilerRemoteDataSource {
  const NoSpoilerRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<bool> get() async {
    try {
      return await _apiClient.get(
        ApiEndpoints.spoiler,
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          return json['spoilerEnabled'] as bool? ?? false;
        },
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) return false;
      rethrow;
    }
  }

  @override
  Future<bool> save(bool enabled) async {
    try {
      return await _apiClient.patch(
        ApiEndpoints.spoiler,
        data: {'spoilerEnabled': enabled},
        decoder: (data) {
          final json = data as Map<String, dynamic>;
          return json['spoilerEnabled'] as bool? ?? enabled;
        },
      );
    } on ApiException catch (e) {
      if (e.statusCode == 404) return enabled;
      rethrow;
    }
  }
}
