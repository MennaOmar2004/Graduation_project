import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';
import 'login_Screen.dart';
import 'games_screen.dart';

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
                text: "تسجيل دخول كولى امر",
                width: 500,
                height: 65,
                backgroundColor: AppColors.gray,
                shadowColor: const Color(0xFFD6D6D6),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
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
