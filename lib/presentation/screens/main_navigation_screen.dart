import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../main.dart';
import 'home_screen.dart';
import 'leaderboard_screen.dart';
import '../../utils/seed_data.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  ParseUser? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserAndSeed();
  }

  Future<void> _loadUserAndSeed() async {
    final user = await ParseUser.currentUser() as ParseUser?;

    // Seed once to ensure new colors are applied
    await seedDatabase(force: false);

    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    if (_currentUser != null) {
      await _currentUser!.logout();
      if (mounted) {
        context.go('/auth');
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final theme = Theme.of(context);

    final List<Widget> pages = <Widget>[
      HomeScreen(currentUser: _currentUser),
      _selectedIndex == 1 ? const LeaderboardScreen() : const SizedBox.shrink(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'PERGUNTADOS' : 'RANKING',
          style: theme.textTheme.labelLarge?.copyWith(
            fontSize: 18,
          ),
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: PerguntadosApp.themeNotifier,
            builder: (context, currentMode, child) {
              return IconButton(
                icon: Icon(
                  currentMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  PerguntadosApp.themeNotifier.value = 
                      currentMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                },
                tooltip: 'Alternar Tema',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Sair',
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          selectedItemColor: AppTheme.geography,
          unselectedItemColor: theme.brightness == Brightness.light 
              ? AppTheme.textSecondary.withValues(alpha: 0.5)
              : AppTheme.textSecondaryDark.withValues(alpha: 0.5),
          selectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12,
          ),
          unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
            fontSize: 12,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: Icon(Icons.home_rounded, size: 30),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_rounded),
              activeIcon: Icon(Icons.emoji_events_rounded, size: 30),
              label: 'Ranking',
            ),
          ],
        ),
      ),
    );
  }
}
