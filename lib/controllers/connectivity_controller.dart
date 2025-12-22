import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityController extends GetxController {
  final RxBool isConnected = true.obs;
  final RxBool isChecking = false.obs;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void onInit() {
    super.onInit();
    // Check initial connectivity
    checkConnectivity();
    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    // Check if we have any valid connection
    isConnected.value = !result.contains(ConnectivityResult.none);
  }

  Future<void> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      isConnected.value = !result.contains(ConnectivityResult.none);
    } catch (_) {
      isConnected.value = false;
    }
  }

  Future<void> retry() async {
    isChecking.value = true;
    await checkConnectivity();
    // Small delay to show loading state
    await Future.delayed(const Duration(milliseconds: 300));
    isChecking.value = false;
  }
}