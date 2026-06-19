import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';

/// The initial state view when the user has not picked a photo yet.
/// Displays instructions and a circular avatar placeholder.
class AiAvatarInitialView extends StatelessWidget {
  const AiAvatarInitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular Avatar Placeholder with Border and Glow
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 170,
                height: 170,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink,
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipOval(
                    child: Container(
                      color: AppColors.backgroundLight,
                      child: Image.asset(
                        'assets/images/image_profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person,
                          size: 90,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Camera badge overlay on bottom right
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 24,
                    color: AppColors.pink2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Heading Text
          Text(
            'اصنع صورتك الكرتونية! ✨',
            style: AppTextStyles.linkText.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.blue_,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Description / Guideline Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'اختاري صورتك من الكاميرا أو المعرض والـ AI هيحوّلها لصورة أنمي سحرية وجذابة!',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
