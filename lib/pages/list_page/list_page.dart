import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/dialogs/input_text_dialog.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_bloc.dart';
import 'package:smart_list/strings.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ListPageBloc _bloc = BlocProvider.of<ListPageBloc>(context);
    return Scaffold(
      appBar: AppBar(title: BlocBuilder<ListPageBloc, ListPageState>(
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

    return ListView.builder(
      itemCount: state.items.length,
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.only(left: 3, right: 3),
        onLongPress: () {
          print('long tap'); //TODO по длинному тапу надо начать менять порядок
        },
        onTap: () {
          //переходим на страницу списка
          //TODO возможно, можно сразу передавать MainListModel, чтоб лишний раз
          //базу не дергать в ListPageBlock._loaded
          //listBloc.add(ListPageLoadEvent(state.items[index].id));
          //Navigator.push(
          //    context, MaterialPageRoute(builder: (context) => ListPage()));
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
                  Checkbox(
                      value: state.items[index].checked, onChanged: (val) {})
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
