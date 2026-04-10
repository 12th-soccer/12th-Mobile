import 'package:twelfth_mobile/features/search/domain/entities/club_search_result.dart';
import 'package:twelfth_mobile/features/search/domain/entities/player_search_result.dart';

enum SearchStatus { initial, loading, success, empty, error }

enum SearchFilter { player, club }

class SearchState {
  final SearchStatus status;
  final SearchFilter filter;
  final List<ClubSearchResult> clubs;
  final List<PlayerSearchResult> players;
  final String? errorMessage;

  const SearchState({
    this.status = SearchStatus.initial,
    this.filter = SearchFilter.player,
    this.clubs = const [],
    this.players = const [],
    this.errorMessage,
  });

  bool get isLoading => status == SearchStatus.loading;

  bool get hasResults =>
      status == SearchStatus.success &&
      (clubs.isNotEmpty || players.isNotEmpty);

  SearchState copyWith({
    SearchStatus? status,
    SearchFilter? filter,
    List<ClubSearchResult>? clubs,
    List<PlayerSearchResult>? players,
    String? errorMessage,
  }) => SearchState(
    status: status ?? this.status,
    filter: filter ?? this.filter,
    clubs: clubs ?? this.clubs,
    players: players ?? this.players,
    errorMessage: errorMessage,
  );
}
