// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:little_flower_app/controllers/attendance_controller.dart';
// import 'package:little_flower_app/models/students_model.dart';
// import 'package:intl/intl.dart';

// class AttendanceMarkView extends StatelessWidget {
//   final String grade;
//   final String section;

//   AttendanceMarkView({Key? key, required this.grade, required this.section})
//     : super(key: key);

//   final AttendanceController ctrl = Get.find<AttendanceController>();

//   @override
//   Widget build(BuildContext context) {
//     // Initialize on first build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ctrl.initForClass(grade: grade, section: section);
//     });

//     return WillPopScope(
//       onWillPop: () => _onWillPop(),
//       child: Scaffold(
//         backgroundColor: Color(0xFFF8F9FA),
//         appBar: AppBar(
//           title: Text(
//             'Grade $grade - Section $section',
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: Color(0xFF4361EE),
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(20.r),
//               bottomRight: Radius.circular(20.r),
//             ),
//           ),
//         ),
//         body: Obx(() {
//           if (ctrl.isLoading.value) {
//             return _buildLoadingState();
//           }

//           if (ctrl.students.isEmpty) {
//             return _buildEmptyState();
//           }

//           return Column(
//             children: [
//               // Header with date and stats
//               Container(
//                 padding: EdgeInsets.all(16.w),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(20.r),
//                     bottomRight: Radius.circular(20.r),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Attendance',
//                           style: TextStyle(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF2D3748),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 6.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF4361EE).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20.r),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.calendar_today_rounded,
//                                 size: 14.w,
//                                 color: Color(0xFF4361EE),
//                               ),
//                               SizedBox(width: 6.w),
//                               GestureDetector(
//                                 onTap: () async {
//                                   final picked = await showDatePicker(
//                                     context: context,
//                                     initialDate: ctrl.selectedDate.value,
//                                     firstDate: DateTime.now().subtract(
//                                       Duration(days: 365),
//                                     ),
//                                     lastDate: DateTime.now().add(
//                                       Duration(days: 365),
//                                     ),
//                                   );
//                                   if (picked != null) {
//                                     await ctrl.changeDate(picked);
//                                   }
//                                 },
//                                 child: Text(
//                                   DateFormat(
//                                     'MMM dd, yyyy',
//                                   ).format(ctrl.selectedDate.value),
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF4361EE),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Attendance not marked indicator
//                     Obx(() {
//                       if (!ctrl.isAttendanceMarked.value) {
//                         return Container(
//                           margin: EdgeInsets.only(top: 8.h),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12.w,
//                             vertical: 6.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange[50],
//                             borderRadius: BorderRadius.circular(8.r),
//                             border: Border.all(color: Colors.orange[300]!),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.info_outline_rounded,
//                                 size: 14.w,
//                                 color: Colors.orange[700],
//                               ),
//                               SizedBox(width: 6.w),
//                               Text(
//                                 'Attendance not marked for this date',
//                                 style: TextStyle(
//                                   fontSize: 12.sp,
//                                   color: Colors.orange[700],
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }
//                       return SizedBox.shrink();
//                     }),
//                     SizedBox(height: 12.h),
//                     Obx(() {
//                       final presentCount = ctrl.attendance.values
//                           .where((present) => present)
//                           .length;
//                       final totalCount = ctrl.students.length;

//                       return Column(
//                         children: [
//                           Row(
//                             children: [
//                               _buildStatItem(
//                                 'Present',
//                                 presentCount.toString(),
//                                 Colors.green,
//                               ),
//                               SizedBox(width: 8.w),
//                               _buildStatItem(
//                                 'Absent',
//                                 (totalCount - presentCount).toString(),
//                                 Colors.red,
//                               ),
//                               SizedBox(width: 8.w),
//                               _buildStatItem(
//                                 'Total',
//                                 totalCount.toString(),
//                                 Color(0xFF4361EE),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12.h),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () {
//                                     ctrl.markAll(true);
//                                     Get.snackbar(
//                                       'All Marked Present',
//                                       'All students have been marked as present',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       backgroundColor: Colors.green,
//                                       colorText: Colors.white,
//                                       duration: Duration(seconds: 2),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                     foregroundColor: Colors.white,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8.r),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: 10.h,
//                                     ),
//                                   ),
//                                   icon: Icon(Icons.check_circle, size: 16.w),
//                                   label: Text(
//                                     'Mark All Present',
//                                     style: TextStyle(fontSize: 12.sp),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 8.w),
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () {
//                                     ctrl.markAll(false);
//                                     Get.snackbar(
//                                       'All Marked Absent',
//                                       'All students have been marked as absent',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       backgroundColor: Colors.red,
//                                       colorText: Colors.white,
//                                       duration: Duration(seconds: 2),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                     foregroundColor: Colors.white,
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8.r),
//                                     ),
//                                     padding: EdgeInsets.symmetric(
//                                       vertical: 10.h,
//                                     ),
//                                   ),
//                                   icon: Icon(Icons.cancel, size: 16.w),
//                                   label: Text(
//                                     'Mark All Absent',
//                                     style: TextStyle(fontSize: 12.sp),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16.h),

