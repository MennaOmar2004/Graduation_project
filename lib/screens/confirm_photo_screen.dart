import 'package:flutter/material.dart';

import '../colors.dart';
import '../static/app_assets.dart';

class ConfirmPhotoScreen extends StatefulWidget {
  const ConfirmPhotoScreen({super.key});

  @override
  State<ConfirmPhotoScreen> createState() => _ConfirmPhotoScreenState();
}

class _ConfirmPhotoScreenState extends State<ConfirmPhotoScreen> {
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
                  children: [
                    Image.asset(AppAssets.smallIcon, height: 100),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        "assets/images/default_photo.png",
                        height: 450,
                        width: 400,
                      ),
                    ),
                  ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.red,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/Close.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green,
                            blurRadius: 6,
                            // offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/images/yes.png",
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
