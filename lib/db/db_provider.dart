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
      version: 1,
      onOpen: (db) {},
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    print('создаем бд');
    await db.execute(_sql_mainList);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) {}

  static const String _sql_mainList = 'CREATE TABLE main_list ('
      'id INTEGER PRIMARY KEY,'
      'name TEXT,'
      'deleted BIT'
      ')';
}
