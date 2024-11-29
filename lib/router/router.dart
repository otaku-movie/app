import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/pages/Home.dart';
import 'package:otaku_movie/pages/tab/MovieList.dart';
import 'package:otaku_movie/pages/User.dart';
import 'package:otaku_movie/pages/movie/SelectMovieTicketPage.dart';
import 'package:otaku_movie/pages/movie/SelectSeatPage.dart';
import 'package:otaku_movie/pages/movie/ShowTimeDetail.dart';
import 'package:otaku_movie/pages/movie/ShowTimeList.dart';
import 'package:otaku_movie/pages/movie/confirmOrder.dart';
import 'package:otaku_movie/pages/movie/movieDetail.dart';
import 'package:otaku_movie/pages/movie/payError.dart';
import 'package:otaku_movie/pages/movie/paySuccess.dart';
import 'package:otaku_movie/pages/order/orderDetail.dart';
import 'package:otaku_movie/pages/order/orderList.dart';
import 'package:otaku_movie/pages/search.dart';
import 'package:otaku_movie/pages/user/login.dart';
import 'package:otaku_movie/pages/user/register.dart';

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
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return Home();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/user/login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return Login();
          },
        ),
        GoRoute(
          path: '/user/register',
          name: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return Register();
          },
        ),
        GoRoute(
          path: '/movie/search',
          name: 'search',
          builder: (BuildContext context, GoRouterState state) {
            return const Search();
          },
        ),
        GoRoute(
          path: '/movie/movieList',
          name: 'movieList',
          builder: (BuildContext context, GoRouterState state) {
            return const MovieList();
          },
        ),
        GoRoute(
          path: '/movie/detail/:id',
          name: 'movieDetail',
          builder: (BuildContext context, GoRouterState state) {
            return MovieDetail(id: state.pathParameters['id']);
          },
        ),
        GoRoute(
          path: '/movie/showTimeList/:id',
          name: 'showTimeList',
          builder: (BuildContext context, GoRouterState state) {
            return ShowTimeList(id: state.pathParameters['id']);
          },
        ),
        GoRoute(
          path: '/movie/showTimeList/:id/showTimeDetail',
          name: 'showTimeDetail',
          builder: (BuildContext context, GoRouterState state) {
            return ShowTimeDetail(id: state.pathParameters['id']);
          },
        ),
        GoRoute(
          path: '/movie/selectSeat',
          name: 'selectSeat',
          builder: (BuildContext context, GoRouterState state) {
            return SelectSeatPage();
          },
        ),
        GoRoute(
          path: '/movie/selectMovieTicket',
          name: 'selectMovieTicket',
          builder: (BuildContext context, GoRouterState state) {
            return const SelectMovieTicketPage();
          },
        ),
        GoRoute(
          path: '/movie/confirmOrder',
          name: 'confirmOrder',
          builder: (BuildContext context, GoRouterState state) {
            return const ConfirmOrder();
          },
        ),
        GoRoute(
          path: '/movie/order/success',
          name: 'paySuccess',
          builder: (BuildContext context, GoRouterState state) {
            return const PaySuccess();
          },
        ),
         GoRoute(
          path: '/movie/order/error',
          name: 'payError',
          builder: (BuildContext context, GoRouterState state) {
            return const PayError();
          },
        ),
        GoRoute(
          path: '/me',
          name: 'me',
          builder: (BuildContext context, GoRouterState state) {
            return const UserInfo();
          },
        ),
        GoRoute(
          path: '/me/orderList',
          name: 'orderList',
          builder: (BuildContext context, GoRouterState state) {
            return const OrderList();
          },
        ),
         GoRoute(
          path: '/me/orderList/orderDetail',
          name: 'orderDetail',
          builder: (BuildContext context, GoRouterState state) {
            return const OrderDetail();
          },
        ),
      ],
    ),
  ],
);