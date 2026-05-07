import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';

class AppEmpty extends StatelessWidget {
  const AppEmpty({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Text(
          message ?? LocaleKeys.commonEmpty.tr,
          style: context.appTextTheme.bodyLarge?.copyWith(
            color: context.appTheme.mutedText,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
