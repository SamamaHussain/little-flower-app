import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:little_flower_app/testing.dart';

class TestingView extends StatelessWidget {
  const TestingView({super.key});

  @override
  Widget build(BuildContext context) {
    final testingController = Get.find<testing>();
    return Scaffold(
      body: Obx(() => Center(child: Text(testingController.count.toString()))),
      floatingActionButton: IconButton(
        onPressed: () => testingController.incrementCout(),
        icon: Icon(Icons.add),
      ),
    );
  }
}
