import 'package:flutter/material.dart';
import 'app_colors.dart';

class TvFocusTheme {
  static BoxDecoration getFocusDecoration({required bool isFocused}) {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isFocused ? AppColors.cyan : Colors.transparent,
        width: 3.5,
      ),
      boxShadow: isFocused
          ? [
              BoxShadow(
                color: AppColors.cyan.withOpacity(0.95),
                blurRadius: 35,
                spreadRadius: 2,
              ),
            ]
          : [],
    );
  }
}
