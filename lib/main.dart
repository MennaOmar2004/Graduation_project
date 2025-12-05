import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/avatar_selection/avatar_selection_cubit.dart';
import 'package:wanisi_app/screens/home_tasks_screen.dart';
import 'package:wanisi_app/screens/confirm_photo_screen.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/splash_screen.dart';
import 'package:wanisi_app/screens/take_photo_screen.dart';
import 'package:wanisi_app/screens/widgets/dissmissable_keyboard_ontap.dart';

void main() {
  runApp(
    BlocProvider<AvatarSelectionCubit>(
      create: (context) {
        return AvatarSelectionCubit();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissKeyboardOnTap(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wanisi',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
