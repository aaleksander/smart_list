import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/dialogs/input_text_dialog.dart';
import 'package:smart_list/pages/main_page/bloc/mainpage_bloc.dart';
import 'package:smart_list/strings.dart';

enum MainListOption { rename, remove }

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainPageBloc _bloc = BlocProvider.of<MainPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(main_title),
      ),
      body: BlocBuilder<MainPageBloc, MainPageState>(builder: (context, state) {
        if (state is MainPageInitialState)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (state is MainPageLoadedState) return _loaded(state, _bloc);
        if (state is MainPageErrorState) {
          //TODO нужна отдельная ошибка "такой список существует", тогда
          //появятся две кнопки "перейти к списку" и "вернуться на главную страницу"
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                      onPressed: () {
                        _bloc.add(MainPageInitialEvent());
                      },
                      child: Text('OK')),
                ],
              ),
            ),
          );
        }
        return Center(child: Text('неизвестный state: ${state.toString()}'));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return InputTextDialog(
                    context: context,
                    text: new_list_title,
                    textConfirm: create,
                    func: (text) {
                      print('новый список $text');
                      _bloc.add(MainPageNewListEvent(text));
                    });
              });
        },
        child: Icon(Icons.add),
      ),
      drawer: Container(
        child: Drawer(
          child: Text('Categories'),
        ),
      ),
    );
  }

  _loaded(MainPageLoadedState state, MainPageBloc bloc) {
    if (state.items.length == 0) {
      return Center(
        child: Text(main_list_is_empty),
      );
    }

    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.only(left: 3, right: 3),
        onLongPress: () {
          print('long tap'); //TODO по длинному тапу надо начать менять порядок
        },
        onTap: () {
          //TODO переходим на страницу списка
          print('tap on list item');
        },
        title: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('${state.items[index].name}')),
                  Text(
                    '1/5',
                  ),
                  PopupMenuButton<MainListOption>(
                      onSelected: (MainListOption res) {
                        switch (res) {
                          case MainListOption.rename:
                            //TODO !! переименование списка
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return InputTextDialog(
                                      context: context,
                                      defaultText: state.items[index].name,
                                      text: rename_list_title,
                                      textConfirm: rename_cmd,
                                      func: (text) {
                                        print('новый список $text');
                                        bloc.add(MainListRenameListEvent(
                                            state.items[index], text));
                                      });
                                });
                            break;
                          case MainListOption.remove:
                            //удаление списка
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Удаляем список "${state.items[index].name}"'),
                                    content: Text(
                                        'Список отправить в архив. Подтвердите свое согласие.'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            bloc.add(MainListRemoveListEvent(
                                                state.items[index]));
                                            Navigator.pop(context);
                                          },
                                          child: Text('УДАЛИТЬ')),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('ОТМЕНА')),
                                    ],
                                  );
                                });
                            break;
                          default:
                            throw Exception('неизвестный пункт меню');
                        }
                      },
                      itemBuilder: (context) =>
                          <PopupMenuEntry<MainListOption>>[
                            const PopupMenuItem<MainListOption>(
                              value: MainListOption.rename,
                              child: Text(rename),
                            ),
                            const PopupMenuItem<MainListOption>(
                              value: MainListOption.remove,
                              child: Text(remove),
                            ),
                          ]),
                ],
              ),
              LinearProgressIndicator(
                backgroundColor: Colors.black12,
                value: 0.3,
              )
            ],
          ),
        ),
      ),
    );
  }
}
