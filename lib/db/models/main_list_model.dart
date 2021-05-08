class MainListModel {
  int id;
  String name;
  bool deleted;

  MainListModel({this.id, this.name, this.deleted});

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
}
