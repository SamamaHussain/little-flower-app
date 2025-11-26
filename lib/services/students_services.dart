import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:little_flower_app/models/students_model.dart';

class StudentServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all students (both active and inactive)
  Future<List<Student>> fetchAllStudents({bool showInactive = false}) async {
    try {
      Query query = _firestore
          .collection('students')
          .orderBy('grade')
          .orderBy('section')
          .orderBy('rollNumber');

      // Only filter by isActive if we DON'T want to show inactive students
      if (!showInactive) {
        query = query.where('isActive', isEqualTo: true);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        return Student.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching students: $e');
      throw e;
    }
  }

  // Add these methods to your StudentServices class

  // ---------------------------------------------------------------------------
  // COMPLETELY DELETE STUDENT FROM DATABASE (HARD DELETE)
  // ---------------------------------------------------------------------------
  Future<void> permanentlyDeleteStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
    } catch (e) {
      print('Error permanently deleting student: $e');
      throw e;
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
      final querySnapshot = await _firestore
          .collection('students')
          .where('isActive', isEqualTo: true)
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .orderBy('rollNumber')
          .get();

      return querySnapshot.docs.map((doc) {
        return Student.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching active students by class: $e');
      throw e;
    }
  }

  // Get students by class (with inactive option)
  Future<List<Student>> fetchStudentsByClass(
    String grade,
    String section, {
    bool showInactive = false,
  }) async {
    try {
      Query query = _firestore
          .collection('students')
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .orderBy('rollNumber');

      // If not showing inactive, filter only active students
      if (!showInactive) {
        query = query.where('isActive', isEqualTo: true);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        return Student.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      print('Error fetching students by class: $e');
      throw e;
    }
  }

  // Add new student
  Future<String> addStudent(Student student) async {
    try {
      final docRef = await _firestore
          .collection('students')
          .add(student.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding student: $e');
      throw e;
    }
  }

  // Update student
  Future<void> updateStudent(String studentId, Student student) async {
    try {
      await _firestore
          .collection('students')
          .doc(studentId)
          .update(student.toFirestore());
    } catch (e) {
      print('Error updating student: $e');
      throw e;
    }
  }

  // Delete student (soft delete)
  Future<void> deactivateStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).update({
        'isActive': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error deleting student: $e');
      throw e;
    }
  }

  // Reactivate student
  Future<void> reactivateStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).update({
        'isActive': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error reactivating student: $e');
      throw e;
    }
  }

  // Check if roll number already exists in class
  Future<bool> checkRollNumberExists(
    String grade,
    String section,
    String rollNumber, {
    String? excludeStudentId,
  }) async {
    try {
      Query query = _firestore
          .collection('students')
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .where('rollNumber', isEqualTo: rollNumber)
          .where('isActive', isEqualTo: true);

      if (excludeStudentId != null) {
        query = query.where(
          FieldPath.documentId,
          isNotEqualTo: excludeStudentId,
        );
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking roll number: $e');
      throw e;
    }
  }

  // Get student by ID
  Future<Student?> getStudentById(String studentId) async {
    try {
      final doc = await _firestore.collection('students').doc(studentId).get();
      if (doc.exists) {
        return Student.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error getting student by ID: $e');
      throw e;
    }
  }

  // Get students count by class
  Future<int> getStudentsCountByClass(String grade, String section) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('isActive', isEqualTo: true)
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting students count: $e');
      throw e;
    }
  }

  // Get all unique grades
  Future<List<String>> getUniqueGrades() async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('isActive', isEqualTo: true)
          .get();

      final grades = querySnapshot.docs
          .map((doc) => doc.data()['grade'] as String)
          .toSet()
          .toList();

      grades.sort();
      return grades;
    } catch (e) {
      print('Error getting unique grades: $e');
      throw e;
    }
  }

  // Get all unique sections for a grade
  Future<List<String>> getUniqueSections(String grade) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('isActive', isEqualTo: true)
          .where('grade', isEqualTo: grade)
          .get();

      final sections = querySnapshot.docs
          .map((doc) => doc.data()['section'] as String)
          .toSet()
          .toList();

      sections.sort();
      return sections;
    } catch (e) {
      print('Error getting unique sections: $e');
      throw e;
    }
  }
}
