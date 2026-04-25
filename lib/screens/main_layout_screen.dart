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

  // ... داخل كلاس _NavIcon المعدل ...

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // إضافة padding عشان منطقة الضغط تبقى أكبر وأسهل
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 0.9, // تصغير بسيط لغير المختار
              duration: const Duration(milliseconds: 200),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.6, // بهتان بسيط لغير المختار بيدي شكل شيك
                child: Image.asset(
                  imagePath,
                  width: 60, // تصغير العرض لـ 60 عشان الـ 3 أيقونات يرتاحوا بجانب بعض
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isSelected ? 25 : 0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
                // إضافة توهج بسيط للخط بيدي لمسة جمالية
                boxShadow: isSelected ? [
                  BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 4)
                ] : [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}