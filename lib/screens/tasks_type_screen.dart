import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/Behavioral_tasks.dart';
import 'package:wanisi_app/screens/Religious_tasks.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/studying_tasks.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';
import 'package:wanisi_app/widgets/avatar_circle.dart';
import '../colors.dart';
import '../cubit_of_tasks/tasks_cubit.dart';
import 'home_tasks_screen.dart';
import 'main_layout_screen.dart';

class TasksTypeScreen extends StatefulWidget {
  const TasksTypeScreen({super.key});

  @override
  State<TasksTypeScreen> createState() => _TasksTypeScreenState();
}

class _TasksTypeScreenState extends State<TasksTypeScreen> {

  final List<Map<String, dynamic>> gridItems = [
    {
      "image": "assets/images/home_work.png",
      "buttonText": "مهام منزلية",
      "buttonColor": AppColors.lightGreen,
      "boxShadowColor": AppColors.lightGreen,
      "borderColor": AppColors.lightGreen,
    },
    {
      "image": "assets/images/study.png",
      "buttonText": "مهام دراسية",
      "buttonColor": AppColors.lightBlue,
      "boxShadowColor": AppColors.lightBlue,
      "borderColor": AppColors.lightBlue,
    },
    {
      "image": "assets/images/behavior.png",
      "buttonText": "مهام سلوكية",
      "buttonColor": AppColors.lightPurple,
      "boxShadowColor": AppColors.lightPurple,
      "borderColor": AppColors.lightPurple,
    },
    {
      "image": "assets/images/pray.png",
      "buttonText": "مهام دينية",
      "buttonColor": AppColors.lightPink,
      "boxShadowColor": AppColors.lightPink,
      "borderColor": AppColors.lightPink,
    },
  ];

  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<TasksCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TasksCubit>();

    final progress = cubit.totalTasks == 0
        ? 0.0
        : cubit.totalDone / cubit.totalTasks;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 16),

            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                  AvatarCircle(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    'مهام ونيسي',
                    style: AppTextStyles.linkText.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        'نقاطك',
                        style: AppTextStyles.linkText.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const ScoreIndicator(score: '70'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// PROGRESS
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Glowing Star.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "${cubit.totalDone}/${cubit.totalTasks}",
                      style: AppTextStyles.numberText.copyWith(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10),

                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, _) {
                    return Center(
                      child: SizedBox(
                        width: 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 9,
                            backgroundColor: Colors.grey.shade300,
                            color: const Color(0xFF69D66E),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// GRID
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: gridItems.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) {
                    final category = gridItems[index]["buttonText"];

                    final done =
                        cubit.completedByCategory[category] ?? 0;
                    final total =
                        cubit.totalByCategory[category] ?? 0;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: gridItems[index]["borderColor"].withOpacity(
                            .2,
                          ),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gridItems[index]["boxShadowColor"]
                                .withOpacity(0.2),
                            offset: const Offset(0, 7),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),

                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Image.asset(
                              gridItems[index]["image"],
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("$done/$total"),
                              SizedBox(width: 5,),
                              Image.asset(
                                'assets/images/Checked Checkbox.png',
                                width: 25,
                                height: 25,
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: gridItems[index]["boxShadowColor"]
                                        .withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 0,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  gridItems[index]["buttonColor"],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: AppColors.buttonBorder,
                                      width: 1,
                                    ),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                ),
                                onPressed: () {
                                  if (category == "مهام منزلية") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const HomeTasksScreen(),
                                      ),
                                    );
                                  } else if (category == "مهام دراسية") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const StudyingTasks(),
                                      ),
                                    );
                                  } else if (category == "مهام سلوكية") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const BehavioralTasks(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const ReligiousTasks(),
                                      ),
                                    );
                                  }
                                },
                                child: Text(category,style: AppTextStyles.buttonText,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            /// BOTTOM NAV
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
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const MainLayout(selectedIndex: 0),
                            ),
                                (route) => false,
                          );
                        },
                      ),
                      _NavIcon(
                        imagePath: 'assets/images/Trophy.png',
                        isSelected: _selectedIndex == 1,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const MainLayout(selectedIndex: 1),
                            ),
                                (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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