//               // Students List
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 16.w),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16.r),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: ListView.separated(
//                     padding: EdgeInsets.all(0),
//                     itemCount: ctrl.students.length,
//                     separatorBuilder: (_, __) => Divider(
//                       height: 1.h,
//                       indent: 16.w,
//                       endIndent: 16.w,
//                       color: Colors.grey[100],
//                     ),
//                     itemBuilder: (context, index) {
//                       final Student s = ctrl.students[index];
//                       final sid = s.id ?? s.rollNumber;

//                       return Container(
//                         margin: EdgeInsets.symmetric(vertical: 4.h),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(12.r),
//                             onTap: () => ctrl.togglePresent(sid),
//                             child: Padding(
//                               padding: EdgeInsets.all(16.w),
//                               child: Row(
//                                 children: [
//                                   // Student Avatar
//                                   Container(
//                                     width: 44.w,
//                                     height: 44.w,
//                                     decoration: BoxDecoration(
//                                       color: Color(0xFF4361EE).withOpacity(0.1),
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Icon(
//                                       Icons.person_rounded,
//                                       color: Color(0xFF4361EE),
//                                       size: 20.w,
//                                     ),
//                                   ),
//                                   SizedBox(width: 12.w),

//                                   // Student Info
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           s.name,
//                                           style: TextStyle(
//                                             fontSize: 14.sp,
//                                             fontWeight: FontWeight.w600,
//                                             color: Color(0xFF2D3748),
//                                           ),
//                                         ),
//                                         SizedBox(height: 2.h),
//                                         Text(
//                                           'Roll No: ${s.rollNumber}',
//                                           style: TextStyle(
//                                             fontSize: 12.sp,
//                                             color: Colors.grey[600],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   // Attendance Radio Buttons
//                                   Obx(() {
//                                     final present =
//                                         ctrl.attendance[sid] ??
//                                         ctrl.defaultPresent;
//                                     return Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         _buildAttendanceRadio(
//                                           value: true,
//                                           groupValue: present,
//                                           label: 'Present',
//                                           color: Colors.green,
//                                           onChanged: () =>
//                                               ctrl.togglePresent(sid),
//                                           icon: Icons.check,
//                                         ),
//                                         SizedBox(width: 16.w),
//                                         _buildAttendanceRadio(
//                                           value: false,
//                                           groupValue: present,
//                                           label: 'Absent',
//                                           color: Colors.red,
//                                           onChanged: () =>
//                                               ctrl.togglePresent(sid),
//                                           icon: Icons.close,
//                                         ),
//                                       ],
//                                     );
//                                   }),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               // Save Button
//               Container(
//                 padding: EdgeInsets.all(16.w),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 52.h,
//                   child: Obx(
//                     () => ElevatedButton(
//                       onPressed: ctrl.isLoading.value
//                           ? null
//                           : () => ctrl.saveAttendance(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF4361EE),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.r),
//                         ),
//                         disabledBackgroundColor: Color(
//                           0xFF4361EE,
//                         ).withOpacity(0.5),
//                       ),
//                       child: ctrl.isLoading.value
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 20.w,
//                                   height: 20.w,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2.w,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 SizedBox(width: 12.w),
//                                 Text(
//                                   'Saving...',
//                                   style: TextStyle(fontSize: 16.sp),
//                                 ),
//                               ],
//                             )
//                           : Text(
//                               'Save Attendance',
//                               style: TextStyle(
//                                 fontSize: 16.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   Future<bool> _onWillPop() async {
//     if (!ctrl.hasUnsavedChanges.value) return true;

//     final result = await Get.dialog<bool>(
//       AlertDialog(
//         title: Text('Unsaved Changes'),
//         content: Text(
//           'You have unsaved changes. Are you sure you want to leave?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(result: false),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Get.back(result: true),
//             child: Text('Leave', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     return result ?? false;
//   }

//   Widget _buildStatItem(String label, String value, Color color) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Column(
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w700,
//                 color: color,
//               ),
//             ),
//             SizedBox(height: 2.h),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 10.sp,
//                 color: color,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAttendanceRadio({
//     required bool value,
//     required bool groupValue,
//     required String label,
//     required Color color,
//     required VoidCallback onChanged,
//     required IconData icon,
//   }) {
//     final isSelected = value == groupValue;

//     return GestureDetector(
//       onTap: onChanged,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Radio button circle
//             Container(
//               width: 20.w,
//               height: 20.w,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isSelected ? color : Colors.transparent,
//                 border: Border.all(
//                   color: isSelected ? color : Colors.grey[400]!,
//                   width: 2.w,
//                 ),
//               ),
//               child: isSelected
//                   ? Icon(icon, size: 12.w, color: Colors.white)
//                   : null,
//             ),
//             SizedBox(height: 4.h),
//             // Label
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 10.sp,
//                 fontWeight: FontWeight.w500,
//                 color: isSelected ? color : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(color: Color(0xFF4361EE), strokeWidth: 3.w),
//           SizedBox(height: 16.h),
//           Text(
//             'Loading Students...',
//             style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120.w,
//             height: 120.w,
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.people_outline_rounded,
//               size: 48.w,
//               color: Colors.grey[400],
//             ),
//           ),
//           SizedBox(height: 24.h),
//           Text(
//             'No Students Found',
//             style: TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             'There are no students in this class',
//             style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:little_flower_app/controllers/attendance_controller.dart';
import 'package:little_flower_app/models/students_model.dart';
import 'package:intl/intl.dart';
import 'package:little_flower_app/utils/colors.dart';

class AttendanceMarkView extends StatelessWidget {
  final String grade;
  final String section;

  AttendanceMarkView({Key? key, required this.grade, required this.section})
    : super(key: key);

  final AttendanceController ctrl = Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    // Initialize on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctrl.initForClass(grade: grade, section: section);
    });

    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: SafeArea(
          child: Obx(() {
            if (ctrl.isLoading.value) {
              return _buildLoadingState();
            }

            if (ctrl.students.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                SizedBox(height: 12.h),
                _buildCustomHeader(),
                // Header with date and stats
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
                          Text(
                            'Attendance',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 14.w,
                                  color: AppColors.darkBlue,
                                ),
                                SizedBox(width: 6.w),
                                GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: ctrl.selectedDate.value,
                                      firstDate: DateTime.now().subtract(
                                        Duration(days: 365),
                                      ),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 365),
                                      ),
                                    );
                                    if (picked != null) {
                                      await ctrl.changeDate(picked);
                                    }
                                  },
                                  child: Text(
                                    DateFormat(
                                      'MMM dd, yyyy',
                                    ).format(ctrl.selectedDate.value),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Attendance not marked indicator
                      Obx(() {
                        if (!ctrl.isAttendanceMarked.value) {
                          return Container(
                            margin: EdgeInsets.only(top: 12.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  size: 14.w,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  'Attendance not marked for this date',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      }),
                      SizedBox(height: 16.h),
                      Obx(() {
                        final presentCount = ctrl.attendance.values
                            .where((present) => present)
                            .length;
                        final totalCount = ctrl.students.length;

                        return Column(
                          children: [
                            Row(
                              children: [
                                _buildStatItem(
                                  'Present',
                                  presentCount.toString(),
                                  AppColors.green,
                                ),
                                SizedBox(width: 8.w),
                                _buildStatItem(
                                  'Absent',
                                  (totalCount - presentCount).toString(),
                                  Colors.red.withOpacity(0.5),
                                ),
                                SizedBox(width: 8.w),
                                _buildStatItem(
                                  'Total',
                                  totalCount.toString(),
                                  AppColors.lightBlue,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ctrl.markAll(true);
                                      Get.snackbar(
                                        'All Marked Present',
                                        'All students have been marked as present',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Color(0xFF06D6A0),
                                        colorText: Colors.black,
                                        duration: Duration(seconds: 2),
                                        borderRadius: 12.r,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.green
                                          .withOpacity(0.5),
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                    ),
                                    icon: Icon(Icons.check_circle, size: 16.w),
                                    label: Text(
                                      'Mark All Present',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ctrl.markAll(false);
                                      Get.snackbar(
                                        'All Marked Absent',
                                        'All students have been marked as absent',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red.withOpacity(
                                          0.5,
                                        ),
                                        colorText: Colors.black,
                                        duration: Duration(seconds: 2),
                                        borderRadius: 12.r,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.withOpacity(
                                        0.5,
                                      ),
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                    ),
                                    icon: Icon(Icons.cancel, size: 16.w),
                                    label: Text(
                                      'Mark All Absent',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Students List
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemCount: ctrl.students.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1.h,
                        indent: 20.w,
                        endIndent: 20.w,
                        color: Color(0xFFE2E8F0),
                      ),
                      itemBuilder: (context, index) {
                        final Student s = ctrl.students[index];
                        final sid = s.id ?? s.rollNumber;

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20.r),
                              onTap: () => ctrl.togglePresent(sid),
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Row(
                                  children: [
                                    // Student Avatar with rotating colors
                                    Container(
                                      width: 50.w,
                                      height: 50.w,
                                      decoration: BoxDecoration(
                                        color: _getAvatarColor(
                                          index,
                                        ), // Use index-based color rotation
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Colors.white,
                                        size: 24.w,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),

                                    // Student Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF2D3748),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Roll No: ${s.rollNumber}',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Color(0xFF718096),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Attendance Radio Buttons
                                    Obx(() {
                                      final present =
                                          ctrl.attendance[sid] ??
                                          ctrl.defaultPresent;
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildAttendanceRadio(
                                            value: true,
                                            groupValue: present,
                                            label: 'Present',
                                            color: Color(0xFF06D6A0),
                                            onChanged: () =>
                                                ctrl.togglePresent(sid),
                                            icon: Icons.check,
                                          ),
                                          SizedBox(height: 12.w),
                                          _buildAttendanceRadio(
                                            value: false,
                                            groupValue: present,
                                            label: 'Absent',
                                            color: Colors.red,
                                            onChanged: () =>
                                                ctrl.togglePresent(sid),
                                            icon: Icons.close,
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Save Button
                Container(
                  padding: EdgeInsets.all(16.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: ctrl.isLoading.value
                            ? null
                            : () => ctrl.saveAttendance(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          disabledBackgroundColor: AppColors.darkBlue
                              .withOpacity(0.5),
                        ),
                        child: ctrl.isLoading.value
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
                                    'Saving...',
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                ],
                              )
                            : Text(
                                'Save Attendance',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
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
                'Grade $grade - Section $section',
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

  Future<bool> _onWillPop() async {
    if (!ctrl.hasUnsavedChanges.value) return true;

    final result = await Get.dialog<bool>(
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
              Text(
                'Unsaved Changes',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'You have unsaved changes. Are you sure you want to leave?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
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
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Leave'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRadio({
    required bool value,
    required bool groupValue,
    required String label,
    required Color color,
    required VoidCallback onChanged,
    required IconData icon,
  }) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: onChanged,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? color : Color(0xFFE2E8F0),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Color(0xFF718096),
                  width: 1.w,
                ),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.darkBlue,
              strokeWidth: 2,
            ),
            SizedBox(height: 20.h),
            Text(
              'Loading Students',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
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
              color: AppColors.darkBlue,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Students Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'There are no students in this class',
            style: TextStyle(fontSize: 14.sp, color: Color(0xFF718096)),
          ),
        ],
      ),
    );
  }

  Color _getAvatarColor(int index) {
    // Define color palette similar to dashboard management tiles
    final colors = [
      AppColors.pink,
      AppColors.green,
      AppColors.yellow,
      AppColors.lightBlue,
      AppColors.pink, // Announcements color
      AppColors.lightBlue, // Staff management color
      AppColors.darkBlue, // Primary dark blue
      Color(0xFF06D6A0), // Green
    ];

    // Rotate colors based on index to ensure variety
    return colors[index % colors.length];
  }
}
