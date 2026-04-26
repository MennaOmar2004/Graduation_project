import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/widgets/custom_dropdown_field.dart';
import 'package:wanisi_app/screens/success_screen.dart';
import '../colors.dart';
import '../network/dio_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final specializationsController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    specializationsController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        hint: "اسم الطفل",
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
                        hint: "السن",
                        inputType: TextInputType.number,
                        controller: ageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الحقل فارغ';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 1 || age > 18) {
                            return 'ادخل عمر صالح (1-18)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomDropdownField<String>(
                        hint: "الجنس",
                        value: selectedGender,
                        items: [
                          DropdownMenuItem(
                            value: 'male',
                            alignment: Alignment.centerRight,
                            child: Text('ذكر'),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            alignment: Alignment.centerRight,
                            child: Text('أنثى'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'الرجاء اختيار الجنس';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hint: "التفضيلات",
                        inputType: TextInputType.text,
                        controller: specializationsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الحقل فارغ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hint: "كلمة سر الطفل",
                        controller: passwordController,
                        inputType: TextInputType.number,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الحقل فارغ';
                          }
                          if (value.length < 3) {
                            return 'كلمة السر يجب أن تكون 3 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      LayeredButton(
                          text: "تسجيل الطفل",
                          // داخل onPressed في SignupScreen
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final prefs = await SharedPreferences.getInstance();
                                final parentId = prefs.getInt("parentId");

                                if (parentId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("عفواً، يجب تسجيل دخول الأب أولاً")),
                                  );
                                  return;
                                }

                                // 1️⃣ إنشاء الطفل
                                final createResponse = await DioHelper.dio.post(
                                  "/api/v1/children",
                                  data: {
                                    "fullName": nameController.text.trim(),
                                    "age": int.parse(ageController.text.trim()), // تحويل السن لرقم
                                    "parentId": parentId,
                                    "avatarUrl": "https://ui-avatars.com/api/?name=${nameController.text}", // قيمة افتراضية
                                    "preferences": specializationsController.text.trim(),
                                    "pinCode": passwordController.text.trim(),
                                    "gender": selectedGender,
                                  },
                                );

                                // تأكدي من قراءة الـ ID بشكل صحيح (حسب رد السيرفر)
                                final dynamic responseData = createResponse.data;
                                final int childId = responseData["data"] != null
                                    ? responseData["data"]["id"]
                                    : responseData["id"];

                                // 2️⃣ تسجيل دخول الطفل فوراً
                                final loginResponse = await DioHelper.dio.post(
                                  "/api/v1/auth/child/login",
                                  data: {
                                    "childId": childId,
                                    "pinCode": passwordController.text.trim(),
                                  },
                                );

                                // 3️⃣ حفظ توكن الطفل ومعرفه للعمليات القادمة
                                await prefs.setString("child_token", loginResponse.data["token"]);
                                await prefs.setInt("childId", childId);

                                // 4️⃣ الانتقال
                                if (mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SuccessScreen(
                                        message: 'تم تسجيل الطفل بنجاح',
                                        buttonText: 'متابعة',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print("❌ Complete Error: $e");
                                String errorMsg = "فشل التسجيل، تأكد من البيانات";

                                // إذا كان الخطأ من السيرفر، نحاول إظهار السبب الحقيقي
                                if (e is DioException && e.response?.data != null) {
                                  errorMsg = e.response?.data["message"] ?? errorMsg;
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMsg)),
                                );
                              }
                            }
                          }
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'تسجيل الدخول',
                              style: AppTextStyles.linkText.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.text,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'لديك حساب بالفعل؟',
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
