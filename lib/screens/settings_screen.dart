import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/cubit_of_child/child_cubit.dart';
import 'package:wanisi_app/screens/avatar_selection_screen/avatar_selection_screen.dart';
import 'package:wanisi_app/screens/personal_info_screen.dart';
import 'package:wanisi_app/screens/select_child_screen.dart';
import 'package:wanisi_app/screens/signup_screen.dart';
import '../colors.dart';
import '../cubit_of_child/child_state.dart';
import '../model_of_child/child.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Map<String, dynamic>> listItems = [
    {
      "image": "assets/images/setting.png",
      "boxText": "معلومات شخصية",
      "boxColor": Color(0xFFEAF9FF),
      "boxShadowColor": Color(0xFF3396FF),
      "borderColor": Color(0xFF3396FF),
    },
    {
      "image": "assets/images/Camera.png",
      "boxText": "تعديل الصورة الشخصية",
      "boxColor": Color(0xFFFFFEEB),
      "boxShadowColor": Color(0xFFFFF133),
      "borderColor": Color(0xFFFFF133),
    },
    {
      "image": "assets/images/time.png",
      "boxText": "ضبط وقت استخدام التطبيق",
      "boxColor": Color(0xFFF3FFE3),
      "boxShadowColor": Color(0xFF72C076),
      "borderColor": Color(0xFF72C076),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('الإعدادات',
          style: AppTextStyles.buttonText.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF9D9D9D),
            fontSize: 23
          ),
          textAlign: TextAlign.right,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color:  Color(0xFF9D9D9D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 30,),
              BlocBuilder<ChildCubit, ChildState>(
                builder: (context, state) {
                  final child = context.select<ChildCubit,Child?>((cubit) {
                    final state = cubit.state;
                    if (state is ChildSelectedSuccess) return state.data;
                    return null;
                  });

                  final url = child?.avatarUrl;
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.pink2, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pink2.withValues(alpha: 0.35),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: url != null
                          ? Image.network(
                              url,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/image_profile.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/image_profile.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50,),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 20),
                      itemCount: listItems.length,
                      itemBuilder: (context, index) {
                        final item = listItems[index];
                        return Container(
                          width:double.infinity ,
                          height: 55,
                          decoration: BoxDecoration(
                            // *** هنا يتم تمرير لون خلفية ***
                            color: item["boxColor"], // استخدام المفتاح الموحد الجديد
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: item["borderColor"].withValues(alpha: 0.7),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: item["boxShadowColor"].withValues(alpha: 0.2),
                                offset: const Offset(0, 7),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if(listItems[index]["boxText"]=="معلومات شخصية"){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => PersonalInfoScreen()));
                              }
                              if(listItems[index]["boxText"]=="تعديل الصورة الشخصية"){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => AvatarSelectionScreen(mode: AvatarMode.edit)));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(item["image"], width: 50, height: 50),
                                  Expanded(
                                    child: Text(
                                      item["boxText"],
                                      style: AppTextStyles.buttonText.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9D9D9D)
                                      ),
                                      textAlign: TextAlign.right,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
                child: Row(
                  children: [
                    // الزر الأول: تبديل الطفل
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.buttonShadow,
                              offset: const Offset(0, 6),
                              blurRadius: 0,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SelectChildScreen(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF91D6F0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: AppColors.buttonBorder, width: 1),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // لجعل المحتوى في المنتصف
                            children: [
                              Image.asset("assets/images/Baby_Face.png", width: 30, height: 30),
                              const SizedBox(width: 8),
                              Flexible( // حماية النص من الخروج عن الإطار في الشاشات الصغيرة
                                child: Text(
                                  "تبديل الطفل",
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17, // تأكد من تناسق الخط
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15), // مسافة بين الزرين

                    // الزر الثاني: إضافة طفل
                    Expanded(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.buttonShadow,
                              offset: const Offset(0, 6),
                              blurRadius: 0,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0900FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: AppColors.buttonBorder, width: 1),
                            ),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: Center(
                            child: Text(
                              "+   اضافة طفل",
                              style: AppTextStyles.buttonText.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          )
      ),
    );
  }
}

