import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';
import 'package:little_flower_app/models/staff_model.dart';
import 'package:little_flower_app/routes/app_pages.dart';
import 'package:little_flower_app/utils/colors.dart';

class StaffManagementView extends StatelessWidget {
  final StaffController controller = Get.put(StaffController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }
            return Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _buildCustomHeader(),
                  SizedBox(height: 30),
                  // Header Stats
                  _buildHeaderStats(),
                  SizedBox(height: 20.h),

                  // Staff List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Staff Accounts',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF3F4072).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${controller.staffList.length} ${controller.staffList.length == 1 ? 'Staff' : 'Staff'}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xFF3F4072),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Staff List
                  Expanded(child: _buildStaffList()),
                ],
              ),
            );
          }),
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
            IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF2D3748)),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
            SizedBox(width: 12.w),
            Text(
              'Manage Staff',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.refresh_rounded),
          onPressed: () => controller.fetchStaff(),
          tooltip: 'Refresh',
        ),
      ],
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
            'Loading Staff...',
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

  Widget _buildHeaderStats() {
    return Container(
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
              color: Color(0xFF3F4072).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.people_alt_rounded,
              color: Color(0xFF3F4072),
              size: 28.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Staff',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF718096),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Obx(
                  () => Text(
                    '${controller.staffList.length}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.STAFF_SIGNUP),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Color(0xFF06D6A0),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 16.w),
                  SizedBox(width: 6.w),
                  Text(
                    'Add Staff',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffList() {
    return Obx(() {
      if (controller.staffList.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        itemCount: controller.staffList.length,
        itemBuilder: (context, index) {
          final staff = controller.staffList[index];
          return _buildStaffCard(staff, index);
        },
      );
    });
  }

  Widget _buildStaffCard(Staff staff, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Staff Avatar with rotating colors
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: _getAvatarColor(index),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),

                // Staff Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staff.fullName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        staff.email,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF718096),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: staff.accountType == 'admin'
                              ? Colors.orange.withOpacity(0.1)
                              : Color(0xFF3F4072).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          staff.accountType.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: staff.accountType == 'admin'
                                ? Colors.orange
                                : Color(0xFF3F4072),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action Menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF718096),
                    size: 20.w,
                  ),
                  onSelected: (value) {
                    if (value == 'change_password') {
                      _showChangePasswordDialog(staff);
                    }
                    if (value == 'edit_name') {
                      _showEditNameDialog(staff);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit_name',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                            color: Color(0xFF3F4072),
                            size: 18.w,
                          ),
                          SizedBox(width: 8.w),
                          Text('Edit Name'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'change_password',
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_reset_rounded,
                            color: Color(0xFF3F4072),
                            size: 18.w,
                          ),
                          SizedBox(width: 8.w),
                          Text('Change Password'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightBlue,
    ];
    return colors[index % colors.length];
  }

  void _showEditNameDialog(Staff staff) {
    final firstNameController = TextEditingController(text: staff.firstName);
    final lastNameController = TextEditingController(text: staff.lastName);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Staff Name",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16.w),
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
                        foregroundColor: Color(0xFF718096),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: Text("Cancel"),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(() {
                      final isUpdating = controller.isUpdating.value;
                      return ElevatedButton(
                        onPressed: isUpdating
                            ? null
                            : () async {
                                final first = firstNameController.text.trim();
                                final last = lastNameController.text.trim();

                                if (first.isEmpty || last.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Both fields are required",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white,
                                    borderRadius: 12.r,
                                  );
                                  return;
                                }

                                await controller.updateStaff(
                                  staff.uid,
                                  first,
                                  last,
                                );
                                Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3F4072),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: isUpdating
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  color: Colors.white,
                                ),
                              )
                            : Text("Save"),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePasswordDialog(Staff staff) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Color(0xFF3F4072).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset_rounded,
                  size: 32.w,
                  color: Color(0xFF3F4072),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Change Staff Password',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Send password reset email to ${staff.fullName}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 8.h),
              Text(
                'They will receive an email to set a new password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF718096),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isSendingResetEmail.value
                            ? null
                            : () {
                                controller.sendPasswordReset(staff.email);
                                Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3F4072),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: controller.isSendingResetEmail.value
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  color: Colors.white,
                                ),
                              )
                            : Text('Send Reset Email'),
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
              Icons.people_outline_rounded,
              size: 48.w,
              color: Color(0xFF3F4072),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Staff Accounts',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add staff members to manage accounts',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.STAFF_SIGNUP),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3F4072),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Add First Staff',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
