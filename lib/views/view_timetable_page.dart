import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/timetable_controller.dart';
import 'package:little_flower_app/models/timetable_model.dart';
import 'package:little_flower_app/utils/colors.dart';

class ViewTimetableScreen extends GetView<TimetableController> {
  final String grade;
  final String section;

  ViewTimetableScreen({Key? key})
    : grade = Get.arguments['grade'],
      section = Get.arguments['section'],
      super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectClassTimetable(grade, section);
    });

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.h),
            _buildCustomHeader(),
            SizedBox(height: 16.h),

            // Day Selector Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final timetable =
                            controller.selectedClassTimetable.value;
                        return Text(
                          timetable?.className ??
                              'Grade $grade - Section $section',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2D3748),
                          ),
                        );
                      }),
                      Obx(
                        () => controller.selectedClassTimetable.value != null
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.yellow.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.yellow.withOpacity(0.4),
                                  ),
                                ),
                                child: Text(
                                  '${_getTotalLectures()} lectures',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkBlue,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  _buildDaySelector(),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return _buildLoadingState();
                if (controller.selectedClassTimetable.value == null)
                  return _buildEmptyState();
                return _buildTimetableContent();
              }),
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
            'View Timetable',
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

  Widget _buildDaySelector() {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: controller.daysOfWeek.length,
        itemBuilder: (context, index) {
          final day = controller.daysOfWeek[index];
          return Obx(() {
            final isSelected = controller.selectedDay.value == day;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectedDay.value = day,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 72.w,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.darkBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.darkBlue
                          : Color(0xFFE2E8F0),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      day.substring(0, 3).toUpperCase(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Color(0xFF718096),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  int _getTotalLectures() {
    final timetable = controller.selectedClassTimetable.value;
    if (timetable == null) return 0;
    return timetable.weeklyTimetable.expand((day) => day.timeSlots).length;
  }

  Widget _buildLoadingState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: AppColors.darkBlue, strokeWidth: 2),
        SizedBox(height: 20.h),
        Text(
          'Loading Timetable',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() => Center(
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
          'No Timetable Found',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'This class does not have a timetable yet',
          style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildTimetableContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        final timeSlots = controller.getCurrentDayTimetable()?.timeSlots ?? [];
        if (timeSlots.isEmpty) return _buildNoTimeSlotsState();

        return ListView.builder(
          itemCount: timeSlots.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) =>
              _buildTimeSlotCard(timeSlots[index], index),
        );
      }),
    );
  }

  Widget _buildNoTimeSlotsState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: AppColors.darkBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.schedule_rounded,
            size: 40.w,
            color: AppColors.darkBlue,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'No Classes Scheduled',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'No time slots added for this day',
          style: TextStyle(fontSize: 14.sp, color: Color(0xFFA0AEC0)),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  // BEAUTIFULLY REDESIGNED TIME SLOT CARD – Only AppColors, Super Readable
  Widget _buildTimeSlotCard(TimeSlot timeSlot, int index) {
    final bool isBreak = timeSlot.isBreak;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: isBreak
              ? AppColors.yellow.withOpacity(0.3)
              : AppColors.lightBlue.withOpacity(0.2),
          width: 1.5,
        ),
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
          // Time Pillar
          Container(
            width: 76.w,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              color: isBreak
                  ? AppColors.yellow.withOpacity(0.18)
                  : AppColors.darkBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  timeSlot.startTime,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    // Fixed: No darken() — using safe dark shades
                    color: isBreak
                        ? Color(0xFFE67701)
                        : AppColors
                              .darkBlue, // Orange for break, darkBlue for class
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Container(
                    height: 1.5,
                    width: 28.w,
                    color: isBreak ? Color(0xFFE67701) : AppColors.darkBlue,
                  ),
                ),
                Text(
                  timeSlot.endTime,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: isBreak ? Color(0xFFE67701) : AppColors.darkBlue,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 18.w),

          // Main Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBreak
                      ? (timeSlot.breakTitle ?? 'Break Time')
                      : (timeSlot.subject.isNotEmpty
                            ? timeSlot.subject
                            : 'Free Period'),
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: isBreak
                        ? Color(0xFFD97706)
                        : Color(
                            0xFF2D3748,
                          ), // Darker amber for break, black for subject
                  ),
                ),
                SizedBox(height: 6.h),
                if (!isBreak)
                  Text(
                    timeSlot.teacher.isNotEmpty
                        ? 'by ${timeSlot.teacher}'
                        : 'Teacher not assigned',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Color(0xFF718096),
                      fontWeight: timeSlot.teacher.isNotEmpty
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  )
                else
                  Text(
                    'Relax and recharge',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      color: Color(0xFF718096),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          // Period number
          Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
