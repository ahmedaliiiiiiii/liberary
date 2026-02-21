import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeProvider.themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'City Library',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}

// إضافة ThemeProvider هنا
class ThemeProvider {
  static ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
}
