import 'package:get/get.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';

class StaffManageBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => StaffController(), fenix: true);
  }
}
