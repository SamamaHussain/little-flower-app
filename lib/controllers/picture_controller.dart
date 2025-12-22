// picture_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

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
      AppSnackbar.error('Failed to load profile picture');
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

      AppSnackbar.success('Profile picture updated successfully');

      print('Profile picture updated: ${profilePicUrl.value}');
    } catch (e) {
      AppSnackbar.error('Failed to update profile picture: $e');
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

      AppSnackbar.info('Profile picture removed');
    } catch (e) {
      AppSnackbar.error('Failed to clear profile picture: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  // Refresh the profile picture
  Future<void> refresh() async {
    await fetchProfilePic();
  }
}
