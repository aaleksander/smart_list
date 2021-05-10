part of 'listpage_bloc.dart';

@immutable
abstract class ListPageEvent {}

class ListPageInitialEvent extends ListPageEvent {}

class ListPageLoadEvent extends ListPageEvent {
  final int id;
  ListPageLoadEvent(this.id);
}

class ListPageNewItemEvent extends ListPageEvent {
  final String name;
  ListPageNewItemEvent(this.name);
}