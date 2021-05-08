import 'package:smart_list/db/db_provider.dart';
import 'package:smart_list/db/models/main_list_model.dart';

//TODO вынести все что можно в генерик-класс
class MainListRepository {
  static const String table_name = 'main_list';
  MainListRepository._();
  static final MainListRepository inst = MainListRepository._();

  Future<List<MainListModel>> getAll() async {
    //TODO нужен параметр "удаленные/неудаленные"
    print("запрос всех списков");
    final db = await DBProvider.db.database;
    var res = await db.query(table_name);
    List<MainListModel> list =
        res.isNotEmpty ? res.map((x) => MainListModel.fromMap(x)).toList() : [];
    return list;
  }

  newList(String name) async {
    print('insert нового списка');
    final db = await DBProvider.db.database;

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $table_name");
    int id = (table.first["id"] != null) ? table.first["id"] : 1;
    print('new id = $id');

    var raw = await db.rawInsert(
        'INSERT INTO $table_name (id, name, deleted)'
        ' values(?, ?, ?)',
        [id, name, 0]);

    return id;
  }

  byId(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("$table_name", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? MainListModel.fromMap(res.first) : Null;
  }
}
