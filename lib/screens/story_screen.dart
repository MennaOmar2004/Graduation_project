import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:wanisi_app/screens/achievements_screen.dart';
import 'package:wanisi_app/screens/settings_screen.dart';
import 'package:wanisi_app/screens/widgets/score_indicator.dart';

import '../colors.dart';
import '../widgets/avatar_circle.dart';
import '../widgets/back_ground_widget.dart';
import 'main_layout_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final int _selectedIndex = 0;

  void _showSuccessSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // مهم جداً عشان الحواف والبطريق
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none, // عشان يسمح للبطريق يخرج برا حدود الحاوية
          children: [
            // 1. الحاوية البيضاء الرئيسية (الـ Card)
            Container(
              margin: EdgeInsets.only(top: 50), // مساحة للبطريق فوق
              padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFF1F9FF), // لون الخلفية اللبني الفاتح من الصورة
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'لقد اتممت قراءة القصة',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  SizedBox(height: 15),
                  // جزء النقاط الذهبية
                  IntrinsicWidth(
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFEEB),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFF149).withOpacity(0.7),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XFFFFCF35).withOpacity(0.2),
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // ⭐ مهم جدًا
                          children: [
                            Image.asset(
                              "assets/images/Glowing Star.png",
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "+20",
                              style: AppTextStyles.buttonText.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'مجموع نقاطك في القصص : 1000',
                    style: AppTextStyles.numberText.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2.0),    // الإزاحة: 0 بالعرض و 3 لتحت (نفس اللي في فيجما)
                          blurRadius: 4.0,           // درجة التمويه (كل ما زادت بيبقى الضل ناعم زي الصورة)
                          color: Colors.black.withOpacity(0.3),

                        )
                      ]
                    ),
                  ),
                  SizedBox(height: 20),
                  // زرار رؤية الانجازات
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0XFFD98399).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AchievementsScreen(),));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFFCBAD3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: AppColors.buttonBorder,
                              width: 1,
                            ),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/Trophy.png",height: 50,width: 50,),
                            Text("رؤية الانجازات",
                              style: AppTextStyles.buttonText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // IntrinsicWidth(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(10),
                  //     child: ElevatedButton(
                  //       onPressed: () {},
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Color(0XFFD98399),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //           side: const BorderSide(
                  //             color: AppColors.buttonBorder,
                  //             width: 1,
                  //           ),
                  //         ),
                  //         elevation: 0,
                  //         shadowColor: Colors.transparent,
                  //         padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Image.asset("assets/images/Trophy.png",height: 50,width: 50,),
                  //           SizedBox(width: 5,),
                  //           Text("رؤية الانجازات",
                  //             style: AppTextStyles.buttonText,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // 2. صورة البطريق (البروز)
            Positioned(
              top: 0, // يبدأ من أعلى الـ Stack
              child: Image.asset(
                'assets/images/bingoin.png',
                height: 125, // تحكمي في مقاسه بحيث يبرز لفوق
              ),
            ),
            // 3. زرار الإغلاق (X)
            Positioned(
              top: 70,
              right: 30,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child:Image.asset("assets/images/grey_Close.png",width: 35,height: 35,) ,
              ),
            ),
            // داخل الـ Stack بتاع الـ BottomSheet
            Positioned(
              top: -100, // عشان ينزل من فوق الكارت والبطريق
              left: MediaQuery.of(context).size.width / 2, // دي الخدعة! بنحدد نص عرض الشاشة بالظبط
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive, // انفجار في كل الاتجاهات
                shouldLoop: false,
                colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
                numberOfParticles: 40,
                gravity: 0.1,
                // ضيفي دول عشان نضمن إن الورق ما يحدفش شمال
                blastDirection: 3.14 / 2, // يوجه الانفجار للأسفل (90 درجة بالراديان)
                maxBlastForce: 15,
                minBlastForce: 5,
              ),
            ),
          ],
        );
      },
    );
  }

  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer(); // تعريف مشغل الصوت
  @override
  void initState() {
    super.initState();
    // بنحدد مدة طيران الورق (مثلاً 3 ثواني)
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // تحميل ملف الصوت مسبقاً (Preload)
    _audioPlayer.setSource(AssetSource('sounds/tada.mp3'));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _audioPlayer.dispose();// مهم جداً عشان ما يستهلكش رام
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
          child: Stack(
            children: [
              BackGroundWidget(),
              Column(
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
                        AvatarCircle(onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SettingsScreen(),));
                        },
                        ),
                        const Spacer(),
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
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      width: double.infinity,
                      height:  500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Color(0xFFD98399),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:  Color(0xFFD98399),
                            offset: const Offset(0, 7),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  'قصة غاده والارنب',
                                  style: AppTextStyles.numberText.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: (){},
                                        child: Image.asset("assets/images/Sound.png",width: 40,height: 40,),
                                      ),
                                      Text(
                                        'استماع',
                                        style: AppTextStyles.numberText.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              width: 130,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0XFFD98399).withOpacity(0.3),
                                    offset: const Offset(0, 4),
                                    blurRadius: 0,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // 1. تشغيل الصوت فوراً
                                  await _audioPlayer.play(AssetSource('sounds/tada.mp3'));
                                  _confettiController.play();
                                  _showSuccessSheet(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0XFFD98399),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                      color: AppColors.buttonBorder,
                                      width: 1,
                                    ),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                ),
                                child: Text("انتهاء",
                                  style: AppTextStyles.buttonText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Stack(
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
                                isSelected: _selectedIndex == 0,
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainLayout(selectedIndex: 0,),
                                    ),
                                        (route) => false,
                                  );
                                },
                              ),
                              _NavIcon(
                                imagePath: 'assets/images/Trophy.png',
                                isSelected: _selectedIndex == 1,
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const MainLayout(selectedIndex: 1,),
                                    ),
                                        (route) => false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]
          )
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