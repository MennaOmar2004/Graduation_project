import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/widgets/layered_button.dart';
import 'package:wanisi_app/widgets/custom_text_form_field.dart';
import 'package:wanisi_app/widgets/custom_dropdown_field.dart';
import 'package:wanisi_app/screens/success_screen.dart';
import 'package:wanisi_app/screens/signup_screen.dart';

import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';

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

  @override
  void dispose() {
    ageController.dispose();
    nameController.dispose();
    genderController.dispose();
    favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
                    builder: (context, state) {
                      final avatarPath =
                          state.selectedAvatar ?? "assets/images/image_profile.png";
                      return Image.asset(avatarPath, height: 150, width: 150);
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
                        return 'الرجاء اختيار الدولة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    hint: "المفضلات",
                    controller: favoriteController,
                    inputType: TextInputType.text,
                    obscure: true,
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
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
