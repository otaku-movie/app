import 'package:get/get.dart';
import 'package:otaku_movie/response/dict_response.dart';
import '../api/index.dart';

class DictController extends GetxController {
  var dict = DictResponse().obs;

  @override
  void onInit() {
    super.onInit();
    getDict(); // 初始化时加载数据
  }

  void getDict() {
    ApiRequest().request(
      path: '/dict/specify',
      method: 'GET',
      queryParameters: {},
      fromJsonT: (json) => DictResponse.fromJson(json),
    ).then((res) {
      if (res.data != null) {
        dict.value = res.data!; // 更新字典数据
      }
    });
  }
}
