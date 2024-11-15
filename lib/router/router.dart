import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/pages/MovieList.dart';
import 'package:otaku_movie/pages/User.dart';
import 'package:otaku_movie/pages/movie/SelectMovieTicketPage.dart';
import 'package:otaku_movie/pages/movie/SelectSeatPage.dart';
import 'package:otaku_movie/pages/movie/ShowTimeDetail.dart';
import 'package:otaku_movie/pages/movie/ShowTimeList.dart';
import 'package:otaku_movie/pages/movie/confirmOrder.dart';

// class Routes {
//   static FluroRouter router = FluroRouter();
//   static String root = '/';
//   static String setting = '/setting';

//   static void configureRoutes(FluroRouter router) {
//     router.notFoundHandler = Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       return Notfound();
//     });
//     router.define(root, handler: Handler(
//         handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//       return Home();
//     }));
//     router.define(setting, handler: Handler(
//         handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
//       return Setting();
//     }));

//     router.define("/movie/movieList", handler: Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       return const MovieList();
//     }));
//      router.define("/movie/showTimeList", handler: Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       return const ShowTimeList();
//     }));
//     router.define("/me", handler: Handler(
//         handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
//       return const UserInfo();
//     }));
//   }
// }

final GoRouter routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ConfirmOrder();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/movie/movieList',
          builder: (BuildContext context, GoRouterState state) {
            return const MovieList();
          },
        ),
        GoRoute(
          path: '/movie/showTimeList',
          builder: (BuildContext context, GoRouterState state) {
            return const ShowTimeList();
          },
        ),
        GoRoute(
          path: '/movie/showTimeList/showTimeDetail',
          builder: (BuildContext context, GoRouterState state) {
            return const ShowTimeDetail();
          },
        ),
        GoRoute(
          path: '/movie/selectSeat',
          builder: (BuildContext context, GoRouterState state) {
            return SelectSeatPage();
          },
        ),
        GoRoute(
          path: '/movie/selectMovieTicket',
          builder: (BuildContext context, GoRouterState state) {
            return const SelectMovieTicketPage();
          },
        ),
         GoRoute(
          path: '/movie/confirmOrder',
          builder: (BuildContext context, GoRouterState state) {
            return const ConfirmOrder();
          },
        ),
        GoRoute(
          path: '/me',
          builder: (BuildContext context, GoRouterState state) {
            return const UserInfo();
          },
        ),
        GoRoute(
          path: '/movie/detail',
          builder: (BuildContext context, GoRouterState state) {
            return const MovieList();
          },
        ),
      ],
    ),
  ],
);