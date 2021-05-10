import 'package:smart_list/db/models/base_model.dart';

class ItemListModel extends BaseModel {
  int id;
  int parentId;
  String name;
  int type;
  bool checked;

  ItemListModel({this.id, this.parentId, this.name, this.type, this.checked});

  factory ItemListModel.fromMap(Map<String, dynamic> json) {
    return ItemListModel(
      id: json["id"],
      parentId: json["parent_id"],
      name: json["name"],
      type: json["type"],
      checked: bit2Bool(json, 'checked'),
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "parent_id": parentId,
        "name": name,
        "type": type,
        "checked": checked,
      };
}
