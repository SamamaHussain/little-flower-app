import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/utils/colors.dart';

class AppSnackbar {
  // Helper to close any existing snackbar before showing new one
  static void _showSnackbar({
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    // Close any existing snackbar to prevent overlap
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: 12.r,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    );
  }

  // Success snackbar - green background with dark text
  static void success(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: AppColors.green,
      textColor: AppColors.darkBlue,
    );
  }

  // Error snackbar - light red background with dark red text
  static void error(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: const Color(0xFFFFCDD2),
      textColor: const Color(0xFF8B0000),
    );
  }

  // Info/General snackbar - dark blue background with white text
  static void info(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: AppColors.darkBlue,
      textColor: Colors.white,
    );
  }

  // Warning snackbar - yellow background with dark text
  static void warning(String message) {
    _showSnackbar(
      message: message,
      backgroundColor: AppColors.yellow,
      textColor: AppColors.darkBlue,
    );
  }
}