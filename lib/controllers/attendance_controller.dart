import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:little_flower_app/models/students_model.dart';
import 'package:little_flower_app/services/attendance_services.dart';
import 'package:little_flower_app/services/students_services.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

/// Helper to format date as yyyy-MM-dd
String formatDateOnly(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class AttendanceController extends GetxController {
  final StudentServices _studentServices = StudentServices();
  final AttendanceService _attendanceService = AttendanceService();

  // UI state
  final RxBool isLoading = false.obs;
  final RxList<Student> students = <Student>[].obs;

  // attendance mapping: studentId -> present
  final RxMap<String, bool> attendance = <String, bool>{}.obs;

  final RxString selectedGrade = ''.obs;
  final RxString selectedSection = ''.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  // default present if no record exists
  final bool defaultPresent = false;

  // To check if the attendance is marked or not
  final RxBool isAttendanceMarked = false.obs;

  // Track unsaved changes
  final RxBool hasUnsavedChanges = false.obs;

  // Store initial attendance state for comparison
  final RxMap<String, bool> _initialAttendance = <String, bool>{}.obs;

  // Initialize with class
  Future<void> initForClass({
    required String grade,
    required String section,
    DateTime? date,
  }) async {
    selectedGrade.value = grade;
    selectedSection.value = section;
    selectedDate.value = date ?? DateTime.now();

    await loadStudentsAndAttendance();
  }

  Future<void> loadStudentsAndAttendance() async {
    try {
      isLoading.value = true;
      students.clear();
      attendance.clear();
      _initialAttendance.clear();
      isAttendanceMarked.value = false;
      hasUnsavedChanges.value = false;

      final grade = selectedGrade.value;
      final section = selectedSection.value;
      final dateString = formatDateOnly(selectedDate.value);

      // fetch students for class
      final sList = await _studentServices.fetchStudentsByClass(grade, section);
      students.assignAll(sList);

      // try fetching existing attendance
      final existing = await _attendanceService.fetchAttendanceForClassDate(
        grade: grade,
        section: section,
        dateString: dateString,
      );

      // Check if attendance exists for this date
      if (existing.isNotEmpty) {
        isAttendanceMarked.value = true;
        for (final s in students) {
          final status = existing[s.id] ?? defaultPresent;
          attendance[s.id ?? s.rollNumber] = status;
          _initialAttendance[s.id ?? s.rollNumber] = status;
        }
      } else {
        isAttendanceMarked.value = false;
        for (final s in students) {
          attendance[s.id ?? s.rollNumber] = defaultPresent;
          _initialAttendance[s.id ?? s.rollNumber] = defaultPresent;
        }
      }
    } catch (e, st) {
      debugPrint('Attendance load error: $e\n$st');
      isAttendanceMarked.value = false;
      final sList = await _studentServices.fetchStudentsByClass(
        selectedGrade.value,
        selectedSection.value,
      );
      students.assignAll(sList);
      for (final s in students) {
        attendance[s.id ?? s.rollNumber] = defaultPresent;
        _initialAttendance[s.id ?? s.rollNumber] = defaultPresent;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void togglePresent(String studentId) {
    attendance.update(studentId, (value) => !value, ifAbsent: () => true);
    _checkForUnsavedChanges();
    update();
  }

  void markAll(bool present) {
    final newAttendance = <String, bool>{};
    for (final student in students) {
      final sid = student.id ?? student.rollNumber;
      newAttendance[sid] = present;
    }
    attendance.value = newAttendance;
    _checkForUnsavedChanges();
    update();
  }

  void _checkForUnsavedChanges() {
    // Compare current attendance with initial state
    bool hasChanges = false;

    for (final key in attendance.keys) {
      if (attendance[key] != _initialAttendance[key]) {
        hasChanges = true;
        break;
      }
    }

    hasUnsavedChanges.value = hasChanges;
  }

  Future<void> saveAttendance() async {
    try {
      isLoading.value = true;
      final grade = selectedGrade.value;
      final section = selectedSection.value;
      final dateString = formatDateOnly(selectedDate.value);

      // Prepare map
      final map = <String, bool>{};
      for (final s in students) {
        final id = s.id ?? s.rollNumber;
        map[id] = attendance[id] ?? defaultPresent;
      }

      await _attendanceService.saveAttendanceBatch(
        grade: grade,
        section: section,
        dateString: dateString,
        attendanceMap: map,
      );

      // Update initial state after successful save
      _initialAttendance.value = Map<String, bool>.from(attendance);
      isAttendanceMarked.value = true;
      hasUnsavedChanges.value = false;

      AppSnackbar.success('Attendance saved for $grade - $section on $dateString');
    } catch (e) {
      debugPrint('Save attendance error: $e');
      AppSnackbar.error('Failed to save attendance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // change selected date
  Future<void> changeDate(DateTime newDate) async {
    selectedDate.value = newDate;
    await loadStudentsAndAttendance();
  }

  @override
  void onClose() {
    // Clean up when controller is disposed
    students.clear();
    attendance.clear();
    _initialAttendance.clear();
    super.onClose();
  }
}
