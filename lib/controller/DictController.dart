import 'package:get/get.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/dict_response.dart';
import '../api/index.dart';

class DictController extends GetxController {
  var dict = DictResponse().obs;

  @override
  void onInit() {
    super.onInit();
    getDict(); // 初始化时加载数据
  }

  Future<void> getDict() async {
    try {
      final res = await ApiRequest().request(
        path: '/dict/specify',
        method: 'GET',
        queryParameters: {},
        fromJsonT: (json) => DictResponse.fromJson(json),
      );
      if (res.data != null) {
        dict.value = res.data!; // 更新字典数据
      }
    } catch (e) {
      // 字典是筛选/展示辅助数据，拉取失败时保留旧值/空值即可，不能让启动流程崩溃。
      log.e('加载字典失败，保留当前字典数据', error: e);
    }
  }
}
