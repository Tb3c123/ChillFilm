import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'presentation/screens/splash_screen.dart';

class WatchFilmApp extends StatelessWidget {
  const WatchFilmApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinema TV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.cyan,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
