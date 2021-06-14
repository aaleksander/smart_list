import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/db/repositaries/item_list_Repository.dart';
import 'package:smart_list/db/repositaries/main_list_repository.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_state.dart';
import 'package:smart_list/strings.dart';

class ListPageCubit extends Cubit<ListPageState> {
  MainListModel _mainList;
  ListPageCubit() : super(ListPageInitialState());

  Future<void> load(int id) async {
    emit(ListPageInitialState());
    _mainList = await MainListRepository.inst.byId(id);
    await _mainList.loadItems();
    emit(ListPageLoadedState(_mainList));
  }

  Future<void> newItem(String name) async {
    //print('_new $name для ${_mainList.name} (${_mainList.id})');

    if (name == '') return;

    try {
      //проверяем, есть ли уже пункт с таким названием
      var list = await ItemListRepository.inst.getAll(parentId: _mainList.id);
      if (list.any((x) => x.name == name)) {
        emit(ListPageErrorState(new_item_exists, _mainList));
        return;
      }
      var res = await ItemListRepository.inst.newItem(name, _mainList.id);
      var newItem = await ItemListRepository.inst.byId(res);
      _mainList.items.add(newItem); // = await MainListRepository.inst.getAll();
      emit(ListPageLoadedState(_mainList));
    } catch (e) {
      emit(ListPageErrorState(e.toString(), _mainList));
    }
  }

  Future<void> check(int id, bool check) async {
    //print("_check $id to $check");

    var item = await ItemListRepository.inst.byId(id);

    ItemListRepository.inst.check(id, check);
    _mainList = await MainListRepository.inst.byId(item.parentId);
    await _mainList.loadItems();
    emit(ListPageLoadedState(_mainList));
  }

  Future<void> remove(int id) async {
    var item = await ItemListRepository.inst.byId(id);
    ItemListRepository.inst.remove(id);
    _mainList = await MainListRepository.inst.byId(item.parentId);
    await _mainList.loadItems();
    emit(ListPageLoadedState(_mainList));
  }

  Future<void> removeChecked(int id) async {
    print('_remove Checked $id');
    _mainList = await MainListRepository.inst.byId(id);
    await _mainList.loadItems();
    for (int i = 0; i < _mainList.items.length; i++) {
      if (_mainList.items[i].checked) {
        await ItemListRepository.inst.remove(_mainList.items[i].id);
      }
    }
    //докачиваем окончательный список
    _mainList = await MainListRepository.inst.byId(id);
    await _mainList.loadItems();
    emit(ListPageLoadedState(_mainList));
  }
}
