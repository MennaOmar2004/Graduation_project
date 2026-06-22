import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/qalqlah/qalqlah_cubit.dart';
import 'package:wanisi_app/screens/qalqlah_screen/widgets/_body.dart';

/// Entry screen for Qalqlah Detection.
/// Provides [QalqlahCubit] to the widget tree.
class QalqlahScreen extends StatelessWidget {
  const QalqlahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QalqlahCubit(),
      child: const QalqlahBody(),
    );
  }
}
