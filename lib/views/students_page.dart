import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/students_controller.dart';
import 'package:little_flower_app/models/students_model.dart';
import 'package:little_flower_app/utils/colors.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

class StudentsView extends GetView<StudentsController> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 14),
                // HEADER
                _buildCustomHeader(),
                SizedBox(height: 20),

                // SEARCH + FILTERS
                _buildSearchAndFilters(),
                SizedBox(height: 20.h),

                // STUDENTS LIST (not expanded!)
                Obx(() {
                  if (controller.isLoading.value) {
                    return _buildStudentsLoading();
                  }

                  final displayedStudents = controller.filteredStudents.where((
                    student,
                  ) {
                    return controller.showInactiveStudents.value
                        ? true
                        : student.isActive;
                  }).toList();

                  if (displayedStudents.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    itemCount: displayedStudents.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // VERY IMPORTANT
                    itemBuilder: (context, index) {
                      return _buildStudentCard(displayedStudents[index], index);
                    },
                  );
                }),

                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(),
        backgroundColor: AppColors.darkBlue,
        child: Icon(Icons.add_rounded, color: Colors.white, size: 24.w),
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Row(
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
              'Student Management',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        // Student count with filter status
        Obx(() => _buildStudentCount()),
        SizedBox(height: 16.h),

        // Search Bar
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search students...',
            prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF718096)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.darkBlue),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
          onChanged: (value) {
            controller.searchStudents(value);
          },
        ),
        SizedBox(height: 12.h),

        // Filters Row
        Row(
          children: [
            Expanded(
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedGrade.value,
                      isExpanded: true,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color(0xFF718096),
                      ),
                      items: controller.grades.map((String grade) {
                        return DropdownMenuItem(
                          value: grade,
                          child: Text(
                            grade == 'All' ? 'All Grades' : 'Grade $grade',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.selectedGrade.value = newValue!;
                        controller.applyFilters();
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedSection.value,
                      isExpanded: true,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Color(0xFF718096),
                      ),
                      items: controller.sections.map((String section) {
                        return DropdownMenuItem(
                          value: section,
                          child: Text(
                            section == 'All'
                                ? 'All Sections'
                                : 'Section $section',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.selectedSection.value = newValue!;
                        controller.applyFilters();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Show Inactive Students Toggle
        Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            controller.showInactiveStudents.value
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: AppColors.green,
                            size: 18.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.showInactiveStudents.value
                                    ? 'Showing All Students'
                                    : 'Showing Active Students',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                controller.showInactiveStudents.value
                                    ? 'Including inactive accounts'
                                    : 'Active accounts only',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: controller.showInactiveStudents.value,
                          onChanged: (value) async {
                            await controller.toggleInactiveStudents();
                          },
                          activeColor: AppColors.green,
                          inactiveTrackColor: AppColors.green.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCount() {
    final totalStudents = controller.students.length;
    final activeStudents = controller.students.where((s) => s.isActive).length;
    final inactiveStudents = controller.students
        .where((s) => !s.isActive)
        .length;
    final filteredCount = controller.filteredStudents.length;
    final hasFilters =
        controller.selectedGrade.value != 'All' ||
        controller.selectedSection.value != 'All' ||
        searchController.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hasFilters
                  ? 'Showing $filteredCount students'
                  : 'Total Students: $totalStudents',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF718096),
              ),
            ),
            if (hasFilters && filteredCount != totalStudents)
              GestureDetector(
                onTap: () {
                  controller.selectedGrade.value = 'All';
                  controller.selectedSection.value = 'All';
                  searchController.clear();
                  controller.applyFilters();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.close_rounded,
                        size: 14.w,
                        color: AppColors.darkBlue,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Clear filters',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          'Active: $activeStudents • Inactive: $inactiveStudents',
          style: TextStyle(fontSize: 12.sp, color: Color(0xFFA0AEC0)),
        ),
      ],
    );
  }

  Widget _buildStudentsLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Loading avatar
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 16.w),
              // Loading content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 80.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: 150.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudentCard(Student student, int index) {
    // Get rotating color based on index
    final avatarColor = _getAvatarColor(index);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: !student.isActive
              ? Colors.red.withOpacity(0.3)
              : Colors.transparent,
          width: !student.isActive ? 1 : 0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => _showStudentDetails(student),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Student Avatar with rotating colored background
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: !student.isActive
                        ? Colors.red
                        : avatarColor, // Use rotating color for active students
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white, // Always white icon
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 16.w),

                // Student Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            student.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          if (!student.isActive) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'Inactive',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Grade ${student.grade} - Section ${student.section}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Roll No: ${student.rollNumber}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Color(0xFF718096),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Parent: ${student.parentName}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),

                // Different popup menu for active vs inactive students
                _buildStudentPopupMenu(student),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Separate method for popup menu based on student status
  Widget _buildStudentPopupMenu(Student student) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: Color(0xFF718096), size: 20.w),
      onSelected: (value) {
        if (value == 'edit') {
          _showEditStudentDialog(student);
        } else if (value == 'toggle_status') {
          if (student.isActive) {
            _showDeactivateConfirmation(student);
          } else {
            _showActivateConfirmation(student);
          }
        } else if (value == 'permanent_delete') {
          _showPermanentDeleteConfirmation(student);
        }
      },
      itemBuilder: (context) {
        if (student.isActive) {
          // Menu for active students
          return [
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: AppColors.darkBlue,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'toggle_status',
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.person_off_rounded,
                      color: AppColors.darkBlue,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Deactivate'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'permanent_delete',
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Delete'),
                ],
              ),
            ),
          ];
        } else {
          // Menu for inactive students
          return [
            PopupMenuItem(
              value: 'toggle_status',
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.darkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.darkBlue,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Activate'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'permanent_delete',
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text('Permanently Delete'),
                ],
              ),
            ),
          ];
        }
      },
    );
  }

  // Add this helper method for rotating colors
  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightBlue,
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightBlue,
    ];
    return colors[index % colors.length];
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
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 48.w,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            controller.showInactiveStudents.value
                ? 'No Inactive Students'
                : 'No Students Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.selectedGrade.value != 'All' ||
                    controller.selectedSection.value != 'All' ||
                    searchController.text.isNotEmpty
                ? 'Try changing your filters or search term'
                : controller.showInactiveStudents.value
                ? 'All students are currently active'
                : 'Add students to start managing your class',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFFA0AEC0)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          if (!controller.showInactiveStudents.value)
            ElevatedButton(
              onPressed: () => _showAddStudentDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Add First Student',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  void _showAddStudentDialog() {
    final nameController = TextEditingController();
    final rollNumberController = TextEditingController();
    final parentNameController = TextEditingController();

    String selectedGrade = '1';
    String selectedSection = 'A';

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add New Student',
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

                    _buildTextFieldWithValidation(
                      controller: nameController,
                      label: 'Student Name',
                      hintText: 'Enter student name',
                      allowSpaces: true,
                      maxLength: 50,
                    ),
                    SizedBox(height: 16.h),

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
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedGrade,
                                    isExpanded: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Color(0xFF718096),
                                    ),
                                    items:
                                        List.generate(
                                          12,
                                          (index) => (index + 1).toString(),
                                        ).map((String grade) {
                                          return DropdownMenuItem(
                                            value: grade,
                                            child: Text('Grade $grade'),
                                          );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGrade = newValue!;
                                      });
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
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedSection,
                                    isExpanded: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Color(0xFF718096),
                                    ),
                                    items: ['A', 'B', 'C', 'D'].map((
                                      String section,
                                    ) {
                                      return DropdownMenuItem(
                                        value: section,
                                        child: Text('Section $section'),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedSection = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    _buildTextFieldWithValidation(
                      controller: rollNumberController,
                      label: 'Roll Number',
                      hintText: 'Enter roll number',
                      allowSpaces: false,
                      numbersOnly: true,
                      maxLength: 3,
                    ),
                    SizedBox(height: 16.h),

                    _buildTextFieldWithValidation(
                      controller: parentNameController,
                      label: 'Parent Name',
                      hintText: 'Enter parent name',
                      allowSpaces: true,
                      maxLength: 50,
                    ),

                    SizedBox(height: 24.h),
                    Obx(
                      () => controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.darkBlue,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      side: BorderSide(color: AppColors.darkBlue),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.darkBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_validateForm(
                                        nameController.text,
                                        rollNumberController.text,
                                        parentNameController.text,
                                      )) {
                                        final student = Student(
                                          name: nameController.text.trim(),
                                          grade: selectedGrade,
                                          section: selectedSection,
                                          rollNumber: rollNumberController.text
                                              .trim(),
                                          parentName: parentNameController.text
                                              .trim(),
                                          isActive: true,
                                        );

                                        final validationError = student
                                            .validate();
                                        if (validationError != null) {
                                          AppSnackbar.error(validationError);
                                          return;
                                        }

                                        controller.addStudent(student);
                                        Get.back();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.darkBlue,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Add Student',
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextFieldWithValidation({
    required TextEditingController controller,
    required String label,
    required String hintText,
    bool allowSpaces = false,
    bool numbersOnly = false,
    int? maxLength,
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
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.darkBlue),
            ),
            filled: true,
            fillColor: Colors.white,
            counterText: '',
          ),
          onChanged: (value) {
            String filteredValue = value;

            if (numbersOnly) {
              filteredValue = value.replaceAll(RegExp(r'[^0-9]'), '');
            } else {
              if (allowSpaces) {
                filteredValue = value.replaceAll(RegExp(r'[^a-zA-Z ]'), '');
              } else {
                filteredValue = value.replaceAll(RegExp(r'[^a-zA-Z]'), '');
              }

              if (allowSpaces) {
                filteredValue = filteredValue.replaceAll(RegExp(r'\s+'), ' ');
              }
            }

            if (filteredValue != value) {
              controller.value = controller.value.copyWith(
                text: filteredValue,
                selection: TextSelection.collapsed(
                  offset: filteredValue.length,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  bool _validateForm(String name, String rollNumber, String parentName) {
    if (name.isEmpty) {
      AppSnackbar.error('Please enter student name');
      return false;
    }

    if (rollNumber.isEmpty) {
      AppSnackbar.error('Please enter roll number');
      return false;
    }

    if (parentName.isEmpty) {
      AppSnackbar.error('Please enter parent name');
      return false;
    }

    return true;
  }

  void _showEditStudentDialog(Student student) {
    final nameController = TextEditingController(text: student.name);
    final rollNumberController = TextEditingController(
      text: student.rollNumber,
    );
    final parentNameController = TextEditingController(
      text: student.parentName,
    );

    String selectedGrade = student.grade;
    String selectedSection = student.section;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Edit Student',
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

                    _buildTextFieldWithValidation(
                      controller: nameController,
                      label: 'Student Name',
                      hintText: 'Enter student name',
                      allowSpaces: true,
                      maxLength: 50,
                    ),
                    SizedBox(height: 16.h),

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
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedGrade,
                                    isExpanded: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Color(0xFF718096),
                                    ),
                                    items:
                                        List.generate(
                                          12,
                                          (index) => (index + 1).toString(),
                                        ).map((String grade) {
                                          return DropdownMenuItem(
                                            value: grade,
                                            child: Text('Grade $grade'),
                                          );
                                        }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedGrade = newValue!;
                                      });
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
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedSection,
                                    isExpanded: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Color(0xFF718096),
                                    ),
                                    items: ['A', 'B', 'C', 'D'].map((
                                      String section,
                                    ) {
                                      return DropdownMenuItem(
                                        value: section,
                                        child: Text('Section $section'),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedSection = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    _buildTextFieldWithValidation(
                      controller: rollNumberController,
                      label: 'Roll Number',
                      hintText: 'Enter roll number',
                      allowSpaces: false,
                      numbersOnly: true,
                      maxLength: 3,
                    ),
                    SizedBox(height: 16.h),

                    _buildTextFieldWithValidation(
                      controller: parentNameController,
                      label: 'Parent Name',
                      hintText: 'Enter parent name',
                      allowSpaces: true,
                      maxLength: 50,
                    ),

                    SizedBox(height: 24.h),
                    Obx(
                      () => controller.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.darkBlue,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Get.back(),
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      side: BorderSide(color: AppColors.darkBlue),
                                    ),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.darkBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_validateForm(
                                        nameController.text,
                                        rollNumberController.text,
                                        parentNameController.text,
                                      )) {
                                        final updatedStudent = student.copyWith(
                                          name: nameController.text.trim(),
                                          grade: selectedGrade,
                                          section: selectedSection,
                                          rollNumber: rollNumberController.text
                                              .trim(),
                                          parentName: parentNameController.text
                                              .trim(),
                                        );

                                        final validationError = updatedStudent
                                            .validate();
                                        if (validationError != null) {
                                          AppSnackbar.error(validationError);
                                          return;
                                        }

                                        if (student.id != null) {
                                          controller.updateStudent(
                                            student.id!,
                                            updatedStudent,
                                          );
                                        }
                                        Get.back();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.darkBlue,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    ),
                                    child: Text(
                                      'Update Student',
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // void _showToggleStatusDialog(Student student) {
  //   Get.dialog(
  //     AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.r),
  //       ),
  //       title: Row(
  //         children: [
  //           Icon(
  //             student.isActive
  //                 ? Icons.person_off_rounded
  //                 : Icons.person_rounded,
  //             color: student.isActive ? Colors.orange : AppColors.green,
  //             size: 24.w,
  //           ),
  //           SizedBox(width: 12.w),
  //           Text(
  //             student.isActive ? 'Deactivate Student' : 'Activate Student',
  //             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             student.isActive
  //                 ? 'Are you sure you want to deactivate this student?'
  //                 : 'Are you sure you want to activate this student?',
  //             style: TextStyle(fontSize: 14.sp),
  //           ),
  //           SizedBox(height: 16.h),
  //           Container(
  //             padding: EdgeInsets.all(12.w),
  //             decoration: BoxDecoration(
  //               color: Colors.grey[50],
  //               borderRadius: BorderRadius.circular(12.r),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   student.name,
  //                   style: TextStyle(
  //                     fontSize: 16.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 SizedBox(height: 4.h),
  //                 Text(
  //                   'Grade ${student.grade} - Section ${student.section}',
  //                   style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
  //                 ),
  //                 Text(
  //                   'Roll No: ${student.rollNumber}',
  //                   style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         OutlinedButton(
  //           onPressed: () => Get.back(),
  //           style: OutlinedButton.styleFrom(
  //             side: BorderSide(color: AppColors.darkBlue),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12.r),
  //             ),
  //           ),
  //           child: Text('Cancel', style: TextStyle(color: AppColors.darkBlue)),
  //         ),
  //         Obx(
  //           () => controller.isLoading.value
  //               ? CircularProgressIndicator(color: AppColors.darkBlue)
  //               : ElevatedButton(
  //                   onPressed: () async {
  //                     final updatedStudent = student.copyWith(
  //                       isActive: !student.isActive,
  //                     );
  //                     if (student.id != null) {
  //                       await controller.updateStudent(
  //                         student.id!,
  //                         updatedStudent,
  //                       );
  //                     }
  //                     Get.back();
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: student.isActive
  //                         ? Colors.orange
  //                         : AppColors.green,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(12.r),
  //                     ),
  //                   ),
  //                   child: Text(
  //                     student.isActive ? 'Deactivate' : 'Activate',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void _showActivateConfirmation(Student student) {
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
                  color: AppColors.darkBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_add_rounded,
                  size: 32.w,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Activate Student?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Do you want to activate ${student.name}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 8.h),
              Text(
                'Roll No: ${student.rollNumber} | Grade ${student.grade}-${student.section}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w500,
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
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.reactivateStudent(student.id!);
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
                        'Activate',
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

  void _showDeactivateConfirmation(Student student) {
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
                  color: AppColors.darkBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_off_rounded,
                  size: 32.w,
                  color: AppColors.darkBlue,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Deactivate Student?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Do you want to deactivate ${student.name}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 8.h),
              Text(
                'This will make the student inactive but preserve their data.',
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
                    child: ElevatedButton(
                      onPressed: () {
                        controller.deactivateStudent(student.id!);
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
                        'Deactivate',
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

  void _showStudentDetails(Student student) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: !student.isActive
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.darkBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.person_rounded,
                color: !student.isActive ? Colors.red : AppColors.darkBlue,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Student Details',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Name', student.name),
              _buildDetailItem('Grade', student.grade),
              _buildDetailItem('Section', student.section),
              _buildDetailItem('Roll Number', student.rollNumber),
              _buildDetailItem('Parent Name', student.parentName),
              _buildDetailItem(
                'Status',
                student.isActive ? 'Active' : 'Inactive',
                valueColor: student.isActive ? AppColors.green : Colors.red,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close', style: TextStyle(color: AppColors.darkBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              color: valueColor ?? Color(0xFF2D3748),
              fontWeight: valueColor != null
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showPermanentDeleteConfirmation(Student student) {
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
              /// ICON
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  size: 32.w,
                  color: Colors.red,
                ),
              ),

              SizedBox(height: 16.h),

              /// TITLE
              Text(
                'Delete Student?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),

              SizedBox(height: 12.h),

              /// DESCRIPTION
              Text(
                'Do you want to permanently delete ${student.name}?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 8.h),
              Text(
                '⚠️ This action cannot be undone. All student data will be permanently removed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.sp, color: Color(0xFF718096)),
              ),

              SizedBox(height: 18.h),

              /// STUDENT INFORMATION BOX
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Grade ${student.grade} • Section ${student.section}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Roll No: ${student.rollNumber}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Parent: ${student.parentName}",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              /// ACTION BUTTONS
              Row(
                children: [
                  /// CANCEL BUTTON
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

                  /// DELETE BUTTON
                  Expanded(
                    child: Obx(
                      () => controller.isLoading.value
                          ? Container(
                              height: 48.h, // Match button height
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 24.w, // Fixed width
                                height: 24
                                    .w, // Fixed height (same as width for circle)
                                child: CircularProgressIndicator(
                                  strokeWidth: 3.w,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.red,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (student.id != null) {
                                  final success = await controller
                                      .permanentlyDeleteStudent(student.id!);
                                  if (success) {
                                    Get.back(); // Only close if successful
                                  }
                                  // If not successful, don't close so user can try again
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
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
