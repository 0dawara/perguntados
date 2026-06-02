import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ChallengeModel {
  final String id;
  final String player1Id;
  final String player1Username;
  final String player2Id;
  final String player2Username;
  final int player1Score;
  final int player2Score;
  final String currentTurnId;
  final String status; // 'active', 'completed', 'expired'
  final DateTime deadline;
  final String? winnerId;
  final DateTime? createdAt;

  ChallengeModel({
    required this.id,
    required this.player1Id,
    required this.player1Username,
    required this.player2Id,
    required this.player2Username,
    required this.player1Score,
    required this.player2Score,
    required this.currentTurnId,
    required this.status,
    required this.deadline,
    this.winnerId,
    this.createdAt,
  });

  factory ChallengeModel.fromParse(ParseObject object) {
    final player1 = object.get<ParseUser>('player1');
    final player2 = object.get<ParseUser>('player2');
    final currentTurn = object.get<ParseUser>('currentTurn');
    final winner = object.get<ParseUser>('winner');

    return ChallengeModel(
      id: object.objectId!,
      player1Id: player1?.objectId ?? '',
      player1Username: player1?.username ?? 'Jogador 1',
      player2Id: player2?.objectId ?? '',
      player2Username: player2?.username ?? 'Jogador 2',
      player1Score: object.get<int>('player1Score') ?? 0,
      player2Score: object.get<int>('player2Score') ?? 0,
      currentTurnId: currentTurn?.objectId ?? '',
      status: object.get<String>('status') ?? 'active',
      deadline: object.get<DateTime>('deadline') ?? DateTime.now().add(const Duration(hours: 24)),
      winnerId: winner?.objectId,
      createdAt: object.createdAt,
    );
  }
}
