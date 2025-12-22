import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';
import '../models/announcement_model.dart';

class AnnouncementsController extends GetxController {
  final RxList<Announcement> announcements = <Announcement>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  RxBool isLoading = false.obs;

  Announcement? announcement;

  @override
  void onInit() {
    fetchAnnouncements();
    super.onInit();
  }

  Future<void> fetchAnnouncements() async {
    try {
      isLoading = true.obs;
      final querySnapshot = await _firestore
          .collection('announcements')
          .orderBy('date', descending: true)
          .get();

      announcements.assignAll(
        querySnapshot.docs.map((doc) {
          return Announcement.fromFirestore(doc.data(), doc.id);
        }).toList(),
      );
      isLoading = false.obs;
    } catch (e) {
      isLoading = true.obs;
      print('Error fetching announcements: $e');
      // For demo purposes, add some sample data
      announcements.assignAll([
        Announcement(
          title: 'Welcome Back!',
          content:
              'School reopens on January 15th. We look forward to seeing all students!',
          date: DateTime(2024, 1, 10),
        ),
        Announcement(
          title: 'Parent-Teacher Meeting',
          content:
              'Scheduled for January 20th. Please check the portal for your time slot.',
          date: DateTime(2024, 1, 5),
        ),
      ]);
      isLoading = false.obs;
    }
  }

  Future<void> createAnnouncement(String title, String content) async {
    try {
      isLoading = true.obs;
      announcement = Announcement(
        title: title,
        content: content,
        date: DateTime.now(),
      );

      await _firestore
          .collection('announcements')
          .add(announcement!.toFirestore());

      // Refresh announcements
      await fetchAnnouncements();
      isLoading = false.obs;
      // Get.back(); // Close dialog
      AppSnackbar.success('Announcement created successfully');
    } catch (e) {
      print('Error creating announcement: $e');
      AppSnackbar.error('Failed to create announcement');
    }
  }

  Future<void> updateAnnouncement(
    String announcementId,
    String newTitle,
    String newContent,
  ) async {
    try {
      isLoading = true.obs;
      final updatedAnnouncement = announcements
          .firstWhere((announcement) => announcement.id == announcementId)
          .copyWith(
            title: newTitle,
            content: newContent,
            updatedAt: DateTime.now(),
          );

      await _firestore
          .collection('announcements')
          .doc(announcementId)
          .update(updatedAnnouncement.toFirestore());

      // Update local list
      final index = announcements.indexWhere(
        (announcement) => announcement.id == announcementId,
      );
      if (index != -1) {
        announcements[index] = updatedAnnouncement;
        announcements.refresh();
      }
      isLoading = false.obs;
      // Get.back();
      AppSnackbar.success('Announcement updated successfully');
    } catch (e) {
      print('Error updating announcement: $e');
      AppSnackbar.error('Failed to update announcement');
    }
  }

  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      isLoading = true.obs;
      await _firestore.collection('announcements').doc(announcementId).delete();

      // Remove from local list
      announcements.removeWhere(
        (announcement) => announcement.id == announcementId,
      );

      AppSnackbar.success('Announcement deleted successfully');
      isLoading = false.obs;
    } catch (e) {
      print('Error deleting announcement: $e');
      AppSnackbar.error('Failed to delete announcement');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
