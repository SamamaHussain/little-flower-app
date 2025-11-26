import 'package:get/get.dart';
import 'package:little_flower_app/controllers/students_controller.dart';

class AttendanceBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => StudentsController(), fenix: true);
  }
}
