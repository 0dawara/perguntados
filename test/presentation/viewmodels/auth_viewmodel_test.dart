import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:checks/checks.dart';
import 'package:perguntados/presentation/viewmodels/auth_viewmodel.dart';
import 'package:perguntados/data/repositories/auth_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockParseResponse extends Mock implements ParseResponse {}
class MockParseError extends Mock implements ParseError {}

void main() {
  late AuthViewModel viewModel;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    viewModel = AuthViewModel(repository: mockRepository);
  });

  group('AuthViewModel', () {
    test('initial state is login mode and not loading', () {
      check(viewModel.isLogin).isTrue();
      check(viewModel.isLoading).isFalse();
    });

    test('toggleAuthMode switches between login and signup', () {
      viewModel.toggleAuthMode();
      check(viewModel.isLogin).isFalse();

      viewModel.toggleAuthMode();
      check(viewModel.isLogin).isTrue();
    });

    group('submit (login)', () {
      test('returns null on successful login', () async {
        final mockResponse = MockParseResponse();
        when(() => mockResponse.success).thenReturn(true);
        when(() => mockRepository.login(any(), any()))
            .thenAnswer((_) async => mockResponse);

        final result = await viewModel.submit(username: 'user', password: 'password');

        check(result).isNull();
        verify(() => mockRepository.login('user', 'password')).called(1);
        check(viewModel.isLoading).isFalse();
      });

      test('returns error message on failed login', () async {
        final mockResponse = MockParseResponse();
        final mockError = MockParseError();
        when(() => mockError.message).thenReturn('Invalid credentials');
        when(() => mockResponse.success).thenReturn(false);
        when(() => mockResponse.error).thenReturn(mockError);
        when(() => mockRepository.login(any(), any()))
            .thenAnswer((_) async => mockResponse);

        final result = await viewModel.submit(username: 'user', password: 'password');

        check(result).equals('Invalid credentials');
        check(viewModel.isLoading).isFalse();
      });
    });

    group('submit (signup)', () {
      setUp(() {
        viewModel.toggleAuthMode(); // Switch to signup mode
      });

      test('returns validation error if email is missing', () async {
        final result = await viewModel.submit(username: 'user', password: 'password');
        check(result).equals('E-mail é obrigatório.');
      });

      test('returns null on successful signup', () async {
        final mockResponse = MockParseResponse();
        when(() => mockResponse.success).thenReturn(true);
        when(() => mockRepository.signUp(any(), any(), any()))
            .thenAnswer((_) async => mockResponse);

        final result = await viewModel.submit(
            username: 'user', password: 'password', email: 'test@test.com');

        check(result).isNull();
        verify(() => mockRepository.signUp('user', 'password', 'test@test.com')).called(1);
      });
    });

    test('logout calls repository logout', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async {});

      await viewModel.logout();

      verify(() => mockRepository.logout()).called(1);
    });
  });
}
