import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_club.dart';
import 'package:twelfth_mobile/features/favorites/domain/entities/favorite_player.dart';
import 'package:twelfth_mobile/features/favorites/domain/repositories/i_favorites_repository.dart';

class GetFavoriteClubsUseCase {
  final IFavoritesRepository _repository;

  const GetFavoriteClubsUseCase(this._repository);

  Future<List<FavoriteClub>> call() => _repository.getFavoriteClubs();
}

class AddFavoriteClubUseCase {
  final IFavoritesRepository _repository;

  const AddFavoriteClubUseCase(this._repository);

  Future<void> call(int clubId) => _repository.addFavoriteClub(clubId);
}

class RemoveFavoriteClubUseCase {
  final IFavoritesRepository _repository;

  const RemoveFavoriteClubUseCase(this._repository);

  Future<void> call(int clubId) => _repository.removeFavoriteClub(clubId);
}

class GetFavoritePlayersUseCase {
  final IFavoritesRepository _repository;

  const GetFavoritePlayersUseCase(this._repository);

  Future<List<FavoritePlayer>> call() => _repository.getFavoritePlayers();
}

class AddFavoritePlayerUseCase {
  final IFavoritesRepository _repository;

  const AddFavoritePlayerUseCase(this._repository);

  Future<void> call(int playerId) => _repository.addFavoritePlayer(playerId);
}

class RemoveFavoritePlayerUseCase {
  final IFavoritesRepository _repository;

  const RemoveFavoritePlayerUseCase(this._repository);

  Future<void> call(int playerId) => _repository.removeFavoritePlayer(playerId);
}
