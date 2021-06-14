import 'package:flutter/foundation.dart';
import 'package:smart_list/db/models/main_list_model.dart';

@immutable
abstract class MainPageState {}

///первичная инициализация
class MainPageInitialState extends MainPageState {}

///загрузился список списков
class MainPageLoadedState extends MainPageState {
  final List<MainListModel> items;

  MainPageLoadedState({@required this.items});
}

///возникла ошибка
class MainPageErrorState extends MainPageState {
  final String message;
  MainPageErrorState(this.message);
}

///список создан
class MainPageListAddedState extends MainPageState {
  final int id;
  MainPageListAddedState(this.id);
}
