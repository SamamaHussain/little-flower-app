import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:little_flower_app/routes/app_pages.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final Rx<User?> _user = Rx<User?>(null);
  var isPasswordVisible = false.obs;
  RxBool _isLoading = false.obs;
  User? get user => _user.value;

  final RxBool _isAdmin = false.obs;
  bool get isAdmin => _isAdmin.value;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    _user.bindStream(_auth.authStateChanges());

    // When user changes, update admin status
    ever(_user, (User? user) async {
      if (user != null) {
        await _checkAdminStatus(user.uid);
      } else {
        _isAdmin.value = false;
      }
    });

    super.onInit();
  }

  // Check if current user is admin by directly querying Firestore
  Future<bool> _checkAdminStatus(String uid) async {
    try {
      print('🔍 Checking admin status for user: $uid');

      final doc = await _firestore.collection('staff').doc(uid).get();

      if (doc.exists) {
        final data = doc.data();
        final accountType = data?['accountType'] as String?;
        final isActive = data?['isActive'] ?? true;

        bool adminStatus = accountType == 'admin' && isActive == true;

        print('📊 User data: ${data?.toString()}');
        print('✅ Admin status: $adminStatus');

        _isAdmin.value = adminStatus;
        return adminStatus;
      } else {
        print('❌ User document not found in staff collection');
        _isAdmin.value = false;
        return false;
      }
    } catch (e) {
      print('❌ Error checking admin status: $e');
      _isAdmin.value = false;
      return false;
    }
  }

  // You can also call this manually if needed
  Future<bool> checkAdminStatus() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return false;
    return await _checkAdminStatus(currentUser.uid);
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print('Current user is ${_auth.currentUser}');
      Get.offAllNamed(Routes.DASHBOARD);
    } on FirebaseAuthException catch (e) {
      AppSnackbar.error(e.message ?? 'An error occurred during login');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    print('User after logout: ${_auth.currentUser}');
    Get.offAllNamed('/guest');
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Auto-logout happens when app is completely closed (Firebase handles this)
}
