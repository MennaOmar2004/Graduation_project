import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/widgets/custom_dropdown_field.dart';
import 'package:wanisi_app/screens/success_screen.dart';
import 'package:wanisi_app/screens/signup_screen.dart';

import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';
import '../cubit_of_child/child_cubit.dart';
import '../cubit_of_child/child_state.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreen();
}

class _PersonalInfoScreen extends State<PersonalInfoScreen> {
  final ageController = TextEditingController();
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final favoriteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedGender;
  int? childId;

  @override
  void dispose() {
    ageController.dispose();
    nameController.dispose();
    genderController.dispose();
    favoriteController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    loadChildId();
  }

  Future<void> loadChildId() async {
    final prefs = await SharedPreferences.getInstance();
     childId= prefs.getInt("childId");
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildCubit,ChildState>(
      listener: (context, state) {
        if (state is ChildUpdatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تعديل بيانات الطفل بنجاح")),
          );

          Navigator.pop(context); // رجوع للشاشة اللي قبلها
        }

        if (state is ChildError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                          SizedBox(height: 100,),
                          BlocBuilder<ChildCubit, ChildState>(
                            builder: (context, state) {
                              print("OPTIONS STATE = $state");
                              if (state is ChildSelectedSuccess) {
                                return Image.network(
                                  state.data.avatarUrl,
                                  height: 100,
                                  width: 100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/image_profile.png",
                                      height: 100,
                                      width: 100,
                                    );
                                  },
                                );
                              }
                              return Image.asset(
                                "assets/images/image_profile.png",
                                height: 100,
                                width: 100,
                              );
                            },
                          ),
                          const SizedBox(height: 50),
                          CustomTextFormField(
                            hint: "اسم الطفل ",
                            inputType: TextInputType.text,
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
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomDropdownField<String>(
                            hint: "الجنس",
                            value: selectedGender,
                            items: [
                              DropdownMenuItem(
                                value: 'boy',
                                alignment: Alignment.centerRight,
                                child: Text('ذكر'),
                              ),
                              DropdownMenuItem(
                                value: 'girl',
                                alignment: Alignment.centerRight,
                                child: Text('انثى'),
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
                            hint: "المفضلات",
                            controller: favoriteController,
                            inputType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الحقل فارغ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          LayeredButton(
                            text: "تعديل",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final state = context.read<ChildCubit>().state;
                                  String currentUrl = "";

                                  // سحب رابط الصورة الحالي عشان نبعته هو هو للسيرفر
                                  if (state is ChildSelectedSuccess) {
                                    currentUrl = state.data.avatarUrl;
                                  }
                                  context.read<ChildCubit>().updateChild(
                                      childId :childId!,
                                      name :nameController.text,
                                      age : int.parse(ageController.text),
                                      avatarUrl:currentUrl,
                                      preferences:favoriteController.text
                                  );
                                }
                              }
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
