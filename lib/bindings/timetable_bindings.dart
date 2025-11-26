import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:little_flower_app/controllers/timetable_controller.dart';

class TimetableBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => TimetableController(), fenix: true);
  }
}
