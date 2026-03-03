import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:login_signup/theme/app_colors.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    this.buttonText,
    this.onTap,
    this.color,
    this.textColor,
  });
  final String? buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => onTap!);
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: (color ?? AppColors.primary).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
