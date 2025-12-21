import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import '../colors.dart';
import '../widgets/custom_Elevated_button.dart';
import '../widgets/custom_text_form_field.dart';
import 'avatar_selection_screen/avatar_selection_screen.dart';

class Login2 extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Login2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox.expand(
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
                        const SizedBox(height: 100),
                        CustomTextFormField(
                          hint: "البريد الالكترونى للام",
                          inputType: TextInputType.emailAddress,
                          controller:emailController ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الحقل فارغ';
                            }
                            if (!value.contains('@')) {
                              return 'ادخل ايميل صالح';
                            }
                            return null;
                          },),
                        const SizedBox(height: 50),
                        CustomTextFormField(
                          hint: "كلمة السر",
                          inputType: TextInputType.number,
                          controller: passwordController,
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
                        const SizedBox(height: 50),
                        LayeredButton(
                          text: "تسجيل الدخول",
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const AvatarSelectionScreen(),
                                ),
                              );
                            }
                            else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('الرجاء ملء جميع الحقول بشكل صحيح', style:AppTextStyles.buttonText),
                                  backgroundColor: Colors.black,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        )
                        // CustomElevatedButton(
                        //   onPressed: () {
                        //     // Navigate to Success Screen after registration/login
                        //     Navigator.of(context).pushReplacement(
                        //       MaterialPageRoute(
                        //         builder: (context) => const AvatarSelectionScreen(),
                        //       ),
                        //     );
                        //   },
                        //   buttonBackground: AppColors.blue,
                        //   buttonText: "تسجيل الدخول",
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
