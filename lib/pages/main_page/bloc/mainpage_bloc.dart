import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/db/repositaries/main_list_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_list/strings.dart';

part 'mainpage_event.dart';
part 'mainpage_state.dart';

class MainPageBloc extends Bloc<MainPageEvent, MainPageState> {
  MainPageBloc() : super(MainPageInitialState());

  @override
  Stream<MainPageState> mapEventToState(
    MainPageEvent event,
  ) async* {
    if (event is MainPageInitialEvent) {
      yield* _init();
    }

    if (event is MainPageNewListEvent) {
      yield* _newList(event);
    }

    if (event is MainListRemoveListEvent) {
      yield* _remove(event.item);
    }

    if (event is MainListRenameListEvent) {
      yield* _rename(event.item, event.newName);
    }

    if (event is MainPageShowListEvent) {
      print('переходим на список ${event.id}');
    }
  }

  Stream<MainPageState> _rename(MainListModel model, String newName) async* {
    print('rename list "${model.name}" to "$newName"');
    if (newName == '') return;
    try {
      //проверяем, есть ли уже список с таким названием
      var list = await MainListRepository.inst.getAll(deleted: false);
      if (list.any((x) => x.name == newName)) {
        //TODO проверить, чтобы id не совпадали.
        yield MainPageErrorState(new_list_exists);
        return;
      }
      await MainListRepository.inst.rename(model.id, newName);
      var item = list.firstWhere((x) => x.id == model.id);
      item.name = newName;
      for (int i = 0; i < list.length; i++) await list[i].loadItems();
      yield MainPageLoadedState(items: list);
    } catch (e) {
      yield MainPageErrorState(e.toString());
    }
  }

  Stream<MainPageState> _init() async* {
    print("initial event");
    yield MainPageInitialState();
    var list = await MainListRepository.inst.getAll(deleted: false);
    for (int i = 0; i < list.length; i++) {
      await list[i].loadItems();
    }
    yield MainPageLoadedState(items: list);
  }

  Stream<MainPageState> _newList(MainPageNewListEvent event) async* {
    print('new list event: "${event.newName.toString()}"');
    if (event.newName == '') return;
    try {
      //проверяем, есть ли уже список с таким названием
      var list = await MainListRepository.inst.getAll(deleted: false);
      //TODO как-то надо избавиться от постоянного дерганья loadItems
      for (int i = 0; i < list.length; i++) {
        await list[i].loadItems();
      }
      if (list.any((x) => x.name == event.newName)) {
        yield MainPageErrorState(new_list_exists);
        return;
      }
      var res = await MainListRepository.inst.newList(event.newName);
      var newItem = await MainListRepository.inst.byId(res);
      list.add(newItem); // = await MainListRepository.inst.getAll();
      //TODO надо сразу переходить на только что созданный список
      yield MainPageLoadedState(items: list);
    } catch (e) {
      yield MainPageErrorState(e.toString());
    }
  }

  Stream<MainPageState> _remove(MainListModel item) async* {
    print("remove event: ${item.name}");
    MainListRepository.inst.remove(item.id);
    var list = await MainListRepository.inst.getAll(deleted: false);
    for (int i = 0; i < list.length; i++) await list[i].loadItems();
    yield MainPageLoadedState(items: list);
  }
}
