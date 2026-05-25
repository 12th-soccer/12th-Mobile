import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/api_client.dart';
import 'package:twelfth_mobile/core/network/api_endpoints.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/search/data/models/search_models.dart';

class PlayerCacheService {
  static final PlayerCacheService _instance = PlayerCacheService._internal();

  factory PlayerCacheService() => _instance;

  PlayerCacheService._internal();

  final Map<int, PlayerSearchResultModel> _playerCache = {};
  bool _isK1Loaded = false;
  bool _isK2Loaded = false;

  Future<void> initializeCache() async {
    await Future.wait([_loadK1Players(), _loadK2Players()]);
  }

  Future<void> _loadK1Players() async {
    if (_isK1Loaded) return;

    try {
      final client = DioClient.instance.apiClient;
      final players = await client.get<List<dynamic>>(
        ApiEndpoints.playersKleague1('2024'),
        decoder: (data) {
          if (data == null) return <dynamic>[];
          if (data is List) return data;
          if (data is Map<String, dynamic>) {
            return (data['content'] ?? data['players'] ?? []) as List<dynamic>;
          }
          return [];
        },
      );

      int playersWithImages = 0;
      int playersWithoutImages = 0;

      for (final playerJson in players) {
        final player = PlayerSearchResultModel.fromJson(
          playerJson as Map<String, dynamic>,
        );
        _playerCache[player.playerId] = player;

        if (player.imageUrl != null && player.imageUrl!.isNotEmpty) {
          playersWithImages++;
        } else {
          playersWithoutImages++;
        }
      }

      _isK1Loaded = true;
      print('[PlayerCache] Loaded ${players.length} K1 players');
      print('[PlayerCache] K1 players with images: $playersWithImages');
      print('[PlayerCache] K1 players without images: $playersWithoutImages');
    } catch (e) {
      print('[PlayerCache] Failed to load K1 players: $e');
    }
  }

  Future<void> _loadK2Players() async {
    if (_isK2Loaded) return;

    try {
      final client = DioClient.instance.apiClient;
      final players = await client.get<List<dynamic>>(
        ApiEndpoints.playersKleague2('2024'),
        decoder: (data) {
          if (data == null) return <dynamic>[];
          if (data is List) return data;
          if (data is Map<String, dynamic>) {
            return (data['content'] ?? data['players'] ?? []) as List<dynamic>;
          }
          return [];
        },
      );

      int playersWithImages = 0;
      int playersWithoutImages = 0;

      for (final playerJson in players) {
        final player = PlayerSearchResultModel.fromJson(
          playerJson as Map<String, dynamic>,
        );
        _playerCache[player.playerId] = player;

        if (player.imageUrl != null && player.imageUrl!.isNotEmpty) {
          playersWithImages++;
        } else {
          playersWithoutImages++;
        }
      }

      _isK2Loaded = true;
      print('[PlayerCache] Loaded ${players.length} K2 players');
      print('[PlayerCache] K2 players with images: $playersWithImages');
      print('[PlayerCache] K2 players without images: $playersWithoutImages');
    } catch (e) {
      print('[PlayerCache] Failed to load K2 players: $e');
    }
  }

  PlayerSearchResultModel? getCachedPlayer(int playerId) {
    return _playerCache[playerId];
  }

  String? getCachedPlayerImage(int playerId) {
    final player = _playerCache[playerId];
    if (player?.imageUrl != null) {
      print(
        '[PlayerCache] Found cached image for player $playerId: ${player!.imageUrl}',
      );
    }
    return player?.imageUrl;
  }

  int get cacheSize => _playerCache.length;

  bool get isInitialized => _isK1Loaded && _isK2Loaded;
}

final playerCacheInitProvider = FutureProvider<void>((ref) async {
  await PlayerCacheService().initializeCache();
});

