import 'package:flutter_riverpod/flutter_riverpod.dart';

class RevealedMatchesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void reveal(String matchId) {
    if (!state.contains(matchId)) {
      state = {...state, matchId};
    }
  }

  bool isRevealed(String matchId) => state.contains(matchId);
}

final revealedMatchesProvider =
    NotifierProvider<RevealedMatchesNotifier, Set<String>>(
  RevealedMatchesNotifier.new,
);
