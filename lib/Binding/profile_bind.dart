import 'package:get/get.dart';
import 'package:se_project_food/Screen/Profile/user_profile.dart';

class UserProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfile());
  }
}
