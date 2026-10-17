import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ErfanOxigenApp(),
    ),
  );
}

class ErfanOxigenApp extends StatelessWidget {
  const ErfanOxigenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERFAN OXIGEN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          if (!appState.isAuthenticated) {
            return const LoginScreen();
          }
          return const MainShell();
        },
      ),
    );
  }
}
