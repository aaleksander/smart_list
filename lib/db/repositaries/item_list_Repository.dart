import 'package:smart_list/db/db_provider.dart';
import 'package:smart_list/db/models/item_list_model.dart';
import 'package:smart_list/db/repositaries/base_repository.dart';

class ItemListRepository extends BaseRepository<ItemListModel> {
  ItemListRepository._() : super(tableName: 'item_list');
  static final ItemListRepository inst = ItemListRepository._();

  Future<List<ItemListModel>> getAll({int parentId = -1}) async {
    final db = await DBProvider.db.database;

    String where = (parentId == -1) ? '' : 'parent_id=${parentId.toString()}';

    var res =
        await db.query(tableName, where: where); //, orderBy: 'checked, id');

    List<ItemListModel> list =
        res.isNotEmpty ? res.map((x) => ItemListModel.fromMap(x)).toList() : [];
    return list;
  }

  Future<ItemListModel> byId(int id) async {
    final db = await DBProvider.db.database;
    var res = await db.query("$tableName", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ItemListModel.fromMap(res.first) : Null;
  }

  newItem(String name, int parentId) async {
    final db = await DBProvider.db.database;

    int id = await getNewId();
    print('new id = $id, ');

    await db.rawInsert(
        'INSERT INTO $tableName (id, parent_id, name, checked )'
        ' values(?, ?, ?, ?)',
        [id, parentId, name, 0]);

    return id;
  }

  check(int id, bool val) async {
    final db = await DBProvider.db.database;

    var row = {
      'checked': val ? 1 : 0,
    };

    await db.update(tableName, row, where: 'id = ?', whereArgs: [id]);
  }

  remove(int id) async {
    final db = await DBProvider.db.database;

    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
