import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mbh/app/core/base/base_service.dart';

class HiveService extends BaseService {
  final Map<String, Box<dynamic>> _openedBoxes = <String, Box<dynamic>>{};

  Future<Box<dynamic>> openBox(String name) async {
    if (_openedBoxes.containsKey(name)) {
      return _openedBoxes[name]!;
    }

    final Box<dynamic> box = await Hive.openBox<dynamic>(name);
    _openedBoxes[name] = box;
    return box;
  }

  dynamic read(String boxName, String key) {
    return _openedBoxes[boxName]?.get(key);
  }

  Future<void> write(String boxName, String key, dynamic value) async {
    final Box<dynamic> box = await openBox(boxName);
    await box.put(key, value);
  }

  Future<void> clearBox(String boxName) async {
    final Box<dynamic> box = await openBox(boxName);
    await box.clear();
  }
}
