import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mbh/app/bootstrap/app_initializer.dart';
import 'package:mbh/app/config/flavor/app_flavor.dart';
import 'package:mbh/app/config/flavor/flavor_config.dart';
import 'package:mbh/app/core/logging/app_logger.dart';
import 'package:mbh/app/core/monitoring/crash_reporter.dart';

class AppRunner {
  const AppRunner._();

  static Future<void> run({
    required AppFlavor flavor,
    required Widget app,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();
    FlavorConfig.init(flavor);
    await AppInitializer.init();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _reportFlutterError(details);
    };

    runZonedGuarded(
      () => runApp(app),
      (Object error, StackTrace stack) {
        _reportZoneError(error, stack);
      },
    );
  }

  static void _reportFlutterError(FlutterErrorDetails details) {
    try {
      final AppLogger logger = Get.find<AppLogger>();
      logger.fatal(
        'FlutterError: ${details.exceptionAsString()}',
        error: details.exception,
        stackTrace: details.stack,
      );

      final CrashReporter reporter = Get.find<CrashReporter>();
      reporter.recordError(
        details.exception,
        details.stack ?? StackTrace.current,
        fatal: true,
      );
    } catch (_) {}
  }

  static void _reportZoneError(Object error, StackTrace stack) {
    try {
      final AppLogger logger = Get.find<AppLogger>();
      logger.fatal('Uncaught zone error: $error', error: error, stackTrace: stack);

      final CrashReporter reporter = Get.find<CrashReporter>();
      reporter.recordError(error, stack, fatal: true);
    } catch (_) {}
  }
}
