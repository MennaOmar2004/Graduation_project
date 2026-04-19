import 'package:flutter/cupertino.dart';

class BackGroundWidget extends StatelessWidget {
  const BackGroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        // 🌿 نباتات + زهور (أعلى يسار)
        Positioned(
          top: 120,
          left: -10,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/bg4.png',
              width: 50,
            ),
          ),
        ),

        // 🐦 الطائر (أعلى يمين)
        Positioned(
          top: 90,
          right: -5,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/bg3.png',
              width: 55,
            ),
          ),
        ),

        // 🌸 زهور جانبية (منتصف الشاشة)
        Positioned(
          top: 320,
          right: -15,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/bg2.png',
              width: 50,
            ),
          ),
        ),
        // 🌱 نباتات أسفل الشاشة
        Positioned(
          bottom: 120,
          left: -10,
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/bg1.png',
              width: 50,
            ),
          ),
        ),
      ],
    );
  }

}
