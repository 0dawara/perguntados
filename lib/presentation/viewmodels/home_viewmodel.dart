import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/auth_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HomeViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  final AuthRepository _authRepository;
  
  List<CategoryModel> _categories = [];
  bool _isLoading = true;
  num _currentScore = 0;
  bool _isSpinning = false;
  int? _selectedIndex;
  final StreamController<int> _selectedController = StreamController<int>.broadcast();

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  num get currentScore => _currentScore;
  bool get isSpinning => _isSpinning;
  int? get selectedIndex => _selectedIndex;
  Stream<int> get selectedStream => _selectedController.stream;

  HomeViewModel(ParseUser? user, {GameRepository? gameRepository, AuthRepository? authRepository})
      : _gameRepository = gameRepository ?? GameRepository(),
        _authRepository = authRepository ?? AuthRepository() {
    _currentScore = user?.get<num>('totalScore') ?? 0;
    _loadCategories();
  }

  @override
  void dispose() {
    _selectedController.close();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    _isLoading = true;
    notifyListeners();
    _categories = await _gameRepository.getCategories();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshScore(ParseUser? user) async {
    if (user != null) {
      final updatedUser = await _authRepository.refreshUser(user);
      if (updatedUser != null) {
        _currentScore = updatedUser.get<num>('totalScore') ?? 0;
        notifyListeners();
      }
    }
  }

  void spinWheel() {
    if (_categories.isEmpty || _isSpinning) return;
    
    _isSpinning = true;
    _selectedIndex = _generateRandomIndex();
    _selectedController.add(_selectedIndex!);
    notifyListeners();
  }

  int _generateRandomIndex() {
    // Basic random logic, could be more complex
    return DateTime.now().millisecondsSinceEpoch % _categories.length;
  }

  void onAnimationEnd() {
    _isSpinning = false;
    notifyListeners();
  }

  CategoryModel? getSelectedCategory() {
    if (_selectedIndex == null) return null;
    return _categories[_selectedIndex!];
  }
}
