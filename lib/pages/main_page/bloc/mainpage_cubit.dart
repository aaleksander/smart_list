import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/db/repositaries/main_list_repository.dart';
import 'package:smart_list/pages/main_page/bloc/mainpage_bloc.dart';

import '../../../strings.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(MainPageInitialState());

  Future<void> init() async {
    print("initial event");
    emit(MainPageInitialState());
    var list = await MainListRepository.inst.getAll(deleted: false);
    for (int i = 0; i < list.length; i++) {
      await list[i].loadItems();
    }
    print('initial ok');
    emit(MainPageLoadedState(items: list));
  }

  Future<void> newList(String newName) async {
    print('new list event: "$newName"');
    if (newName != '') {
      try {
        //проверяем, есть ли уже список с таким названием
        var list = await MainListRepository.inst.getAll(deleted: false);
        //FIXME как-то надо избавиться от постоянного дерганья loadItems
        for (int i = 0; i < list.length; i++) {
          await list[i].loadItems();
        }
        if (list.any((x) => x.name == newName)) {
          emit(MainPageErrorState(new_list_exists));
        }
        var res = await MainListRepository.inst.newList(newName);
        var newItem = await MainListRepository.inst.byId(res);
        list.add(newItem);
        emit(MainPageListAddedState(newItem.id));
      } catch (e) {
        emit(MainPageErrorState(e.toString()));
      }
    }
  }

  Future<void> remove(MainListModel item) async {
    print("remove event: ${item.name}");
    MainListRepository.inst.remove(item.id);
    var list = await MainListRepository.inst.getAll(deleted: false);
    for (int i = 0; i < list.length; i++) await list[i].loadItems();
    emit(MainPageLoadedState(items: list));
  }

  Future<void> rename(MainListModel model, String newName) async {
    print('rename list "${model.name}" to "$newName"');
    if (newName == '') return;
    try {
      //проверяем, есть ли уже список с таким названием
      var list = await MainListRepository.inst.getAll(deleted: false);
      MainListModel a =
          list.firstWhere((x) => x.name == newName, orElse: () => null);
      if (a != null && a.id != model.id) {
        //если это запись с другим id => ошибка
        emit(MainPageErrorState(new_list_exists));
        return;
      }
      //переименовываем
      await MainListRepository.inst.rename(model.id, newName);
      var item = list.firstWhere((x) => x.id == model.id);
      item.name = newName;
      for (int i = 0; i < list.length; i++) await list[i].loadItems();
      emit(MainPageLoadedState(items: list));
    } catch (e) {
      emit(MainPageErrorState(e.toString()));
    }
  }
}
