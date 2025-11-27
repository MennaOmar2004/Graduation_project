import 'package:flutter/material.dart';
import 'package:wanisi_app/widgets/custom_Elevated_button.dart';

import '../colors.dart';
import 'login_Screen.dart';
import 'options_screen.dart';

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
              const Text(
                "تطبيق تعليمي وترفيهي آمن وممتع للأطفال",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 80),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  LoginScreen(),
                    ),
                  );
                },
                buttonBackground: AppColors.gray,
                buttonText: "تسجيل دخول كوالى امر",
                image: "assets/images/icon.png",
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: () {
                  // Navigate to Options Screen for child mode
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  LoginScreen(),
                    ),
                  );
                },
                buttonBackground: AppColors.blue,
                buttonText: "انا طفل",
                image: "assets/images/baby_icon.png",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
