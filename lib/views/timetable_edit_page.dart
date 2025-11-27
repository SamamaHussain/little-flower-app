import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/timetable_controller.dart';
import 'package:little_flower_app/models/timetable_model.dart';
import 'package:little_flower_app/utils/colors.dart';

class EditTimetableScreen extends GetView<TimetableController> {
  final String grade;
  final String section;

  EditTimetableScreen({Key? key})
    : grade = Get.arguments['grade'],
      section = Get.arguments['section'],
      super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load timetable when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectClassTimetable(grade, section);
    });

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.h),
            // Custom Header
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
                                  color: AppColors.yellow.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${_getTotalLectures()} lectures',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.darkBlue,
                                      ),
                                    ),
                                  ],
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

            // Timetable Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }

                if (controller.selectedClassTimetable.value == null) {
                  return _buildEmptyState();
                }

                return _buildTimetableContent();
              }),
            ),
          ],
        ),
      ),

      // Save Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => controller.isSaving.value
            ? Container(
                width: 200.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.darkBlue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Saving...',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: 200.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30.r),
                    onTap: () => controller.saveTimetable(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Save Timetable',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
                'Edit Timetable',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),

          // Add Time Slot Button
          Obx(
            () => controller.selectedClassTimetable.value != null
                ? Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 20.w,
                      ),
                      onPressed: () => controller.addTimeSlotToCurrentDay(),
                      padding: EdgeInsets.zero,
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: controller.daysOfWeek.length,
        itemBuilder: (context, index) {
          final day = controller.daysOfWeek[index];
          return Obx(() {
            final isSelected = controller.selectedDay.value == day;
            return Container(
              margin: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectedDay.value = day,
                child: Container(
                  width: 70.w,
                  height: 50.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.darkBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.darkBlue
                          : Color(0xFFE2E8F0),
                      width: 1.w,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        day.substring(0, 3),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Color(0xFF718096),
                        ),
                      ),
                    ],
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

    int total = 0;
    for (final day in timetable.weeklyTimetable) {
      total += day.timeSlots.length;
    }
    return total;
  }

  Widget _buildLoadingState() {
    return Center(
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
            'No Timetable Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Create a new timetable for this class',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () =>
                controller.createEmptyTimetableForClass(grade, section),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Create Timetable',
              style: TextStyle(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(() {
        final currentDayTimetable = controller.getCurrentDayTimetable();
        final timeSlots = currentDayTimetable?.timeSlots ?? [];

        if (timeSlots.isEmpty) {
          return _buildNoTimeSlotsState();
        }

        return ListView.builder(
          itemCount: timeSlots.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return _buildTimeSlotCard(timeSlots[index], index);
          },
        );
      }),
    );
  }

  Widget _buildNoTimeSlotsState() {
    return Center(
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
              Icons.add_rounded,
              size: 40.w,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Time Slots Added',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tap the + button to add your first time slot',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFFA0AEC0)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(TimeSlot timeSlot, int index) {
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
          onTap: () => _showEditTimeSlotDialog(timeSlot),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Time Indicator
                Container(
                  width: 70.w,
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: timeSlot.isBreak
                        ? AppColors.yellow.withOpacity(0.2)
                        : AppColors.darkBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        timeSlot.startTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: timeSlot.isBreak
                              ? Color(0xFFE67701)
                              : AppColors.darkBlue,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: 20.w,
                        height: 1.h,
                        color: timeSlot.isBreak
                            ? Color(0xFFE67701)
                            : AppColors.darkBlue,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        timeSlot.endTime,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: timeSlot.isBreak
                              ? Color(0xFFE67701)
                              : AppColors.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                // Slot Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (timeSlot.isBreak) ...[
                        Text(
                          timeSlot.breakTitle ?? 'Break Time',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE67701),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Break Period',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color(0xFF718096),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ] else ...[
                        Text(
                          timeSlot.subject.isNotEmpty
                              ? timeSlot.subject
                              : 'No Subject',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          timeSlot.teacher.isNotEmpty
                              ? 'Teacher: ${timeSlot.teacher}'
                              : 'No teacher assigned',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Edit Icon
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 16.w,
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

  void _showEditTimeSlotDialog(TimeSlot timeSlot) {
    final startTimeController = TextEditingController(text: timeSlot.startTime);
    final endTimeController = TextEditingController(text: timeSlot.endTime);
    final subjectController = TextEditingController(text: timeSlot.subject);
    final teacherController = TextEditingController(text: timeSlot.teacher);
    final breakTitleController = TextEditingController(
      text: timeSlot.breakTitle ?? '',
    );

    bool isBreak = timeSlot.isBreak;

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
                    isBreak ? 'Edit Break' : 'Edit Time Slot',
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

              // Break Toggle
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Switch(
                      value: isBreak,
                      onChanged: (value) {
                        isBreak = value;
                        Get.back();
                        _showEditTimeSlotDialog(
                          timeSlot.copyWith(isBreak: value),
                        );
                      },
                      activeColor: AppColors.yellow,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Mark as Break Period',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              if (!isBreak) ...[
                // Subject Field
                _buildTextField(
                  controller: subjectController,
                  label: 'Subject',
                  hintText: 'Enter subject name',
                ),
                SizedBox(height: 16.h),

                // Teacher Field
                _buildTextField(
                  controller: teacherController,
                  label: 'Teacher',
                  hintText: 'Enter teacher name',
                ),
                SizedBox(height: 16.h),
              ] else ...[
                // Break Title Field
                _buildTextField(
                  controller: breakTitleController,
                  label: 'Break Title',
                  hintText: 'e.g., Lunch Break, Short Break',
                ),
                SizedBox(height: 16.h),
              ],

              // Time Fields in Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: startTimeController,
                      label: 'Start Time',
                      hintText: '09:00 AM',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTextField(
                      controller: endTimeController,
                      label: 'End Time',
                      hintText: '10:00 AM',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                children: [
                  // Delete Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.deleteTimeSlot(timeSlot.id);
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text('Delete'),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Save Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final updatedSlot = timeSlot.copyWith(
                          startTime: startTimeController.text.trim(),
                          endTime: endTimeController.text.trim(),
                          subject: isBreak ? '' : subjectController.text.trim(),
                          teacher: isBreak ? '' : teacherController.text.trim(),
                          isBreak: isBreak,
                          breakTitle: isBreak
                              ? breakTitleController.text.trim()
                              : null,
                        );

                        controller.updateTimeSlot(timeSlot.id, updatedSlot);
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Save',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
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
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.darkBlue),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
