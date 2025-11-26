import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:little_flower_app/models/staff_model.dart';

class StaffServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------------------------------------------------------------------
  // CREATE STAFF
  // ---------------------------------------------------------------------------
  Future<String> createStaffAccount({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String accountType,
  }) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      final staff = Staff(
        uid: uid,
        email: email,
        firstName: firstName,
        lastName: lastName,
        accountType: accountType,
        createdAt: DateTime.now(),
        isActive: true,
      );

      await _firestore.collection('staff').doc(uid).set(staff.toFirestore());

      return uid;
    } catch (e) {
      throw e;
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE STAFF NAME
  // ---------------------------------------------------------------------------
  Future<void> updateStaffName(
    String uid,
    String firstName,
    String lastName,
  ) async {
    await _firestore.collection('staff').doc(uid).update({
      "firstName": firstName,
      "lastName": lastName,
    });
  }

  // ---------------------------------------------------------------------------
  // DELETE STAFF FROM FIRESTORE
  // ---------------------------------------------------------------------------
  Future<void> deleteStaffFromFirestore(String uid) async {
    await _firestore.collection('staff').doc(uid).delete();
  }

  // ---------------------------------------------------------------------------
  // GET ALL STAFF
  // ---------------------------------------------------------------------------
  Future<List<Staff>> getAllStaff({String? excludeUid}) async {
    Query query = _firestore
        .collection('staff')
        .orderBy("createdAt", descending: true);

    if (excludeUid != null && excludeUid.isNotEmpty) {
      query = query.where(FieldPath.documentId, isNotEqualTo: excludeUid);
    }

    final snap = await query.get();

    return snap.docs
        .map((d) => Staff.fromFirestore(d.data() as Map<String, dynamic>, d.id))
        .toList();
  }

  // ---------------------------------------------------------------------------
  // GET Current STAFF
  // ---------------------------------------------------------------------------

  Future<Staff?> getCurrentStaff() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) return null;

      final doc = await _firestore.collection('staff').doc(uid).get();

      if (!doc.exists) {
        print("❌ No staff document found for UID: $uid");
        return null; // IMPORTANT: do NOT throw here
      }

      return Staff.fromFirestore(doc.data()!, doc.id);
    } catch (e) {
      print("❌ ERROR in getCurrentStaff(): $e");
      return null; // avoid throwing
    }
  }

  // ---------------------------------------------------------------------------
  // CHECK EMAIL EXISTS
  // ---------------------------------------------------------------------------
  Future<bool> checkEmailExists(String email) async {
    final query = await _firestore
        .collection('staff')
        .where("email", isEqualTo: email)
        .get();

    return query.docs.isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // RESET PASSWORD
  // ---------------------------------------------------------------------------
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
