// picture_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PictureController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable for the image URL
  final RxString profilePicUrl = ''.obs;

  // UI State
  final RxBool isLoading = false.obs;
  final RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfilePic();
  }

  // Fetch profile picture URL from Firestore
  Future<void> fetchProfilePic() async {
    try {
      isLoading.value = true;

      final docSnapshot = await _firestore
          .collection('profile_pic')
          .doc('pic')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        profilePicUrl.value = data['link'] ?? '';

        if (profilePicUrl.value.isEmpty) {
          print('Profile picture link is empty');
        } else {
          print('Profile picture loaded: ${profilePicUrl.value}');
        }
      } else {
        print('No profile picture document found');
        profilePicUrl.value = '';
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile picture',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error fetching profile picture: $e');
      profilePicUrl.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  // Update the profile picture URL in Firestore
  Future<void> updateProfilePic(String newImageUrl) async {
    try {
      isUpdating.value = true;

      // Validate URL format
      if (newImageUrl.isEmpty) {
        throw 'Please provide a valid image URL';
      }

      if (!newImageUrl.startsWith('http')) {
        throw 'Please provide a valid HTTP/HTTPS URL';
      }

      // Update in Firestore
      await _firestore.collection('profile_pic').doc('pic').set({
        'link': newImageUrl.trim(),
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local observable
      profilePicUrl.value = newImageUrl.trim();

      Get.snackbar(
        'Success',
        'Profile picture updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      print('Profile picture updated: ${profilePicUrl.value}');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw e;
    } finally {
      isUpdating.value = false;
    }
  }

  // Clear/remove the profile picture
  Future<void> clearProfilePic() async {
    try {
      isUpdating.value = true;

      // Set empty string in Firestore
      await _firestore.collection('profile_pic').doc('pic').set({
        'link': '',
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update local observable
      profilePicUrl.value = '';

      Get.snackbar(
        'Cleared',
        'Profile picture removed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear profile picture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // Refresh the profile picture
  Future<void> refresh() async {
    await fetchProfilePic();
  }
}
