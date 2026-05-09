import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class GameplayScreen extends StatefulWidget {
  final ParseObject category;

  const GameplayScreen({super.key, required this.category});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  ParseObject? _question;
  bool _isLoading = true;
  int? _selectedAnswerIndex;
  bool _answered = false;

  // Cronômetro
  int _timeLeft = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _handleTimeOut();
      }
    });
  }

  void _handleTimeOut() {
    if (!_answered) {
      setState(() {
        _answered = true;
        _selectedAnswerIndex = -1; // -1 significa que esgotou o tempo
      });
      _showResult(false);
    }
  }

  Future<void> _loadQuestion() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Question'))
      ..whereEqualTo('category', widget.category.toPointer());
    
    final response = await query.query();

    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final questions = response.results as List<ParseObject>;
      final random = Random();
      final randomQuestion = questions[random.nextInt(questions.length)];

      setState(() {
        _question = randomQuestion;
        _isLoading = false;
      });

      _startTimer();
    } else {
      // Caso não ache perguntas
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _answerQuestion(int index) {
    if (_answered) return;

    _timer?.cancel();
    setState(() {
      _selectedAnswerIndex = index;
      _answered = true;
    });

    final correctIndex = _question!.get<int>('correctAnswerIndex') ?? 0;
    final isCorrect = (index == correctIndex);

    _showResult(isCorrect);
  }

  Future<void> _showResult(bool isCorrect) async {
    int pointsEarned = 0;

    if (isCorrect) {
      pointsEarned = 10;
      final currentUser = await ParseUser.currentUser() as ParseUser?;
      if (currentUser != null) {
        final currentScore = currentUser.get<num>('totalScore') ?? 0;
        currentUser.set('totalScore', currentScore + pointsEarned);
        await currentUser.save();
      }
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? 'Correto!' : 'Incorreto!'),
          content: Text(isCorrect
              ? 'Você ganhou $pointsEarned pontos!'
              : 'Você errou ou o tempo acabou. Tente novamente na próxima!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha dialog
                Navigator.of(context).pop(); // Volta para seleção de categoria/dashboard
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Erro')),
        body: const Center(child: Text('Nenhuma pergunta encontrada para esta categoria.')),
      );
    }

    final catName = widget.category.get<String>('name') ?? 'Categoria';
    final text = _question!.get<String>('text') ?? '';
    final options = List<String>.from(_question!.get<List>('options') ?? []);
    final correctIndex = _question!.get<int>('correctAnswerIndex') ?? 0;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(catName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Cronômetro
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _timeLeft <= 5 ? Colors.red : Colors.green,
              ),
              child: Text(
                '$_timeLeft',
                style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            // Texto da Pergunta
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            // Opções
            ...List.generate(options.length, (index) {
              Color btnColor = Colors.white;
              Color txtColor = Colors.black87;

              if (_answered) {
                if (index == correctIndex) {
                  btnColor = Colors.green;
                  txtColor = Colors.white;
                } else if (index == _selectedAnswerIndex) {
                  btnColor = Colors.red;
                  txtColor = Colors.white;
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor,
                      foregroundColor: txtColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    onPressed: _answered ? null : () => _answerQuestion(index),
                    child: Text(
                      options[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
