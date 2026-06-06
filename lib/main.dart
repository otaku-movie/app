import 'package:flutter/material.dart';

import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/DictController.dart';
import 'package:otaku_movie/myApp.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/utils/index.dart';
import 'controller/LanguageController.dart';
import 'controller/TimeFormatController.dart';
import 'package:jiffy/jiffy.dart';

// import "package:flutter_flavorizr/flutter_flavorizr.dart";

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void switchEnvironment(EnvironmentType newEnv) {
  Config.currentEnvironment = newEnv;
  print('Switched to environment: $newEnv');
}

void main() async {
  // 插件 / 平台通道在 runApp 前调用，需先确保绑定初始化。
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化埋点（Firebase 未配置时自动降级为 no-op，不影响启动）。
  await Analytics.instance.init();
  Analytics.instance.logEvent(Ev.appOpen);

  // 根据 dart-define 的 ENV 参数设置环境，默认为生产环境
  EnvironmentType env = getEnvironment();
  switchEnvironment(getEnvironment());

  print("---------------env: $env");

  // 初始化配置（自动获取本机 IP 地址，仅 dev 环境）
  await Config.initialize();

  // 设置Jiffy为中文语言环境
  await Jiffy.setLocale('zh_cn');

  // 初始化 GetX 控制器
  Get.put(LanguageController());
  Get.lazyPut(() => DictController());
  final timeFormatController = Get.put(TimeFormatController(), permanent: true);
  await timeFormatController.init();

  // 启动应用
  runApp(MyApp(
    title: env.name
  ));
}

