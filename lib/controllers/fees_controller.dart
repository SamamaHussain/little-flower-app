import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:little_flower_app/utils/snackbar_utils.dart';


class FeesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> feeRecords = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> studentsWithDues =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedMonth = RxString(_getCurrentMonth());

  @override
  void onInit() {
    fetchFeeRecords();
    super.onInit();
  }

  static String _getCurrentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  Future<void> fetchFeeRecords() async {
    try {
      isLoading.value = true;
      final querySnapshot = await _firestore
          .collection('fees')
          .where('month', isEqualTo: selectedMonth.value)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _createDefaultFeeRecords();
      } else {
        feeRecords.assignAll(
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'studentId': data['studentId'],
              'studentName': data['studentName'],
              'month': data['month'],
              'amount': data['amount'] ?? 0,
              'paidAmount': data['paidAmount'] ?? 0,
              'status': data['status'] ?? 'pending',
              'dueDate': data['dueDate'],
              'grade': data['grade'],
              'section': data['section'],
            };
          }).toList(),
        );
      }

      _calculateStudentsWithDues();
    } catch (e) {
      print('Error fetching fee records: $e');
      // Demo data
      feeRecords.assignAll([
        {
          'id': '1',
          'studentId': '1',
          'studentName': 'John Smith',
          'month': selectedMonth.value,
          'amount': 5000,
          'paidAmount': 5000,
          'status': 'paid',
          'dueDate': '2024-01-15',
          'grade': '10',
          'section': 'A',
        },
        {
          'id': '2',
          'studentId': '2',
          'studentName': 'Sarah Johnson',
          'month': selectedMonth.value,
          'amount': 5000,
          'paidAmount': 3000,
          'status': 'partial',
          'dueDate': '2024-01-15',
          'grade': '10',
          'section': 'B',
        },
        {
          'id': '3',
          'studentId': '3',
          'studentName': 'Mike Davis',
          'month': selectedMonth.value,
          'amount': 5000,
          'paidAmount': 0,
          'status': 'pending',
          'dueDate': '2024-01-15',
          'grade': '9',
          'section': 'A',
        },
      ]);
      _calculateStudentsWithDues();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _createDefaultFeeRecords() async {
    final studentsSnapshot = await _firestore.collection('students').get();

    final defaultRecords = studentsSnapshot.docs.map((doc) {
      final student = doc.data();
      return {
        'studentId': doc.id,
        'studentName': student['name'] ?? 'Unknown',
        'month': selectedMonth.value,
        'amount': 5000, // Default fee amount
        'paidAmount': 0,
        'status': 'pending',
        'dueDate': '${selectedMonth.value}-15',
        'grade': student['grade'] ?? 'N/A',
        'section': student['section'] ?? 'N/A',
      };
    }).toList();

    for (final record in defaultRecords) {
      await _firestore.collection('fees').add(record);
    }

    feeRecords.assignAll(defaultRecords);
  }

  void _calculateStudentsWithDues() {
    studentsWithDues.assignAll(
      feeRecords.where((record) {
        return record['status'] == 'pending' || record['status'] == 'partial';
      }).toList(),
    );
  }

  Future<void> updateFeePayment(String recordId, double paidAmount) async {
    try {
      final record = feeRecords.firstWhere(
        (record) => record['id'] == recordId,
      );
      final totalAmount = record['amount'] ?? 0;
      final newPaidAmount = paidAmount;
      final newStatus = newPaidAmount >= totalAmount
          ? 'paid'
          : newPaidAmount > 0
          ? 'partial'
          : 'pending';

      await _firestore.collection('fees').doc(recordId).update({
        'paidAmount': newPaidAmount,
        'status': newStatus,
        'paidDate': FieldValue.serverTimestamp(),
      });

      // Update local record
      final index = feeRecords.indexWhere((record) => record['id'] == recordId);
      if (index != -1) {
        feeRecords[index]['paidAmount'] = newPaidAmount;
        feeRecords[index]['status'] = newStatus;
        feeRecords.refresh();
      }

      _calculateStudentsWithDues();
      AppSnackbar.success('Fee payment updated successfully');
    } catch (e) {
      print('Error updating fee payment: $e');
      AppSnackbar.error('Failed to update fee payment');
    }
  }

  Future<Map<String, dynamic>> getFeeSummary() async {
    final totalAmount = feeRecords.fold<double>(
      0,
      (sum, record) => sum + (record['amount'] ?? 0),
    );
    final paidAmount = feeRecords.fold<double>(
      0,
      (sum, record) => sum + (record['paidAmount'] ?? 0),
    );
    final pendingAmount = totalAmount - paidAmount;
    final paidStudents = feeRecords
        .where((record) => record['status'] == 'paid')
        .length;
    final dueStudents = feeRecords.length - paidStudents;

    return {
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'pendingAmount': pendingAmount,
      'paidStudents': paidStudents,
      'dueStudents': dueStudents,
      'collectionRate': totalAmount > 0
          ? (paidAmount / totalAmount * 100).round()
          : 0,
    };
  }

  List<Map<String, dynamic>> getStudentsByStatus(String status) {
    return feeRecords.where((record) => record['status'] == status).toList();
  }
}
