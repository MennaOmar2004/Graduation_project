import 'package:flutter/material.dart';
import 'package:wanisi_app/colors.dart';

class CustomTextFormField extends StatelessWidget {
   final String hint;
   final IconData? suffixIcon;
   final TextEditingController controller;
   final bool? obscure;
  const CustomTextFormField({
    super.key,
    required this.hint,
    this.suffixIcon,
    required this.controller,
    this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
          color: Colors.blue.shade100,
          offset:  Offset(0, 10),
          blurRadius:5,
        )],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
        obscureText:obscure ?? false,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        maxLines: obscure == true ? 1:3,  // Allow multiple lines
        minLines: 1,  // Start with single line
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.blue)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade600)
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500
          ),
          prefixIcon: suffixIcon != null
              ? IconButton(
            onPressed: (){},
            icon: Icon(
                suffixIcon,
              color: Colors.grey.shade600,
              size: 28,
            ),
          )
              : null,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),  // Increased vertical padding
          isDense: false,  // Ensure the field can expand
        ),
      ),
    );
  }
}
