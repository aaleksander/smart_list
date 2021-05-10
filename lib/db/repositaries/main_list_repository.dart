import 'package:flutter/cupertino.dart';
import 'package:smart_list/db/db_provider.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/db/repositaries/base_repository.dart';

class MainListRepository extends BaseRepository<MainListModel> {
  //static const String table_name = 'main_list';
  MainListRepository._() : super(tableName: 'main_list');
  static final MainListRepository inst = MainListRepository._();

  Future<List<MainListModel>> getAll({@required bool deleted}) async {
    final db = await DBProvider.db.database;
    var res = await db.query(tableName, where: 'deleted = ${deleted ? 1 : 0}');
    List<MainListModel> list =
        res.isNotEmpty ? res.map((x) => MainListModel.fromMap(x)).toList() : [];
    return list;
  }

  newList(String name) async {
    final db = await DBProvider.db.database;

    int id = await getNewId();
    print('new id = $id');

    await db.rawInsert(
        'INSERT INTO $tableName (id, name, deleted)'
        ' values(?, ?, ?)',
        [id, name, 0]);

    return id;
  }

  byId(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("$tableName", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? MainListModel.fromMap(res.first) : Null;
  }

  remove(int id) async {
    final db = await DBProvider.db.database;
    await db.rawInsert('update $tableName set deleted = 1 where id = ?', [id]);
  }

  rename(int id, String newName) async {
    final db = await DBProvider.db.database;
    await db.rawInsert(
        'update $tableName set name = ? where id = ?', [newName, id]);
  }
}
