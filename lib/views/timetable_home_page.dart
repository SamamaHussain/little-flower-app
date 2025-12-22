import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/timetable_controller.dart';
import 'package:little_flower_app/models/timetable_model.dart';
import 'package:little_flower_app/utils/colors.dart';
import 'package:little_flower_app/views/timetable_edit_page.dart';

class TimetableManagement extends GetView<TimetableController> {
  const TimetableManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.h),
            // Custom Header
            _buildCustomHeader(),
            SizedBox(height: 20.h),
            _buildTimetableCreateCard(),
            SizedBox(height: 16.h),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return _buildLoadingState();
                  }

                  if (controller.classTimetables.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildTimetableList();
                }),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTimetableDialog(),
        backgroundColor: AppColors.darkBlue,
        child: Icon(Icons.add_rounded, color: Colors.white, size: 24.w),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
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
                'Timetable Management',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableCreateCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
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
                Icons.schedule_rounded,
                color: AppColors.darkBlue,
                size: 28.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Timetables',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(
                    () => Text(
                      '${controller.classTimetables.length}',
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
              onTap: () => _showCreateTimetableDialog(),
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
                      'Create',
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
            'Loading Timetables',
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
              Icons.schedule_rounded,
              size: 48.w,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Timetables Created',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create your first timetable to get started',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => _showCreateTimetableDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Create First Timetable',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableList() {
    return ListView.builder(
      itemCount: controller.classTimetables.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final timetable = controller.classTimetables[index];
        return _buildTimetableCard(timetable, index);
      },
    );
  }

  Widget _buildTimetableCard(ClassTimetable timetable, int index) {
    return GestureDetector(
      onLongPress: () => _showDeleteConfirmationDialog(timetable),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25.r),
            onTap: () => Get.to(
              () => EditTimetableScreen(),
              arguments: {
                'grade': timetable.grade,
                'section': timetable.section,
              },
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  // Class Icon with rotating colors - matching attendance style
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: _getAvatarColor(index),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // Class Info - matching attendance text styling
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timetable.className,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${_getTotalLectures(timetable)} lectures • ${_getTotalDays(timetable)} days',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Forward Arrow - matching attendance style
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16.w,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(ClassTimetable timetable) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline_rounded, size: 48.w, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                'Delete Timetable?',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to delete ${timetable.className} timetable?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 59, 59, 59),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await controller.deleteTimetable(timetable.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
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

  Color _getAvatarColor(int index) {
    // Define color palette similar to attendance page
    final colors = [
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightBlue,
      Color(0xFFFECBE2),
      Color(0xFFB0F5FF),
      Color(0xFF3F4072),
      Color(0xFF06D6A0),
    ];
    return colors[index % colors.length];
  }

  int _getTotalLectures(ClassTimetable timetable) {
    int total = 0;
    for (final day in timetable.weeklyTimetable) {
      total += day.timeSlots.length;
    }
    return total;
  }

  int _getTotalDays(ClassTimetable timetable) {
    return timetable.weeklyTimetable
        .where((day) => day.timeSlots.isNotEmpty)
        .length;
  }

  // String _formatDate(DateTime date) {
  //   return '${date.day}/${date.month}/${date.year}';
  // }

  void _showCreateTimetableDialog() {
    // Initialize values
    controller.selectedGradeForDialog.value = controller.grades.first;
    controller.selectedSectionForDialog.value = controller.sections.first;

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create New Timetable',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, size: 20.w),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Grade Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grade',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedGradeForDialog.value,
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          icon: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Color(0xFF718096),
                          ),
                          items: controller.grades.map((String grade) {
                            return DropdownMenuItem(
                              value: grade,
                              child: Text('Grade $grade'),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedGradeForDialog.value = newValue!;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Section Selection
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Section',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedSectionForDialog.value,
                          isExpanded: true,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          icon: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Color(0xFF718096),
                          ),
                          items: controller.sections.map((String section) {
                            return DropdownMenuItem(
                              value: section,
                              child: Text('Section $section'),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedSectionForDialog.value =
                                newValue!;
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Buttons
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
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.to(
                          () => EditTimetableScreen(),
                          arguments: {
                            'grade': controller.selectedGradeForDialog.value,
                            'section':
                                controller.selectedSectionForDialog.value,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 14.sp,
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
