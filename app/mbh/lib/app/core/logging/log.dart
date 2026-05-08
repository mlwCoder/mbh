import 'package:get/get.dart';
import 'package:mbh/app/core/logging/app_logger.dart';

class Log {
  const Log._();

  static const String _appTag = 'APP';
  static const String _loginTag = 'LOGIN';
  static const String _apiTag = 'API';
  static const String _wsTag = 'WS';
  static const String _homeTag = 'HOME';
  static const String _profileTag = 'PROFILE';

  static AppLogger get _logger => Get.find<AppLogger>();

  static void d(String tag, String message) {
    _logger.debug(message, tag: tag);
  }

  static void i(String tag, String message) {
    _logger.info(message, tag: tag);
  }

  static void w(String tag, String message) {
    _logger.warn(message, tag: tag);
  }

  static void e(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.error(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void f(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.fatal(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void app(String message) {
    i(_appTag, message);
  }

  static void login(String message) {
    i(_loginTag, message);
  }

  static void api(String message) {
    i(_apiTag, message);
  }

  static void ws(String message) {
    i(_wsTag, message);
  }

  static void home(String message) {
    i(_homeTag, message);
  }

  static void profile(String message) {
    i(_profileTag, message);
  }
}
