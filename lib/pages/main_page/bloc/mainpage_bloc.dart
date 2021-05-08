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
      print("initial event");
      yield MainPageInitialState();
      var list = await MainListRepository.inst.getAll();
      yield MainPageLoadedState(items: list);
    }

    if (event is MainPageNewListEvent) {
      print('new list event: "${event.newName.toString()}"');
      if (event.newName == '') return;
      try {
        //проверяем, есть ли уже список с таким названием
        var list = await MainListRepository.inst.getAll();
        if (list.any((x) => x.name == event.newName)) {
          yield MainPageErrorState(new_list_exists); //TODO
          return;
        }
        var res = await MainListRepository.inst.newList(event.newName);
        var newItem = await MainListRepository.inst.byId(res);
        list.add(newItem); // = await MainListRepository.inst.getAll();
        yield MainPageLoadedState(items: list);
      } catch (e) {
        yield MainPageErrorState(e.toString());
      }
    }
  }
}
