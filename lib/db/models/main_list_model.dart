import 'package:smart_list/db/models/base_model.dart';
import 'package:smart_list/db/models/item_list_model.dart';
import 'package:smart_list/db/repositaries/item_list_Repository.dart';

class MainListModel extends BaseModel {
  int id;
  String name;
  bool deleted;

  MainListModel({this.id, this.name, this.deleted}) {
    loadItems();
  }

  factory MainListModel.fromMap(Map<String, dynamic> json) {
    bool del = false;
    if (json['deleted'] != null) del = json['deleted'] == 1;

    return MainListModel(
      id: json["id"],
      name: json["name"],
      deleted: del,
    );
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "deleted": deleted,
      };

  List<ItemListModel> _items = [];

  loadItems() async {
    print('load items for "$name"');
    _items = await ItemListRepository.inst.getAll(parentId: id);
  }

  List<ItemListModel> get items => _items;
}
