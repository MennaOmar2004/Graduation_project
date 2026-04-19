import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/options_screen.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';
import 'package:wanisi_app/widgets/back_ground_widget.dart';

import '../colors.dart';
import '../widgets/avatar_circle.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final List<Map<String, dynamic>> gridItems1 = [
    {
      "image": "assets/images/medal 1.png",
      "buttonColor": Color(0xFFFFF1A8),
      "boxShadowColor":  Color(0xFFFFF1A8),
      "borderColor":  Color(0xFFFFF1A8),
    },
    {
      "image": "assets/images/medal 2.png",
      "buttonColor": Color(0xFFFFF1A8),
      "boxShadowColor":  Color(0xFFFFF1A8),
      "borderColor":  Color(0xFFFFF1A8),
    },
    {
      "image": "assets/images/medal 3.png",
      "buttonColor": Color(0xFFFFF1A8),
      "boxShadowColor":  Color(0xFFFFF1A8),
      "borderColor":  Color(0xFFFFF1A8),
    },
    {
      "image": "assets/images/medal 1 (1).png",
      "buttonColor": Color(0xFFFFF1A8),
      "boxShadowColor":  Color(0xFFFFF1A8),
      "borderColor":  Color(0xFFFFF1A8),
    },
    {
      "image": "assets/images/medal 2 (1).png",
      "buttonColor": Color(0xFFFFF1A8),
      "boxShadowColor":  Color(0xFFFFF1A8),
      "borderColor":  Color(0xFFFFF1A8),
    },
    {
      "image": "assets/images/medal 3 (1).png",
      "buttonColor": Color(0xFFFFF1A8),
      "boxShadowColor":  Color(0xFFFFF1A8),
      "borderColor":  Color(0xFFFFF1A8),
    },
  ];
  // int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
          child: Stack(
            children:[
              BackGroundWidget(),
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                // IconButton(
                                //   onPressed: () {
                                //     Navigator.of(context).pop();
                                //   },
                                //   icon: const Icon(Icons.arrow_back_ios_new),
                                // ),
                                AvatarCircle(onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => SettingsScreen(),));
                                },),
                                const Spacer(),
                                // Title
                                Text(
                                  'مقتنياتك',
                                  style: AppTextStyles.numberText.copyWith(
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
                          const SizedBox(height: 20),
                          Divider(
                            height: 20,        // المسافة الرأسية حوالين الخط
                            thickness: 1,      // سمك الخط
                            indent: 50,        // مسافة من الشمال
                            endIndent: 50,     // مسافة من اليمين
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'مجموع نقاطك في الالعاب : 1000 ',
                            style: AppTextStyles.numberText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(25),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:gridItems1.length ,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
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
                                      color: gridItems1[index]["borderColor"],
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: gridItems1[index]["boxShadowColor"],
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
                                            gridItems1[index]["image"],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 10,),
                          Divider(
                            height: 20,        // المسافة الرأسية حوالين الخط
                            thickness: 1,      // سمك الخط
                            indent: 50,        // مسافة من الشمال
                            endIndent: 50,     // مسافة من اليمين
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'مجموع نقاطك في القصص : 1000  ',
                            style: AppTextStyles.numberText.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(25),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:gridItems1.length ,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
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
                                      color: gridItems1[index]["borderColor"],
                                      width: 1.2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: gridItems1[index]["boxShadowColor"],
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
                                            gridItems1[index]["image"],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Stack(
                  //   alignment: Alignment.bottomCenter,
                  //   children: [
                  //     Image.asset(
                  //       'assets/images/bottom.png',
                  //       width: double.infinity,
                  //       fit: BoxFit.cover,
                  //     ),
                  //     Positioned(
                  //       bottom: 20,
                  //       left: 0,
                  //       right: 0,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           _NavIcon(
                  //             imagePath: 'assets/images/Home.png',
                  //             isSelected: _selectedIndex == 0,
                  //             onTap: () {
                  //               Navigator.pushReplacement(
                  //                 context,
                  //                 MaterialPageRoute(builder: (context) => OptionsScreen()),
                  //               );
                  //             },
                  //           ),
                  //           _NavIcon(
                  //             imagePath: 'assets/images/Trophy.png',
                  //             isSelected: _selectedIndex == 1,
                  //             onTap: () {
                  //               Navigator.pushReplacement(
                  //                 context,
                  //                 MaterialPageRoute(builder: (context) => AchievementsScreen()),
                  //               );
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ]
          ),

      ),
    );
  }
}
// class _NavIcon extends StatelessWidget {
//   final String imagePath;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _NavIcon({
//     required this.imagePath,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedScale(
//         scale: isSelected ? 1.3 : 1.0,
//         duration: const Duration(milliseconds: 200),
//         child: Image.asset(imagePath, width: 70, height: 70),
//       ),
//     );
//   }
// }
