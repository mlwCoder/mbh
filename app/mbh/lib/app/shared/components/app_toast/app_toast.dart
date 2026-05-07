import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToast {
  const AppToast._();

  static void show(String message) {
    Get.closeAllSnackbars();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text(message),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}
