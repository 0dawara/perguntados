import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = '8nq6Jb2ffvi0XylEYCHT7XFGCxZxqzUbRzNkAsXe';
  const keyClientKey = 'cuQJqeIApURDDaBugpBQzDF95yeR9fGnPxHtF6eG';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );

  runApp(const PerguntadosApp());
}

class PerguntadosApp extends StatelessWidget {
  const PerguntadosApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp.router(
          title: 'Perguntados',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

