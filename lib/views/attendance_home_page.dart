import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/students_controller.dart';
import 'package:little_flower_app/utils/colors.dart';
import 'package:little_flower_app/views/mark_attendace_page.dart';

class AttendanceHomeView extends StatelessWidget {
  AttendanceHomeView({Key? key}) : super(key: key);

  final StudentsController studentsController = Get.find<StudentsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Obx(() {
          if (studentsController.isLoading.value) {
            return _buildLoadingState();
          }
          return SingleChildScrollView(
            // Wrap entire content in SingleChildScrollView
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14),
                  _buildCustomHeader(),
                  SizedBox(height: 30.h),
                  Text(
                    'Select Class',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Grade and Section Filters
                  Obx(() {
                    final grades = studentsController.grades;
                    final sections = studentsController.sections;

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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
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
                                        color: Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: studentsController
                                              .selectedGrade
                                              .value,
                                          isExpanded: true,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          items: grades.map((grade) {
                                            return DropdownMenuItem(
                                              value: grade,
                                              child: Text(
                                                grade == 'All'
                                                    ? 'All Grades'
                                                    : 'Grade $grade',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Color(0xFF2D3748),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              studentsController
                                                      .selectedGrade
                                                      .value =
                                                  newValue;
                                              studentsController.applyFilters();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
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
                                        color: Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.grey.withOpacity(0.2),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: studentsController
                                              .selectedSection
                                              .value,
                                          isExpanded: true,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                          ),
                                          items: sections.map((section) {
                                            return DropdownMenuItem(
                                              value: section,
                                              child: Text(
                                                section == 'All'
                                                    ? 'All Sections'
                                                    : 'Section $section',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Color(0xFF2D3748),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              studentsController
                                                      .selectedSection
                                                      .value =
                                                  newValue;
                                              studentsController.applyFilters();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 24.h),

                  // Classes Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Classes',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Obx(() {
                        final totalClasses = _calculateTotalClasses();
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkBlue,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '$totalClasses ${totalClasses == 1 ? 'Class' : 'Classes'}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Classes List - Remove Expanded and use regular Column
                  Obx(() {
                    final grades = studentsController.filteredStudents
                        .map((student) => student.grade)
                        .toSet()
                        .toList()
                        .where((g) => g != 'All')
                        .toList();

                    if (grades.isEmpty) {
                      return _buildEmptyState();
                    }

                    // Create a list of all class cards with their indices
                    List<Widget> classCards = [];
                    int cardIndex = 0;

                    for (final grade in grades) {
                      final sections = studentsController.filteredStudents
                          .where((student) => student.grade == grade)
                          .map((student) => student.section)
                          .toSet()
                          .toList();
                      sections.sort();

                      for (final section in sections) {
                        final count = studentsController.filteredStudents
                            .where(
                              (student) =>
                                  student.grade == grade &&
                                  student.section == section,
                            )
                            .length;
                        classCards.add(
                          _buildClassCard(grade, section, count, cardIndex),
                        );
                        cardIndex++;
                      }
                    }

                    return Column(
                      children: [
                        for (int i = 0; i < classCards.length; i++) ...[
                          classCards[i],
                          if (i < classCards.length - 1) SizedBox(height: 14.h),
                        ],
                      ],
                    );
                  }),
                  SizedBox(height: 20.h), // Extra padding at bottom
                ],
              ),
            ),
          );
        }),
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
              'Manage Attendance',
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

  Widget _buildClassCard(
    String grade,
    String section,
    int studentCount,
    int index,
  ) {
    // Define color palette similar to dashboard management tiles
    final colors = [
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightBlue,
      Color(0xFFFECBE2), // Announcements color
      Color(0xFFB0F5FF), // Staff management color
    ];

    // Rotate colors based on index to ensure variety
    final color = colors[index % colors.length];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Get.to(
            () => AttendanceMarkView(grade: grade, section: section),
            transition: Transition.rightToLeft,
          );
        },
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              // Colorful icon background
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(
                  Icons.class_rounded,
                  color: Colors.white,
                  size: 26.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade $grade - Section $section',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$studentCount ${studentCount == 1 ? 'student' : 'students'}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              // Colored rounded background for forward arrow
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.w,
                  color: Colors.white,
                ),
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
              Icons.class_outlined,
              size: 48.w,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Classes Available',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add students to create classes',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
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
          Container(
            width: 80.w,
            height: 80.w,
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
              Icons.calendar_today_rounded,
              size: 40.w,
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Loading Classes...',
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

  int _calculateTotalClasses() {
    final grades = studentsController.filteredStudents
        .map((student) => student.grade)
        .toSet()
        .toList()
        .where((g) => g != 'All')
        .toList();

    int total = 0;
    for (final grade in grades) {
      final sections = studentsController.filteredStudents
          .where((student) => student.grade == grade)
          .map((student) => student.section)
          .toSet()
          .toList();
      total += sections.length;
    }
    return total;
  }
}
