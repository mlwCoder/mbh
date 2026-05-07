import 'package:mbh/app/config/env/env.dart';
import 'package:mbh/app/config/flavor/app_flavor.dart';

class FlavorConfig {
  FlavorConfig._();

  static late EnvConfig instance;

  static void init(AppFlavor flavor) {
    instance = switch (flavor) {
      AppFlavor.dev => const EnvConfig(
        flavor: AppFlavor.dev,
        appName: 'MBH Dev',
        baseUrl: 'https://dev-api.example.com',
        enableLogging: true,
        enableCrashReporting: false,
      ),
      AppFlavor.test => const EnvConfig(
        flavor: AppFlavor.test,
        appName: 'MBH Test',
        baseUrl: 'https://test-api.example.com',
        enableLogging: true,
        enableCrashReporting: false,
      ),
      AppFlavor.staging => const EnvConfig(
        flavor: AppFlavor.staging,
        appName: 'MBH Staging',
        baseUrl: 'https://staging-api.example.com',
        enableLogging: true,
        enableCrashReporting: true,
      ),
      AppFlavor.prod => const EnvConfig(
        flavor: AppFlavor.prod,
        appName: 'MBH',
        baseUrl: 'https://api.example.com',
        enableLogging: false,
        enableCrashReporting: true,
      ),
    };
  }
}
