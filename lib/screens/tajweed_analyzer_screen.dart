import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/blocs/tajweed/tajweed_cubit.dart';
import 'package:wanisi_app/screens/tajweed_analyzer_screen/widgets/_body.dart';

/// Entry screen for Tajweed Analyzer.
/// Provides [TajweedCubit] to the widget tree and renders [TajweedBody].
class TajweedAnalyzerScreen extends StatelessWidget {
  const TajweedAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TajweedCubit(),
      child: const TajweedBody(),
    );
  }
}
