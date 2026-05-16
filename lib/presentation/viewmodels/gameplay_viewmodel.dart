import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/models/question_model.dart';
import '../../data/repositories/game_repository.dart';

class GameplayViewModel extends ChangeNotifier {
  final GameRepository _repository = GameRepository();
  final CategoryModel category;

  List<QuestionModel> _questions = [];
  QuestionModel? _currentQuestion;
  bool _isLoading = true;
  int? _selectedAnswerIndex;
  bool _answered = false;
  int _timeLeft = 15;
  Timer? _timer;

  List<QuestionModel> get questions => _questions;
  QuestionModel? get currentQuestion => _currentQuestion;
  bool get isLoading => _isLoading;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get answered => _answered;
  int get timeLeft => _timeLeft;

  GameplayViewModel({required this.category}) {
    _loadQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    _isLoading = true;
    notifyListeners();
    _questions = await _repository.getQuestionsByCategory(category.id);
    if (_questions.isNotEmpty) {
      _currentQuestion = _questions[Random().nextInt(_questions.length)];
      _startTimer();
    }
    _isLoading = false;
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        _timer?.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    if (!_answered) {
      _answered = true;
      _selectedAnswerIndex = -1;
      notifyListeners();
    }
  }

  bool answerQuestion(int index) {
    if (_answered) return false;

    _timer?.cancel();
    _selectedAnswerIndex = index;
    _answered = true;
    notifyListeners();

    final isCorrect = (index == _currentQuestion?.correctAnswerIndex);
    if (isCorrect) {
      final points = category.name.toLowerCase() == 'coroa' ? 25 : 10;
      _repository.updateScore(points);
    }
    return isCorrect;
  }
}
