import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../../data/models/category_model.dart';
import '../../data/models/question_model.dart';
import '../../data/models/challenge_model.dart';
import '../../data/repositories/game_repository.dart';
import '../../data/repositories/challenge_repository.dart';

class ChallengeGameplayViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  final ChallengeRepository _challengeRepository;
  
  late ChallengeModel _challenge;
  ParseUser? _currentUser;
  
  // Wheel State
  List<CategoryModel> _categories = [];
  bool _isSpinning = false;
  int? _selectedCategoryIndex;
  final StreamController<int> _selectedController = StreamController<int>.broadcast();
  bool _showWheel = true;

  // Question State
  List<QuestionModel> _questions = [];
  QuestionModel? _currentQuestion;
  bool _isLoading = true;
  int? _selectedAnswerIndex;
  bool _answered = false;
  int _timeLeft = 15;
  Timer? _timer;
  bool _isTurnEnded = false;
  bool _isMatchEnded = false;

  // Getters
  ChallengeModel get challenge => _challenge;
  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  bool get isSpinning => _isSpinning;
  int? get selectedCategoryIndex => _selectedCategoryIndex;
  Stream<int> get selectedStream => _selectedController.stream;
  bool get showWheel => _showWheel;
  
  List<QuestionModel> get questions => _questions;
  QuestionModel? get currentQuestion => _currentQuestion;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get answered => _answered;
  int get timeLeft => _timeLeft;
  bool get isTurnEnded => _isTurnEnded;
  bool get isMatchEnded => _isMatchEnded;
  
  bool get isPlayer1 => _challenge.player1Id == _currentUser?.objectId;
  int get myScore => isPlayer1 ? _challenge.player1Score : _challenge.player2Score;
  int get opponentScore => isPlayer1 ? _challenge.player2Score : _challenge.player1Score;

  final VoidCallback? onTimeOut;

  ChallengeGameplayViewModel({
    required ChallengeModel challenge,
    GameRepository? gameRepository,
    ChallengeRepository? challengeRepository,
    this.onTimeOut,
  })  : _challenge = challenge,
        _gameRepository = gameRepository ?? GameRepository(),
        _challengeRepository = challengeRepository ?? ChallengeRepository() {
    _init();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _selectedController.close();
    super.dispose();
  }

  Future<void> _init() async {
    _currentUser = await ParseUser.currentUser() as ParseUser?;
    _categories = await _gameRepository.getCategories();
    _isLoading = false;
    notifyListeners();
  }

  void spinWheel() {
    if (_categories.isEmpty || _isSpinning) return;
    
    _isSpinning = true;
    _selectedCategoryIndex = Random().nextInt(_categories.length);
    _selectedController.add(_selectedCategoryIndex!);
    notifyListeners();
  }

  Future<void> onAnimationEnd() async {
    _isSpinning = false;
    _showWheel = false;
    notifyListeners();
    
    await _loadQuestionForCategory(_categories[_selectedCategoryIndex!]);
  }

  Future<void> _loadQuestionForCategory(CategoryModel category) async {
    _isLoading = true;
    notifyListeners();
    
    _questions = await _gameRepository.getQuestionsByCategory(category.id);
    if (_questions.isNotEmpty) {
      _currentQuestion = _questions[Random().nextInt(_questions.length)];
      _resetQuestionState();
      _startTimer();
    } else {
      // If no questions found, let the user spin again (fallback)
      _showWheel = true;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  void _resetQuestionState() {
    _answered = false;
    _selectedAnswerIndex = null;
    _timeLeft = 15;
  }

  void _startTimer() {
    _timer?.cancel();
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

  void _handleTimeOut() async {
    if (!_answered) {
      await answerQuestion(-1); // -1 or null means timeout/wrong
      onTimeOut?.call();
    }
  }

  Future<bool> answerQuestion(int index) async {
    if (_answered) return false;

    _timer?.cancel();
    _selectedAnswerIndex = index;
    _answered = true;
    notifyListeners();

    final isCorrect = (index == _currentQuestion?.correctAnswerIndex);
    
    int newP1Score = _challenge.player1Score;
    int newP2Score = _challenge.player2Score;
    
    if (isCorrect) {
      if (isPlayer1) {
        newP1Score++;
      } else {
        newP2Score++;
      }
    }

    final newMyScore = isPlayer1 ? newP1Score : newP2Score;
    final opponentId = isPlayer1 ? _challenge.player2Id : _challenge.player1Id;

    if (newMyScore >= 5) {
      // Win!
      _isMatchEnded = true;
      await _challengeRepository.updateChallengeTurn(
        challengeId: _challenge.id,
        player1Score: newP1Score,
        player2Score: newP2Score,
        nextTurnUserId: _currentUser!.objectId!,
        status: 'completed',
        winnerId: _currentUser!.objectId!,
      );
    } else if (isCorrect) {
      // Keep turn
      await _challengeRepository.updateChallengeTurn(
        challengeId: _challenge.id,
        player1Score: newP1Score,
        player2Score: newP2Score,
        nextTurnUserId: _currentUser!.objectId!,
        status: 'active',
      );
    } else {
      // Missed - turn ends
      _isTurnEnded = true;
      await _challengeRepository.updateChallengeTurn(
        challengeId: _challenge.id,
        player1Score: newP1Score,
        player2Score: newP2Score,
        nextTurnUserId: opponentId,
        status: 'active',
      );
    }

    // Refresh local challenge model state (optimistic)
    _challenge = ChallengeModel(
      id: _challenge.id,
      player1Id: _challenge.player1Id,
      player1Username: _challenge.player1Username,
      player2Id: _challenge.player2Id,
      player2Username: _challenge.player2Username,
      player1Score: newP1Score,
      player2Score: newP2Score,
      currentTurnId: isCorrect && newMyScore < 5 ? _currentUser!.objectId! : opponentId,
      status: newMyScore >= 5 ? 'completed' : 'active',
      deadline: DateTime.now().add(const Duration(hours: 24)),
      winnerId: newMyScore >= 5 ? _currentUser!.objectId! : null,
      createdAt: _challenge.createdAt,
    );

    notifyListeners();
    return isCorrect;
  }

  void nextQuestion() {
    _showWheel = true;
    _currentQuestion = null;
    notifyListeners();
  }
}
