import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String? id;
  final String title;
  final String content;
  final DateTime date;
  final DateTime? updatedAt;

  Announcement({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.updatedAt,
  });

  // Convert from Firestore document to Announcement object
  factory Announcement.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return Announcement(
      id: documentId,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Announcement object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  // Create a copy with updated fields
  Announcement copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    DateTime? updatedAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
