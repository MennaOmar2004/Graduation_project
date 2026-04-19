import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanisi_app/screens/main_layout_screen.dart';
import '../../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../../blocs/avatar_selection/avatar_selection_state.dart';
import '../../static/app_assets.dart';
import '../../colors.dart';
import '../take_photo_screen.dart';
import 'widgets/avatar_grid_item.dart';
import 'widgets/layered_button.dart';
import '../options_screen.dart';

/// Avatar selection screen - allows user to choose their profile avatar
class AvatarSelectionScreen extends StatelessWidget {
  const AvatarSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AvatarSelectionView();
  }
}

class _AvatarSelectionView extends StatelessWidget {
  const _AvatarSelectionView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Logo
            Image.asset(AppAssets.smallIcon, height: 100),
            const SizedBox(height: 16),

            const SizedBox(height: 24),
            // First Button: "انشئ صورتك"
            LayeredButton(
              backgroundColor: AppColors.pink,
              shadowColor:AppColors.pink2 ,
              text: 'انشئ صورتك',
              image:"assets/images/Camera.png",
              width:200 ,
              onPressed: () {
                // TODO: Navigate to create your image screen
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TakePhotoScreen(),));
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(
                //     content: Text(
                //       'انشئ صورتك - قريباً',
                //       style: AppTextStyles.snackbarText,
                //     ),
                //     duration: const Duration(seconds: 2),
                //   ),
                // );
              },
            ),
            const SizedBox(height: 30),

            Text('اختيار صورتك الشخصية', style: AppTextStyles.linkText),
            const SizedBox(height: 20),
            // Avatar Grid with Background extending to edges
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<
                        AvatarSelectionCubit,
                        AvatarSelectionState
                      >(
                        builder: (context, state) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1,
                                ),
                            itemCount: AppAssets.allAvatars.length,
                            itemBuilder: (context, index) {
                              final avatarPath = AppAssets.allAvatars[index];
                              final isSelected =
                                  state.selectedAvatar == avatarPath;

                              return AvatarGridItem(
                                avatarPath: avatarPath,
                                isSelected: isSelected,
                                onTap: () {
                                  context
                                      .read<AvatarSelectionCubit>()
                                      .selectAvatar(avatarPath);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Confirm Button: "تأكيد"
                    BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
                      builder: (context, state) {
                        return LayeredButton(
                          text: 'تأكيد',
                          showShadow: state.selectedAvatar != null,
                          onPressed:
                              state.selectedAvatar != null
                                  ? () {
                                    context
                                        .read<AvatarSelectionCubit>()
                                        .confirmSelection();
                                    // Navigate to options screen
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder:
                                            (context) => MainLayout(selectedIndex: 0,),
                                      ),
                                    );
                                  }
                                  : null,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
