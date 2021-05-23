import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/dialogs/input_text_dialog.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_bloc.dart';
import 'package:smart_list/strings.dart';

enum ListOption { removeChecked }

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListPageBloc _bloc = BlocProvider.of<ListPageBloc>(context);
    return Scaffold(
      appBar: AppBar(
          actions: [
            PopupMenuButton<ListOption>(
                onSelected: (ListOption res) {
                  switch (res) {
                    case ListOption.removeChecked:
                      //TODO !!! удалить отмеченные
                      print('удаляем отмеченные');
                      break;
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<ListOption>>[
                      const PopupMenuItem<ListOption>(
                          value: ListOption.removeChecked,
                          child: Text(remove_checked))
                    ])
          ],
          //TODO справа добавить кнопку "more" с опциями (удалить купленные и т.п.)
          title: BlocBuilder<ListPageBloc, ListPageState>(
            builder: (context, state) {
              if (state is ListPageInitialState) return Text("initial");
              if (state is ListPageLoadedState) return Text(state.item.name);
              return Text('неизвестное состояние: ${state.toString()}');
            },
          )),
      body: BlocBuilder<ListPageBloc, ListPageState>(builder: (context, state) {
        if (state is ListPageInitialState) return Center();

        if (state is ListPageLoadedState) {
          print('state is ListPageLoadedState (${state.item.items.length})');
          return _loaded(context, state.item);
        }

        //TODO !!! состояние "ошибка"

        return Center(
          child: Text('неизвестное состояние: ${state.toString()}'),
        );
      }),
      floatingActionButton: FloatingActionButton(
        //TODO эту область нужно занять на всю ширину, а то, когда список длинный, кнопка "добавить" перекрывает списки
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return InputTextDialog(
                    context: context,
                    text: new_item_title,
                    textConfirm: create,
                    func: (text) {
                      print('новое дело: "$text"');
                      _bloc.add(ListPageNewItemEvent(text));
                    });
              });
        },
      ),
    );
  }

  _loaded(context, MainListModel state) {
    print("_loaded ${state.name}, ${state.items.length}");
    var tmp = state.items;
    if (tmp.length == 0) {
      return Center(
        child: Text(list_is_empty),
      );
    }

    final ListPageBloc _bloc = BlocProvider.of<ListPageBloc>(context);

    return ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          return Dismissible(
            key: Key(item.name),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (direction) {
              print('dismiss ${item.name} $direction');
              _bloc.add(ListPageRemoveItem(item.id));
            },
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 3, right: 3),
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
                        //TODO добавить иконку для пункта
                        Expanded(
                            child: Text(
                          '${state.items[index].name}',
                        )),
                        Checkbox(
                            value: state.items[index].checked,
                            onChanged: (val) {
                              //отмечаем итем как сделанный или наоборот
                              _bloc.add(ListPageCheckEvent(
                                  state.items[index].id, val));
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
