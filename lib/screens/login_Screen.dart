import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/widgets/custom_Elevated_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/screens/success_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Image.asset("assets/images/splash_logo.png"),
              const SizedBox(height: 50),
              const CustomTextFormField(hint: "البريد الالكترونى للام"),
              const SizedBox(height: 20),
              const CustomTextFormField(hint: "الاسم"),
              const SizedBox(height: 20),
              const CustomTextFormField(
                hint: "الدوله",
                suffixIcon: Icons.keyboard_arrow_down,
              ),
              const SizedBox(height: 20),
              const CustomTextFormField(hint: "كلمة السر"),
              const SizedBox(height: 30),
              CustomElevatedButton(
                onPressed: () {
                  // Navigate to Success Screen after adding new child
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (context) => const SuccessScreen(
                            message: 'تم تسجيل الطفل بنجاح',
                            buttonText: 'متابعة',
                          ),
                    ),
                  );
                },
                buttonBackground: AppColors.blue,
                buttonText: "اضافة طفل جديد",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
