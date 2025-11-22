import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(),)); // Replace '/home' with your actual home route
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash_logo.png",),
            Text("“تطبيق تعليمي وترفيهي آمن وممتع للأطفال”",
              style: TextStyle(
                color: AppColors.text,
                fontSize: 25,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
