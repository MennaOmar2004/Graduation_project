import 'package:flutter/material.dart';

import '../colors.dart';
import '../widgets/custom_Elevated_button.dart';
import '../widgets/custom_text_form_field.dart';

class Login2 extends StatelessWidget {
  const Login2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Image.asset("assets/images/splash_logo.png",),
                SizedBox(height: 50,),
                CustomTextFormField(hint: "البريد الالكترونى للام"),
                SizedBox(height: 20,),
                CustomTextFormField(hint: "الاسم الطفل"),
                SizedBox(height: 20,),
                SizedBox(height: 20,),
                CustomTextFormField(hint: "كلمة السر"),
                SizedBox(height: 30,),
                CustomElevatedButton(
                  onPressed: (){},
                  buttonBackground: AppColors.blue,
                  buttonText: "تسجيل الدخول",)
              ],
            ),
          )
      ),
    );
  }
}
