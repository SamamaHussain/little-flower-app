import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String? id;
  final String name;
  final String grade;
  final String section;
  final String rollNumber;
  final String parentName;
  final bool isActive;

  Student({
    this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.rollNumber,
    required this.parentName,
    this.isActive = true,
  }) {
    // Validation
    if (name.isEmpty) throw ArgumentError('Name cannot be empty');
    if (grade.isEmpty) throw ArgumentError('Grade cannot be empty');
    if (section.isEmpty) throw ArgumentError('Section cannot be empty');
    if (rollNumber.isEmpty) throw ArgumentError('Roll number cannot be empty');
    if (parentName.isEmpty) throw ArgumentError('Parent name cannot be empty');
  }

  factory Student.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Student(
      id: documentId,
      name: data['name'] ?? '',
      grade: data['grade'] ?? '',
      section: data['section'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      parentName: data['parentName'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'grade': grade,
      'section': section,
      'rollNumber': rollNumber,
      'parentName': parentName,
      'isActive': isActive,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Student copyWith({
    String? name,
    String? grade,
    String? section,
    String? rollNumber,
    String? parentName,
    bool? isActive,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      rollNumber: rollNumber ?? this.rollNumber,
      parentName: parentName ?? this.parentName,
      isActive: isActive ?? this.isActive,
    );
  }

  String get fullClass => '$grade - $section';

  // Validation methods
  bool get isValid =>
      name.isNotEmpty &&
      grade.isNotEmpty &&
      section.isNotEmpty &&
      rollNumber.isNotEmpty &&
      parentName.isNotEmpty;

  String? validate() {
    if (name.isEmpty) return 'Name is required';
    if (grade.isEmpty) return 'Grade is required';
    if (section.isEmpty) return 'Section is required';
    if (rollNumber.isEmpty) return 'Roll number is required';
    if (parentName.isEmpty) return 'Parent name is required';
    return null;
  }
}
