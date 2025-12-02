import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';
import 'login_Screen.dart';

import 'game_screen.dart';
import 'alphabet_game_screen.dart';
import 'maze_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image.asset("assets/images/splash_logo.png"),
              const SizedBox(height: 10),
              Text(
                "تطبيق تعليمي وترفيهي آمن وممتع للأطفال",
                style: GoogleFonts.cairo(
                  color: AppColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              LayeredButton(
                text: "تسجيل دخول كوالى امر",
                width: 500,
                height: 65,
                backgroundColor: AppColors.gray,
                shadowColor: Color(0xFFD6D6D6),
                image: "assets/images/icon.png",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              LayeredButton(
                text: "انا طفل",
                width: 500,
                height: 65,
                backgroundColor: AppColors.blue,
                image: "assets/images/baby_icon.png",
                onPressed: () {
                  // Navigate to Options Screen for child mode
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              LayeredButton(
                text: "لعبة صائد النجوم",
                width: 500,
                height: 65,
                backgroundColor: const Color(0xFFFF9800), // Orange
                shadowColor: const Color(0xFFF57C00),
                image: "assets/images/icon.png", // Using existing icon for now
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GameScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              LayeredButton(
                text: "تعلم الحروف",
                width: 500,
                height: 65,
                backgroundColor: const Color(0xFF4ECDC4), // Turquoise
                shadowColor: const Color(0xFF3AB0A6),
                image: "assets/images/icon.png",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AlphabetGameScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              LayeredButton(
                text: "طريق القيم",
                width: 500,
                height: 65,
                backgroundColor: const Color(0xFFFFD700), // Gold
                shadowColor: const Color(0xFFFFA500),
                image: "assets/images/icon.png",
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MazeGameScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
