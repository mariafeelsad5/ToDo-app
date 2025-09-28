import 'package:flutter/material.dart';
import 'package:untitled2/HomeLayout.dart';
import 'package:untitled2/components/observe.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled2/components/to_do_cubit.dart';

import 'Widgets/SplashScreen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToDoCubit()..createDatabase(),
      child: MaterialApp(

        home: SplashScreen(),
      ),
    );
  }
}