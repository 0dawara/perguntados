import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import 'package:perguntados/presentation/viewmodels/leaderboard_viewmodel.dart';
import 'package:perguntados/data/repositories/game_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class MockGameRepository extends Mock implements GameRepository {}
class MockParseObject extends Mock implements ParseObject {}

void main() {
  late MockGameRepository mockRepository;
  
  setUp(() {
    mockRepository = MockGameRepository();
  });

  group('LeaderboardViewModel', () {
    test('loads leaderboard on init', () async {
      final mockUser = MockParseObject();
      when(() => mockRepository.getLeaderboard()).thenAnswer((_) async => [mockUser]);

      final viewModel = LeaderboardViewModel(repository: mockRepository);

      check(viewModel.isLoading).isTrue();
      
      await Future.delayed(Duration.zero);
      
      check(viewModel.isLoading).isFalse();
      check(viewModel.topUsers).isNotEmpty();
      check(viewModel.topUsers.first).equals(mockUser);
    });
  });
}
