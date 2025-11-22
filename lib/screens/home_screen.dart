import 'package:flutter/material.dart';

import '../colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image.asset("assets/images/splash_logo.png",),
              SizedBox(height: 10,),
              Text("“تطبيق تعليمي وترفيهي آمن وممتع للأطفال”",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80,),
              SizedBox(
                width: 500,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 10,
                        offset: Offset(10, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBackground,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تسجيل دخول كوالى امر",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          "assets/images/icon.png",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 500,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 10,
                        offset: Offset(10, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.text,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "انا طفل",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          "assets/images/baby_icon.png",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
