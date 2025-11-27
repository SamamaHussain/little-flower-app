import 'package:get/get.dart';
import 'package:little_flower_app/controllers/attendance_controller.dart';
import 'package:little_flower_app/controllers/fees_controller.dart';
import 'package:little_flower_app/controllers/staff_controller.dart';
import 'package:little_flower_app/controllers/students_controller.dart';

class NavBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StudentsController(), fenix: true);
    Get.lazyPut(() => FeesController(), fenix: true);
    Get.lazyPut(() => AttendanceController(), fenix: true);
    Get.lazyPut(() => StaffController(), fenix: true);
  }
}
