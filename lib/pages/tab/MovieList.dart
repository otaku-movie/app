import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/pages/tab/NowShowing.dart';
import 'package:otaku_movie/pages/tab/comingSoon.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import 'package:otaku_movie/response/response.dart';
import '../../components/Input.dart';
import '../../generated/l10n.dart';
import '../../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';
import 'package:go_router/go_router.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _PageState();
}

class _PageState extends State<MovieList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  int _gridCount = 20;
  int _listCount = 0;

  List<MovieNowShowingResponse> data = [];
  

  void getData() {
    ApiRequest().request(
      path: '/app/movie/list',
      method: 'GET',
      queryParameters: {
        "page": 1,
        "pageSize": 10
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieNowShowingResponse>.fromJson(json, (data) {
          return MovieNowShowingResponse.fromJson(data as Map<String, dynamic>);  // 解析每个元素
        });
        
      },
    ).then((res) {
      setState(() {
        data = res.data?.list ?? [];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    getData();
    // await Future.delayed(const Duration(seconds: 2), () {
    //   if (mounted) {
    //     setState(() {
    //       if (_tabController.index == 0) {
    //         _listCount = 20;
    //       } else {
    //         _gridCount = 20;
    //       }
    //     });
    //   }
    // });
  }

  Future<void> _onLoad() async {
    // await Future.delayed(const Duration(seconds: 2), () {
    //   if (mounted) {
    //     setState(() {
    //       if (_tabController.index == 0) {
    //         _listCount += 10;
    //       } else {
    //         _gridCount += 10;
    //       }
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    final tabs = <Widget>[
      Text(S.of(context).movieList_tabBar_currentlyShowing,
          style: TextStyle(color: Colors.white, fontSize: 32.sp)),
      Text(S.of(context).movieList_tabBar_comingSoon,
          style: TextStyle(color: Colors.white, fontSize: 32.sp)),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              context.goNamed('search');
            },
            child:  Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 244, 243, 243)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('搜索全部电影', style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.grey.shade500
                  ),),
                  Icon(Icons.search_outlined,
                  color: Colors.grey.shade500)
                ],
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
            indicatorColor: Colors.blue,
            labelPadding: EdgeInsets.only(bottom: 15.h),
          ),
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: EasyRefresh.builder(
          header: const ClassicHeader(),
          footer: const ClassicFooter(),
          onRefresh: _onRefresh,
          onLoad: _onLoad,
          childBuilder: (context, physics) {
            return Container(
              // padding: const EdgeInsets.only(left: 10, right: 10),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  NowShowing(physics: physics),
                  ComingSoon(physics: physics)
                ],
              ),
            );
          },
        ),
        )
        
      ),
    );
  }
}
