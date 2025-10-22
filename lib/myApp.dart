import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/router/router.dart';
import 'package:otaku_movie/utils/seat_cancel_manager.dart';

class MyApp extends StatefulWidget {
  final String? title;
  
  const MyApp({super.key, this.title});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // 当应用进入后台或暂停状态时，处理座位取消
    if (state == AppLifecycleState.paused || 
        state == AppLifecycleState.detached) {
      SeatCancelManager.handleAppExit();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final locale = Get.find<LanguageController>().locale.value;

          return MaterialApp.router(
            routerConfig: routerConfig,
            locale: locale,
            
            builder: FToastBuilder(),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            // onGenerateRoute: Application.router.generator,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              useMaterial3: true,
            ),
            // home: const Home(),
          );
        });
      },
    );
  }
}

// class AppInfo extends StatefulWidget {
//   const AppInfo({super.key, required String title});

//   @override
//   State<AppInfo> createState() => _AppInfoPageState();
// }

// class _AppInfoPageState extends State<AppInfo> {
//   PackageInfo? _packageInfo;

//   @override
//   void initState() {
//     super.initState();
//     _loadPackageInfo();
//   }

//   Future<void> _loadPackageInfo() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       _packageInfo = packageInfo;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_packageInfo?.appName ?? 'Loading...'),
//       ),
//       body: Center(
//         child: _packageInfo == null
//             ? const CircularProgressIndicator() // 显示加载动画
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('App Name: ${_packageInfo!.appName}'),
//                   Text('Package Name: ${_packageInfo!.packageName}'),
//                   Text('Version: ${_packageInfo!.version}'),
//                   Text('Build Number: ${_packageInfo!.buildNumber}'),
//                 ],
//               ),
//       ),
//     );
//   }
// }