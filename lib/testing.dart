import 'package:get/get.dart';

class testing extends GetxController {
  RxInt count = 0.obs;

  void incrementCout() {
    print(count);
    count++;
  }
}
