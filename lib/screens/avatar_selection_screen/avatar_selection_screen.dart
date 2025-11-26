import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/avatar_selection/avatar_selection_cubit.dart';
import '../../blocs/avatar_selection/avatar_selection_state.dart';
import '../../static/app_assets.dart';
import 'widgets/avatar_grid_item.dart';

/// Avatar selection screen - allows user to choose their profile avatar
class AvatarSelectionScreen extends StatelessWidget {
  const AvatarSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvatarSelectionCubit(),
      child: const _AvatarSelectionView(),
    );
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
            Image.asset(AppAssets.smallIcon, height: 80),
            const SizedBox(height: 16),
            // App Name "ونيسي"
            Text(
              'ونيسي',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 24),
            // First Button: "انشئ صورتك"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to create your image screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'انشئ صورتك - قريباً',
                          style: GoogleFonts.cairo(),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'انشئ صورتك',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Second Text/Link: "اختيار صورتك الشخصية"
            Text(
              'اختيار صورتك الشخصية',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 20),
            // Avatar Grid
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6EAF8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
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
                        final isSelected = state.selectedAvatar == avatarPath;

                        return AvatarGridItem(
                          avatarPath: avatarPath,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<AvatarSelectionCubit>().selectAvatar(
                              avatarPath,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Confirm Button: "تأكيد"
            BlocBuilder<AvatarSelectionCubit, AvatarSelectionState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          state.selectedAvatar != null
                              ? () {
                                context
                                    .read<AvatarSelectionCubit>()
                                    .confirmSelection();
                                // TODO: Navigate to next screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تم اختيار الصورة بنجاح',
                                      style: GoogleFonts.cairo(),
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        disabledBackgroundColor: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        'تأكيد',
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
