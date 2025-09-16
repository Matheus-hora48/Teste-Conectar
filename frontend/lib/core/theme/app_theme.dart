import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryColor,
    );
  }
}
