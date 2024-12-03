import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/movie/show_time.dart';
import '../../controller/LanguageController.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:get/get.dart'; // Ensure this import is present

class ShowTimeList extends StatefulWidget {
  final String? id;

  const ShowTimeList({super.key, this.id});

  @override
  State<ShowTimeList> createState() => _PageState();
}

class _PageState extends State<ShowTimeList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ShowTimeResponse> data = [];
  int tabLength = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    ApiRequest().request(
      path: '/app/movie/showTime',
      method: 'POST',
      data: {"movieId": int.parse(widget.id!)},
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json.map((item) => ShowTimeResponse.fromJson(item)).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          data = res.data!;
          tabLength = data.length;
        });

        // 在数据加载后初始化 TabController
        _tabController = TabController(length: tabLength, vsync: this);
      }
    });
  }

  List<Widget> generateTab() {
    List<String> weekList = [
      S.of(context).common_week_monday,
      S.of(context).common_week_tuesday,
      S.of(context).common_week_wednesday,
      S.of(context).common_week_thursday,
      S.of(context).common_week_friday,
      S.of(context).common_week_saturday,
      S.of(context).common_week_sunday,
    ];

    return data.map((item) {
      DateTime date = DateTime.parse(item.date!);
      List<String> dateParts = item.date!.split("-");
      String formattedDate = "${dateParts[1]}/${dateParts[2]}";

      return Tab(
        child: Column(
          children: [
            Text(weekList[date.weekday - 1]), // 星期
            Text(formattedDate), // 日期格式为 "月/日"
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? const Scaffold(
            appBar:  CustomAppBar(
              title: "电影名称"
            ),
            body: Center(child: CircularProgressIndicator()), // 数据未加载时显示加载指示器
          )
        : DefaultTabController(
            initialIndex: 0,
            length: tabLength,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBar(
                title: "电影名称",
                bottom: TabBar(
                  controller: _tabController,
                  tabs: generateTab(),
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.h),  
                  labelColor: Colors.white, // 设置选中标签的颜色
                  unselectedLabelColor: Colors.white70, // 设置未选中标签的颜色
                  indicatorColor: Colors.blue, // 设置选中时的指示器颜色
                ),
                backgroundColor: Colors.blue,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 36.sp),
              ),
              body: EasyRefresh.builder(
                header: const ClassicHeader(),
                // footer: const ClassicFooter(),
                onRefresh: _onRefresh,
                // onLoad: _onLoad,
                childBuilder: (context, physics) {
                  return TabBarView(
                    controller: _tabController,
                    physics: const BouncingScrollPhysics(),  // 使 TabBarView 支持滑动
                    children: data.map((item) {
                      return ListView.builder(
                        physics: physics,
                        itemCount: item.data?.length,
                        itemBuilder: (context, index) {
                          Cinema children = item.data![index];
                          
                          return GestureDetector(
                            onTap: () {
                              context.pushNamed('showTimeDetail', pathParameters: {
                                "id": widget.id ?? ''
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              // height: 350.h,
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: Color(0XFFe6e6e6),
                                  ),
                                ),
                              ),
                              child: Space(
                                direction: "column",
                                bottom: 8.h,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        spacing: 4.w,
                                        children: [
                                          Text(children.cinemaName ?? '', style: TextStyle(fontSize: 36.sp)),
                                          const Icon(Icons.star, color: Color(0xFFebb21b)),
                                        ],
                                      ),
                                      Wrap(
                                        spacing: 4.w,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Text('3.7km', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
                                          Icon(Icons.arrow_forward_ios, size: 36.sp, color: Colors.grey.shade600),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(children.cinemaAddress ?? '', style: TextStyle(color: Colors.grey.shade400)),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '今日上映场次共',
                                          style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600),
                                        ),
                                        TextSpan(
                                          text: '${children.time?.length}',
                                          style: TextStyle(fontSize: 28.sp, color: Colors.red),
                                        ),
                                        TextSpan(
                                          text: '场',
                                          style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          );
  }

  FutureOr _onRefresh() {
  }

  FutureOr _onLoad() {
  }
}

