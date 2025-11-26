import 'package:get/get.dart';
import 'package:little_flower_app/controllers/announcement_controller.dart';
import 'package:little_flower_app/controllers/auth_controller.dart';
import 'package:little_flower_app/controllers/weather_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.put(AnnouncementsController());
    Get.put(WeatherController());
  }
}
