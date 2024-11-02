import 'dart:ui';

import 'package:get/get.dart';

class LanguageController extends GetxController {
  // 语言设置
  Rx<Locale> locale = const Locale('zh').obs;

  // 切换语言
  void changeLanguage(String languageCode) {
    locale.value = Locale(languageCode);
  }
}
