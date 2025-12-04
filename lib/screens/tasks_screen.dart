import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/options_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';

import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';
import 'login2.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final List<Map<String, dynamic>> gridItems = [
    {
      "image": "assets/images/home_work.png",
      "buttonText": "مهام منزلية",
      "buttonColor": AppColors.lightGreen,
      "boxShadowColor": AppColors.lightGreen,
      "borderColor": AppColors.lightGreen,
      "text":"2/4"
    },
    {
      "image": "assets/images/study.png",
      "buttonText": "مهام دراسية",
      "buttonColor": AppColors.lightBlue,
      "boxShadowColor": AppColors.lightBlue,
      "borderColor": AppColors.lightBlue,
      "text":"3/5"
    },
    {
      "image": "assets/images/behavior.png",
      "buttonText": "مهام سلوكية",
      "buttonColor": AppColors.lightPurple,
      "boxShadowColor": AppColors.lightPurple,
      "borderColor": AppColors.lightPurple,
      "text":"6/10"
    },
    {
      "image": "assets/images/pray.png",
      "buttonText": "مهام دينيه",
      "buttonColor": AppColors.lightPink,
      "boxShadowColor": AppColors.lightPink,
      "borderColor": AppColors.lightPink,
      "text":"5/7"
    },
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => OptionsScreen()));
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'مهام ونيسي',
                  style: AppTextStyles.linkText.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/Glowing Star.png',
                          width: 40,
                          height: 40,
                        ),
                        Text("20/30",style: AppTextStyles.numberText.copyWith(color:Colors.grey,fontSize: 20),)
                      ]
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: .7,          // Progress 25%
                        minHeight: 9,
                        backgroundColor: Colors.grey.shade300,
                        color: Color(0xFF69D66E) ,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: gridItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.80,
                  ),
                  itemBuilder: (context, index) {
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                gridItems[index]["image"],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(gridItems[index]["text"]),
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
                                onPressed: () {
                                  // // Navigate to Games screen when "العاب" button is pressed
                                  // if (gridItems[index]["buttonText"] ==
                                  //     "العاب") {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder:
                                  //           (context) => const GamesScreen(),
                                  //     ),
                                  //   );
                                  // }
                                  // // Navigate to Stories screen when "قصص" button is pressed
                                  // else if (gridItems[index]["buttonText"] ==
                                  //     "قصص") {
                                  //   Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //       builder:
                                  //           (context) => const StoriesScreen(),
                                  //     ),
                                  //   );
                                  // }
                                },
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
                                child: Text(
                                  gridItems[index]["buttonText"],
                                  style: AppTextStyles.buttonText,
                                ),
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
            const SizedBox(height: 20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        imagePath: 'assets/images/Messaging.png',
                        isSelected: _selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                      _NavIcon(
                        imagePath: 'assets/images/Trophy.png',
                        isSelected: _selectedIndex == 2,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
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