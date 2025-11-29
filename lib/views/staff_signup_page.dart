import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';
import 'package:little_flower_app/utils/colors.dart';

class StaffSignUpView extends StatelessWidget {
  final StaffController controller = Get.find<StaffController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 14.h),
              _buildCustomHeader(),
              SizedBox(height: 30.h),
              // Header
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.darkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Color(0xFF3D4072),
                        size: 28.w,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Staff Account',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Fill in the details to create a new staff account',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Color(0xFF718096),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Form
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // First Name & Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: firstNameController,
                            label: 'First Name',
                            hintText: 'Enter first name',
                            isObscure: false,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTextField(
                            controller: lastNameController,
                            label: 'Last Name',
                            hintText: 'Enter last name',
                            isObscure: false,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Email
                    _buildTextField(
                      controller: emailController,
                      label: 'Email Address',
                      hintText: 'Enter email address',
                      keyboardType: TextInputType.emailAddress,
                      isObscure: false,
                    ),
                    SizedBox(height: 20.h),

                    // Password
                    Obx(
                      () => _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        hintText: 'Enter password',
                        isPassword: true,
                        toggle: controller.showPassword,
                        isObscure: controller.showPassword.value,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Confirm Password
                    Obx(
                      () => _buildTextField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        hintText: 'Re-enter password',
                        isPassword: true,
                        toggle: controller.showConfirmPassword,
                        isObscure: controller.showConfirmPassword.value,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // Create Account Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: controller.isCreating.value
                              ? null
                              : () => _createAccount(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF06D6A0),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            disabledBackgroundColor: AppColors.darkBlue
                                .withOpacity(0.5),
                          ),
                          child: controller.isCreating.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20.w,
                                      height: 20.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.w,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'Creating Account...',
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Create Staff Account',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button and title
        Row(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF2D3748),
                size: 24.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Manage Announcements',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool isObscure,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    RxBool? toggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8.h),

        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isObscure,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),

              // 👇 PASSWORD TOGGLE ICON
              suffixIcon: isPassword
                  ? Obx(
                      () => InkWell(
                        onTap: () => toggle?.value = !(toggle.value),
                        child: Icon(
                          (toggle?.value ?? false)
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: Color(0xFF718096),
                          size: 20.w,
                        ),
                      ),
                    )
                  : null,
            ),
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  void _createAccount() async {
    if (_validateForm()) {
      Get.defaultDialog(
        title: "Warning",
        middleText:
            "On signing up, you will be logged out automatically.\nDo you want to continue?",
        textCancel: "No",
        textConfirm: "Yes",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // close dialog
          controller.createStaffAccount(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            firstName: firstNameController.text.trim(),
            lastName: lastNameController.text.trim(),
          );
        },
      );
    }
  }

  bool _validateForm() {
    if (firstNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter first name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12.r,
      );
      return false;
    }

    if (lastNameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter last name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12.r,
      );
      return false;
    }

    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      Get.snackbar(
        'Error',
        'Please enter valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12.r,
      );
      return false;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12.r,
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12.r,
      );
      return false;
    }

    return true;
  }
}
