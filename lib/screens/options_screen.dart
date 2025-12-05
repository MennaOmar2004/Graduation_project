import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/tasks_type_screen.dart';
import 'package:wanisi_app/screens/login2.dart';
import 'package:wanisi_app/screens/stories_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';
import 'games_screen.dart';

import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final List<Map<String, dynamic>> gridItems = [
    {
      "image": "assets/images/games.png",
      "buttonText": "العاب",
      "buttonColor": AppColors.green,
      "boxShadowColor": AppColors.green,
      "borderColor": AppColors.green,
    },
    {
      "image": "assets/images/video.png",
      "buttonText": "فيديو",
      "buttonColor": AppColors.blue_,
      "boxShadowColor": AppColors.blue_,
      "borderColor": AppColors.blue_,
    },
    {
      "image": "assets/images/stories.png",
      "buttonText": "قصص",
      "buttonColor": AppColors.purple,
      "boxShadowColor": AppColors.purple,
      "borderColor": AppColors.purple,
    },
    {
      "image": "assets/images/tasks.png",
      "buttonText": "مهام",
      "buttonColor": AppColors.red,
      "boxShadowColor": AppColors.red,
      "borderColor": AppColors.red,
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
                      ).push(MaterialPageRoute(builder: (context) => Login2()));
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
            BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
              builder: (context, state) {
                final avatarPath =
                    state.selectedAvatar ?? "assets/images/image_profile.png";
                return Image.asset(avatarPath, height: 100, width: 100);
              },
            ),
            const SizedBox(height: 5),
            Text(
              "مرحبا غادة",
              style: TextStyle(color: AppColors.blue, fontSize: 20),
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
                                  // Navigate to Games screen when "العاب" button is pressed
                                  if (gridItems[index]["buttonText"] ==
                                      "العاب") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const GamesScreen(),
                                      ),
                                    );
                                  }
                                  // Navigate to Stories screen when "قصص" button is pressed
                                  else if (gridItems[index]["buttonText"] ==
                                      "قصص") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const StoriesScreen(),
                                      ),
                                    );
                                  }
                                  else if (gridItems[index]["buttonText"] == "مهام"){
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const TasksTypeScreen(),
                                      ),
                                    );
                                  }
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
