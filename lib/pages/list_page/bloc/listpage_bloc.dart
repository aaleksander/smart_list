import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/db/repositaries/item_list_Repository.dart';
import 'package:smart_list/db/repositaries/main_list_repository.dart';
import 'package:smart_list/strings.dart';

part 'listpage_event.dart';
part 'listpage_state.dart';

class ListPageBloc extends Bloc<ListPageEvent, ListPageState> {
  MainListModel _mainList;
  ListPageBloc() : super(ListPageInitialState());

  @override
  Stream<ListPageState> mapEventToState(
    ListPageEvent event,
  ) async* {
    if (event is ListPageLoadEvent) yield* _load(event.id);
    if (event is ListPageNewItemEvent) yield* _new(event.name);
    if (event is ListPageCheckEvent) yield* _check(event.id, event.checked);
    if (event is ListPageRemoveItem) yield* _remove(event.id);
  }

  Stream<ListPageState> _load(int id) async* {
    yield ListPageInitialState();
    _mainList = await MainListRepository.inst.byId(id);
    await _mainList.loadItems();
    print('итого: ${_mainList.items.length}');
    yield ListPageLoadedState(_mainList);
  }

  Stream<ListPageState> _new(String name) async* {
    print('_new $name для ${_mainList.name} (${_mainList.id})');

    if (name == '') return;

    try {
      //проверяем, есть ли уже пункт с таким названием
      var list = await ItemListRepository.inst.getAll(parentId: _mainList.id);
      if (list.any((x) => x.name == name)) {
        yield ListPageErrorState(new_item_exists);
        return;
      }
      var res = await ItemListRepository.inst.newItem(name, _mainList.id);
      var newItem = await ItemListRepository.inst.byId(res);
      _mainList.items.add(newItem); // = await MainListRepository.inst.getAll();
      //TODO надо сразу переходить на только что созданный список
      yield ListPageLoadedState(_mainList);
    } catch (e) {
      yield ListPageErrorState(e.toString());
    }
  }

  Stream<ListPageState> _check(int id, bool check) async* {
    print("_check $id to $check");

    var item = await ItemListRepository.inst.byId(id);

    ItemListRepository.inst.check(id, check);
    _mainList = await MainListRepository.inst.byId(item.parentId);
    await _mainList.loadItems();
    yield ListPageLoadedState(_mainList);
  }

  Stream<ListPageState> _remove(int id) async* {
    print('_remove $id');

    var item = await ItemListRepository.inst.byId(id);
    ItemListRepository.inst.remove(id);
    _mainList = await MainListRepository.inst.byId(item.parentId);
    await _mainList.loadItems();
    yield ListPageLoadedState(_mainList);
  }
}
