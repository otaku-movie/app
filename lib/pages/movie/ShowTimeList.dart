import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/cinema/cinema_spec_response.dart';
import 'package:otaku_movie/response/movie/show_time.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:get/get.dart'; // Ensure this import is present

class ShowTimeList extends StatefulWidget {
  final String? id;
  final String? movieName;

  const ShowTimeList({super.key, this.id, this.movieName});

  @override
  State<ShowTimeList> createState() => _PageState();
}

class _PageState extends State<ShowTimeList> with TickerProviderStateMixin  {
  TabController? _tabController; // 改为可空
  List<ShowTimeResponse> data = [];
  List<CinemaSpecResponse> cinemaSpec = [];
  List<AreaResponse> areaTreeList = [];
  int tabLength = 0;
  bool loading = false;
  Map<String, dynamic> filterParams = {};

  @override
  void initState() {
    super.initState();
    getData();
    getCinemaSpec();
    getAreaTree();
  }

  getAreaTree () {
    ApiRequest().request(
      path: '/areas/tree',
      method: 'GET',
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json.map((item) => AreaResponse.fromJson(item)).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        List<AreaResponse> list = res.data!;
        
        setState(() {
          areaTreeList = list;
        });
        print(areaTreeList);
      }
    }).whenComplete(() {
    });
  }

  getCinemaSpec () {
    ApiRequest().request(
      path: '/cinema/spec/list',
      method: 'POST',
       data: {
        'page': 1,
        'pageSize': 30,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<CinemaSpecResponse>.fromJson(
          json,
          (data) => CinemaSpecResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      if (res.data?.list != null) {
        List<CinemaSpecResponse> list = res.data!.list!;
        
        setState(() {
          cinemaSpec = list;
        });
        print(cinemaSpec);
      }
    }).whenComplete(() {
    });
  }



  getData() {
    setState(() {
      loading = true;
    });

    final areaIdList = filterParams['areaId'] ?? [];
    final params = {
      "regionId": int.tryParse(areaIdList.length > 0 ? areaIdList[0] : ''),
      "prefectureId": int.tryParse(areaIdList.length > 1 ? areaIdList[1] : ''),
      "cityId": int.tryParse(areaIdList.length > 2 ? areaIdList[2] : ''),
    };

    ApiRequest().request(
      path: '/app/movie/showTime',
      method: 'POST',
      data: {
        "movieId": int.parse(widget.id!),
        "page": 1,
        "subtitleId": int.tryParse((filterParams['subtitleId'] ?? []).length > 0 ? filterParams['subtitleId'][0] : ''),
        "specId": filterParams['specId'],
        ...params,
      },
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json.map((item) => ShowTimeResponse.fromJson(item)).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          data = res.data!;
          _tabController?.dispose();
          tabLength = data.length;
        });

        // 在数据加载后初始化 TabController
        _tabController = TabController(length: tabLength, vsync: this);
      }
    }).whenComplete((){
      setState(() {
        loading = false;
      });
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
    FilterValue convertToFilterValue(dynamic item) {
      return FilterValue(
        id: item.id.toString(),
        name: item.name ?? '',
        children: (item.children != null && (item.children as List).isNotEmpty)
            ? (item.children as List).map((child) => convertToFilterValue(child)).toList()
            : null,
      );
    }

    if (loading) {
      return Scaffold(
        appBar: CustomAppBar(title: widget.movieName),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      initialIndex: 0,
      length: tabLength > 0 ? tabLength : 1, // 至少为1，防止TabController报错
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: CustomAppBar(
          title: widget.movieName,
          bottom: (data.isNotEmpty && _tabController != null)
              ? TabBar(
                  controller: _tabController,
                  tabs: generateTab(),
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.h),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.6),
                  labelStyle: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.normal),
                  indicator: UnderlineTabIndicator(
                    borderSide: const BorderSide(width: 3, color: Colors.white),
                    insets: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                )
              : null,
          backgroundColor: const Color(0xFF1989FA),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 36.sp, fontWeight: FontWeight.w600),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 筛选栏始终保留
            FilterBar(
              filters: [
                 FilterOption(
                  key: 'areaId',
                  title: S.of(context).movieShowList_dropdown_area,
                  multi: false,
                  nested: true,
                  values:  areaTreeList.map((item) => convertToFilterValue(item)).toList(),
                ),
                FilterOption(
                  key: 'specId',
                  title: S.of(context).movieShowList_dropdown_screenSpec,
                  values: cinemaSpec.map((item) {
                    return FilterValue(id: item.id.toString(), name: item.name ?? '');
                  }).toList(),
                ),
                 FilterOption(
                  key: 'subtitleId',
                  title: S.of(context).movieShowList_dropdown_subtitle,
                  values: [
                    FilterValue(id: '1', name: '电影'),
                    FilterValue(id: '2', name: '音乐'),
                    FilterValue(id: '3', name: '书籍'),
                  ],
                ),
               
              ],
              initialSelected: filterParams, // 只初始化时传递
              onConfirm: (selected) {
                setState(() {
                  filterParams = selected;
                });
                getData();
              },
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: (data.isEmpty || _tabController == null)
                  ? Center(
                      child: Text(
                        '暂无数据',
                        style: TextStyle(fontSize: 32.sp, color: Colors.grey),
                      ),
                    )
                  : EasyRefresh.builder(
                      header: customHeader(context),
                      footer: customFooter(context),
                      onRefresh: _onRefresh,
                      childBuilder: (context, physics) {
                        return TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: data.map((item) {
                            return ListView.builder(
                              physics: physics,
                              itemCount: item.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                final children = item.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    context.pushNamed('showTimeDetail', 
                                      pathParameters: {
                                        "id": '${widget.id}'
                                      },
                                      queryParameters: {
                                        "movieId": widget.id,
                                        "cinemaId": '${children.cinemaId}'
                                      }
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                children.cinemaName ?? '',
                                                style: TextStyle(
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(0xFF323233),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1989FA).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    size: 16.sp,
                                                    color: const Color(0xFF1989FA),
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  Text(
                                                    '3.7km',
                                                    style: TextStyle(
                                                      fontSize: 22.sp,
                                                      color: const Color(0xFF1989FA),
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 20.sp,
                                              color: Colors.grey.shade400,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.place_outlined,
                                              size: 18.sp,
                                              color: Colors.grey.shade500,
                                            ),
                                            SizedBox(width: 6.w),
                                            Expanded(
                                              child: Text(
                                                children.cinemaAddress ?? '',
                                                style: TextStyle(
                                                  fontSize: 24.sp,
                                                  color: Colors.grey.shade600,
                                                  height: 1.4,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
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
          ],
        ),
      )
    );
  }

  FutureOr _onRefresh() {
  }

  FutureOr _onLoad() {
  }
}

