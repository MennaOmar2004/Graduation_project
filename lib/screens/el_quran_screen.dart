import 'package:flutter/material.dart';
import 'el_quran_screen/widgets/_body.dart';

class ElQuranScreen extends StatelessWidget {
  const ElQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white, body: QuranBody());
  }
}
