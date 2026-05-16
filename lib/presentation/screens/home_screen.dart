import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/responsive_layout.dart';

class HomeScreen extends StatefulWidget {
  final ParseUser? currentUser;
  const HomeScreen({super.key, this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel(widget.currentUser);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onAnimationEnd() async {
    _viewModel.onAnimationEnd();
    
    final selectedCategory = _viewModel.getSelectedCategory();
    if (selectedCategory == null) return;

    await context.push('/gameplay', extra: selectedCategory);

    _viewModel.refreshScore(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ResponsiveLayout(
                  mobile: _buildMobileLayout(theme),
                  tablet: _buildWideLayout(theme, isTablet: true),
                  desktop: _buildWideLayout(theme, isTablet: false),
                ),
        );
      }
    );
  }

  Widget _buildMobileLayout(ThemeData theme) {
    return Column(
      children: [
        _buildTopBar(theme),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildWheelSection(theme),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWideLayout(ThemeData theme, {required bool isTablet}) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildTopBar(theme, isEmbedded: true),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'DESAFIE SEUS CONHECIMENTOS EM DIVERSAS CATEGORIAS!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.geography,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        Expanded(
          flex: isTablet ? 2 : 3,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: _buildWheelSection(theme, isWide: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(ThemeData theme, {bool isEmbedded = false}) {
    return Container(
      padding: EdgeInsets.only(
        top: isEmbedded ? 20 : 60,
        bottom: 20,
        left: 24,
        right: 24,
      ),
      decoration: isEmbedded
          ? null
          : BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OLÁ, ${widget.currentUser?.username?.toUpperCase() ?? "JOGADOR"}!',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.brightness == Brightness.light 
                        ? AppTheme.textSecondary 
                        : AppTheme.textSecondaryDark,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'VAMOS JOGAR?',
                    style: theme.textTheme.displayMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.history.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: AppTheme.history, size: 24),
                const SizedBox(width: 8),
                Text(
                  '${_viewModel.currentScore}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheelSection(ThemeData theme, {bool isWide = false}) {
    final wheelSize = isWide ? 400.0 : 320.0;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_viewModel.categories.isNotEmpty) ...[
          SizedBox(
            height: wheelSize,
            width: wheelSize,
            child: FortuneWheel(
              selected: _viewModel.selectedStream,
              animateFirst: false,
              onAnimationEnd: _onAnimationEnd,
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
                          size: isWide ? 32 : 28,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: isWide ? 80 : 60),
          SizedBox(
            width: 240,
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.geography,
                elevation: 8,
                shadowColor: AppTheme.geography.withValues(alpha: 0.5),
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
        ] else
          const Text('Nenhuma categoria disponível.'),
      ],
    );
  }
}
