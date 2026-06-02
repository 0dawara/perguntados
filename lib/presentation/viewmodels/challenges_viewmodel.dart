import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../data/models/challenge_model.dart';
import '../../data/repositories/challenge_repository.dart';

class ChallengesViewModel extends ChangeNotifier {
  final ChallengeRepository _repository;
  ParseUser? _currentUser;
  
  bool _isLoading = true;
  bool _isCreating = false;
  
  List<ParseUser> _users = [];
  List<ChallengeModel> _myTurnChallenges = [];
  List<ChallengeModel> _theirTurnChallenges = [];
  
  Timer? _refreshTimer;

  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  List<ParseUser> get users => _users;
  List<ChallengeModel> get myTurnChallenges => _myTurnChallenges;
  List<ChallengeModel> get theirTurnChallenges => _theirTurnChallenges;
  ParseUser? get currentUser => _currentUser;

  ChallengesViewModel({ChallengeRepository? repository}) 
      : _repository = repository ?? ChallengeRepository() {
    _init();
  }

  Future<void> _init() async {
    _currentUser = await ParseUser.currentUser() as ParseUser?;
    await refreshData();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    // Atualiza os dados a cada 10 segundos em segundo plano
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      refreshData(showLoading: false);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> refreshData({bool showLoading = true}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }

    final newUsers = await _repository.getUsersToChallenge();
    final allActive = await _repository.getActiveChallenges();
    
    _users = newUsers;
    _myTurnChallenges = [];
    _theirTurnChallenges = [];

    final now = DateTime.now();

    for (var challenge in allActive) {
      if (challenge.deadline.isBefore(now)) {
        // Handle expired challenges by updating status if needed, but for UI we can just ignore or show as expired.
        // For simplicity, we just won't show them, or we could automatically complete them.
        // Let's assume we show them as expired, but since query only fetches 'active', we might need to handle them.
        // If expired, the player whose turn it was loses. Let's just handle it in the UI or skip.
      }
      
      if (challenge.currentTurnId == _currentUser?.objectId) {
        _myTurnChallenges.add(challenge);
      } else {
        _theirTurnChallenges.add(challenge);
      }
    }

    if (showLoading) {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<ChallengeModel?> startChallenge(ParseUser opponent) async {
    _isCreating = true;
    notifyListeners();

    final challenge = await _repository.createChallenge(opponent);
    if (challenge != null) {
      _myTurnChallenges.insert(0, challenge);
    }
    
    _isCreating = false;
    notifyListeners();
    return challenge;
  }
}
