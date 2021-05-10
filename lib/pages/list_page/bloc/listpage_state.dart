part of 'listpage_bloc.dart';

@immutable
abstract class ListPageState {}

class ListPageInitialState extends ListPageState {}

class ListPageLoadedState extends ListPageState {
  final MainListModel item;

  ListPageLoadedState(this.item);
}

///возникла ошибка
class ListPageErrorState extends ListPageState {
  final String message;
  ListPageErrorState(this.message);
}
