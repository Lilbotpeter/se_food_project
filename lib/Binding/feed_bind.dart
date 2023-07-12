import 'package:get/get.dart';
import 'package:se_project_food/Screen/Feed/feed_page.dart';

class FeedPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FeedPage());
  }
}
