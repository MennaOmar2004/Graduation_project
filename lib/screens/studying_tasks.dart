import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';

import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';
import '../widgets/avatar_circle.dart';

class StudyingTasks extends StatefulWidget {
  const StudyingTasks({super.key});

  @override
  State<StudyingTasks> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<StudyingTasks> {
  final List<Map<String, dynamic>> listItems = [
    {
      "image":"assets/images/check_box.png",
      "boxText": "انجزت واجبي المنزلي",
      "boxColor": Color(0xDDFFFEEB),
      "boxShadowColor": Color(0xFFFFF133),
      "borderColor":  Color(0xFFFFF133)
    },
    {
      "image":"assets/images/empty_box.png",
      "boxText": "قرأت القران",
      "boxColor": Color(0xFFFFE8F1),
      "boxShadowColor": Color(0xFFFCBAD3),
      "borderColor": Color(0xFFFCBAD3),
    },
    {
      "image":"assets/images/empty_box.png",
      "boxText": "انجزت واجبي المنزلي",
      "boxColor": Color(0xFFF3FFE3),
      "boxShadowColor": Color(0xFF72C076),
      "borderColor": Color(0xFF72C076),
    },
    {
      "image":"assets/images/empty_box.png",
      "boxText": "انجزت واجبي المنزلي",
      "boxColor": Color(0xFFF2DDF6),
      "boxShadowColor": Color(0xFFD66BEB),
      "borderColor": Color(0xFFD66BEB),
    },
    {
      "image":"assets/images/empty_box.png",
      "boxText": "انجزت واجبي المنزلي",
      "boxColor": Color(0xFFF6EADD),
      "boxShadowColor": Color(0xFFEBB46B),
      "borderColor": Color(0xFFEBB46B),
    },
  ];
  late List<bool> checkedList;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    checkedList = List.generate(listItems.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                    AvatarCircle(onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SettingsScreen(),));
                    },
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      'مهام وانيسي',
                      style: AppTextStyles.linkText.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Score section with label
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'نقاطك',
                          style: AppTextStyles.linkText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const ScoreIndicator(score: '70'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100,),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      checkedList[index] = !checkedList[index];
                                    });
                                  },
                                  child: Image.asset(
                                    checkedList[index]
                                        ? "assets/images/Checked Checkbox.png"
                                        : "assets/images/empty_box.png",
                                    width: 40,
                                    height: 40,
                                  ),
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
                        );
                      },
                    ),
                  )
              ),
              SizedBox(height: 50),
              IntrinsicWidth(
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFEEB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFFF133).withOpacity(0.7),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFF133).withOpacity(0.2),
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // ⭐ مهم جدًا
                      children: [
                        Image.asset(
                          "assets/images/Glowing Star.png",
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "+20",
                          style: AppTextStyles.buttonText.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Image.asset(
                    'assets/images/bottom.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavIcon(
                          imagePath: 'assets/images/Home.png',
                          isSelected: _selectedIndex == 0,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                        ),
                        _NavIcon(
                          imagePath: 'assets/images/Trophy.png',
                          isSelected: _selectedIndex == 1,
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
}
class _NavIcon extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Image.asset(imagePath, width: 70, height: 70),
      ),
    );
  }
}
