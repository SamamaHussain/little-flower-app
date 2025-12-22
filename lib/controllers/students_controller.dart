import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:little_flower_app/models/students_model.dart';
import 'package:little_flower_app/services/students_services.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

class StudentsController extends GetxController {
  final RxList<Student> students = <Student>[].obs;
  final RxList<Student> filteredStudents = <Student>[].obs;
  final StudentServices _studentServices = StudentServices();
  final RxBool isLoading = false.obs;
  final RxString selectedGrade = 'All'.obs;
  final RxString selectedSection = 'All'.obs;
  final RxBool showInactiveStudents = false.obs;

  final List<String> grades = [
    'All',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];
  final List<String> sections = ['All', 'A', 'B', 'C', 'D'];

  @override
  void onInit() {
    fetchStudents();
    super.onInit();
  }

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      // Always fetch ALL students from Firestore
      final studentsList = await _studentServices.fetchAllStudents(
        showInactive: true,
      );
      students.assignAll(studentsList);
      applyFilters();
    } catch (e) {
      print('Error fetching students: $e');
      // Fallback to demo data for development
      students.assignAll(_getDemoStudents());
      applyFilters();
      AppSnackbar.warning('Using demo data. Check your connection.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleInactiveStudents() async {
    showInactiveStudents.value = !showInactiveStudents.value;
    applyFilters(); // Just apply filters, no need to reload from Firestore
  }

  void applyFilters() {
    print('Applying filters - showInactive: ${showInactiveStudents.value}');
    print('Total students: ${students.length}');
    print('Active students: ${students.where((s) => s.isActive).length}');
    print('Inactive students: ${students.where((s) => !s.isActive).length}');

    filteredStudents.assignAll(
      students.where((student) {
        final gradeMatch =
            selectedGrade.value == 'All' ||
            student.grade == selectedGrade.value;
        final sectionMatch =
            selectedSection.value == 'All' ||
            student.section == selectedSection.value;

        // The key fix:
        // When showInactiveStudents is TRUE, show ALL students (both active and inactive)
        // When showInactiveStudents is FALSE, show ONLY active students
        final statusMatch = showInactiveStudents.value
            ? true
            : student.isActive;

        final shouldInclude = gradeMatch && sectionMatch && statusMatch;

        if (shouldInclude) {
          print(
            'Including student: ${student.name} (Active: ${student.isActive})',
          );
        }

        return shouldInclude;
      }).toList(),
    );

    print('Filtered students count: ${filteredStudents.length}');
    print(
      'Filtered active: ${filteredStudents.where((s) => s.isActive).length}',
    );
    print(
      'Filtered inactive: ${filteredStudents.where((s) => !s.isActive).length}',
    );
  }

  // Rest of your methods remain the same...
  Future<void> addStudent(Student student) async {
    try {
      // Check if roll number already exists
      final rollNumberExists = await _studentServices.checkRollNumberExists(
        student.grade,
        student.section,
        student.rollNumber,
      );

      if (rollNumberExists) {
        AppSnackbar.error('Roll number ${student.rollNumber} already exists in ${student.grade}-${student.section}');
        return;
      }

      await _studentServices.addStudent(student);
      await fetchStudents(); // Refresh the list
      AppSnackbar.success('Student added successfully');
    } catch (e) {
      print('Error adding student: $e');
      AppSnackbar.error('Failed to add student: ${e.toString()}'
      );
    }
  }

  Future<void> updateStudent(String studentId, Student updatedStudent) async {
    try {
      // Check if roll number already exists (excluding current student)
      final rollNumberExists = await _studentServices.checkRollNumberExists(
        updatedStudent.grade,
        updatedStudent.section,
        updatedStudent.rollNumber,
        excludeStudentId: studentId,
      );

      if (rollNumberExists) {
        AppSnackbar.error('Roll number ${updatedStudent.rollNumber} already exists in ${updatedStudent.grade}-${updatedStudent.section}');
        return;
      }

      await _studentServices.updateStudent(studentId, updatedStudent);
      await fetchStudents(); // Refresh the list
      AppSnackbar.success('Student updated successfully');
    } catch (e) {
      print('Error updating student: $e');
      AppSnackbar.error('Failed to update student: ${e.toString()}');
    }
  }

  // Add these methods to your StudentsController class

  // ---------------------------------------------------------------------------
  // PERMANENTLY DELETE STUDENT (HARD DELETE)
  // ---------------------------------------------------------------------------
  Future<bool> permanentlyDeleteStudent(String studentId) async {
    try {
      isLoading.value = true;

      await _studentServices.permanentlyDeleteStudent(studentId);
      await fetchStudents(); // Refresh the list

      AppSnackbar.success('Student permanently deleted');
      return true;
    } catch (e) {
      print('Error permanently deleting student: $e');
      AppSnackbar.error('Failed to delete student: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // GET ACTIVE STUDENTS BY CLASS
  // ---------------------------------------------------------------------------
  Future<List<Student>> fetchActiveStudentsByClass(
    String grade,
    String section,
  ) async {
    try {
      return await _studentServices.fetchActiveStudentsByClass(grade, section);
    } catch (e) {
      print('Error fetching active students by class: $e');
      // Fallback to local filtering if service fails
      return students
          .where(
            (student) =>
                student.isActive &&
                student.grade == grade &&
                student.section == section,
          )
          .toList();
    }
  }

  // ---------------------------------------------------------------------------
  // BULK DELETE INACTIVE STUDENTS
  // ---------------------------------------------------------------------------
  Future<void> bulkDeleteInactiveStudents() async {
    try {
      isLoading.value = true;

      final inactiveStudents = students.where((s) => !s.isActive).toList();

      if (inactiveStudents.isEmpty) {
        AppSnackbar.info('No inactive students found');
        return;
      }

      // Show confirmation dialog
      final bool confirmDelete = await Get.dialog(
        AlertDialog(
          title: Text('Delete All Inactive Students'),
          content: Text(
            'This will permanently delete ${inactiveStudents.length} inactive student(s). This action cannot be undone. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Delete All', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (!confirmDelete) {
        isLoading.value = false;
        return;
      }

      // Delete all inactive students
      for (final student in inactiveStudents) {
        await _studentServices.permanentlyDeleteStudent(student.id as String);
      }

      await fetchStudents(); // Refresh the list

      AppSnackbar.success('${inactiveStudents.length} inactive student(s) deleted permanently');
    } catch (e) {
      print('Error bulk deleting inactive students: $e');
      AppSnackbar.error('Failed to delete inactive students: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deactivateStudent(String studentId) async {
    try {
      await _studentServices.deactivateStudent(studentId);
      await fetchStudents(); // Refresh the list
      AppSnackbar.success('Student deactivated successfully');
    } catch (e) {
      print('Error deleting student: $e');
      AppSnackbar.error('Failed to deactivate student: ${e.toString()}');
    }
  }

  Future<void> reactivateStudent(String studentId) async {
    try {
      await _studentServices.reactivateStudent(studentId);
      await fetchStudents(); // Refresh the list
      AppSnackbar.success('Student reactivated successfully');
    } catch (e) {
      print('Error reactivating student: $e');
      AppSnackbar.error('Failed to reactivate student: ${e.toString()}');
    }
  }

  Future<Student?> getStudentById(String studentId) async {
    try {
      return await _studentServices.getStudentById(studentId);
    } catch (e) {
      print('Error getting student by ID: $e');
      return null;
    }
  }

  List<Student> getStudentsByClass(String grade, String section) {
    return students.where((student) {
      return student.grade == grade &&
          student.section == section &&
          student.isActive;
    }).toList();
  }

  List<String> getUniqueGrades() {
    final grades = students
        .where((s) => s.isActive)
        .map((student) => student.grade)
        .toSet()
        .toList();
    grades.sort();
    return ['All', ...grades];
  }

  List<String> getUniqueSections() {
    final sections = students
        .where((s) => s.isActive)
        .map((student) => student.section)
        .toSet()
        .toList();
    sections.sort();
    return ['All', ...sections];
  }

  // Get students count for dashboard
  int getTotalStudentsCount() {
    return students.where((student) => student.isActive).length;
  }

  void searchStudents(String query) {
    if (query.isEmpty) {
      applyFilters();
    } else {
      filteredStudents.assignAll(
        students.where(
          (student) =>
              (student.name.toLowerCase().contains(query.toLowerCase()) ||
                  student.parentName.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  student.rollNumber.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  student.grade.toLowerCase().contains(query.toLowerCase()) ||
                  student.section.toLowerCase().contains(
                    query.toLowerCase(),
                  )) &&
              (showInactiveStudents.value ? true : student.isActive),
        ),
      );
    }
  }

  int getStudentsCountByClass(String grade, String section) {
    return students
        .where(
          (student) =>
              student.grade == grade &&
              student.section == section &&
              student.isActive,
        )
        .length;
  }

  // Demo data for development
  List<Student> _getDemoStudents() {
    return [
      Student(
        id: '1',
        name: 'John Smith',
        grade: '10',
        section: 'A',
        rollNumber: '101',
        parentName: 'Robert Smith',
        isActive: true,
      ),
      Student(
        id: '2',
        name: 'Sarah Johnson',
        grade: '10',
        section: 'B',
        rollNumber: '102',
        parentName: 'Michael Johnson',
        isActive: true,
      ),
      Student(
        id: '3',
        name: 'Mike Davis',
        grade: '9',
        section: 'A',
        rollNumber: '201',
        parentName: 'David Davis',
        isActive: true,
      ),
      // Add inactive students for testing
      Student(
        id: '4',
        name: 'Inactive Student 1',
        grade: '10',
        section: 'A',
        rollNumber: '103',
        parentName: 'Parent Name 1',
        isActive: false,
      ),
      Student(
        id: '5',
        name: 'Inactive Student 2',
        grade: '9',
        section: 'B',
        rollNumber: '202',
        parentName: 'Parent Name 2',
        isActive: false,
      ),
    ];
  }
}
