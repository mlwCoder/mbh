import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mbh/app/core/base/base_service.dart';
import 'package:mbh/app/core/constants/storage_keys.dart';

class SecureStorageService extends BaseService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> writeAccessToken(String value) {
    return _storage.write(key: StorageKeys.accessToken, value: value);
  }

  Future<String?> readAccessToken() {
    return _storage.read(key: StorageKeys.accessToken);
  }

  Future<void> writeRefreshToken(String value) {
    return _storage.write(key: StorageKeys.refreshToken, value: value);
  }

  Future<String?> readRefreshToken() {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }
}
