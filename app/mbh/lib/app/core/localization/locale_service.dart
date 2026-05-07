import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/storage/kv/app_storage.dart';

class LocaleService extends GetxService {
  LocaleService(this._storage);

  final AppStorage _storage;

  final Rx<Locale> currentLocale = const Locale('zh', 'CN').obs;

  Future<LocaleService> init() async {
    final String? code = _storage.localeCode;
    currentLocale.value = _parseLocale(code);
    return this;
  }

  Locale get locale => currentLocale.value;

  Future<void> updateLocale(Locale locale) async {
    currentLocale.value = locale;
    await _storage.setLocaleCode('${locale.languageCode}_${locale.countryCode}');
    Get.updateLocale(locale);
  }

  Locale _parseLocale(String? code) {
    return switch (code) {
      'en_US' => const Locale('en', 'US'),
      'ru_RU' => const Locale('ru', 'RU'),
      _ => const Locale('zh', 'CN'),
    };
  }
}
