import 'package:flutter/material.dart';

import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/DictController.dart';
import 'package:otaku_movie/myApp.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/utils/index.dart';
import 'controller/LanguageController.dart';

// import "package:flutter_flavorizr/flutter_flavorizr.dart";

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void switchEnvironment(EnvironmentType newEnv) {
  Config.currentEnvironment = newEnv;
  print('Switched to environment: $newEnv');
}

void main() {
  // 根据 dart-define 的 ENV 参数设置环境，默认为生产环境
  EnvironmentType env = getEnvironment();
  switchEnvironment(getEnvironment());

  print("---------------env: $env");

  // 初始化 GetX 控制器
  Get.put(LanguageController());
  Get.lazyPut(() => DictController());

  // 启动应用
  runApp(MyApp(
    title: env.name
  ));
}

