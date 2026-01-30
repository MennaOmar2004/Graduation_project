import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/achievements_screen.dart';
import 'package:wanisi_app/screens/options_screen.dart';

class MainLayout extends StatefulWidget {
  final int selectedIndex;
  const MainLayout({super.key, this.selectedIndex =0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
 late int selectedIndex;

  final List<Widget> _screens = [
    OptionsScreen(),
    AchievementsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex; // initialize state from widget
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: selectedIndex,
                children: _screens,
              ),
            ),

            /// Bottom Navigation
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
                        isSelected: selectedIndex == 0,
                        onTap: () {
                          setState(() => selectedIndex = 0);
                        },
                      ),
                      _NavIcon(
                        imagePath: 'assets/images/Trophy.png',
                        isSelected: selectedIndex == 1,
                        onTap: () {
                          setState(() => selectedIndex = 1);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.3 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Image.asset(imagePath, width: 70, height: 70),
          ),
          const SizedBox(height: 4), // مسافة صغيرة بين الصورة والخط
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3, // سمك الخط
            width: isSelected ? 30 : 0, // يظهر الخط فقط لو مختارة
            decoration: BoxDecoration(
              color: Colors.blue, // لون الخط
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}