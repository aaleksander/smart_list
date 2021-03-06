import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/dialogs/confirm_delete_dialog.dart';
import 'package:smart_list/dialogs/input_text_dialog.dart';
import 'package:smart_list/misc/stream_builder_with_listener.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_cubit.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_state.dart';
import 'package:smart_list/pages/list_page/list_page.dart';
import 'package:smart_list/pages/main_page/bloc/mainpage_cubit.dart';
import 'package:smart_list/pages/main_page/bloc/mainpage_state.dart';
import 'package:smart_list/strings.dart';

enum MainListOption { rename, remove }

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final MainPageBloc _bloc = BlocProvider.of<MainPageBloc>(context);
    final MainPageCubit _bloc = BlocProvider.of<MainPageCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(main_title),
      ),
      body: StreamBuilderWithListener<MainPageState>(
        stream: _bloc.stream,
        initialData: _bloc.state,
        listener: (value) {
          if (value is MainPageListAddedState) {
            print('переход на список ${value.id}');
            final mainBloc = BlocProvider.of<MainPageCubit>(context);
            final listBloc = BlocProvider.of<ListPageCubit>(context);
            listBloc.load(value.id);
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListPage()))
                .then((value) {
              mainBloc.init();
            });
          }
        },
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state is MainPageInitialState)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (state is MainPageLoadedState) {
            return _listView(context, state);
          }

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
                          _bloc.init();
                          // add(MainPageInitialEvent());
                        },
                        child: Text('OK')),
                  ],
                ),
              ),
            );
          }
          print('mainPage: неизвестный state: ${state.toString()}');
          return Container(); //заглушка
          //return Center(child: Text('неизвестный state: ${state.toString()}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        //TODO эту область нужно занять на всю ширину, а то, когда список длинный, кнопка "добавить" перекрывает списки
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return InputTextDialog(
                    context: context,
                    text: new_list_title,
                    textConfirm: create,
                    func: (text) {
                      _bloc.newList(text); // .add(MainPageNewListEvent(text));
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

  _listView(context, MainPageLoadedState state) {
    return ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, i) {
          return _itemElement(context, state.items[i]);
        });
  }

  _itemElement(context, MainListModel model) {
    final mainBloc = BlocProvider.of<MainPageCubit>(context);
    final listBloc = BlocProvider.of<ListPageCubit>(context);
    return ListTile(
      key: Key(model.id.toString()),
      contentPadding: EdgeInsets.only(left: 3, right: 3),
      onLongPress: () {
        print('long tap'); //TODO по длинному тапу надо начать менять порядок
      },
      onTap: () {
        //переходим на страницу списка
        listBloc.load(model.id);
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListPage()))
            .then((value) {
          mainBloc.init(); //это чтобы опять перегрузился список
        });
      },
      title: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: BlocBuilder<ListPageCubit, ListPageState>(
            builder: (context, state) {
          return Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text('${model.name}')),
                  Text(
                    '${model.items.where((element) => element.checked).length}/${model.items.length}',
                  ),
                  PopupMenuButton<MainListOption>(
                      onSelected: (MainListOption res) {
                        switch (res) {
                          case MainListOption.rename:
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return InputTextDialog(
                                      context: context,
                                      defaultText: model.name,
                                      text: rename_list_title,
                                      textConfirm: rename_cmd,
                                      func: (text) {
                                        mainBloc.rename(model, text);
                                      });
                                });
                            break;
                          case MainListOption.remove:
                            //удаление списка
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return ConfirmDialog(
                                      func: () => mainBloc.remove(model),
                                      text: '$removing_list "${model.name}"',
                                      textConfirm: confirm_removing_list,
                                      actionText: delete,
                                      cancelText: cancel,
                                      context: context);
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
                value: model.percent,
              )
            ],
          );
        }),
      ),
    );
  }
}
