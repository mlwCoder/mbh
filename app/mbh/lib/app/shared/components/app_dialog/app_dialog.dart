import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbh/app/core/localization/locale_keys.dart';

class AppDialog {
  const AppDialog._();

  static Future<bool?> confirm({
    required String title,
    required String message,
  }) {
    return Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(LocaleKeys.commonCancel.tr),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: Text(LocaleKeys.commonConfirm.tr),
          ),
        ],
      ),
    );
  }
}
