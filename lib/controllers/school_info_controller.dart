import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

class SchoolInfoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable values for the information to be edited
  final RxString schoolHours = '7:30 AM - 2:30 PM'.obs;
  final RxString officeHours = '7:00 AM - 4:00 PM'.obs;
  final RxString contactPhone = '+1 (555) 123-4567'.obs;
  final RxString contactEmail = 'info@school.edu'.obs;
  final RxString schoolAddress = '123 Education Street, City'.obs;

  // UI State
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  // Text controllers for editing
  final TextEditingController schoolHoursController = TextEditingController();
  final TextEditingController officeHoursController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController schoolAddressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSchoolInfo();
  }

  // Fetch school information from Firestore
  Future<void> fetchSchoolInfo() async {
    try {
      isLoading.value = true;

      final docSnapshot = await _firestore
          .collection('school_info')
          .doc('contact_details')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;

        // Update observable values
        schoolHours.value = data['school_hours'] ?? '7:30 AM - 2:30 PM';
        officeHours.value = data['office_hours'] ?? '7:00 AM - 4:00 PM';
        contactPhone.value = data['contact_phone'] ?? '+1 (555) 123-4567';
        contactEmail.value = data['contact_email'] ?? 'info@school.edu';
        schoolAddress.value =
            data['school_address'] ?? '123 Education Street, City';

        // Update text controllers
        _syncControllersWithObservables();
      }
    } catch (e) {
      AppSnackbar.error('Failed to load school information');
      print('Error fetching school info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Sync text controllers with observable values
  void _syncControllersWithObservables() {
    schoolHoursController.text = schoolHours.value;
    officeHoursController.text = officeHours.value;
    contactPhoneController.text = contactPhone.value;
    contactEmailController.text = contactEmail.value;
    schoolAddressController.text = schoolAddress.value;
  }

  // Update all contact information at once
  Future<void> updateSchoolInfo({
    required String newSchoolHours,
    required String newOfficeHours,
    required String newContactPhone,
    required String newContactEmail,
    required String newSchoolAddress,
  }) async {
    try {
      isSaving.value = true;

      // Update observable values
      schoolHours.value = newSchoolHours;
      officeHours.value = newOfficeHours;
      contactPhone.value = newContactPhone;
      contactEmail.value = newContactEmail;
      schoolAddress.value = newSchoolAddress;

      // Update in Firestore
      await _firestore.collection('school_info').doc('contact_details').set({
        'school_hours': schoolHours.value,
        'office_hours': officeHours.value,
        'contact_phone': contactPhone.value,
        'contact_email': contactEmail.value,
        'school_address': schoolAddress.value,
        'updated_at': FieldValue.serverTimestamp(),
        'updated_by':
            Get.find<StaffController>().currentStaff.value?.email ?? 'admin',
      }, SetOptions(merge: true));

      AppSnackbar.success('School information updated successfully');
    } catch (e) {
      AppSnackbar.error('Failed to update school information');
      throw e;
    } finally {
      isSaving.value = false;
    }
  }

  // Update individual fields if needed
  Future<void> updateSchoolHours(String hours) async {
    try {
      schoolHours.value = hours;
      await _firestore.collection('school_info').doc('contact_details').set({
        'school_hours': schoolHours.value,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateOfficeHours(String hours) async {
    try {
      officeHours.value = hours;
      await _firestore.collection('school_info').doc('contact_details').set({
        'office_hours': officeHours.value,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateContactPhone(String phone) async {
    try {
      contactPhone.value = phone;
      await _firestore.collection('school_info').doc('contact_details').set({
        'contact_phone': contactPhone.value,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateContactEmail(String email) async {
    try {
      contactEmail.value = email;
      await _firestore.collection('school_info').doc('contact_details').set({
        'contact_email': contactEmail.value,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateSchoolAddress(String address) async {
    try {
      schoolAddress.value = address;
      await _firestore.collection('school_info').doc('contact_details').set({
        'school_address': schoolAddress.value,
        'updated_at': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw e;
    }
  }

  // Reset to default values
  Future<void> resetToDefaults() async {
    try {
      isSaving.value = true;

      schoolHours.value = '7:30 AM - 2:30 PM';
      officeHours.value = '7:00 AM - 4:00 PM';
      contactPhone.value = '+1 (555) 123-4567';
      contactEmail.value = 'info@school.edu';
      schoolAddress.value = '123 Education Street, City';

      _syncControllersWithObservables();

      // Clear from Firestore (optional - comment out if you want to keep data)
      // await _firestore.collection('school_info').doc('contact_details').delete();

      // Or update with defaults
      await updateSchoolInfo(
        newSchoolHours: schoolHours.value,
        newOfficeHours: officeHours.value,
        newContactPhone: contactPhone.value,
        newContactEmail: contactEmail.value,
        newSchoolAddress: schoolAddress.value,
      );

      AppSnackbar.info('All information reset to defaults');
    } catch (e) {
      AppSnackbar.error('Failed to reset information');
    } finally {
      isSaving.value = false;
    }
  }

  // Load current values into controllers for editing
  void loadForEditing() {
    _syncControllersWithObservables();
  }

  @override
  void onClose() {
    // Dispose all text controllers
    schoolHoursController.dispose();
    officeHoursController.dispose();
    contactPhoneController.dispose();
    contactEmailController.dispose();
    schoolAddressController.dispose();

    super.onClose();
  }
}
