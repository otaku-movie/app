import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/movie/show_time.dart';
import '../../controller/LanguageController.dart';
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

  List<Widget> getWeek() {
    List<String> weekList = ['一', '二', '三', '四', '五', '六', '日'];
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
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("东宝シネマズ 新宿", style: TextStyle(fontSize: 33.sp, color: Colors.white)),
              backgroundColor: Colors.blue,
            ),
            body: const Center(child: CircularProgressIndicator()), // 数据未加载时显示加载指示器
          )
        : DefaultTabController(
            initialIndex: 0,
            length: tabLength,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Text("东宝シネマズ 新宿", style: TextStyle(fontSize: 33.sp)),
                bottom:TabBar(
                  controller: _tabController,
                  tabs: getWeek(),
                  labelPadding: EdgeInsets.only(bottom: 15.h),
                  labelColor: Colors.white, // 设置选中标签的颜色
                  unselectedLabelColor: Colors.black, // 设置未选中标签的颜色
                  indicatorColor: Colors.blue, // 设置选中时的指示器颜色
                ),
                backgroundColor: Colors.blue,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
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
                            child: Container(
                              width: double.infinity,
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
                            onTap: () {
                              context.goNamed('showTimeDetail');
                            },
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

