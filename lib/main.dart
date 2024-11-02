import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/pages/Home.dart';
import 'package:otaku_movie/router/application.dart';
import 'package:otaku_movie/router/router.dart';
import 'package:get/get.dart';
import 'controller/LanguageController.dart';
import 'generated/l10n.dart';
import 'package:get/get.dart';

void main() {
  final languageController = Get.put(LanguageController());
  final router = FluroRouter();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final locale = Get.find<LanguageController>().locale.value;

          return MaterialApp(
            locale: locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            onGenerateRoute: Application.router.generator,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              useMaterial3: true,
            ),
            home: const Home(),
          );
        });
      },
    );
  }
}
