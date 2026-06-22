import 'package:flutter/material.dart';
import 'package:wanisi_app/configs/app_colors.dart';
import 'package:wanisi_app/configs/app_text_styles.dart';
import 'package:wanisi_app/configs/app_spacing.dart';
import '_mic_button.dart';

/// Card containing the Ayah input text field and the speech microphone controls.
class TajweedInputCard extends StatelessWidget {
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final bool isListening;
  final Animation<double> pulseAnimation;
  final VoidCallback onMicTap;

  const TajweedInputCard({
    super.key,
    required this.controller,
    required this.formKey,
    required this.isListening,
    required this.pulseAnimation,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue_.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Label row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'اكتب الآية أو استخدم الميكروفون',
                style: AppTextStyles.linkText.copyWith(
                  fontSize: 14,
                  color: AppColors.blue_,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.blue_,
                  size: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // TextField + Mic button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mic button
              TajweedMicButton(
                isListening: isListening,
                pulseAnimation: pulseAnimation,
                onTap: onMicTap,
              ),
              const SizedBox(width: 12),
              // Text field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  minLines: 2,
                  style: AppTextStyles.linkText.copyWith(
                    fontSize: 18,
                    color: const Color(0xFF2D2D5E),
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء إدخال آية';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'مثال: قُلْ هُوَ اللَّهُ أَحَدٌ',
                    hintStyle: AppTextStyles.linkText.copyWith(
                      fontSize: 15,
                      color: Colors.grey.shade400,
                    ),
                    hintTextDirection: TextDirection.rtl,
                    filled: true,
                    fillColor: const Color(0xFFF5F7FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.blue_,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isListening) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'جارٍ الاستماع...',
                        style: AppTextStyles.snackbarText.copyWith(
                          color: Colors.redAccent,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
