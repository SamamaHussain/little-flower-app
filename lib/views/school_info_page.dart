// edit_school_info_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/school_info_controller.dart';
import 'package:little_flower_app/utils/colors.dart';

class EditSchoolInfoScreen extends GetView<SchoolInfoController> {
  const EditSchoolInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load current values into controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadForEditing();
    });

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Obx(() {
          // Show loading state
          if (controller.isLoading.value) {
            return _buildLoadingState();
          }

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Custom App Bar
                _buildAppBar(),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Info Card
                      _buildInfoCard(),
                      SizedBox(height: 20.h),

                      // Form Fields
                      _buildFormFields(),
                      SizedBox(height: 30.h),

                      // Action Buttons
                      _buildActionButtons(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.darkBlue,
            strokeWidth: 3.w,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading...',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF2D3748),
              size: 24.w,
            ),
          ),

          SizedBox(width: 12.w),

          // Title
          Expanded(
            child: Text(
              'Edit School Info',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
          ),

          // Reset Button
          Obx(() {
            return InkWell(
              onTap: controller.isSaving.value ? null : _showResetDialog,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.restore_rounded,
                      size: 16.w,
                      color: Color(0xFF2D3748),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          // Icon on left
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.school_rounded, size: 28.w, color: Colors.white),
          ),

          SizedBox(width: 16.w),

          // Content on right
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'School Contact Details',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),

                SizedBox(height: 4.h),

                // Subtitle
                Text(
                  'Update information shown on the guest page',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF718096),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // School Hours
          _buildTextField(
            label: 'School Hours',
            hintText: 'e.g., 7:30 AM - 2:30 PM',
            controller: controller.schoolHoursController,
            icon: Icons.schedule_rounded,
            iconColor: AppColors.green,
          ),
          SizedBox(height: 16.h),

          // Office Hours
          _buildTextField(
            label: 'Office Hours',
            hintText: 'e.g., 7:00 AM - 4:00 PM',
            controller: controller.officeHoursController,
            icon: Icons.business_center_rounded,
            iconColor: AppColors.lightBlue,
          ),
          SizedBox(height: 16.h),

          // Contact Phone
          _buildTextField(
            label: 'Contact Phone',
            hintText: 'e.g., +1 (555) 123-4567',
            controller: controller.contactPhoneController,
            icon: Icons.phone_rounded,
            iconColor: AppColors.pink,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 16.h),

          // Contact Email
          _buildTextField(
            label: 'Contact Email',
            hintText: 'e.g., info@school.edu',
            controller: controller.contactEmailController,
            icon: Icons.email_rounded,
            iconColor: AppColors.yellow,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.h),

          // School Address
          _buildTextField(
            label: 'School Address',
            hintText: 'e.g., 123 Education Street, City',
            controller: controller.schoolAddressController,
            icon: Icons.location_on_rounded,
            iconColor: AppColors.darkBlue,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 16.w, color: iconColor),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Text Field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xFFE2E8F0), width: 1),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(fontSize: 15.sp, color: Color(0xFF2D3748)),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14.sp, color: Color(0xFFA0AEC0)),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      return Row(
        children: [
          // Cancel Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Color(0xFFE2E8F0), width: 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.isSaving.value ? null : () => Get.back(),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Save Button
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: controller.isSaving.value
                    ? AppColors.darkBlue.withOpacity(0.5)
                    : AppColors.darkBlue,
                boxShadow: controller.isSaving.value
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.darkBlue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.isSaving.value ? null : _saveChanges,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: controller.isSaving.value
                          ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void _saveChanges() {
    // Validate fields
    if (controller.schoolHoursController.text.isEmpty ||
        controller.officeHoursController.text.isEmpty ||
        controller.contactPhoneController.text.isEmpty ||
        controller.contactEmailController.text.isEmpty ||
        controller.schoolAddressController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Email validation (basic)
    final email = controller.contactEmailController.text;
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar(
        'Validation Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Save changes
    controller
        .updateSchoolInfo(
          newSchoolHours: controller.schoolHoursController.text.trim(),
          newOfficeHours: controller.officeHoursController.text.trim(),
          newContactPhone: controller.contactPhoneController.text.trim(),
          newContactEmail: controller.contactEmailController.text.trim(),
          newSchoolAddress: controller.schoolAddressController.text.trim(),
        )
        .then((_) {
          // Navigate back after successful save
          Future.delayed(Duration(milliseconds: 500), () {
            Get.back();
          });
        })
        .catchError((error) {
          // Error is already handled in controller
        });
  }

  void _showResetDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 32.w,
                  color: Colors.orange,
                ),
              ),

              SizedBox(height: 16.h),

              // Title
              Text(
                'Reset to Defaults?',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlue,
                ),
              ),

              SizedBox(height: 8.h),

              // Message
              Text(
                'This will reset all school information to default values. This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF718096),
                  height: 1.4,
                ),
              ),

              SizedBox(height: 24.h),

              // Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Color(0xFFE2E8F0), width: 1),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.back(),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // Reset Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: Colors.orange,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.resetToDefaults();
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child: Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
