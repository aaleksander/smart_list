import 'package:smart_list/db/models/base_model.dart';
import 'package:smart_list/db/models/item_list_model.dart';
import 'package:smart_list/db/repositaries/item_list_Repository.dart';

class MainListModel extends BaseModel {
  int id;
  String name;
  bool deleted;

  MainListModel({this.id, this.name, this.deleted});

  factory MainListModel.fromMap(Map<String, dynamic> json) {
    // bool del = false;
    // if (json['deleted'] != null) del = json['deleted'] == 1;

    return MainListModel(
      id: json["id"],
      name: json["name"],
      deleted: bit2Bool(json, 'deleted'),
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
  // List<ItemListModel> get items => ItemListRepository.inst.getAll(parentId: id);

  get percent {
    var all = items.length;
    var che = items.where((element) => element.checked).length;

    if (all == 0)
      return 0.0;
    else
      return che / all;
  }
}
