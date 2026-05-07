import 'package:mbh/app/core/monitoring/crash_reporter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryReporter implements CrashReporter {
  SentryReporter({required this.dsn});

  final String dsn;

  @override
  Future<void> init() async {
    // Sentry is initialized in main via SentryFlutter.init.
    // This method is a no-op placeholder when Sentry is pre-configured.
  }

  @override
  Future<void> setUser(String id, {String? email, String? name}) async {
    Sentry.configureScope((Scope scope) {
      scope.setUser(SentryUser(
        id: id,
        email: email,
        username: name,
      ));
    });
  }

  @override
  Future<void> log(String message) async {
    Sentry.addBreadcrumb(Breadcrumb(message: message));
  }

  @override
  Future<void> recordError(Object error, StackTrace stackTrace, {bool fatal = false}) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (Scope scope) {
        scope.level = fatal ? SentryLevel.fatal : SentryLevel.error;
      },
    );
  }
}
