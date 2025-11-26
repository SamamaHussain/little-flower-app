import 'package:cloud_firestore/cloud_firestore.dart';

class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final String subject;
  final String teacher;
  final bool isBreak;
  final String? breakTitle;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.teacher,
    required this.isBreak,
    this.breakTitle,
  });

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'startTime': startTime,
      'endTime': endTime,
      'subject': subject,
      'teacher': teacher,
      'isBreak': isBreak,
      'breakTitle': breakTitle,
    };
  }

  // Create from Firestore
  factory TimeSlot.fromFirestore(Map<String, dynamic> data) {
    return TimeSlot(
      id: data['id'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      subject: data['subject'] ?? '',
      teacher: data['teacher'] ?? '',
      isBreak: data['isBreak'] ?? false,
      breakTitle: data['breakTitle'],
    );
  }

  // Copy with
  TimeSlot copyWith({
    String? id,
    String? startTime,
    String? endTime,
    String? subject,
    String? teacher,
    bool? isBreak,
    String? breakTitle,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      isBreak: isBreak ?? this.isBreak,
      breakTitle: breakTitle ?? this.breakTitle,
    );
  }
}

class DailyTimetable {
  final String day;
  final List<TimeSlot> timeSlots;

  DailyTimetable({required this.day, required this.timeSlots});

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'day': day,
      'timeSlots': timeSlots.map((slot) => slot.toFirestore()).toList(),
    };
  }

  // Create from Firestore
  factory DailyTimetable.fromFirestore(Map<String, dynamic> data) {
    return DailyTimetable(
      day: data['day'] ?? '',
      timeSlots:
          (data['timeSlots'] as List<dynamic>?)
              ?.map((slotData) => TimeSlot.fromFirestore(slotData))
              .toList() ??
          [],
    );
  }
}

class ClassTimetable {
  final String id;
  final String grade;
  final String section;
  final List<DailyTimetable> weeklyTimetable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ClassTimetable({
    required this.id,
    required this.grade,
    required this.section,
    required this.weeklyTimetable,
    required this.createdAt,
    this.updatedAt,
  });

  String get className => 'Grade $grade - Section $section';

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'grade': grade,
      'section': section,
      'weeklyTimetable': weeklyTimetable
          .map((day) => day.toFirestore())
          .toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore
  factory ClassTimetable.fromFirestore(Map<String, dynamic> data, String id) {
    return ClassTimetable(
      id: id,
      grade: data['grade'] ?? '',
      section: data['section'] ?? '',
      weeklyTimetable:
          (data['weeklyTimetable'] as List<dynamic>?)
              ?.map((dayData) => DailyTimetable.fromFirestore(dayData))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Get timetable for specific day
  DailyTimetable? getTimetableForDay(String day) {
    try {
      return weeklyTimetable.firstWhere((daily) => daily.day == day);
    } catch (e) {
      return DailyTimetable(day: day, timeSlots: []);
    }
  }

  // Copy with method
  ClassTimetable copyWith({
    String? id,
    String? grade,
    String? section,
    List<DailyTimetable>? weeklyTimetable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassTimetable(
      id: id ?? this.id,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      weeklyTimetable: weeklyTimetable ?? this.weeklyTimetable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
