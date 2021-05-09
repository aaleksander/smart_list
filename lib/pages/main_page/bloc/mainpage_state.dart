part of 'mainpage_bloc.dart';

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
