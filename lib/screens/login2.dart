import 'package:flutter/material.dart';
import '../colors.dart';
import '../widgets/custom_Elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'avatar_selection_screen/avatar_selection_screen.dart';

class Login2 extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Login2({super.key});

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
              CustomTextFormField(hint: "البريد الالكترونى للام",controller:emailController ,),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              CustomTextFormField(hint: "كلمة السر",controller: passwordController,obscure: true,
              ),
              const SizedBox(height: 30),
              CustomElevatedButton(
                onPressed: () {
                  // Navigate to Success Screen after registration/login
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const AvatarSelectionScreen(),
                    ),
                  );
                },
                buttonBackground: AppColors.blue,
                buttonText: "تسجيل الدخول",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
