import 'package:smart_list/db/db_provider.dart';
import 'package:smart_list/db/models/base_model.dart';

///базовый класс для репозитория
class BaseRepository<T extends BaseModel> {
  final String tableName;
  BaseRepository({this.tableName});

  getNewId() async {
    final db = await DBProvider.db.database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM $tableName");
    return (table.first["id"] != null) ? table.first["id"] : 1;
  }
}
