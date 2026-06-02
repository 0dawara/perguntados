import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/challenges_viewmodel.dart';
import '../../data/models/challenge_model.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> with SingleTickerProviderStateMixin {
  late ChallengesViewModel _viewModel;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = ChallengesViewModel();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startChallenge(dynamic opponent) async {
    final challenge = await _viewModel.startChallenge(opponent);
    if (challenge != null && mounted) {
      _tabController.animateTo(0);
      context.push('/challenge_gameplay', extra: challenge);
    }
  }

  void _continueChallenge(ChallengeModel challenge) {
    context.push('/challenge_gameplay', extra: challenge);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        if (_viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: theme.brightness == Brightness.light ? AppTheme.textPrimary : AppTheme.textPrimaryDark,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.geography,
              tabs: const [
                Tab(text: 'Partidas'),
                Tab(text: 'Novo Desafio'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveChallengesList(theme),
                  _buildUsersList(theme),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActiveChallengesList(ThemeData theme) {
    final myTurn = _viewModel.myTurnChallenges;
    final theirTurn = _viewModel.theirTurnChallenges;

    if (myTurn.isEmpty && theirTurn.isEmpty) {
      return const Center(child: Text('Nenhuma partida ativa.'));
    }

    return RefreshIndicator(
      onRefresh: _viewModel.refreshData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (myTurn.isNotEmpty) ...[
            Text('Sua Vez', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.geography)),
            const SizedBox(height: 8),
            ...myTurn.map((c) => _buildChallengeCard(c, true, theme)),
            const SizedBox(height: 24),
          ],
          if (theirTurn.isNotEmpty) ...[
            Text('Vez do Oponente', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            ...theirTurn.map((c) => _buildChallengeCard(c, false, theme)),
          ],
        ],
      ),
    );
  }

  Widget _buildChallengeCard(ChallengeModel challenge, bool isMyTurn, ThemeData theme) {
    final isPlayer1 = challenge.player1Id == _viewModel.currentUser?.objectId;
    final opponentName = isPlayer1 ? challenge.player2Username : challenge.player1Username;
    final myScore = isPlayer1 ? challenge.player1Score : challenge.player2Score;
    final opponentScore = isPlayer1 ? challenge.player2Score : challenge.player1Score;

    final now = DateTime.now();
    final difference = challenge.deadline.difference(now);
    final isExpired = difference.isNegative;
    
    String timeString;
    if (isExpired) {
      timeString = 'Expirado';
    } else {
      timeString = '${difference.inHours}h ${difference.inMinutes.remainder(60)}m restantes';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text('Contra $opponentName', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Placar: Você $myScore x $opponentScore $opponentName'),
            const SizedBox(height: 4),
            Text(
              timeString, 
              style: TextStyle(color: isExpired ? Colors.red : (isMyTurn ? AppTheme.geography : Colors.grey)),
            ),
          ],
        ),
        trailing: isMyTurn && !isExpired
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _continueChallenge(challenge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.geography,
                      minimumSize: const Size(64, 36),
                    ),
                    child: const Text('Jogar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildUsersList(ThemeData theme) {
    if (_viewModel.users.isEmpty) {
      return const Center(child: Text('Nenhum jogador encontrado.'));
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: _viewModel.refreshData,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _viewModel.users.length,
            itemBuilder: (context, index) {
              final user = _viewModel.users[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.geography.withValues(alpha: 0.2),
                    child: const Icon(Icons.person, color: AppTheme.geography),
                  ),
                  title: Text(user.username ?? 'Jogador'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: _viewModel.isCreating ? null : () => _startChallenge(user),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(64, 36),
                        ),
                        child: const Text('Desafiar'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        if (_viewModel.isCreating)
          Container(
            color: Colors.black12,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
