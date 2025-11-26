import 'package:cloud_firestore/cloud_firestore.dart';

class Staff {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String accountType; // 'admin' or 'staff'
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Staff({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accountType,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
  });

  String get fullName => '$firstName $lastName';

  // Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'accountType': accountType,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  // Create from Firestore
  factory Staff.fromFirestore(Map<String, dynamic> data, String id) {
    return Staff(
      uid: id,
      email: data['email'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      accountType: data['accountType'] ?? 'staff',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      isActive: data['isActive'] ?? true,
    );
  }

  // Copy with
  Staff copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? accountType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Staff(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      accountType: accountType ?? this.accountType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
