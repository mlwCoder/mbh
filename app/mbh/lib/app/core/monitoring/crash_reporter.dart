abstract class CrashReporter {
  Future<void> init();
  Future<void> setUser(String id, {String? email, String? name});
  Future<void> log(String message);
  Future<void> recordError(Object error, StackTrace stackTrace, {bool fatal = false});
}
