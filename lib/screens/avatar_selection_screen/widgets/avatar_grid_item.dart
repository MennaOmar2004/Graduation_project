import 'package:flutter/material.dart';

/// Individual avatar item in the grid
class AvatarGridItem extends StatelessWidget {
  final String avatarPath;
  final bool isSelected;
  final VoidCallback onTap;

  const AvatarGridItem({
    super.key,
    required this.avatarPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFA1C4) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),

        child: ClipOval(child: Image.asset(avatarPath, fit: BoxFit.cover)),
      ),
    );
  }
}
