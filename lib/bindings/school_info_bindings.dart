import 'package:get/get.dart';
import 'package:little_flower_app/controllers/school_info_controller.dart';

class SchoolInfoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SchoolInfoController(), fenix: true);
  }
}
