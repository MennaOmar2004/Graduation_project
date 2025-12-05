import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';

import '../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../blocs/avatar_selection/avatar_selection_state.dart';
import '../colors.dart';

class HomeTasksScreen extends StatefulWidget {
  const HomeTasksScreen({super.key});

  @override
  State<HomeTasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<HomeTasksScreen> {
  // final List<Map<String, dynamic>> gridItems = [
  //   {
  //     "image": "assets/images/home_work.png",
  //     "buttonText": "مهام منزلية",
  //     "buttonColor": AppColors.lightGreen,
  //     "boxShadowColor": AppColors.lightGreen,
  //     "borderColor": AppColors.lightGreen,
  //     "text":"2/4"
  //   },
  //   {
  //     "image": "assets/images/study.png",
  //     "buttonText": "مهام دراسية",
  //     "buttonColor": AppColors.lightBlue,
  //     "boxShadowColor": AppColors.lightBlue,
  //     "borderColor": AppColors.lightBlue,
  //     "text":"3/5"
  //   },
  //   {
  //     "image": "assets/images/behavior.png",
  //     "buttonText": "مهام سلوكية",
  //     "buttonColor": AppColors.lightPurple,
  //     "boxShadowColor": AppColors.lightPurple,
  //     "borderColor": AppColors.lightPurple,
  //     "text":"6/10"
  //   },
  //   {
  //     "image": "assets/images/pray.png",
  //     "buttonText": "مهام دينيه",
  //     "buttonColor": AppColors.lightPink,
  //     "boxShadowColor": AppColors.lightPink,
  //     "borderColor": AppColors.lightPink,
  //     "text":"5/7"
  //   },
  // ];
  int _selectedIndex = 0;
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
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.purple, width: 3),
                        ),
                        child: BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
                          builder: (context, state) {
                            final avatarPath = state.selectedAvatar ?? "assets/images/image_profile.png";
                            return ClipOval(
                              child: Image.asset(
                                avatarPath,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                        // child: ClipOval(
                        //   child: Image.asset(
                        //     'assets/images/avatars/avatar_1.png', // Default avatar
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                      ),
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


            ],
          )
      ),
    );
  }
}
