import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/timetable_controller.dart';
import 'package:little_flower_app/models/timetable_model.dart';
import 'package:little_flower_app/utils/colors.dart';
import 'package:little_flower_app/views/view_timetable_page.dart';

class ViewTimetableHome extends GetView<TimetableController> {
  const ViewTimetableHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            SizedBox(height: 14.h),
            _buildCustomHeader(),
            SizedBox(height: 20.h),
            _buildTimetableStatsCard(),
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
    );
  }

  Widget _buildCustomHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
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
            'View Timetables',
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

  Widget _buildTimetableStatsCard() {
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
            // Left Icon (same style as announcements)
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                Icons.calendar_month_rounded,
                color: AppColors.darkBlue,
                size: 28.w,
              ),
            ),

            SizedBox(width: 16.w),

            // Center: Stats Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Timetables',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Obx(
                    () => Text(
                      controller.classTimetables.isEmpty
                          ? '-'
                          : '${controller.classTimetables.length}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors
                            .darkBlue, // Using your primary brand color
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right Badge: "Updated Today" or "Active"
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Color(0xFF06D6A0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Color(0xFF06D6A0).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: Color(0xFF06D6A0),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Active',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Color(0xFF06D6A0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
            'No Timetables Available',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Timetables will appear here once created',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
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
    final avatarColor = _getAvatarColor(index);

    return Container(
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
            () => ViewTimetableScreen(),
            arguments: {'grade': timetable.grade, 'section': timetable.section},
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Class Icon
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),

                // Class Info
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

                // Forward arrow with matching avatar color
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: avatarColor, // Same color as icon bg with opacity
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.w,
                    color: Colors.white, // Same color as icon bg
                  ),
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
      Color(0xFFFECBE2),
      Color(0xFFB0F5FF),
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
}
