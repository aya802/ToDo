import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/layout/home_layout.dart';
import 'package:to_do/shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(( MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: HomeLayout(),

    );
  }
}

