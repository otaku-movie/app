import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/components/cropper.dart';
import 'package:otaku_movie/pages/Home.dart';
import 'package:otaku_movie/pages/cinema/cinemaDetail.dart';
import 'package:otaku_movie/pages/movie/commentDetail.dart';
import 'package:otaku_movie/pages/movie/writeComment.dart';
import 'package:otaku_movie/pages/tab/MovieList.dart';
import 'package:otaku_movie/pages/user/User.dart';
import 'package:otaku_movie/pages/movie/SelectMovieTicket.dart';
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
import 'package:otaku_movie/pages/user/forgotPassword.dart';
import 'package:otaku_movie/pages/user/login.dart';
import 'package:otaku_movie/pages/user/profile.dart';
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
      name: 'root',
      builder: (BuildContext context, GoRouterState state) {
        return const Login(
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const Home();
          },
        ),
         GoRoute(
          path: '/movie/writeComment',
          name: 'writeComment',
          builder: (BuildContext context, GoRouterState state) {
            return WriteComment(
              id: state.uri.queryParameters['id'],
              movieName: state.uri.queryParameters['movieName'],
              rated: state.uri.queryParameters['rated'] == 'true',
            );
          },
        ),
        GoRoute(
          path: '/user/forgotPassword',
          name: 'forgotPassword',
          builder: (BuildContext context, GoRouterState state) {
            return ForgotPassword();
          },
        ),
        GoRoute(
          path: '/user/login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const Login();
          },
        ),
        GoRoute(
          path: '/user/register',
          name: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const Register();
          },
        ),
        GoRoute(
          path: '/user/profile',
          name: 'userProfile',
          builder: (BuildContext context, GoRouterState state) {
            return UserProfile(
              id: state.uri.queryParameters['id']
            );
          },
        ),
        GoRoute(
          path: '/cinema/detail',
          name: 'cinemaDetail',
          builder: (BuildContext context, GoRouterState state) {
            return CinemaDetail(
              id: state.uri.queryParameters['id']
            );
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
          path: '/movie/comment/detail',
          name: 'commentDetail',
          builder: (BuildContext context, GoRouterState state) {
            return CommentDetail(
              id: state.uri.queryParameters['id'],
              movieId: state.uri.queryParameters['movieId'],
            );
          },
        ),
        GoRoute(
          path: '/movie/showTimeList/:id',
          name: 'showTimeList',
          builder: (BuildContext context, GoRouterState state) {
            return ShowTimeList(
              id: state.pathParameters['id'],
              movieName: state.uri.queryParameters['movieName']
            );
          },
        ),
        GoRoute(
          path: '/movie/showTimeList/:id/showTimeDetail',
          name: 'showTimeDetail',
          builder: (BuildContext context, GoRouterState state) {
            return ShowTimeDetail(
              movieId: state.uri.queryParameters['movieId'],
              cinemaId: state.uri.queryParameters['cinemaId']
            );
          },
        ),
        GoRoute(
          path: '/movie/selectSeat',
          name: 'selectSeat',
          builder: (BuildContext context, GoRouterState state) {
            return SelectSeatPage(
              id: state.uri.queryParameters['id'], 
              theaterHallId: state.uri.queryParameters['theaterHallId']
            );
          },
        ),
        GoRoute(
          path: '/cinema/selectMovieTicketType',
          name: 'selectMovieTicketType',
          builder: (BuildContext context, GoRouterState state) {
            return SelectMovieTicketType(
              cinemaId: state.uri.queryParameters['cinemaId'],
                movieShowTimeId: state.uri.queryParameters['movieShowTimeId']
            );
          },
        ),
        GoRoute(
          path: '/movie/confirmOrder',
          name: 'confirmOrder',
          builder: (BuildContext context, GoRouterState state) {
            return ConfirmOrder(
              id: state.uri.queryParameters['id'],
            );
          },
        ),
        GoRoute(
          path: '/movie/order/success',
          name: 'paySuccess',
          builder: (BuildContext context, GoRouterState state) {
            return PaySuccess(
              orderId: state.uri.queryParameters['orderId'], 
            );
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
            return OrderDetail(
              id: state.uri.queryParameters['id'],
            );
          },
        ),
      ],
    ),
  ],
);