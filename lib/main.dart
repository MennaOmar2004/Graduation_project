import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/avatar_selection/avatar_selection_cubit.dart';
import 'package:wanisi_app/screens/games_screen.dart';
import 'package:wanisi_app/screens/home_tasks_screen.dart';
import 'package:wanisi_app/screens/confirm_photo_screen.dart';
import 'package:wanisi_app/screens/options_screen.dart' show OptionsScreen;import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/splash_screen.dart';
import 'package:wanisi_app/screens/stories_screen.dart';
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
  /* runApp(
    BlocProvider<AvatarSelectionCubit>(
      create: (context) {
        return AvatarSelectionCubit();
      },
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(), // Wrap your app
      ),
    ),
  );*/
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
