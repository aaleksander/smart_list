part of 'mainpage_bloc.dart';

@immutable
abstract class MainPageState {}

class MainPageInitialState extends MainPageState {}

class MainPageLoadedState extends MainPageState {
  final List<MainListModel> items;

  MainPageLoadedState({@required this.items});
}

class MainPageErrorState extends MainPageState {
  final String message;
  MainPageErrorState(this.message);
}
