import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mbh/app/config/flavor/flavor_config.dart';
import 'package:mbh/app/core/auth/auth_service.dart';
import 'package:mbh/app/core/localization/locale_service.dart';
import 'package:mbh/app/core/logging/app_logger.dart';
import 'package:mbh/app/core/logging/log_level.dart';
import 'package:mbh/app/core/monitoring/crash_reporter.dart';
import 'package:mbh/app/core/monitoring/noop_crash_reporter.dart';
import 'package:mbh/app/core/monitoring/sentry_reporter.dart';
import 'package:mbh/app/core/network/client/api_client.dart';
import 'package:mbh/app/core/network/client/dio_factory.dart';
import 'package:mbh/app/core/network/network_service.dart';
import 'package:mbh/app/core/network/websocket/ws_client.dart';
import 'package:mbh/app/core/permissions/permission_service.dart';
import 'package:mbh/app/core/storage/cache_service.dart';
import 'package:mbh/app/core/storage/hive/hive_boxes.dart';
import 'package:mbh/app/core/storage/hive/hive_service.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';
import 'package:mbh/app/core/storage/secure/secure_storage_service.dart';
import 'package:mbh/app/core/storage/sqlite/app_database.dart';
import 'package:mbh/app/core/storage/sqlite/dao/app_kv_dao.dart';
import 'package:mbh/app/core/theme/theme_service.dart';
import 'package:mbh/app/core/upload/upload_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppInitializer {
  const AppInitializer._();

  static Future<void> init() async {
    // ---- Storage ----
    await GetStorage.init();
    await Hive.initFlutter();

    final GetStorage storageBox = GetStorage();
    final AppStorage appStorage = Get.put<AppStorage>(AppStorage(storageBox), permanent: true);

    // ---- Logger ----
    final AppLogger logger = Get.put<AppLogger>(AppLogger(), permanent: true);
    final bool isProd = !FlavorConfig.instance.enableLogging;
    await logger.init(
      enableConsole: !isProd,
      enableFile: true,
      minLevel: isProd ? LogLevel.warn : LogLevel.debug,
    );
    logger.info('Initializing app for ${FlavorConfig.instance.appName}');

    // ---- Crash reporter ----
    final CrashReporter crashReporter = FlavorConfig.instance.enableCrashReporting
        ? SentryReporter(dsn: 'YOUR_SENTRY_DSN')
        : NoopCrashReporter();
    await crashReporter.init();
    Get.put<CrashReporter>(crashReporter, permanent: true);

    // ---- Secure storage ----
    final SecureStorageService secureStorageService = Get.put<SecureStorageService>(
      SecureStorageService(const FlutterSecureStorage()),
      permanent: true,
    );

    // ---- Auth ----
    final AuthService authService = Get.put<AuthService>(
      AuthService(secureStorageService),
      permanent: true,
    );
    await authService.init();

    // ---- Hive ----
    final HiveService hiveService = Get.put<HiveService>(HiveService(), permanent: true);
    await hiveService.openBox(HiveBoxes.appCache);
    await hiveService.openBox(HiveBoxes.userCache);

    // ---- SQLite ----
    final AppDatabase appDatabase = Get.put<AppDatabase>(AppDatabase(), permanent: true);
    await appDatabase.init();

    final AppKvDao appKvDao = Get.put<AppKvDao>(AppKvDao(appDatabase), permanent: true);

    // ---- Cache ----
    final CacheService cacheService = Get.put<CacheService>(
      CacheService(hiveService: hiveService, appKvDao: appKvDao),
      permanent: true,
    );
    await cacheService.init();

    // ---- Network ----
    final DioFactory dioFactory = DioFactory(
      logger: logger,
      secureStorageService: secureStorageService,
    );
    final ApiClient apiClient = ApiClient(dioFactory.create());
    Get.put<NetworkService>(NetworkService(apiClient), permanent: true);

    // ---- Upload ----
    Get.put<UploadService>(UploadService(logger), permanent: true);

    // ---- WebSocket ----
    Get.put<WsClient>(WsClient(logger), permanent: true);

    // ---- Permissions ----
    Get.put<PermissionService>(PermissionService(logger), permanent: true);

    // ---- Theme ----
    final ThemeService themeService = Get.put<ThemeService>(
      ThemeService(appStorage),
      permanent: true,
    );
    await themeService.init();

    // ---- Locale ----
    final LocaleService localeService = Get.put<LocaleService>(
      LocaleService(appStorage),
      permanent: true,
    );
    await localeService.init();

    // ---- Diagnostics ----
    final String dbPath = await getDatabasesPath();
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    logger.debug('SQLite path: $dbPath');
    logger.debug('Documents path: ${appDocDir.path}');
  }
}
