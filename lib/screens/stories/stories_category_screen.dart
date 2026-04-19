import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wanisi_app/colors.dart';
import 'package:wanisi_app/screens/stories/stories_list_screen.dart';
import 'package:wanisi_app/widgets/back_ground_widget.dart';

class StoriesCategoryScreen extends StatelessWidget {
  const StoriesCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const BackGroundWidget(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                Text(
                  'قصص ونيسي',
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    children: [
                      _CategoryCard(
                        title: 'قصص تربوية',
                        image: 'assets/images/first_bunny.png',
                        color: AppColors.purple,
                        onTap: () => _onCategoryTap(context, 'قصص تربوية'),
                      ),
                      const SizedBox(height: 30),
                      _CategoryCard(
                        title: 'قصص دينية',
                        image: 'assets/images/secound_bunny.png', // noted spelling
                        color: AppColors.blue,
                        onTap: () => _onCategoryTap(context, 'قصص دينية'),
                      ),
                      const SizedBox(height: 30),
                      _CategoryCard(
                        title: 'قصص تعليمية',
                        image: 'assets/images/third_bunny.png',
                        color: AppColors.green,
                        onTap: () => _onCategoryTap(context, 'قصص تعليمية'),
                      ),
                      const SizedBox(height: 20), // Standard bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey[400]),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blue, width: 2),
            ),
            padding: const EdgeInsets.all(2),
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/person1.png'),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'نقاطك',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.pink, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/images/star.png', width: 20),
                    const SizedBox(width: 4),
                    Text(
                      '70',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  void _onCategoryTap(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoriesListScreen(category: category),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String image;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.image,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(image),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
