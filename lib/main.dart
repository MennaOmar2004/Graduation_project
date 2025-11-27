import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/avatar_selection/avatar_selection_cubit.dart';
import 'package:wanisi_app/screens/login2.dart';
import 'package:wanisi_app/screens/login_Screen.dart';
import 'package:wanisi_app/screens/splash_screen.dart';

void main() {
  runApp(
    BlocProvider<AvatarSelectionCubit>(create: (context) {
      return AvatarSelectionCubit();
    },
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wanisi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Login2(),
    );
  }
}
