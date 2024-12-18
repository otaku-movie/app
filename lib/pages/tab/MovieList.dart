import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
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
  
  List<MovieNowShowingResponse> data = [];
  

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: CustomAppBar(
          title: GestureDetector(
            onTap: () {
              context.pushNamed('search');
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
                  Text(S.of(context).search_placeholder, style: TextStyle(
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
          child: TabBarView(
            controller: _tabController,
            children: const <Widget>[
              NowShowing(),
              ComingSoon()
            ],
          )
        )
        
      ),
    );
  }
}
