import 'package:flutter/foundation.dart';

class Bookmarking extends ChangeNotifier {
  static final Bookmarking instance = Bookmarking._();
  Bookmarking._();

  final Set<String> _teams = {};
  final Set<String> _players = {};

  Set<String> get teams => _teams;
  Set<String> get players => _players;

  bool isTeamBookmarked(String name) => _teams.contains(name);
  bool isPlayerBookmarked(String name) => _players.contains(name);

  void toggleTeam(String name) {
    _teams.contains(name) ? _teams.remove(name) : _teams.add(name);
    notifyListeners();
  }

  void togglePlayer(String name) {
    _players.contains(name) ? _players.remove(name) : _players.add(name);
    notifyListeners();
  }
}
