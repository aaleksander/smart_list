import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/db/models/main_list_model.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_bloc.dart';
import 'package:smart_list/strings.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final ListPageBloc _bloc = BlocProvider.of<ListPageBloc>(context);
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

        if (state is ListPageLoadedState) return _loaded(context, state.item);

        return Center(
          child: Text('неизвестное состояние: ${state.toString()}'),
        );
      }),
    );
  }

  _loaded(context, MainListModel state) {
    var tmp = state.items;
    if (tmp.length == 0) {
      return Center(
        child: Text(main_list_is_empty),
      );
    }

    return Center(
      child: Text('что-то есть'),
    );
  }
}
