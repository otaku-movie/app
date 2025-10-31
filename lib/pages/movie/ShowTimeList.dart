import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/cinema/cinema_spec_response.dart';
import 'package:otaku_movie/response/movie/show_time.dart';
import 'package:otaku_movie/response/language/language_response.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_show_time_detail_response.dart';
import 'package:otaku_movie/utils/location_util.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  List<ShowTimeTag> showTimeTagList = []; // 添加上映标签列表
  int tabLength = 0;
  bool loading = false;
  bool error = false;
  Map<String, dynamic> filterParams = {};
  Placemark? location;
  Position? position;
  String? currentAddressFull;
  bool locationLoading = false;
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _tabController = null;
    easyRefreshController.dispose();
    super.dispose();
  }

  // 加载初始数据
  Future<void> _loadInitialData() async {
    // 开始时设置 loading 状态
    setState(() {
      loading = true;
      error = false;
    });
    
    // 先加载筛选数据
    await getCinemaSpec();
    await getAreaTree();
    await getLanguageList();
    await getShowTimeTagList();
    
    // 先加载数据（显示loading），然后再获取位置
    await getData();
    
    // 后台获取位置信息，获取到位置后重新加载数据计算距离
    getLocation();
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

  Future<void> getShowTimeTagList() async {
    ApiRequest().request(
      path: '/showTimeTag/list',
      method: 'POST',
      data: {
        'page': 1,
        'pageSize': 30,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<ShowTimeTag>.fromJson(
          json,
          (data) => ShowTimeTag.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      if (res.data?.list != null) {
        List<ShowTimeTag> list = res.data!.list!;
        
        setState(() {
          showTimeTagList = list;
        });
        print('上映标签列表: $showTimeTagList');
      }
    }).catchError((error) {
      print('获取上映标签列表失败: $error');
    }).whenComplete(() {
    });
  }

  Future<void> getLocation() async {
    try {
      if (mounted) {
        setState(() {
          locationLoading = true;
        });
      }
      final current = await LocationUtil.getCurrentPosition(accuracy: LocationAccuracy.high);
      if (current == null) {
        // 获取不到位置，不设置 loading = false，让后续逻辑处理
        return;
      }
      final place = await LocationUtil.reverseGeocode(current);
      final full = await LocationUtil.reverseGeocodeTextLocalized(context, current);
      if (!mounted) return;
      setState(() {
        location = place;
        position = current;
        currentAddressFull = full;
      });
      // 获取到位置信息后，重新获取数据，以便计算距离
      getData(refresh: true);
    } catch (e) {
      print('Error getting location: $e');
      // 获取位置失败，不阻止数据加载
    } finally {
      if (mounted) {
        setState(() {
          locationLoading = false;
        });
      }
    }
  }



  Future<void> getData({bool refresh = false}) async {
    if (!refresh) {
    setState(() {
      loading = true;
        error = false;
    });
    }

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
    
    // 只有当上映标签ID不为空时才添加
    final showTimeTagId = (filterParams['showTimeTagId'] ?? []).length > 0 ? filterParams['showTimeTagId'][0] : '';
    if (showTimeTagId.isNotEmpty) {
      requestData["showTimeTagId"] = int.tryParse(showTimeTagId);
    }
    
    // 添加经纬度参数，用于后端查询附近影院
    if (position != null) {
      requestData['latitude'] = position!.latitude;
      requestData['longitude'] = position!.longitude;
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
        List<ShowTimeResponse> list = res.data!;
        
        // 计算距离并排序
        if (position != null) {
          _computeDistancesForList(list);
          print('✅ 距离计算完成, position: ${position!.latitude}, ${position!.longitude}');
        } else {
          print('⚠️ position 为 null，无法计算距离');
        }
        
        if (!mounted) return;
        
        setState(() {
          data = list;
          _tabController?.dispose();
          _tabController = null;
          tabLength = data.length;
          loading = false;
          error = false;
        });

        // 在数据加载后初始化 TabController（确保页面还在 mounted）
        if (mounted && tabLength > 0) {
          _tabController = TabController(length: tabLength, vsync: this);
        }
        
        // 通知 EasyRefresh 刷新完成
        if (refresh) {
          easyRefreshController.finishRefresh(IndicatorResult.success, true);
        }
      } else {
        // 数据为空，清空列表
        if (!mounted) return;
        
        setState(() {
          data = [];
          _tabController?.dispose();
          _tabController = null;
          tabLength = 0;
          loading = false;
          error = false;
        });
        
        // 通知 EasyRefresh 刷新完成
        if (refresh) {
          easyRefreshController.finishRefresh(IndicatorResult.success, true);
        }
      }
    }).catchError((err) {
      print('获取数据失败: $err');
      // API失败时设置错误状态
      if (!mounted) return;
      
      setState(() {
        data = [];
        _tabController?.dispose();
        _tabController = null;
        tabLength = 0;
        loading = false;
        error = true;
      });
      
      // 通知 EasyRefresh 刷新失败
      if (refresh) {
        easyRefreshController.finishRefresh(IndicatorResult.fail, true);
      }
    });
  }

  // 计算距离并排序
  void _computeDistancesForList(List<ShowTimeResponse> responses) {
    if (position == null) {
      print('⚠️ _computeDistancesForList: position 为 null');
      return;
    }
    
    for (var response in responses) {
      if (response.data == null) continue;
      int computedCount = 0;
      for (var cinema in response.data!) {
        if (cinema.cinemaLatitude != null && cinema.cinemaLongitude != null) {
          final distance = LocationUtil.distanceBetweenMeters(
            position!,
            cinema.cinemaLatitude,
            cinema.cinemaLongitude,
          );
          if (distance != null) {
            cinema.distance = distance;
            computedCount++;
            print('📍 影院 ${cinema.cinemaName}: 距离 ${distance.toStringAsFixed(0)}m (${cinema.cinemaLatitude}, ${cinema.cinemaLongitude})');
          } else {
            print('⚠️ 无法计算 ${cinema.cinemaName} 的距离');
          }
        } else {
          print('⚠️ ${cinema.cinemaName} 缺少经纬度: lat=${cinema.cinemaLatitude}, lng=${cinema.cinemaLongitude}');
        }
      }
      print('✅ 已计算 ${computedCount}/${response.data!.length} 个影院的距离');
      
      // 按距离排序
      response.data!.sort((a, b) {
        final distA = a.distance ?? double.infinity;
        final distB = b.distance ?? double.infinity;
        return distA.compareTo(distB);
      });
    }
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
        body: AppErrorWidget(loading: loading, child: Container()),
      );
    }

    return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: CustomAppBar(
          title: widget.movieName,
          bottom: (data.isNotEmpty && _tabController != null && mounted)
              ? TabBar(
                  controller: _tabController!,
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
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 12.h, left: 16.w, right: 16.w, bottom: 12.h),
              child: FilterBar(
                style: FilterBarStyle(
                  dropdownGap: 10.h,
                ),
              filters: [
                 FilterOption(
                  key: 'areaId',
                  title: S.of(context).about_movieShowList_dropdown_area,
                  multi: false,
                  nested: true,
                  icon: Icons.location_on_rounded,
                  values: [
                    FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
                    ...areaTreeList
                        .where((item) => item.name != null && item.name!.isNotEmpty)
                        .map((item) => convertToFilterValue(item))
                        .toList(),
                  ],
                ),
                FilterOption(
                  key: 'specId',
                  title: S.of(context).about_movieShowList_dropdown_screenSpec,
                  icon: Icons.movie_filter_rounded,
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
                  icon: Icons.subtitles_rounded,
                  values: [
                    FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
                    ...languageList.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
                      return FilterValue(id: item.id.toString(), name: item.name!);
                    }).toList(),
                  ],
                ),
                FilterOption(
                  key: 'showTimeTagId',
                  title:  S.of(context).about_movieShowList_dropdown_tag,
                  icon: Icons.local_activity_rounded,
                  values: [
                    FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
                    ...showTimeTagList.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
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
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: AppErrorWidget(
                loading: loading,
                error: error,
                onRetry: () => getData(refresh: true),
                child: EasyRefresh.builder(
                  controller: easyRefreshController,
                      header: customHeader(context),
                      footer: customFooter(context),
                  onRefresh: () async {
                    await getData(refresh: true);
                  },
                      childBuilder: (context, physics) {
                    if (data.isEmpty || _tabController == null || !mounted) {
                      // 没有数据时，使用 SingleChildScrollView 确保可以下拉刷新
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 300.h,
                          padding: EdgeInsets.symmetric(vertical: 100.h),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.movie_creation_outlined,
                                  size: 64.sp,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  S.of(context).about_components_showTimeList_noData,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    
                        if (!mounted || _tabController == null) {
                          return const SizedBox.shrink();
                        }
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
                                            // 显示距离
                                            if (children.distance != null)
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
                                                      LocationUtil.formatDistanceLocalized(context, children.distance!),
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
                ),
          ],
        ),
      );
  }

  FutureOr _onRefresh() async {
    // 重新获取数据
    await getData(refresh: true);
    await getCinemaSpec();
    await getAreaTree();
    await getLanguageList();
    await getShowTimeTagList();
    await getLocation();
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

