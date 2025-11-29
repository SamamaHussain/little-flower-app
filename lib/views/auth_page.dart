import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/colors.dart';

class AuthPage extends GetView<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),

              // School Profile Section (centered)
              _buildSchoolProfileSection(),
              SizedBox(height: 40.h),

              // Login Card
              Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 400.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildLoginForm(),
                    SizedBox(height: 24.h),
                    _buildLoginButton(),
                    SizedBox(height: 10.h),
                    _buildGuestOption(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // School Profile Section (Centered)
  Widget _buildSchoolProfileSection() {
    return Column(
      children: [
        // School Logo
        Hero(
          tag: 'schoolProfile',
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/lfs_logo2.jpeg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.darkBlue, AppColors.darkBlue],
                      ),
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 40.w,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // School Info (Centered)
        Column(
          children: [
            Text(
              'Staff Portal',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF718096),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Little Flower School',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 1,
              width: 200.w,
              color: Colors.black.withOpacity(0.2),
            ),
            SizedBox(height: 8.h),
            Text(
              'Sign in to access your dashboard',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Login Form
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputField(
          'Email Address',
          Icons.email_rounded,
          false,
          emailController,
        ),
        SizedBox(height: 16.h),
        Obx(
          () => _inputField(
            'Password',
            Icons.lock_rounded,
            controller.isPasswordVisible.value,
            passwordController,
            isPassword: true,
          ),
        ),
      ],
    );
  }

  Widget _inputField(
    String label,
    IconData icon,
    bool isObscure,
    TextEditingController textController, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 10.h),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: textController,
            obscureText: isObscure,
            style: TextStyle(fontSize: 15.sp, color: Color(0xFF2D3748)),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 16.h,
              ),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.all(12.w),
                child: Icon(icon, size: 22.w, color: AppColors.darkBlue),
              ),

              // 🔥 only wrap the icon in Obx, not the whole row
              suffixIcon: isPassword
                  ? Obx(
                      () => IconButton(
                        onPressed: () => controller.togglePasswordVisibility(),
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 22.w,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    )
                  : null,

              hintText: "Enter your ${label.toLowerCase()}",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFFCBD5E0),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Login Button (matching Guest info tiles style)
  Widget _buildLoginButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: controller.isLoading
              ? null
              : () => controller.login(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkBlue,
            disabledBackgroundColor: AppColors.darkBlue.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 0,
          ),
          child: controller.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // Guest Option (styled like announcement date badge)
  Widget _buildGuestOption() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.offAllNamed('/guest'),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 16.w,
                  color: AppColors.darkBlue,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
