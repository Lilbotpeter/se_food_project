import 'package:get/get.dart';
import 'package:se_project_food/Screen/Upload/upload_page.dart';

class UploadFoodBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UploadFood());
  }
}
