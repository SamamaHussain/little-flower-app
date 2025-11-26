import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String? id;
  final String studentId;
  final String studentName;
  final String grade;
  final String section;
  final String rollNumber;
  final DateTime date;
  final bool present;
  final DateTime markedAt;

  AttendanceRecord({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.grade,
    required this.section,
    required this.rollNumber,
    required this.date,
    required this.present,
    required this.markedAt,
  });

  factory AttendanceRecord.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return AttendanceRecord(
      id: documentId,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      grade: data['grade'] ?? '',
      section: data['section'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      present: data['present'] ?? false,
      markedAt: data['markedAt'] != null
          ? (data['markedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'grade': grade,
      'section': section,
      'rollNumber': rollNumber,
      'date': Timestamp.fromDate(date),
      'present': present,
      'markedAt': Timestamp.fromDate(markedAt),
    };
  }

  AttendanceRecord copyWith({
    String? studentId,
    String? studentName,
    String? grade,
    String? section,
    String? rollNumber,
    DateTime? date,
    bool? present,
    DateTime? markedAt,
  }) {
    return AttendanceRecord(
      id: id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      rollNumber: rollNumber ?? this.rollNumber,
      date: date ?? this.date,
      present: present ?? this.present,
      markedAt: markedAt ?? this.markedAt,
    );
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String getTodayDate() {
    final now = DateTime.now();
    return formatDate(now);
  }
}
