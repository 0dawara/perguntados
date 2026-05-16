import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/responsive_layout.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _viewModel = AuthViewModel();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.incorrect,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.correct,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        (!_viewModel.isLogin && email.isEmpty)) {
      _showError('Preencha todos os campos obrigatórios.');
      return;
    }

    final error = await _viewModel.submit(
      username: username,
      password: password,
      email: email,
    );

    if (error == null) {
      _showSuccess(_viewModel.isLogin
          ? 'Seja bem-vindo de volta!'
          : 'Cadastro realizado com sucesso!');
      if (mounted) {
        context.go('/home');
      }
    } else {
      _showError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveLayout.isMobile(context) ? 24.0 : size.width * 0.1,
                vertical: 24.0,
              ),
              child: ResponsiveLayout(
                mobile: _buildContent(theme, isCompact: true),
                tablet: Row(
                  children: [
                    Expanded(child: _buildHeader(theme)),
                    Expanded(child: _buildForm(theme)),
                  ],
                ),
                desktop: Row(
                  children: [
                    Expanded(flex: 3, child: _buildHeader(theme)),
                    const SizedBox(width: 60),
                    Expanded(flex: 2, child: _buildForm(theme)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ThemeData theme, {required bool isCompact}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(theme),
        const SizedBox(height: 40),
        _buildForm(theme),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.geography.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.psychology_rounded,
            size: 80,
            color: AppTheme.geography,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'PERGUNTADOS',
          style: theme.textTheme.displayLarge?.copyWith(
            letterSpacing: -1,
            color: AppTheme.geography,
            fontSize: ResponsiveLayout.isMobile(context) ? 32 : 48,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _viewModel.isLogin ? 'BEM-VINDO DE VOLTA!' : 'CRIE SUA CONTA GRÁTIS',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.brightness == Brightness.light 
                ? AppTheme.textSecondary 
                : AppTheme.textSecondaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nome de Usuário',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
              ),
              const SizedBox(height: 20),
              if (!_viewModel.isLogin) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_rounded),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.geography,
                    shadowColor: AppTheme.geography.withValues(alpha: 0.4),
                  ),
                  onPressed: _viewModel.isLoading ? null : _submit,
                  child: _viewModel.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _viewModel.isLogin ? 'ENTRAR' : 'COMEÇAR AGORA',
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
        const SizedBox(height: 24),
        TextButton(
          onPressed: _viewModel.toggleAuthMode,
          child: Text(
            _viewModel.isLogin
                ? 'NÃO TEM UMA CONTA? CADASTRE-SE'
                : 'JÁ TEM UMA CONTA? FAÇA LOGIN',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppTheme.geography,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
