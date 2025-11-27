import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/login2.dart';
import 'package:wanisi_app/screens/stories_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';

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
    },
    {
      "image": "assets/images/video.png",
      "buttonText": "فيديو",
      "buttonColor": AppColors.blue_,
    },
    {
      "image": "assets/images/stories.png",
      "buttonText": "قصص",
      "buttonColor": AppColors.purple,
    },
    {
      "image": "assets/images/tasks.png",
      "buttonText": "مهام",
      "buttonColor": AppColors.red,
    },
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: ConvexAppBar(
      //   onTap: (value) {
      //     setState(() {
      //       currentIndex = value;
      //     });
      //   },
      //   style: TabStyle.reactCircle,
      //   height: 60,
      //   backgroundColor: Colors.blue.shade100,
      //   color: Colors.grey,
      //
      //   // activeColor:Colors.grey ,
      //   curveSize: 90,
      //   top: -15,
      //   items: [
      //     TabItem(
      //       icon: Image.asset("assets/images/Home.png", height: 60),
      //       title: "",
      //     ),
      //     TabItem(
      //       icon: Image.asset("assets/images/Messaging.png", height: 60),
      //       title: "",
      //     ),
      //     TabItem(
      //       icon: Image.asset("assets/images/Trophy.png", height: 60),
      //       title: "",
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
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
            BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
              builder: (context, state) {
                final avatarPath = state.selectedAvatar ?? "assets/images/image_profile.png";
                return Image.asset(
                  avatarPath,
                  height: 100,
                  width: 100,
                );
              },
            ),
            const SizedBox(height: 5),
            Text(
              "مرحبا غادة",
              style: TextStyle(color: AppColors.blue, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
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
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Stories screen when "قصص" button is pressed
                              if (gridItems[index]["buttonText"] == "قصص") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const StoriesScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  gridItems[index]["buttonColor"],
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              gridItems[index]["buttonText"],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Bottom background image
                Image.asset(
                  'assets/images/bottom.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Navigation icons
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Home icon
                      _NavIcon(
                        imagePath: 'assets/images/Home.png',
                        isSelected: _selectedIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      // Messaging icon
                      _NavIcon(
                        imagePath: 'assets/images/Messaging.png',
                        isSelected: _selectedIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        },
                      ),
                      // Trophy icon
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