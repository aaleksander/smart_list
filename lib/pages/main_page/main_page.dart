import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (state is MainPageLoadedState) return _loaded(state);
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
                final TextEditingController nameController =
                    TextEditingController();
                return SimpleDialog(
                  children: [
                    TextField(
                      autofocus: true,
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: new_list_title,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          print('ok ${nameController.text}');
                          Navigator.pop(context);
                          _bloc.add(MainPageNewListEvent(nameController.text));
                        },
                        child: Text(create),
                      ),
                    ),
                  ],
                );
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

  _loaded(MainPageLoadedState state) {
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
                            print('rename ${state.items[index].name}');
                            break;
                          case MainListOption.remove:
                            //TODO !!!! удаление списка
                            print('remove ${state.items[index].name}');
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
