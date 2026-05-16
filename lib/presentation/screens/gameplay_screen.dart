import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../utils/sound_manager.dart';
import '../../data/models/category_model.dart';
import '../viewmodels/gameplay_viewmodel.dart';
import '../widgets/responsive_layout.dart';

class GameplayScreen extends StatefulWidget {
  final CategoryModel category;

  const GameplayScreen({super.key, required this.category});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late GameplayViewModel _viewModel;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _viewModel = GameplayViewModel(category: widget.category);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _answerQuestion(int index) {
    if (_viewModel.answered) return;

    final isCorrect = _viewModel.answerQuestion(index);
    _showResult(isCorrect);
  }

  Future<void> _showResult(bool isCorrect) async {
    int pointsEarned = isCorrect ? (widget.category.name.toLowerCase() == 'coroa' ? 25 : 10) : 0;

    if (isCorrect) {
      _confettiController.play();
      SoundManager.playCorrect();
    } else {
      SoundManager.playIncorrect();
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
                  isCorrect ? 'MUITO BEM!' : 'QUE PENA!',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: isCorrect ? AppTheme.correct : AppTheme.incorrect,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isCorrect
                      ? 'VOCÊ GANHOU $pointsEarned PONTOS!'
                      : 'VOCÊ ERROU OU O TEMPO ACABOU. TENTE NOVAMENTE!',
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
                      shadowColor: (isCorrect ? AppTheme.correct : AppTheme.incorrect).withValues(alpha: 0.4),
                    ),
                    onPressed: () {
                      context.pop(); // Close sheet
                      context.pop(); // Go back home
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
        if (_viewModel.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (_viewModel.currentQuestion == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('ERRO')),
            body: const Center(child: Text('Nenhuma pergunta encontrada.')),
          );
        }

        final theme = Theme.of(context);
        final question = _viewModel.currentQuestion!;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.category.icon, color: widget.category.color),
                const SizedBox(width: 12),
                Text(widget.category.name.toUpperCase()),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: ResponsiveLayout(
            mobile: _buildQuestionContent(theme, question, isWide: false),
            tablet: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildQuestionContent(theme, question, isWide: true),
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
                            const SizedBox(height: 40),
                            Card(
                              color: widget.category.color.withValues(alpha: 0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(widget.category.icon, color: widget.category.color, size: 28),
                                    const SizedBox(width: 12),
                                    Text(
                                      widget.category.name.toUpperCase(),
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: widget.category.color,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                            _buildQuestionCard(theme, question.text),
                            const SizedBox(height: 40),
                            _buildOptions(theme, question),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
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
              _viewModel.timeLeft <= 5 ? AppTheme.incorrect : widget.category.color,
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
