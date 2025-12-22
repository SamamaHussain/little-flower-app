import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:little_flower_app/models/staff_model.dart';
import 'package:little_flower_app/services/staff_services.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

class StaffController extends GetxController {
  final StaffServices _staffServices = StaffServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<Staff> staffList = <Staff>[].obs;
  final Rxn<Staff> currentStaff = Rxn<Staff>();

  final RxBool showPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;

  final RxBool isSendingResetEmail = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxBool isUpdating = false.obs;

  @override
  void onInit() {
    fetchCurrentStaff();
    fetchStaff(); // existing
    super.onInit();
  }

  // ---------------------------------------------------------------------------
  // FETCH STAFF FOR ADMIN
  // ---------------------------------------------------------------------------
  Future<void> fetchStaff() async {
    try {
      isLoading.value = true;
      final currentUid = _auth.currentUser?.uid;

      final staff = await _staffServices.getAllStaff(excludeUid: currentUid);
      staffList.assignAll(staff);
    } catch (e) {
      AppSnackbar.error("Failed to load staff accounts");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE STAFF ACCOUNT (SELF DELETE) — AUTH + FIRESTORE
  // ---------------------------------------------------------------------------

  Future<void> fetchCurrentStaff() async {
    try {
      isLoading.value = true;
      final staff = await _staffServices.getCurrentStaff();
      currentStaff.value = staff;
      print('From currunt staff func $staff');
    } catch (e) {
      AppSnackbar.error("Failed to load your profile");
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // CREATE NEW STAFF
  // ---------------------------------------------------------------------------
  Future<bool> createStaffAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      isCreating.value = true;

      final exists = await _staffServices.checkEmailExists(email);
      if (exists) {
        AppSnackbar.error("Email already exists");
        return false;
      }

      // Show loading dialog before creating
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // --- CREATE STAFF ACCOUNT ---
      await _staffServices.createStaffAccount(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        accountType: "staff",
      );

      // 🔥 IMPORTANT: Firebase logs into new user automatically
      await FirebaseAuth.instance.signOut();

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      // Success
      AppSnackbar.success("Staff account created successfully");

      // Redirect to auth page
      Get.offAllNamed('/auth');

      return true;
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      AppSnackbar.error("$e");
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // RESET STAFF PASSWORD (ADMIN)
  // ---------------------------------------------------------------------------
  Future<void> sendPasswordReset(String email) async {
    try {
      isSendingResetEmail.value = true;
      await _staffServices.sendPasswordResetEmail(email);

      AppSnackbar.success("Reset link sent");
    } catch (e) {
      AppSnackbar.error("$e");
    } finally {
      isSendingResetEmail.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE STAFF NAME + LAST NAME (ADMIN)
  // ---------------------------------------------------------------------------
  Future<void> updateStaff(
    String uid,
    String firstName,
    String lastName,
  ) async {
    try {
      isUpdating.value = true;
      isLoading.value = true;

      await _staffServices.updateStaffName(uid, firstName, lastName);

      await fetchStaff();

      AppSnackbar.success("Staff info updated");
    } catch (e) {
      AppSnackbar.error("$e");
    } finally {
      isUpdating.value = false;
      isLoading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE OWN PROFILE (WITHOUT GLOBAL LOADING STATE)
  // ---------------------------------------------------------------------------
  Future<void> updateStaffProfile(
    String uid,
    String firstName,
    String lastName,
  ) async {
    try {
      await _staffServices.updateStaffName(uid, firstName, lastName);

      // Update local currentStaff without triggering isLoading
      final updatedStaff = await _staffServices.getCurrentStaff();
      currentStaff.value = updatedStaff;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE STAFF ACCOUNT (SELF DELETE) — AUTH + FIRESTORE
  // ---------------------------------------------------------------------------
  Future<bool> deleteOwnAccount({required String password}) async {
    try {
      isDeleting.value = true;

      final user = _auth.currentUser;
      if (user == null) throw "User not found";

      // STEP 1 — Re-authenticate
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);

      // STEP 2 — Delete Firestore document
      await _staffServices.deleteStaffFromFirestore(user.uid);

      // STEP 3 — Delete Firebase Auth user
      await user.delete();

      AppSnackbar.success("Your account has been removed permanently");

      return true;
    } catch (e) {
      if (e.toString().contains("requires-recent-login")) {
        return false; // UI should ask for password
      }
      AppSnackbar.error("$e");
      return false;
    } finally {
      isDeleting.value = false;
    }
  }
}
