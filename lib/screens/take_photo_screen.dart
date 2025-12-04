import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../static/app_assets.dart';

class TakePhotoScreen extends StatefulWidget {
  const TakePhotoScreen({super.key});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(   // <--- ده اللي بيحل المشكلة
              child: SingleChildScrollView(
                child: Column(
                  children: [],
                ),
              ),
            ),
            // الـ Container اللي تحت
            Container(
              width: double.infinity,
              height: 150,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // زرار السهم يتحط بمكان ثابت
                  Positioned(
                    left: 0,     // خليه ناحية الشمال (لو عايزاه يمين غيريها لـ right)
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios_sharp,size: 40,),
                    ),
                  ),

                  // أيقونة الكاميرا في النص
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/Camera.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
