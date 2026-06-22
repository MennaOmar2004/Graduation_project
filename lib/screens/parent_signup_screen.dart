import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/screens/signup_screen.dart';

import '../colors.dart';
import '../cubit_of_auth/auth_cubit.dart';
import '../cubit_of_auth/auth_state.dart';

class ParentSignUpScreen extends StatefulWidget {
  const ParentSignUpScreen({super.key});

  @override
  State<ParentSignUpScreen> createState() => _ParentSignUpScreenState();
}

class _ParentSignUpScreenState extends State<ParentSignUpScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit,AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignupScreen(),
            ),
          );
        }

        else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
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
                          hint: "رقم التليفون",
                          controller: phoneController,
                          inputType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الحقل فارغ';
                            }
                            if (value.length < 6) {
                              return 'رقم التليفون يجب أن يكون 11 رقم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hint: "كلمة السر",
                          controller: passwordController,
                          inputType: TextInputType.text,
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
                        BlocBuilder<AuthCubit,AuthState>(builder: (BuildContext context, state) {
                          final isLoading = state is AuthLoading;
                          return LayeredButton(
                            text: isLoading? "جارى التحقق..." : "إنشاء الحساب",
                            onPressed:isLoading
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                    nameController.text,
                                    emailController.text,
                                    phoneController.text,
                                    passwordController.text,
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
                          );
                        },
                        ),
                        const SizedBox(height: 20),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: (context) => const SignupScreen(),
                        //           ),
                        //         );
                        //       },
                        //       child: Text(
                        //         'تسجيل طفل جديد',
                        //         style: AppTextStyles.linkText.copyWith(
                        //           decoration: TextDecoration.underline,
                        //           decorationColor: AppColors.text,
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(width: 8),
                        //     Text(
                        //       'ليس لديك حساب؟',
                        //       style: TextStyle(
                        //         color: Colors.grey.shade700,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
