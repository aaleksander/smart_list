import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'database.db');

    return await openDatabase(
      path,
      version: 2,
      onOpen: (db) {},
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    print('создаем бд');
    await db.execute(_sql_mainList);
    await db.execute(_sql_itemList);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('апдейтим бд $oldVersion -> $newVersion');
    if (oldVersion == 1 && newVersion == 2) {
      await db.execute(_sql_itemList);
    }
  }

  static const String _sql_itemList = 'CREATE TABLE item_list ('
      'id INTEGER PRIMARY KEY,'
      'parent_id INTEGER,'
      'name TEXT,'
      'type INTEGER,'
      'checked BIT'
      ')';

  static const String _sql_mainList = 'CREATE TABLE main_list ('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'deleted BIT'
      ')';
}
