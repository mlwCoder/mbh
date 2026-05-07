import 'package:get/get.dart';
import 'package:mbh/app/core/logging/app_logger.dart';
import 'package:mbh/app/core/permissions/permission_result.dart';
import 'package:mbh/app/core/permissions/permission_type.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  PermissionService(this._logger);

  final AppLogger _logger;

  Future<PermissionResult> request(AppPermissionType type) async {
    final Permission permission = _map(type);
    final PermissionStatus status = await permission.request();
    _logger.debug('Permission $type -> $status');
    return _convert(status);
  }

  Future<PermissionResult> check(AppPermissionType type) async {
    final Permission permission = _map(type);
    final PermissionStatus status = await permission.status;
    return _convert(status);
  }

  Future<void> openSettings() {
    return openAppSettings();
  }

  Permission _map(AppPermissionType type) {
    return switch (type) {
      AppPermissionType.camera => Permission.camera,
      AppPermissionType.photos => Permission.photos,
      AppPermissionType.location => Permission.location,
      AppPermissionType.notification => Permission.notification,
      AppPermissionType.storage => Permission.storage,
      AppPermissionType.microphone => Permission.microphone,
    };
  }

  PermissionResult _convert(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted || PermissionStatus.limited => PermissionResult.granted,
      PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
      PermissionStatus.restricted => PermissionResult.restricted,
      _ => PermissionResult.denied,
    };
  }
}
