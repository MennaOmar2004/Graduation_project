import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/widgets/custom_Elevated_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                CustomTextFormField(hint: "الاسم"),
                SizedBox(height: 20,),
                CustomTextFormField(hint: "الدوله",suffixIcon:Icons.keyboard_arrow_down),
                SizedBox(height: 20,),
                CustomTextFormField(hint: "كلمة السر"),
                SizedBox(height: 30,),
                CustomElevatedButton(
                  onPressed: (){},
                  buttonBackground: AppColors.blue,
                  buttonText: "اضافة طفل جديد",)
              ],
            ),
          )
      ),
    );
  }
}
