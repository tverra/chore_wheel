import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqlite_api.dart';

import 'list_item.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> _initDB() async {
    final String path = join(await getDatabasesPath(), "trimpoeng.db");
    Database db;

    final OpenDatabaseOptions options = OpenDatabaseOptions(
        version: 1,
        onOpen: (db) {},
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          debugPrint("Upgrading to version ${newVersion.toString()}");
          if (newVersion == 1) {
            await _dropTables(db);
            await _createTables(db);
          }
        },
        onCreate: (Database db, int version) async {
          debugPrint("Creating database tables..");
          await _createTables(db);
        });

    db = await databaseFactory.openDatabase(path, options: options);

    await db.execute('PRAGMA foreign_keys = ON');
    return db;
  }

  Future<Database> getDatabase() async {
    if (_database != null) return _database;
    _database = await _initDB();

    return _database;
  }

  Future<void> _dropTables(Database db) async {
    await db.transaction((Transaction txn) async {
      final Batch batch = txn.batch();

      batch.execute('DROP TABLE ${ListItem.tableName}');

      await batch.commit();
    });
  }

  Future<void> _createTables(Database db) async {
    await db.transaction((Transaction txn) async {
      final Batch batch = txn.batch();

      batch.execute('CREATE TABLE ${ListItem.getTable()}');
      for (String index in ListItem.getIndexes()) batch.execute(index);

      await batch.commit();
    });
  }
}
