import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twelfth_mobile/core/network/dio.dart';
import 'package:twelfth_mobile/features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'package:twelfth_mobile/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_player.dart';
import 'package:twelfth_mobile/features/favorites/domain/repositories/i_favorites_repository.dart';
import 'package:twelfth_mobile/features/favorites/domain/usecases/get_favorite_clubs_usecase.dart';

final _dioProvider = Provider<Dio>((ref) => DioClient.instance.dio);

final _favoritesRemoteDataSourceProvider = Provider<IFavoritesRemoteDataSource>(
  (ref) => FavoritesRemoteDataSourceImpl(ref.read(_dioProvider)),
);

final favoritesRepositoryProvider = Provider<IFavoritesRepository>(
  (ref) =>
      FavoritesRepositoryImpl(ref.read(_favoritesRemoteDataSourceProvider)),
);

final _getFavoriteClubsUseCaseProvider = Provider<GetFavoriteClubsUseCase>(
  (ref) => GetFavoriteClubsUseCase(ref.read(favoritesRepositoryProvider)),
);
final _addFavoriteClubUseCaseProvider = Provider<AddFavoriteClubUseCase>(
  (ref) => AddFavoriteClubUseCase(ref.read(favoritesRepositoryProvider)),
);
final _removeFavoriteClubUseCaseProvider = Provider<RemoveFavoriteClubUseCase>(
  (ref) => RemoveFavoriteClubUseCase(ref.read(favoritesRepositoryProvider)),
);
final _getFavoritePlayersUseCaseProvider = Provider<GetFavoritePlayersUseCase>(
  (ref) => GetFavoritePlayersUseCase(ref.read(favoritesRepositoryProvider)),
);
final _addFavoritePlayerUseCaseProvider = Provider<AddFavoritePlayerUseCase>(
  (ref) => AddFavoritePlayerUseCase(ref.read(favoritesRepositoryProvider)),
);
final _removeFavoritePlayerUseCaseProvider =
    Provider<RemoveFavoritePlayerUseCase>(
      (ref) =>
          RemoveFavoritePlayerUseCase(ref.read(favoritesRepositoryProvider)),
    );

class FavoritesNotifier extends AsyncNotifier<List<FavoriteClub>> {
  @override
  Future<List<FavoriteClub>> build() => _fetch();

  Future<List<FavoriteClub>> _fetch() =>
      ref.read(_getFavoriteClubsUseCaseProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  bool isFavorite(int clubId) =>
      state.valueOrNull?.any((c) => c.clubId == clubId) ?? false;

  Future<bool> toggleFavorite(int clubId, String clubName) async {
    final current = state.valueOrNull ?? [];
    final alreadyFavorite = current.any((c) => c.clubId == clubId);

    if (alreadyFavorite) {
      state = AsyncData(current.where((c) => c.clubId != clubId).toList());
    } else {
      state = AsyncData([
        ...current,
        FavoriteClub(clubId: clubId, clubName: clubName),
      ]);
    }

    try {
      if (alreadyFavorite) {
        await ref.read(_removeFavoriteClubUseCaseProvider).call(clubId);
      } else {
        await ref.read(_addFavoriteClubUseCaseProvider).call(clubId);
      }
      return !alreadyFavorite;
    } catch (_) {
      state = AsyncData(current);
      rethrow;
    }
  }
}

final favoritesNotifierProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<FavoriteClub>>(
      FavoritesNotifier.new,
    );

class FavoritePlayersNotifier extends AsyncNotifier<List<FavoritePlayer>> {
  @override
  Future<List<FavoritePlayer>> build() => _fetch();

  Future<List<FavoritePlayer>> _fetch() =>
      ref.read(_getFavoritePlayersUseCaseProvider).call();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }

  bool isFavorite(int playerId) =>
      state.valueOrNull?.any((p) => p.playerId == playerId) ?? false;

  Future<bool> toggleFavorite(int playerId, String playerName) async {
    final current = state.valueOrNull ?? [];
    final alreadyFavorite = current.any((p) => p.playerId == playerId);

    if (alreadyFavorite) {
      state = AsyncData(current.where((p) => p.playerId != playerId).toList());
    } else {
      state = AsyncData([
        ...current,
        FavoritePlayer(playerId: playerId, playerName: playerName),
      ]);
    }

    try {
      if (alreadyFavorite) {
        await ref.read(_removeFavoritePlayerUseCaseProvider).call(playerId);
      } else {
        await ref.read(_addFavoritePlayerUseCaseProvider).call(playerId);
      }
      return !alreadyFavorite;
    } catch (_) {
      state = AsyncData(current);
      rethrow;
    }
  }
}

final favoritePlayersNotifierProvider =
    AsyncNotifierProvider<FavoritePlayersNotifier, List<FavoritePlayer>>(
      FavoritePlayersNotifier.new,
    );
