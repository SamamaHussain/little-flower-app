import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'attendance';

  String _docId(String grade, String section, String dateString) =>
      '${grade}_${section}_$dateString';

  /// Create/ensure attendance doc with metadata
  Future<void> ensureAttendanceDoc({
    required String grade,
    required String section,
    required String dateString,
  }) async {
    final docRef = _firestore
        .collection(collection)
        .doc(_docId(grade, section, dateString));
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      await docRef.set({
        'grade': grade,
        'section': section,
        'dateString': dateString,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Save attendance for many students with a single batch
  /// attendanceMap: studentId -> present (true/false)
  Future<void> saveAttendanceBatch({
    required String grade,
    required String section,
    required String dateString,
    required Map<String, bool> attendanceMap,
  }) async {
    final docRef = _firestore
        .collection(collection)
        .doc(_docId(grade, section, dateString));
    final batch = _firestore.batch();

    // ensure doc exists
    batch.set(docRef, {
      'grade': grade,
      'section': section,
      'dateString': dateString,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final recordsRef = docRef.collection('records');
    attendanceMap.forEach((studentId, present) {
      final studentDoc = recordsRef.doc(studentId);
      batch.set(studentDoc, {
        'present': present,
        'time': FieldValue.serverTimestamp(),
      });
    });

    await batch.commit();
  }

  /// Fetch records for a class on a date – returns map studentId -> present
  Future<Map<String, bool>> fetchAttendanceForClassDate({
    required String grade,
    required String section,
    required String dateString,
  }) async {
    final docRef = _firestore
        .collection(collection)
        .doc(_docId(grade, section, dateString));
    final colSnap = await docRef.collection('records').get();
    final map = <String, bool>{};
    for (final doc in colSnap.docs) {
      final data = doc.data();
      map[doc.id] = data['present'] == true;
    }
    return map;
  }

  /// Check existence quickly
  Future<bool> attendanceExists({
    required String grade,
    required String section,
    required String dateString,
  }) async {
    final docRef = _firestore
        .collection(collection)
        .doc(_docId(grade, section, dateString));
    final snap = await docRef.get();
    return snap.exists;
  }
}
