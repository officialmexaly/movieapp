import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/app_entry_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FluxShortsApp());
}

class FluxShortsApp extends StatelessWidget {
  const FluxShortsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluxShorts',
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}