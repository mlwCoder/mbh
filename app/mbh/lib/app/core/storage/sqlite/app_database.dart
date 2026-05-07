import 'dart:io';

import 'package:mbh/app/core/base/base_service.dart';
import 'package:mbh/app/core/constants/db_constants.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase extends BaseService {
  Database? _database;

  Database get database {
    final Database? db = _database;
    if (db == null) {
      throw StateError('Database has not been initialized.');
    }
    return db;
  }

  @override
  Future<AppDatabase> init() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = p.join(directory.path, DbConstants.databaseName);
    _database = await openDatabase(
      path,
      version: DbConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return this;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_kv (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == newVersion) {
      return;
    }
  }
}
