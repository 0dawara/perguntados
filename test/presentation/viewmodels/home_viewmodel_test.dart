import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import 'package:perguntados/presentation/viewmodels/home_viewmodel.dart';
import 'package:perguntados/data/repositories/game_repository.dart';
import 'package:perguntados/data/repositories/auth_repository.dart';
import 'package:perguntados/data/models/category_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class MockGameRepository extends Mock implements GameRepository {}
class MockAuthRepository extends Mock implements AuthRepository {}
class MockParseUser extends Mock implements ParseUser {}
class FakeParseUser extends Fake implements ParseUser {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeParseUser());
  });

  late MockGameRepository mockGameRepo;
  late MockAuthRepository mockAuthRepo;
  late MockParseUser mockUser;
  
  final category = CategoryModel(id: '1', name: 'História', color: const Color(0xFFFF0000), icon: Icons.history);

  setUp(() {
    mockGameRepo = MockGameRepository();
    mockAuthRepo = MockAuthRepository();
    mockUser = MockParseUser();
    
    when(() => mockGameRepo.getCategories()).thenAnswer((_) async => [category]);
    when(() => mockUser.get<num>('totalScore')).thenReturn(150);
  });

  HomeViewModel createViewModel() {
    return HomeViewModel(mockUser, gameRepository: mockGameRepo, authRepository: mockAuthRepo);
  }

  group('HomeViewModel', () {
    test('loads categories and sets initial score on init', () async {
      final viewModel = createViewModel();
      
      check(viewModel.isLoading).isTrue();
      check(viewModel.currentScore).equals(150);
      
      await Future.delayed(Duration.zero);
      
      check(viewModel.isLoading).isFalse();
      check(viewModel.categories).isNotEmpty();
      
      viewModel.dispose();
    });

    test('spinWheel triggers spin and selects index', () async {
      final viewModel = createViewModel();
      await Future.delayed(Duration.zero);
      
      var selectedIndexFromStream = -1;
      viewModel.selectedStream.listen((index) {
        selectedIndexFromStream = index;
      });

      viewModel.spinWheel();
      
      check(viewModel.isSpinning).isTrue();
      check(viewModel.selectedIndex).isNotNull();
      
      // Allow stream to emit
      await Future.delayed(Duration.zero);
      check(selectedIndexFromStream).equals(viewModel.selectedIndex!);
      check(viewModel.getSelectedCategory()).isNotNull();

      viewModel.dispose();
    });

    test('spinWheel does nothing if already spinning', () async {
      final viewModel = createViewModel();
      await Future.delayed(Duration.zero);

      viewModel.spinWheel();
      final firstIndex = viewModel.selectedIndex;
      
      // Should not do anything because it's already spinning
      viewModel.spinWheel();
      
      check(viewModel.selectedIndex).equals(firstIndex);
      check(viewModel.isSpinning).isTrue();

      viewModel.dispose();
    });

    test('onAnimationEnd stops spinning', () async {
      final viewModel = createViewModel();
      await Future.delayed(Duration.zero);

      viewModel.spinWheel();
      check(viewModel.isSpinning).isTrue();
      
      viewModel.onAnimationEnd();
      check(viewModel.isSpinning).isFalse();

      viewModel.dispose();
    });

    test('refreshScore updates the score from user', () async {
      final viewModel = createViewModel();
      await Future.delayed(Duration.zero);
      
      final updatedUser = MockParseUser();
      when(() => updatedUser.get<num>('totalScore')).thenReturn(200);
      when(() => mockAuthRepo.refreshUser(any())).thenAnswer((_) async => updatedUser);

      await viewModel.refreshScore(mockUser);
      
      check(viewModel.currentScore).equals(200);

      viewModel.dispose();
    });
  });
}
