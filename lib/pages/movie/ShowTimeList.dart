import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/cinema/cinema_spec_response.dart';
import 'package:otaku_movie/response/movie/show_time.dart';
import 'package:otaku_movie/response/language/language_response.dart';
import 'package:otaku_movie/generated/l10n.dart';

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
  List<LanguageResponse> languageList = []; // 添加字幕列表
  int tabLength = 0;
  bool loading = false;
  Map<String, dynamic> filterParams = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // 加载初始数据
  Future<void> _loadInitialData() async {
    await getData();
    await getCinemaSpec();
    await getAreaTree();
    await getLanguageList();
  }

  Future<void> getAreaTree() async {
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

  Future<void> getCinemaSpec() async {
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

  Future<void> getLanguageList() async {
    ApiRequest().request(
      path: '/language/list',
      method: 'POST',
      data: {
        'page': 1,
        'pageSize': 30,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<LanguageResponse>.fromJson(
          json,
          (data) => LanguageResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      if (res.data?.list != null) {
        List<LanguageResponse> list = res.data!.list!;
        
        setState(() {
          languageList = list;
        });
        print('字幕列表: $languageList');
      }
    }).whenComplete(() {
    });
  }



  Future<void> getData() async {
    setState(() {
      loading = true;
    });

    final areaIdList = filterParams['areaId'] ?? [];
    final params = {
      "regionId": int.tryParse(areaIdList.length > 0 ? areaIdList[0] : ''),
      "prefectureId": int.tryParse(areaIdList.length > 1 ? areaIdList[1] : ''),
      "cityId": int.tryParse(areaIdList.length > 2 ? areaIdList[2] : ''),
    };

    // 构建请求参数，只添加非空的筛选条件
    Map<String, dynamic> requestData = {
      "movieId": int.parse(widget.id!),
      "page": 1,
      ...params,
    };
    
    // 只有当字幕ID不为空时才添加
    final subtitleId = (filterParams['subtitleId'] ?? []).length > 0 ? filterParams['subtitleId'][0] : '';
    if (subtitleId.isNotEmpty) {
      requestData["subtitleId"] = int.tryParse(subtitleId);
    }
    
    // 只有当规格ID不为空时才添加
    final specId = filterParams['specId'];
    if (specId != null && specId.isNotEmpty) {
      requestData["specId"] = specId;
    }

    ApiRequest().request(
      path: '/app/movie/showTime',
      method: 'POST',
      data: requestData,
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json.map((item) => ShowTimeResponse.fromJson(item)).toList();
        }
      },
    ).then((res) {
      if (res.data != null && res.data!.isNotEmpty) {
        setState(() {
          data = res.data!;
          _tabController?.dispose();
          tabLength = data.length;
        });

        // 在数据加载后初始化 TabController
        _tabController = TabController(length: tabLength, vsync: this);
      } else {
        // 添加假数据用于测试
        _addFakeData();
      }
    }).catchError((error) {
      print('获取数据失败: $error');
      // API失败时也添加假数据
      _addFakeData();
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  // 添加假数据用于测试
  void _addFakeData() {
    final now = DateTime.now();
    
    // 创建多个场次，包含不同的座位状态
    List<ShowTime> showTimes1 = [
      // 售罄状态
      ShowTime(
        id: 1,
        theaterHallId: 1,
        theaterHallName: "1号厅",
        startTime: DateTime(now.year, now.month, now.day, 10, 30),
        endTime: DateTime(now.year, now.month, now.day, 12, 30),
        specName: "IMAX 3D",
        totalSeats: 200,
        selectedSeats: 200,
        availableSeats: 0, // 售罄
      ),
      // 紧张状态
      ShowTime(
        id: 2,
        theaterHallId: 1,
        theaterHallName: "1号厅",
        startTime: DateTime(now.year, now.month, now.day, 14, 30),
        endTime: DateTime(now.year, now.month, now.day, 16, 30),
        specName: "2D",
        totalSeats: 150,
        selectedSeats: 130,
        availableSeats: 20, // 紧张 (20/150 = 13.3% < 20%)
      ),
      // 充足状态
      ShowTime(
        id: 3,
        theaterHallId: 2,
        theaterHallName: "2号厅",
        startTime: DateTime(now.year, now.month, now.day, 16, 45),
        endTime: DateTime(now.year, now.month, now.day, 18, 45),
        specName: "3D",
        totalSeats: 180,
        selectedSeats: 50,
        availableSeats: 130, // 充足 (130/180 = 72.2% > 20%)
      ),
      // 更多场次用于测试超过6个的情况
      ShowTime(
        id: 4,
        theaterHallId: 2,
        theaterHallName: "2号厅",
        startTime: DateTime(now.year, now.month, now.day, 19, 0),
        endTime: DateTime(now.year, now.month, now.day, 21, 0),
        specName: "IMAX",
        totalSeats: 200,
        selectedSeats: 80,
        availableSeats: 120,
      ),
      ShowTime(
        id: 5,
        theaterHallId: 3,
        theaterHallName: "3号厅",
        startTime: DateTime(now.year, now.month, now.day, 21, 15),
        endTime: DateTime(now.year, now.month, now.day, 23, 15),
        specName: "2D",
        totalSeats: 120,
        selectedSeats: 15,
        availableSeats: 105,
      ),
      ShowTime(
        id: 6,
        theaterHallId: 3,
        theaterHallName: "3号厅",
        startTime: DateTime(now.year, now.month, now.day, 23, 30),
        endTime: DateTime(now.year, now.month, now.day + 1, 1, 30),
        specName: "3D",
        totalSeats: 120,
        selectedSeats: 110,
        availableSeats: 10, // 紧张
      ),
      ShowTime(
        id: 7,
        theaterHallId: 4,
        theaterHallName: "VIP厅",
        startTime: DateTime(now.year, now.month, now.day + 1, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
        specName: "IMAX 3D",
        totalSeats: 50,
        selectedSeats: 50,
        availableSeats: 0, // 售罄
      ),
      ShowTime(
        id: 8,
        theaterHallId: 4,
        theaterHallName: "VIP厅",
        startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 16, 0),
        specName: "4DX",
        totalSeats: 50,
        selectedSeats: 5,
        availableSeats: 45, // 充足
      ),
    ];

    List<ShowTime> showTimes2 = [
      // 第二个影院的场次
      ShowTime(
        id: 9,
        theaterHallId: 5,
        theaterHallName: "巨幕厅",
        startTime: DateTime(now.year, now.month, now.day, 11, 0),
        endTime: DateTime(now.year, now.month, now.day, 13, 0),
        specName: "IMAX",
        totalSeats: 300,
        selectedSeats: 250,
        availableSeats: 50,
      ),
      ShowTime(
        id: 10,
        theaterHallId: 5,
        theaterHallName: "巨幕厅",
        startTime: DateTime(now.year, now.month, now.day, 15, 0),
        endTime: DateTime(now.year, now.month, now.day, 17, 0),
        specName: "3D",
        totalSeats: 300,
        selectedSeats: 300,
        availableSeats: 0, // 售罄
      ),
    ];

    // 创建假数据
    List<ShowTimeResponse> fakeData = [
      ShowTimeResponse(
        date: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        data: [
          Cinema(
            cinemaId: 1,
            cinemaName: "万达影城（朝阳店）",
            cinemaAddress: "北京市朝阳区建国路93号万达广场",
            showTimes: showTimes1,
          ),
          Cinema(
            cinemaId: 2,
            cinemaName: "CGV影城（三里屯店）",
            cinemaAddress: "北京市朝阳区三里屯太古里南区",
            showTimes: showTimes2,
          ),
        ],
      ),
    ];

    setState(() {
      data = fakeData;
      _tabController?.dispose();
      tabLength = data.length;
    });

    // 在数据加载后初始化 TabController
    _tabController = TabController(length: tabLength, vsync: this);
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

    final currentYear = DateTime.now().year;

    return data.map((item) {
      DateTime date = DateTime.parse(item.date!);
      List<String> dateParts = item.date!.split("-");
      
      // 如果是今年，只显示月/日；如果不是今年，显示年/月/日
      String formattedDate;
      if (date.year == currentYear) {
        formattedDate = "${dateParts[1]}/${dateParts[2]}"; // 月/日
      } else {
        formattedDate = "${dateParts[0]}/${dateParts[1]}/${dateParts[2]}"; // 年/月/日
      }

      return Tab(
        child: Column(
          children: [
            Text(weekList[date.weekday - 1]), // 星期
            Text(formattedDate), // 日期
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
        name: item.name ?? S.of(context).about_components_showTimeList_unnamed,
        children: (item.children != null && (item.children as List).isNotEmpty)
            ? (item.children as List)
                .where((child) => child.name != null && child.name.toString().isNotEmpty)
                .map((child) => convertToFilterValue(child))
                .toList()
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
                  title: S.of(context).about_movieShowList_dropdown_area,
                  multi: false,
                  nested: true,
                  values: areaTreeList
                      .where((item) => item.name != null && item.name!.isNotEmpty)
                      .map((item) => convertToFilterValue(item))
                      .toList(),
                ),
                FilterOption(
                  key: 'specId',
                  title: S.of(context).about_movieShowList_dropdown_screenSpec,
                  values: [
                    FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
                    ...cinemaSpec.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
                      return FilterValue(id: item.id.toString(), name: item.name!);
                    }).toList(),
                  ],
                ),
                 FilterOption(
                  key: 'subtitleId',
                  title: S.of(context).about_movieShowList_dropdown_subtitle,
                  values: [
                    FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
                    ...languageList.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
                      return FilterValue(id: item.id.toString(), name: item.name!);
                    }).toList(),
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
                        S.of(context).about_components_showTimeList_noData,
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
                                            // Container(
                                            //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                            //   decoration: BoxDecoration(
                                            //     color: const Color(0xFF1989FA).withOpacity(0.1),
                                            //     borderRadius: BorderRadius.circular(20.r),
                                            //   ),
                                            //   child: Row(
                                            //     mainAxisSize: MainAxisSize.min,
                                            //     children: [
                                            //       Icon(
                                            //         Icons.location_on_outlined,
                                            //         size: 16.sp,
                                            //         color: const Color(0xFF1989FA),
                                            //       ),
                                            //       SizedBox(width: 4.w),
                                            //       Text(
                                            //         '3.7km',
                                            //         style: TextStyle(
                                            //           fontSize: 22.sp,
                                            //           color: const Color(0xFF1989FA),
                                            //           fontWeight: FontWeight.w500,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
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
                                              size: 24.sp,
                                              color: Colors.red,
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
                                        SizedBox(height: 12.h),
                                        // 场次信息（包含选座状态）
                                        _buildShowTimeInfo(children),
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

  FutureOr _onRefresh() async {
    // 重新获取数据
    await getData();
    await getCinemaSpec();
    await getAreaTree();
    await getLanguageList();
  }

  FutureOr _onLoad() {
  }

  // 构建场次信息
  Widget _buildShowTimeInfo(Cinema children) {
    if (children.showTimes == null || children.showTimes!.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(
              Icons.schedule_outlined,
              size: 20.sp,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 8.w),
            Text(
              S.of(context).about_components_showTimeList_noShowTimeInfo,
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // 分割线
        // Container(
        //   height: 1.h,
        //   margin: EdgeInsets.only(bottom: 12.h),
        //   color: Colors.grey.shade200,
        // ),
        // 横向滚动的场次卡片
        SizedBox(
          height: 200.h, // 设置固定高度
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: children.showTimes!.map((showTime) {
                return Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: _buildShowTimeCard(showTime),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // 构建场次卡片
  Widget _buildShowTimeCard(ShowTime showTime) {
    // 获取选座状态
    int availableSeats = showTime.availableSeats ?? 0;
    int totalSeats = showTime.totalSeats ?? 0;
    
    Color seatStatusColor;
    String seatStatusText;
    IconData seatStatusIcon;
    
    if (availableSeats == 0) {
      seatStatusColor = Colors.red;
      seatStatusText = S.of(context).about_components_showTimeList_seatStatus_soldOut;
      seatStatusIcon = Icons.event_seat;
    } else if (availableSeats <= totalSeats * 0.2) {
      seatStatusColor = Colors.orange;
      seatStatusText = S.of(context).about_components_showTimeList_seatStatus_limited;
      seatStatusIcon = Icons.event_seat;
    } else {
      seatStatusColor = Colors.green;
      seatStatusText = S.of(context).about_components_showTimeList_seatStatus_available;
      seatStatusIcon = Icons.event_seat;
    }

    return Container(
      width: 152.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 时间信息
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 24.sp,
                color: const Color(0xFF1989FA),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  showTime.startTime != null 
                      ? '${showTime.startTime!.hour.toString().padLeft(2, '0')}:${showTime.startTime!.minute.toString().padLeft(2, '0')}'
                      : '--:--',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323233),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // 结束时间
          Text(
            showTime.endTime != null 
                ? '${showTime.endTime!.hour.toString().padLeft(2, '0')}:${showTime.endTime!.minute.toString().padLeft(2, '0')}'
                : '--:--',
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 10.h),
          // 规格信息
          if (showTime.specName != null && showTime.specName!.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1989FA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                showTime.specName!,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color(0xFF1989FA),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          SizedBox(height: 10.h),
          // 选座状态
          Row(
            children: [
              Icon(
                seatStatusIcon,
                size: 22.sp,
                color: seatStatusColor,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  seatStatusText,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: seatStatusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

