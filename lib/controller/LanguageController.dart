import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/controller/DictController.dart';

class LanguageController extends GetxController {
  // 语言设置（默认使用系统语言）
  late Rx<Locale> locale;
  
  RxList<Map<String, String>> lang = RxList([
    {'code': 'zh', 'name': '中文'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'en', 'name': 'English'}
  ]);

  @override
  void onInit() {
    super.onInit();
    // 初始化时使用系统语言
    final systemLocale = PlatformDispatcher.instance.locale;
    // 只支持 zh, ja, en，如果系统语言不支持，默认使用 ja
    final supportedCodes = ['zh', 'ja', 'en'];
    final languageCode = supportedCodes.contains(systemLocale.languageCode) 
        ? systemLocale.languageCode 
        : 'ja';
    locale = Locale(languageCode).obs;
  }

  // 切换语言
  void changeLanguage(String languageCode) {
    locale.value = Locale(languageCode);
    
    // 语言切换后，重新加载字典数据
    if (Get.isRegistered<DictController>()) {
      final dictController = Get.find<DictController>();
      dictController.getDict();
    }
  }
}
