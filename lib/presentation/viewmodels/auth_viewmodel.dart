import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  bool _isLoading = false;
  bool _isLogin = true;

  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;

  AuthViewModel({AuthRepository? repository}) : _repository = repository ?? AuthRepository();

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  Future<String?> submit({
    required String username,
    required String password,
    String? email,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isLogin) {
        final response = await _repository.login(username, password);
        if (response.success) return null;
        return response.error?.message ?? 'Erro ao fazer login.';
      } else {
        if (email == null || email.isEmpty) return 'E-mail é obrigatório.';
        final response = await _repository.signUp(username, password, email);
        if (response.success) return null;
        return response.error?.message ?? 'Erro ao cadastrar.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}
