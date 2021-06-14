import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_list/pages/list_page/bloc/listpage_cubit.dart';
import 'package:smart_list/pages/main_page/bloc/mainpage_cubit.dart';
import 'package:smart_list/pages/main_page/main_page.dart';
import 'package:smart_list/strings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainPageCubit>(
            create: (context) => MainPageCubit()..init()),
        BlocProvider<ListPageCubit>(
          create: (context) => ListPageCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: main_title,
        initialRoute: '/',
        //home: MainPage(),
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => MainPage(), settings: routeSettings);
            default:
              return MaterialPageRoute(
                  builder: (context) => MainPage(), settings: routeSettings);
          }
        },
      ),
    );
  }
}
