import 'dart:ui';

import 'package:get/get.dart';

class LanguageController extends GetxController {
  // 语言设置
  Rx<Locale> locale = const Locale('zh').obs;
   RxList<Map<String, String>> lang = RxList([
    {'code': 'zh', 'name': '中文'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'en', 'name': 'English'}
  ]);

  // 切换语言
  void changeLanguage(String languageCode) {
    locale.value = Locale(languageCode);
  }
}
