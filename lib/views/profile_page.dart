import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/auth_controller.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';
import 'package:little_flower_app/utils/colors.dart';
import 'package:intl/intl.dart';

class ProfilePage extends GetView<AuthController> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final RxBool isEditing = false.obs;

  @override
  Widget build(BuildContext context) {
    final StaffController staffController = Get.find<StaffController>();

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            _buildCustomHeader(),
            SizedBox(height: 16.h),

            // Content
            Expanded(
              child: Obx(() {
                final staff = staffController.currentStaff.value;

                // if (staffController.isLoading.value) {
                //   return _buildLoadingState();
                // }

                if (staff == null) {
                  return _buildEmptyState();
                }

                // Initialize controllers with current staff data only once
                if (firstNameController.text.isEmpty &&
                    lastNameController.text.isEmpty) {
                  firstNameController.text = staff.firstName;
                  lastNameController.text = staff.lastName;
                }

                // Format account creation date
                final createdDate = staff.createdAt;
                final formattedDate = createdDate != null
                    ? DateFormat('MMMM dd, yyyy').format(createdDate)
                    : 'N/A';

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Profile Picture Section
                      _buildProfilePictureSection(),
                      SizedBox(height: 24.h),

                      // Profile Information Card
                      Container(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                Obx(() {
                                  if (controller.isAdmin && !isEditing.value) {
                                    return GestureDetector(
                                      onTap: () => isEditing.value = true,
                                      child: Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.darkBlue.withOpacity(
                                            0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.edit_rounded,
                                          color: AppColors.darkBlue,
                                          size: 18.w,
                                        ),
                                      ),
                                    );
                                  } else if (isEditing.value) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            isEditing.value = false;
                                            // Reset text controllers
                                            firstNameController.text =
                                                staff.firstName;
                                            lastNameController.text =
                                                staff.lastName;
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(
                                                0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.red,
                                              size: 18.w,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        GestureDetector(
                                          onTap: () =>
                                              _saveChanges(staffController),
                                          child: Container(
                                            padding: EdgeInsets.all(8.w),
                                            decoration: BoxDecoration(
                                              color: AppColors.green
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Icon(
                                              Icons.check_rounded,
                                              color: AppColors.green,
                                              size: 18.w,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // First Name
                            Obx(
                              () => _buildInfoField(
                                'First Name',
                                firstNameController,
                                isEditing.value,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Last Name
                            Obx(
                              () => _buildInfoField(
                                'Last Name',
                                lastNameController,
                                isEditing.value,
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Email (non-editable)
                            _buildInfoFieldStatic('Email', staff.email),
                            SizedBox(height: 16.h),

                            // Role
                            _buildInfoFieldStatic(
                              'Role',
                              controller.isAdmin ? 'Principal' : 'Teacher',
                            ),
                            SizedBox(height: 16.h),

                            // Account Type
                            _buildInfoFieldStatic(
                              'Account Type',
                              staff.accountType.toUpperCase(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Account Details Card
                      Container(
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
                            Text(
                              'Account Details',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Account Created Date
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightBlue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: AppColors.darkBlue,
                                    size: 20.w,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Account Created',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF718096),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Change Password Button
                      if (!isEditing.value)
                        _buildActionButton(
                          'Change Password',
                          Icons.lock_reset_rounded,
                          AppColors.darkBlue,
                          () => _showChangePasswordDialog(),
                        ),
                      SizedBox(height: 12.h),

                      // Delete Account Button
                      if (!isEditing.value)
                        _buildActionButton(
                          'Delete Account',
                          Icons.delete_forever_rounded,
                          Colors.red,
                          () => _showDeleteAccountDialog(staffController),
                        ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748)),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(width: 12.w),
          Text(
            'My Profile',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.darkBlue, strokeWidth: 2),
          SizedBox(height: 20.h),
          Text(
            'Loading Profile...',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.person_off_rounded,
              size: 48.w,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Profile Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Unable to load your profile information',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    final StaffController staffController = Get.find<StaffController>();

    return Obx(() {
      final staff = staffController.currentStaff.value;

      return Center(
        child: Stack(
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://thumbs.dreamstime.com/b/profile-picture-caucasian-male-employee-posing-office-happy-young-worker-look-camera-workplace-headshot-portrait-smiling-190186649.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.darkBlue, AppColors.lightBlue],
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 50.w,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 18.w,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoField(
    String label,
    TextEditingController controller,
    bool isEditing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isEditing ? Colors.white : Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isEditing ? AppColors.darkBlue : Color(0xFFE2E8F0),
              width: isEditing ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            enabled: isEditing,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoFieldStatic(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xFFE2E8F0)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withOpacity(0.3)),
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 20.w),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges(StaffController staffController) async {
    final staff = staffController.currentStaff.value;
    if (staff == null) return;

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      Get.snackbar(
        "Error",
        "First name and last name cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show loading
    Get.dialog(
      Center(child: CircularProgressIndicator(color: AppColors.darkBlue)),
      barrierDismissible: false,
    );

    await staffController.updateStaff(staff.uid, firstName, lastName);
    await staffController.fetchCurrentStaff();

    // Close loading
    if (Get.isDialogOpen ?? false) Get.back();

    isEditing.value = false;

    Get.snackbar(
      "Success",
      "Profile updated successfully",
      backgroundColor: AppColors.green,
      colorText: Colors.white,
    );
  }

  void _showChangePasswordDialog() {
    Get.snackbar(
      'Change Password',
      'Password reset link will be sent to your email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.darkBlue,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  void _showDeleteAccountDialog(StaffController staffController) {
    final TextEditingController passwordController = TextEditingController();
    final RxBool obscurePassword = true.obs;

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
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.red,
                  size: 32.w,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Delete Account?',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 20.h),
              Obx(
                () => TextField(
                  controller: passwordController,
                  obscureText: obscurePassword.value,
                  decoration: InputDecoration(
                    labelText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.darkBlue,
                      ),
                      onPressed: () =>
                          obscurePassword.value = !obscurePassword.value,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (passwordController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter your password",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        Get.back(); // Close dialog

                        final success = await staffController.deleteOwnAccount(
                          password: passwordController.text.trim(),
                        );

                        if (success) {
                          Get.offAllNamed('/auth');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
