import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/avatar_selection_screen.dart';
import '../colors.dart';
import '../static/app_assets.dart';
import 'avatar_selection_screen/widgets/layered_button.dart';
import 'options_screen.dart';

/// Success screen shown after child registration
class SuccessScreen extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback? onContinue;

  const SuccessScreen({
    super.key,
    this.message = 'تم تسجيل الطفل بنجاح',
    this.buttonText = 'متابعة',
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo
              Image.asset(AppAssets.smallIcon, height: 200),

              const SizedBox(height: 30),

              const Spacer(),

              // Success card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD), // Light blue background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.buttonShadow, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Checkmark icon
                    Image.asset(
                      'assets/images/Done.png',
                      width: 100,
                      height: 100,
                    ),

                    const SizedBox(height: 80),

                    // Success message
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.linkText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF757575),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Continue button
                    LayeredButton(
                      text: buttonText,
                      onPressed:
                          onContinue ??
                          () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => AvatarSelectionScreen(),
                              ),
                            );
                          },
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
