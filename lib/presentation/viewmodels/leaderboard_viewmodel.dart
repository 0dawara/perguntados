import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../data/repositories/game_repository.dart';

class LeaderboardViewModel extends ChangeNotifier {
  final GameRepository _repository;
  List<ParseObject> _topUsers = [];
  bool _isLoading = true;

  List<ParseObject> get topUsers => _topUsers;
  bool get isLoading => _isLoading;

  LeaderboardViewModel({GameRepository? repository}) : _repository = repository ?? GameRepository() {
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    _isLoading = true;
    notifyListeners();
    _topUsers = await _repository.getLeaderboard();
    _isLoading = false;
    notifyListeners();
  }
}
