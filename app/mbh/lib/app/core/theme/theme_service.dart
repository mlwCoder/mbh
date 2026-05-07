import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';

class ThemeService extends GetxService {
  ThemeService(this._storage);

  final AppStorage _storage;

  final Rx<ThemeMode> currentThemeMode = ThemeMode.system.obs;

  Future<ThemeService> init() async {
    final String? savedMode = _storage.themeMode;
    currentThemeMode.value = _parseThemeMode(savedMode);
    return this;
  }

  ThemeMode get themeMode => currentThemeMode.value;

  Future<void> updateThemeMode(ThemeMode mode) async {
    currentThemeMode.value = mode;
    await _storage.setThemeMode(mode.name);
    Get.changeThemeMode(mode);
  }

  ThemeMode _parseThemeMode(String? mode) {
    return switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }
}
