part of 'listpage_bloc.dart';

@immutable
abstract class ListPageState {}

class ListPageInitialState extends ListPageState {}

class ListPageLoadedState extends ListPageState {
  final MainListModel item;

  ListPageLoadedState(this.item);
}
