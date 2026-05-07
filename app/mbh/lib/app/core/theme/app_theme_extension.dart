import 'package:flutter/material.dart';
import 'package:mbh/app/core/theme/app_colors.dart';
import 'package:mbh/app/core/theme/tokens/radius.dart';
import 'package:mbh/app/core/theme/tokens/shadows.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.cardBackground,
    required this.borderColor,
    required this.mutedText,
    required this.cardShadow,
    required this.inputFill,
    required this.overlay,
  });

  final Color cardBackground;
  final Color borderColor;
  final Color mutedText;
  final List<BoxShadow> cardShadow;
  final Color inputFill;
  final Color overlay;

  static AppThemeExtension light() {
    return const AppThemeExtension(
      cardBackground: AppColors.surfaceLight,
      borderColor: AppColors.borderLight,
      mutedText: Color(0xFF64748B),
      cardShadow: AppShadows.sm,
      inputFill: Color(0xFFF8FAFC),
      overlay: Color(0x800F172A),
    );
  }

  static AppThemeExtension dark() {
    return const AppThemeExtension(
      cardBackground: AppColors.surfaceDark,
      borderColor: AppColors.borderDark,
      mutedText: Color(0xFF94A3B8),
      cardShadow: AppShadows.md,
      inputFill: Color(0xFF1E293B),
      overlay: Color(0x99000000),
    );
  }

  OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      borderSide: BorderSide(color: borderColor),
    );
  }

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? cardBackground,
    Color? borderColor,
    Color? mutedText,
    List<BoxShadow>? cardShadow,
    Color? inputFill,
    Color? overlay,
  }) {
    return AppThemeExtension(
      cardBackground: cardBackground ?? this.cardBackground,
      borderColor: borderColor ?? this.borderColor,
      mutedText: mutedText ?? this.mutedText,
      cardShadow: cardShadow ?? this.cardShadow,
      inputFill: inputFill ?? this.inputFill,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      borderColor: Color.lerp(borderColor, other.borderColor, t) ?? borderColor,
      mutedText: Color.lerp(mutedText, other.mutedText, t) ?? mutedText,
      cardShadow: t < 0.5 ? cardShadow : other.cardShadow,
      inputFill: Color.lerp(inputFill, other.inputFill, t) ?? inputFill,
      overlay: Color.lerp(overlay, other.overlay, t) ?? overlay,
    );
  }
}
