import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/screens/success_screen.dart';

import '../colors.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final countryController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
   LoginScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assets/images/splash_logo.png"),
                  const SizedBox(height: 50),
                  CustomTextFormField(
                    hint: "البريد الالكترونى للام",
                    inputType: TextInputType.emailAddress,
                    controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الحقل فارغ';
                    }
                    if (!value.contains('@')) {
                      return 'ادخل ايميل صالح';
                    }
                    return null;
                  },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hint: "الاسم",
                    inputType: TextInputType.name,
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الحقل فارغ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hint: "الدوله",
                    inputType: TextInputType.text,
                    suffixIcon: Icons.keyboard_arrow_down,
                    controller: countryController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الحقل فارغ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hint: "كلمة السر",
                    controller: passwordController,
                    inputType: TextInputType.number,
                    obscure: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الحقل فارغ';
                      }
                      if (value.length < 6) {
                        return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  LayeredButton(
                    text: "اضافة طفل جديد",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SuccessScreen(
                              message: 'تم تسجيل الطفل بنجاح',
                              buttonText: 'متابعة',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('الرجاء ملء جميع الحقول بشكل صحيح', style:AppTextStyles.buttonText),
                            backgroundColor: Colors.black,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),

                  // CustomElevatedButton(
                  //   onPressed: () {
                  //     // Navigate to Success Screen after adding new child
                  //     Navigator.of(context).pushReplacement(
                  //       MaterialPageRoute(
                  //         builder:
                  //             (context) => const SuccessScreen(
                  //               message: 'تم تسجيل الطفل بنجاح',
                  //               buttonText: 'متابعة',
                  //             ),
                  //       ),
                  //     );
                  //   },
                  //   buttonBackground: AppColors.blue,
                  //   buttonText: "اضافة طفل جديد",
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
