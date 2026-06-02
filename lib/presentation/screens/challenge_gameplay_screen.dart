import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/challenge_model.dart';
import '../viewmodels/challenge_gameplay_viewmodel.dart';
import '../widgets/responsive_layout.dart';

class ChallengeGameplayScreen extends StatefulWidget {
  final ChallengeModel challenge;

  const ChallengeGameplayScreen({super.key, required this.challenge});

  @override
  State<ChallengeGameplayScreen> createState() => _ChallengeGameplayScreenState();
}

class _ChallengeGameplayScreenState extends State<ChallengeGameplayScreen> {
  late ChallengeGameplayViewModel _viewModel;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _viewModel = ChallengeGameplayViewModel(challenge: widget.challenge);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _answerQuestion(int index) async {
    if (_viewModel.answered) return;

    final isCorrect = await _viewModel.answerQuestion(index);
    _showResult(isCorrect);
  }

  Future<void> _showResult(bool isCorrect) async {
    if (isCorrect) {
      _confettiController.play();
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        final screenWidth = MediaQuery.of(context).size.width;
        final isWide = screenWidth > 600;

        String title = isCorrect ? 'MUITO BEM!' : 'QUE PENA!';
        String message = isCorrect 
            ? 'Resposta correta!' 
            : 'Sua rodada acabou. Vez do oponente!';

        if (_viewModel.isMatchEnded) {
          title = 'VITÓRIA!';
          message = 'Você alcançou 5 acertos e venceu o desafio!';
        } else if (_viewModel.isTurnEnded) {
          message = 'Você errou e passou a vez.';
        } else if (isCorrect) {
          message = 'Continue jogando! (Acertos: ${_viewModel.myScore}/5)';
        }

        return Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: isWide ? 500 : double.infinity),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: isWide
                  ? BorderRadius.circular(32)
                  : const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.error,
                  color: isCorrect ? AppTheme.correct : AppTheme.incorrect,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: isCorrect ? AppTheme.correct : AppTheme.incorrect,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCorrect ? AppTheme.correct : AppTheme.incorrect,
                    ),
                    onPressed: () {
                      context.pop(); // Close sheet
                      if (_viewModel.isMatchEnded || _viewModel.isTurnEnded) {
                        context.pop(); // Go back to challenges list
                      } else {
                        _viewModel.nextQuestion(); // Go to spin wheel again
                      }
                    },
                    child: Text(
                      'CONTINUAR',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading && _viewModel.categories.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text('VOCÊ ${_viewModel.myScore} x ${_viewModel.opponentScore} ${_viewModel.isPlayer1 ? widget.challenge.player2Username : widget.challenge.player1Username}'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Stack(
            children: [
              if (_viewModel.showWheel)
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sua vez! Gire a roleta:', style: theme.textTheme.headlineMedium),
                        const SizedBox(height: 40),
                        SizedBox(
                          height: 320,
                          width: 320,
                          child: FortuneWheel(
                            selected: _viewModel.selectedStream,
                            animateFirst: false,
                            onAnimationEnd: _viewModel.onAnimationEnd,
                            indicators: const [
                              FortuneIndicator(
                                alignment: Alignment.topCenter,
                                child: TriangleIndicator(
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                            items: [
                              for (var it in _viewModel.categories)
                                FortuneItem(
                                  style: FortuneItemStyle(
                                    color: it.color,
                                    borderColor: Colors.white,
                                    borderWidth: 4,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 48.0),
                                    child: Transform.rotate(
                                      angle: 3.14159 / 2,
                                      child: Icon(
                                        it.icon,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        SizedBox(
                          width: 240,
                          height: 64,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.geography,
                              elevation: 8,
                            ),
                            onPressed: _viewModel.isSpinning ? null : _viewModel.spinWheel,
                            child: Text(
                              _viewModel.isSpinning ? 'GIRANDO...' : 'GIRAR ROLETA',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_viewModel.currentQuestion != null)
                ResponsiveLayout(
                  mobile: _buildQuestionContent(theme, _viewModel.currentQuestion, isWide: false),
                  tablet: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: _buildQuestionContent(theme, _viewModel.currentQuestion, isWide: true),
                    ),
                  ),
                  desktop: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Column(
                                children: [
                                  _buildTimer(theme),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(40.0),
                              child: Column(
                                children: [
                                  _buildQuestionCard(theme, _viewModel.currentQuestion!.text),
                                  const SizedBox(height: 40),
                                  _buildOptions(theme, _viewModel.currentQuestion),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionContent(ThemeData theme, var question, {required bool isWide}) {
    return Padding(
      padding: EdgeInsets.all(isWide ? 40.0 : 24.0),
      child: Column(
        children: [
          _buildTimer(theme),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQuestionCard(theme, question.text),
                  const SizedBox(height: 32),
                  _buildOptions(theme, question),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer(ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: _viewModel.timeLeft / 15,
            strokeWidth: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              _viewModel.timeLeft <= 5 ? AppTheme.incorrect : AppTheme.geography,
            ),
          ),
        ),
        Text(
          '${_viewModel.timeLeft}',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: _viewModel.timeLeft <= 5 ? AppTheme.incorrect : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(ThemeData theme, String text) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: Text(
          text,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 22,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildOptions(ThemeData theme, var question) {
    return Column(
      children: List.generate(question.options.length, (index) {
        Color btnColor = theme.colorScheme.surface;
        Color txtColor = theme.colorScheme.onSurface;
        Color borderColor = theme.colorScheme.outlineVariant;

        if (_viewModel.answered) {
          if (index == question.correctAnswerIndex) {
            btnColor = AppTheme.correct;
            txtColor = Colors.white;
            borderColor = AppTheme.correct;
          } else if (index == _viewModel.selectedAnswerIndex) {
            btnColor = AppTheme.incorrect;
            txtColor = Colors.white;
            borderColor = AppTheme.incorrect;
          } else {
            btnColor = theme.colorScheme.surfaceContainerLow;
            txtColor = theme.colorScheme.onSurface.withValues(alpha: 0.5);
            borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: txtColor,
                elevation: _viewModel.answered && (index == question.correctAnswerIndex || index == _viewModel.selectedAnswerIndex) ? 4 : 0,
                side: BorderSide(color: borderColor, width: 2),
              ),
              onPressed: _viewModel.answered ? null : () => _answerQuestion(index),
              child: Text(
                question.options[index].toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: txtColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
