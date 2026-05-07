import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mbh/app/core/constants/storage_keys.dart';

class AppStorage extends GetxService {
  AppStorage(this._box);

  final GetStorage _box;

  bool get isFirstLaunch => _box.read(StorageKeys.isFirstLaunch) ?? true;

  String? get localeCode => _box.read<String>(StorageKeys.locale);

  String? get themeMode => _box.read<String>(StorageKeys.themeMode);

  Future<void> setFirstLaunchCompleted() {
    return _box.write(StorageKeys.isFirstLaunch, false);
  }

  Future<void> setLocaleCode(String value) {
    return _box.write(StorageKeys.locale, value);
  }

  Future<void> setThemeMode(String value) {
    return _box.write(StorageKeys.themeMode, value);
  }
}
