import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:little_flower_app/models/timetable_model.dart';

class TimetableServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // GET ALL CLASS TIMETABLES
  // ---------------------------------------------------------------------------
  Future<List<ClassTimetable>> getAllClassTimetables() async {
    try {
      final querySnapshot = await _firestore
          .collection('timetables')
          .orderBy('grade')
          .orderBy('section')
          .get();

      return querySnapshot.docs.map((doc) {
        return ClassTimetable.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching timetables: $e');
      throw e;
    }
  }

  // ---------------------------------------------------------------------------
  // GET TIMETABLE FOR SPECIFIC CLASS
  // ---------------------------------------------------------------------------
  Future<ClassTimetable?> getTimetableForClass(
    String grade,
    String section,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('timetables')
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return ClassTimetable.fromFirestore(doc.data(), doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching timetable for class: $e');
      throw e;
    }
  }

  // ---------------------------------------------------------------------------
  // CREATE OR UPDATE CLASS TIMETABLE
  // ---------------------------------------------------------------------------
  Future<void> saveClassTimetable(ClassTimetable timetable) async {
    try {
      if (timetable.id.isEmpty) {
        // Create new timetable
        await _firestore.collection('timetables').add(timetable.toFirestore());
      } else {
        // Update existing timetable
        await _firestore
            .collection('timetables')
            .doc(timetable.id)
            .update(timetable.toFirestore());
      }
    } catch (e) {
      print('Error saving timetable: $e');
      throw e;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE CLASS TIMETABLE
  // ---------------------------------------------------------------------------
  Future<void> deleteClassTimetable(String timetableId) async {
    try {
      await _firestore.collection('timetables').doc(timetableId).delete();
    } catch (e) {
      print('Error deleting timetable: $e');
      throw e;
    }
  }

  // ---------------------------------------------------------------------------
  // CHECK IF TIMETABLE EXISTS FOR CLASS
  // ---------------------------------------------------------------------------
  Future<bool> timetableExists(String grade, String section) async {
    try {
      final querySnapshot = await _firestore
          .collection('timetables')
          .where('grade', isEqualTo: grade)
          .where('section', isEqualTo: section)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking timetable existence: $e');
      throw e;
    }
  }

  // ---------------------------------------------------------------------------
  // GET ALL UNIQUE GRADES WITH TIMETABLES
  // ---------------------------------------------------------------------------
  Future<List<String>> getUniqueGrades() async {
    try {
      final querySnapshot = await _firestore.collection('timetables').get();
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

  // ---------------------------------------------------------------------------
  // GET SECTIONS FOR A GRADE
  // ---------------------------------------------------------------------------
  Future<List<String>> getSectionsForGrade(String grade) async {
    try {
      final querySnapshot = await _firestore
          .collection('timetables')
          .where('grade', isEqualTo: grade)
          .get();

      final sections = querySnapshot.docs
          .map((doc) => doc.data()['section'] as String)
          .toSet()
          .toList();

      sections.sort();
      return sections;
    } catch (e) {
      print('Error getting sections for grade: $e');
      throw e;
    }
  }
}