final enhancedPlayerImageProvider = FutureProvider.family<String?, int>((
  ref,
  playerId,
) async {
  if (playerId == 0) {
    print('[PlayerImage] Skipping player ID 0');
    return null;
  }

  print('[PlayerImage] === Starting enhanced provider for player $playerId ===');

  final cacheService = PlayerCacheService();
  if (!cacheService.isInitialized) {
    print('[PlayerImage] Cache not initialized for $playerId, waiting...');
    await cacheService.initializeCache();
  }

  print('[PlayerImage] Cache initialized. Cache size: ${cacheService.cacheSize}');

  final cachedImage = cacheService.getCachedPlayerImage(playerId);
  print('[PlayerImage] Cached image for $playerId: $cachedImage');

  if (cachedImage != null && cachedImage.isNotEmpty) {
    print('[PlayerImage] Using cached image for $playerId: $cachedImage');
    print('[PlayerImage] === Final result for player $playerId: $cachedImage ===');
    return cachedImage;
  }

  print('[PlayerImage] No cached image for $playerId, trying individual API...');

  final client = DioClient.instance.apiClient;
  final currentYear = DateTime.now().year;
  final seasons = [currentYear.toString(), (currentYear - 1).toString(), (currentYear - 2).toString()];

  for (final season in seasons) {
    try {
      print('[PlayerImage] Calling individual player API for $playerId, season $season');

      final imageUrl = await client.get(
        ApiEndpoints.player(playerId.toString(), season: season),
        decoder: (data) => _parsePlayerImageData(data, season),
      );

      if (imageUrl != null && imageUrl.isNotEmpty) {
        print('[PlayerImage] Found image URL in season $season: $imageUrl');
        print('[PlayerImage] === Final result for player $playerId: $imageUrl ===');
        return imageUrl;
      } else {
        print('[PlayerImage] No image found in season $season, trying next...');
      }

    } on ApiException catch (e) {
      final status = e.statusCode;
      if (status == 400 || status == 401 || status == 403 || status == 404) {
        print('[PlayerImage] No data for player $playerId in season $season (${status}), trying next...');
        continue;
      }
      print('[PlayerImage] API error for player $playerId in season $season: ${e.statusCode}');
      continue;
    } catch (e) {
      print('[PlayerImage] Unexpected error for player $playerId in season $season: $e');
      continue;
    }
  }

  print('[PlayerImage] No image found for player $playerId in any season');
  print('[PlayerImage] === Final result for player $playerId: null ===');
  return null;
});

String? _parsePlayerImageData(dynamic data, String season) {
  print('[PlayerImage] Individual player API response for season $season: $data (type: ${data.runtimeType})');

  if (data == null) {
    print('[PlayerImage] Null response from player API for season $season');
    return null;
  }

  if (data is String && data.trim().isEmpty) {
    print('[PlayerImage] Empty string response from player API for season $season');
    return null;
  }

  if (data is! Map<String, dynamic>) {
    print('[PlayerImage] Unexpected response type from player API for season $season: ${data.runtimeType}');
    return null;
  }

  final json = data;
  print('[PlayerImage] Player data keys for season $season: ${json.keys.toList()}');

  final photo = json['photo'] as String?;
  final playerImageUrl = json['playerImageUrl'] as String?;
  final profileImageUrl = json['profileImageUrl'] as String?;
  final imageUrl = json['imageUrl'] as String?;
  final defaultImageUrl = json['defaultImageUrl'] as String?;
  final profileImage = json['profileImage'] as String?;
  final defaultProfile = json['defaultProfile'] as String?;
  final defaultAvatar = json['defaultAvatar'] as String?;

  final rawName = json['name'] as String? ?? '';
  final isSwapped = photo == null && rawName.startsWith('http');

  final resolvedImageUrl = photo ??
      playerImageUrl ??
      profileImageUrl ??
      defaultImageUrl ??
      defaultProfile ??
      defaultAvatar ??
      imageUrl ??
      profileImage;

  final finalUrl = isSwapped ? rawName : resolvedImageUrl;

  print('[PlayerImage] API response fields for season $season - photo: $photo, playerImageUrl: $playerImageUrl, final: $finalUrl');

  if (finalUrl != null && finalUrl.isNotEmpty) {
    final lowerUrl = finalUrl.toLowerCase();
    if (lowerUrl.contains('default') ||
        lowerUrl.contains('placeholder') ||
        lowerUrl.contains('no-image') ||
        lowerUrl.contains('avatar') ||
        finalUrl.endsWith('default.png') ||
        finalUrl.endsWith('default.jpg') ||
        finalUrl.endsWith('profile_default.png')) {
      print('[PlayerImage] Server default image detected for season $season: $finalUrl');
      return finalUrl;
    }
  }

  return finalUrl;
}
