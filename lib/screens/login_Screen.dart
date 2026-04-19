import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/widgets/custom_dropdown_field.dart';
import 'package:wanisi_app/screens/success_screen.dart';
import 'package:wanisi_app/screens/signup_screen.dart';

import '../colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedCountry;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/images/bottom_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
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
                      CustomDropdownField<String>(
                        hint: "الدوله",
                        value: selectedCountry,
                        items: [
                          DropdownMenuItem(
                            value: 'egypt',
                            alignment: Alignment.centerRight,
                            child: Text('مصر'),
                          ),
                          DropdownMenuItem(
                            value: 'saudi',
                            alignment: Alignment.centerRight,
                            child: Text('السعودية'),
                          ),
                          DropdownMenuItem(
                            value: 'uae',
                            alignment: Alignment.centerRight,
                            child: Text('الإمارات'),
                          ),
                          DropdownMenuItem(
                            value: 'jordan',
                            alignment: Alignment.centerRight,
                            child: Text('الأردن'),
                          ),
                          DropdownMenuItem(
                            value: 'lebanon',
                            alignment: Alignment.centerRight,
                            child: Text('لبنان'),
                          ),
                          DropdownMenuItem(
                            value: 'palestine',
                            alignment: Alignment.centerRight,
                            child: Text('فلسطين'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الرجاء اختيار الدولة';
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
                                builder:
                                    (context) => const SuccessScreen(
                                  message: 'تم تسجيل الطفل بنجاح',
                                  buttonText: 'متابعة',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'الرجاء ملء جميع الحقول بشكل صحيح',
                                  style: AppTextStyles.buttonText,
                                ),
                                backgroundColor: Colors.black,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'تسجيل طفل جديد',
                              style: AppTextStyles.linkText.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.text,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ليس لديك حساب؟',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
