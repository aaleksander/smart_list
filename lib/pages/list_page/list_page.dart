import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/dialogs/confirm_delete_dialog.dart';
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
            BlocBuilder<ListPageBloc, ListPageState>(builder: (context, state) {
              return PopupMenuButton<ListOption>(
                  onSelected: (ListOption res) {
                    switch (res) {
                      case ListOption.removeChecked:
                        //TODO удалить отмеченные
                        if (state is ListPageLoadedState) {
                          print(
                              'удаляем отмеченные у списка ${state.item.name}');
                          //_bloc.add(ListPageRemoveChecked(item));
                        }
                        break;
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<ListOption>>[
                        const PopupMenuItem<ListOption>(
                            value: ListOption.removeChecked,
                            child: Text(remove_checked))
                      ]);
            })
          ],
          title: BlocBuilder<ListPageBloc, ListPageState>(
            builder: (context, state) {
              if (state is ListPageInitialState) return Text("initial");
              if (state is ListPageLoadedState) return Text(state.item.name);
              if (state is ListPageErrorState) return Text(state.item.name);
              return Text(state.toString());
            },
          )),
      body: BlocBuilder<ListPageBloc, ListPageState>(builder: (context, state) {
        if (state is ListPageInitialState) return Center();

        if (state is ListPageLoadedState) {
          return _loaded(context, state.item);
        }

        if (state is ListPageErrorState) {
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                      onPressed: () {
                        _bloc.add(ListPageLoadEvent(state.item.id));
                      },
                      child: Text('OK')),
                ],
              ),
            ),
          );
        }

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
                      _bloc.add(ListPageNewItemEvent(text));
                    });
              });
        },
      ),
    );
  }

  _loaded(context, MainListModel state) {
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
                child: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.delete,
                        )),
                    Expanded(child: Container())
                  ],
                )),
            secondaryBackground: Container(
              color: Colors.green,
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Icon(Icons.edit)
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialog(
                          func: () => _bloc.add(ListPageRemoveItem(item.id)),
                          text: "$removing_item ${item.name}?",
                          textConfirm: confirm_removing_item,
                          actionText: delete,
                          cancelText: cancel,
                          context: context);
                    });
                return res;
              } else {
                return false;
                // TODO: !!! перейти на страницу редактирования
              }
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
