import 'package:get/get.dart';
import 'package:se_project_food/Screen/Profile/my_food.dart';

class MyFoodsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyFoods());
  }
}
