import 'package:mbh/app/core/monitoring/crash_reporter.dart';

class NoopCrashReporter implements CrashReporter {
  @override
  Future<void> init() async {}

  @override
  Future<void> setUser(String id, {String? email, String? name}) async {}

  @override
  Future<void> log(String message) async {}

  @override
  Future<void> recordError(Object error, StackTrace stackTrace, {bool fatal = false}) async {}
}
