import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/pages/MovieList.dart';
import 'package:otaku_movie/pages/NotFound.dart';
import 'package:otaku_movie/pages/User.dart';
import 'package:otaku_movie/pages/Home.dart';
import 'package:otaku_movie/pages/setting.dart';

class Routes {
  static FluroRouter router = FluroRouter();
  static String root = '/';
  static String setting = '/setting';

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return Notfound();
    });
    router.define(root, handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return Home();
    }));
    router.define(setting, handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return Setting();
    }));

    router.define("/movie/movieList", handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const MovieList();
    }));
    router.define("/me", handler: Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return const UserInfo();
    }));
  }
}
