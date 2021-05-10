import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/db/repositaries/main_list_repository.dart';

part 'listpage_event.dart';
part 'listpage_state.dart';

class ListPageBloc extends Bloc<ListPageEvent, ListPageState> {
  ListPageBloc() : super(ListPageInitialState());

  @override
  Stream<ListPageState> mapEventToState(
    ListPageEvent event,
  ) async* {
    if (event is ListPageLoadEvent) yield* _load(event.id);
  }

  Stream<ListPageState> _load(int id) async* {
    print('load $id');
    var parent = await MainListRepository.inst.byId(id);
    yield ListPageLoadedState(parent);
  }
}
