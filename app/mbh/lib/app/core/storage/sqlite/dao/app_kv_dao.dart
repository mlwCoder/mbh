import 'package:mbh/app/core/storage/sqlite/app_database.dart';
import 'package:sqflite/sqflite.dart';

class AppKvDao {
  AppKvDao(this._database);

  final AppDatabase _database;

  Future<void> upsert(String key, String value) async {
    await _database.database.insert(
      'app_kv',
      <String, Object?>{
        'key': key,
        'value': value,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> find(String key) async {
    final List<Map<String, Object?>> rows = await _database.database.query(
      'app_kv',
      where: 'key = ?',
      whereArgs: <Object?>[key],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return rows.first['value'] as String?;
  }
}
