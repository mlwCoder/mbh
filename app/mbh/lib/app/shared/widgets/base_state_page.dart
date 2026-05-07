import 'package:flutter/material.dart';
import 'package:mbh/app/core/theme/theme_context_ext.dart';
import 'package:mbh/app/shared/components/app_loading/app_loading.dart';

class BaseStatePage extends StatelessWidget {
  const BaseStatePage({
    required this.child,
    super.key,
    this.isLoading = false,
    this.loadingMessage,
  });

  final Widget child;
  final bool isLoading;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: context.appTheme.overlay,
              child: AppLoading(message: loadingMessage),
            ),
          ),
      ],
    );
  }
}
