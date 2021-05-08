part of 'mainpage_bloc.dart';

@immutable
abstract class MainPageEvent {}

class MainPageInitialEvent extends MainPageEvent {}

class MainPageNewListEvent extends MainPageEvent {
  final String newName;

  MainPageNewListEvent(this.newName);
}
