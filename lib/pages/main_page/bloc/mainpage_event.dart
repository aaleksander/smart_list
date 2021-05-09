part of 'mainpage_bloc.dart';

@immutable
abstract class MainPageEvent {}

///первичная инициализация
class MainPageInitialEvent extends MainPageEvent {}

///добавление нового списка
class MainPageNewListEvent extends MainPageEvent {
  final String newName;

  MainPageNewListEvent(this.newName);
}
