import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.black,
    color: AppColors.textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.extrabold,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: AppColors.cyan,
  );
}
