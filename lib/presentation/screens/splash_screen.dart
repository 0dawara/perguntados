import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 2));
    
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    
    if (currentUser == null) {
      if (mounted) {
        context.go('/auth');
      }
    } else {
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.geography.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology_rounded,
                size: 100,
                color: AppTheme.geography,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'PERGUNTADOS',
              style: theme.textTheme.displayLarge?.copyWith(
                color: AppTheme.geography,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.geography),
            ),
          ],
        ),
      ),
    );
  }
}
