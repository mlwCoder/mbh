import 'package:mbh/app/core/base/base_service.dart';
import 'package:mbh/app/core/storage/hive/hive_boxes.dart';
import 'package:mbh/app/core/storage/hive/hive_service.dart';
import 'package:mbh/app/core/storage/sqlite/dao/app_kv_dao.dart';

class CacheService extends BaseService {
  CacheService({
    required HiveService hiveService,
    required AppKvDao appKvDao,
  })  : _hiveService = hiveService,
        _appKvDao = appKvDao;

  final HiveService _hiveService;
  final AppKvDao _appKvDao;

  Future<void> writeMemoryLikeCache(String key, String value) async {
    await _hiveService.write(HiveBoxes.appCache, key, value);
  }

  String? readMemoryLikeCache(String key) {
    return _hiveService.read(HiveBoxes.appCache, key) as String?;
  }

  Future<void> writePersistentCache(String key, String value) {
    return _appKvDao.upsert(key, value);
  }

  Future<String?> readPersistentCache(String key) {
    return _appKvDao.find(key);
  }
}
