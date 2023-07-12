import 'package:get/get.dart';
import 'package:se_project_food/Screen/Search/search_page.dart';

class SearchPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchPage());
  }
}
