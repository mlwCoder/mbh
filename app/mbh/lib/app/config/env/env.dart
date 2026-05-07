import 'package:mbh/app/config/flavor/app_flavor.dart';

class EnvConfig {
  const EnvConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.enableCrashReporting,
  });

  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableLogging;
  final bool enableCrashReporting;
}
