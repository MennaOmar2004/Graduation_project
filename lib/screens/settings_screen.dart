import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool quietMode = false;
  final List<Map<String, dynamic>> listItems = [
    {
      "image": "assets/images/setting.png",
      "boxText": "معلومات شخصية ",
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
      "image": "assets/images/Task.png",
      "boxText": "تعديل التفضيلات",
      "boxColor": Color(0xFFFFE8F1),
      "boxShadowColor": Color(0xFFFCBAD3),
      "borderColor": Color(0xFFFCBAD3),
    },
    {
      "image": "assets/images/time.png",
      "boxText": "ضبط وقت استخدام التطبيق",
      "boxColor": Color(0xFFF3FFE3),
      "boxShadowColor": Color(0xFF72C076),
      "borderColor": Color(0xFF72C076),
    },
    {
      "image": "assets/images/time.png",
      "boxText": "وضع الهدوء وقت النوم",
      "boxColor": Color(0xFFF2DDF6),
      "boxShadowColor": Color(0xFFD66BEB),
      "borderColor": Color(0xFFD66BEB),
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
              BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
                builder: (context, state) {
                  final avatarPath =
                      state.selectedAvatar ?? "assets/images/image_profile.png";
                  return Image.asset(avatarPath, height: 150, width: 150);
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
                            // *** هنا يتم تمرير لون الخلفية ***
                            color: item["boxColor"], // استخدام المفتاح الموحد الجديد
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: item["borderColor"].withOpacity(0.7),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: item["boxShadowColor"].withOpacity(0.2),
                                offset: const Offset(0, 7),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              // منطق التنقل أو الإجراء
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (index != listItems.length - 1)
                                    Image.asset(item["image"], width: 50, height: 50),

                                  // لو آخر عنصر → Switch
                                  if (index == listItems.length - 1)
                                    Switch(
                                      value: quietMode,
                                      activeColor: Colors.blue.shade700,
                                      onChanged: (value) {
                                        setState(() {
                                          quietMode = value;
                                        });
                                      },
                                    ),
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
                padding: const EdgeInsets.only(bottom: 30,right: 20,left: 20),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color:AppColors.buttonShadow,
                        offset: const Offset(0, 6),
                        blurRadius: 0,
                        spreadRadius: 2,
                      ),
                    ]
                  ),
                  child: ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0900FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: AppColors.buttonBorder, width: 1),
                        ),
                        elevation: 0,
                        shadowColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Image.asset("assets/images/Baby_Face.png", width: 45, height: 45),
                        Text(
                            "تبديل الطفل",
                            style: AppTextStyles.buttonText.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            )
                        ),
                        ],
                      )
                  ),
                )
              ),

            ],
          )
      ),
    );
  }
}

