import 'package:flutter/foundation.dart';
import 'package:smart_list/db/models/main_list_model.dart';

@immutable
abstract class ListPageState {}

class ListPageInitialState extends ListPageState {}

class ListPageLoadedState extends ListPageState {
  final MainListModel item;

  ListPageLoadedState(this.item);
}

///возникла ошибка
class ListPageErrorState extends ListPageState {
  final MainListModel item;
  final String message;
  ListPageErrorState(this.message, this.item);
}
