import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/leaderboard_viewmodel.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _viewModel = LeaderboardViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
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
              : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.emoji_events_rounded, color: AppTheme.history, size: 64),
                            const SizedBox(height: 16),
                            Text(
                              'MELHORES JOGADORES',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'QUEM SERÁ O PRÓXIMO MESTRE?',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.brightness == Brightness.light 
                                    ? AppTheme.textSecondary 
                                    : AppTheme.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: _viewModel.topUsers.isEmpty
                          ? SliverFillRemaining(
                              child: Center(
                                child: Text('Nenhum jogador encontrado.', style: theme.textTheme.bodyLarge),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final user = _viewModel.topUsers[index];
                                  final username = user.get<String>('username') ?? 'Desconhecido';
                                  final score = user.get<num>('totalScore') ?? 0;

                                  Color rankColor = theme.brightness == Brightness.light 
                                      ? AppTheme.textSecondary 
                                      : AppTheme.textSecondaryDark;
                                  if (index == 0) {
                                    rankColor = AppTheme.history;
                                  } else if (index == 1) {
                                    rankColor = const Color(0xFF9E9E9E);
                                  } else if (index == 2) {
                                    rankColor = const Color(0xFFCD7F32);
                                  }

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surface,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      leading: CircleAvatar(
                                        backgroundColor: rankColor.withValues(alpha: 0.15),
                                        child: Text(
                                          '${index + 1}',
                                          style: theme.textTheme.labelLarge?.copyWith(
                                            color: rankColor,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        username.toUpperCase(),
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      trailing: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '$score',
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: AppTheme.geography,
                                            ),
                                          ),
                                          Text(
                                            'PONTOS',
                                            style: theme.textTheme.labelLarge?.copyWith(
                                              fontSize: 10,
                                              color: theme.brightness == Brightness.light 
                                                  ? AppTheme.textSecondary 
                                                  : AppTheme.textSecondaryDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                childCount: _viewModel.topUsers.length,
                              ),
                            ),
                    ),
                  ],
                ),
        );
      }
    );
  }
}
