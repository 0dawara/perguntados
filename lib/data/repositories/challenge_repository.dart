import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../models/challenge_model.dart';

class ChallengeRepository {
  Future<List<ParseUser>> getUsersToChallenge() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) return [];

    final query = QueryBuilder<ParseUser>(ParseUser.forQuery())
      ..whereNotEqualTo('objectId', currentUser.objectId)
      ..setLimit(50); // Limit to 50 users for now

    final response = await query.query();
    if (response.success && response.results != null) {
      return (response.results as List).map((e) => e as ParseUser).toList();
    }
    return [];
  }

  Future<ChallengeModel?> createChallenge(ParseUser opponent) async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) return null;

    final challenge = ParseObject('Challenge')
      ..set('player1', currentUser.toPointer())
      ..set('player2', opponent.toPointer())
      ..set('player1Score', 0)
      ..set('player2Score', 0)
      ..set('currentTurn', currentUser.toPointer())
      ..set('status', 'active')
      ..set('deadline', DateTime.now().add(const Duration(hours: 24)));

    // Set ACL so both players can read/write
    final acl = ParseACL(owner: currentUser)..setReadAccess(userId: opponent.objectId!, allowed: true)..setWriteAccess(userId: opponent.objectId!, allowed: true);
    challenge.setACL(acl);

    final response = await challenge.save();
    if (response.success && response.results != null) {
      // Need to fetch it back to get nested pointers correctly, or just construct it locally
      return getChallengeById(response.results!.first.objectId);
    }
    return null;
  }

  Future<ChallengeModel?> getChallengeById(String id) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Challenge'))
      ..whereEqualTo('objectId', id)
      ..includeObject(['player1', 'player2', 'currentTurn', 'winner']);

    final response = await query.query();
    if (response.success && response.results != null && response.results!.isNotEmpty) {
      return ChallengeModel.fromParse(response.results!.first as ParseObject);
    }
    return null;
  }

  Future<List<ChallengeModel>> getActiveChallenges() async {
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) return [];

    final query1 = QueryBuilder<ParseObject>(ParseObject('Challenge'))
      ..whereEqualTo('player1', currentUser.toPointer())
      ..whereEqualTo('status', 'active');

    final query2 = QueryBuilder<ParseObject>(ParseObject('Challenge'))
      ..whereEqualTo('player2', currentUser.toPointer())
      ..whereEqualTo('status', 'active');

    final mainQuery = QueryBuilder.or(
      ParseObject('Challenge'),
      [query1, query2],
    )
      ..includeObject(['player1', 'player2', 'currentTurn', 'winner'])
      ..orderByDescending('updatedAt');

    final response = await mainQuery.query();
    if (response.success && response.results != null) {
      return (response.results as List<ParseObject>)
          .map((e) => ChallengeModel.fromParse(e))
          .toList();
    }
    return [];
  }

  Future<bool> updateChallengeTurn({
    required String challengeId,
    required int player1Score,
    required int player2Score,
    required String nextTurnUserId,
    String status = 'active',
    String? winnerId,
  }) async {
    final challenge = ParseObject('Challenge')..objectId = challengeId;
    challenge.set('player1Score', player1Score);
    challenge.set('player2Score', player2Score);
    challenge.set('currentTurn', (ParseUser.forQuery()..objectId = nextTurnUserId).toPointer());
    challenge.set('status', status);
    challenge.set('deadline', DateTime.now().add(const Duration(hours: 24)));
    
    if (winnerId != null) {
      challenge.set('winner', (ParseUser.forQuery()..objectId = winnerId).toPointer());
    }

    final response = await challenge.save();
    return response.success;
  }
}
