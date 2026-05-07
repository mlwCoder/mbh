import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/core/theme/tokens/spacing.dart';
import 'package:mbh/app/shared/components/app_button/app_button.dart';
import 'package:mbh/app/shared/components/app_button/app_button_variant.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    this.message,
    this.onRetry,
  });

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? LocaleKeys.commonError.tr,
              style: context.appTextTheme.bodyLarge?.copyWith(
                color: context.appTheme.mutedText,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Spacing.lg),
              AppButton(
                label: LocaleKeys.commonRetry.tr,
                onPressed: onRetry,
                variant: AppButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
