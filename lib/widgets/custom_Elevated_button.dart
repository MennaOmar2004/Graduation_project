import 'package:flutter/material.dart';


class CustomElevatedButton extends StatelessWidget {
  final Color buttonBackground;
  final String buttonText;
  final String? image;
  final VoidCallback onPressed;
  const CustomElevatedButton({
    super.key,
    required this.buttonBackground,
    required this.buttonText,
    this.image, required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 10,
              offset: Offset(10, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackground,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 10),
              if (image != null) ...[
                const SizedBox(width: 10),
                Image.asset(
                  image!,
                  width: 40,
                  height: 40,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
