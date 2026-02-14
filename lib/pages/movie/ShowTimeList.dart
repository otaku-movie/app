import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
import 'package:get/get.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/controller/DictController.dart';
import 'package:otaku_movie/response/dict_response.dart';
import 'package:otaku_movie/utils/date_format_util.dart';

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
  List<DictItemResponse> versionList = []; // 版本列表（字典 dubbingVersion）
  List<DictItemResponse> dimensionList = []; // 2D/3D 列表（字典 dimensionType）
  late DictController dictController; // 字典控制器
  int tabLength = 0;
  bool loading = false;
  bool error = false;
  Map<String, dynamic> filterParams = {
    'use30HourFormat': true,
  };
  Placemark? location;
  Position? position;
  String? currentAddressFull;
  bool locationLoading = false;
  TextEditingController searchController = TextEditingController(); // 搜索关键词控制器
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    dictController = Get.find<DictController>();
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    _tabController = null;
    easyRefreshController.dispose();
    searchController.dispose();
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
    await getVersionList();
    
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
      if (!mounted) return;
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
      if (!mounted) return;
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
      if (!mounted) return;
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
      if (!mounted) return;
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

  Future<void> getVersionList() async {
    if (!mounted) return;
    setState(() {
      if (dictController.dict.value['dubbingVersion'] != null) {
        versionList = dictController.dict.value['dubbingVersion']!;
      }
      if (dictController.dict.value['dimensionType'] != null) {
        dimensionList = dictController.dict.value['dimensionType']!;
      }
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



  /// 从 filterParams 中获取第一个值并转换为整数
  int? _getIntFromFilter(String key) {
    final value = filterParams[key];
    if (value is List && value.isNotEmpty) {
      final str = value[0]?.toString() ?? '';
      if (str.isNotEmpty && str != '') {
        return int.tryParse(str);
      }
    }
    return null;
  }

  /// 从 filterParams 中获取列表值
  List<int>? _getIntListFromFilter(String key) {
    final value = filterParams[key];
    if (value is List && value.isNotEmpty) {
      final list = value
          .where((item) => item != null && item.toString().isNotEmpty && item.toString() != '')
          .map((item) => int.tryParse(item.toString()))
          .whereType<int>()
          .toList();
      return list.isNotEmpty ? list : null;
    }
    return null;
  }

  /// 构建请求参数
  Map<String, dynamic> _buildRequestData() {
    final requestData = <String, dynamic>{
      "movieId": int.parse(widget.id!),
      "page": 1,
    };

    // 地区筛选
    final areaIdList = filterParams['areaId'] ?? [];
    if (areaIdList.isNotEmpty) {
      final regionId = int.tryParse(areaIdList[0]?.toString() ?? '');
      if (regionId != null) requestData["regionId"] = regionId;
      
      if (areaIdList.length > 1) {
        final prefectureId = int.tryParse(areaIdList[1]?.toString() ?? '');
        if (prefectureId != null) requestData["prefectureId"] = prefectureId;
      }
      
      if (areaIdList.length > 2) {
        final cityId = int.tryParse(areaIdList[2]?.toString() ?? '');
        if (cityId != null) requestData["cityId"] = cityId;
      }
    }

    // 筛选条件
    final subtitleId = _getIntFromFilter('subtitleId');
    if (subtitleId != null) requestData["subtitleId"] = subtitleId;

    final specId = _getIntListFromFilter('specId');
    if (specId != null) requestData["specId"] = specId;

    final showTimeTagId = _getIntFromFilter('showTimeTagId');
    if (showTimeTagId != null) requestData["showTimeTagId"] = showTimeTagId;

    final dimensionType = _getIntFromFilter('dimensionType');
    if (dimensionType != null) requestData["dimensionType"] = dimensionType;

    final versionCode = _getIntFromFilter('versionCode');
    if (versionCode != null) requestData["versionCode"] = versionCode;

    // 搜索关键词
    final keyword = searchController.text.trim();
    if (keyword.isNotEmpty) {
      requestData["keyword"] = keyword;
    }

    // 开场时间范围筛选
    final timeRange = filterParams['timeRange'];
    if (timeRange is List && timeRange.length == 2) {
      final startTime = timeRange[0]?.toString();
      final endTime = timeRange[1]?.toString();
      
      if (startTime != null && startTime.isNotEmpty) {
        requestData["startTimeFrom"] = startTime;
      }
      if (endTime != null && endTime.isNotEmpty) {
        requestData["startTimeTo"] = endTime;
      }
    }

    // 30小时制开关
    final use30HourFormat = filterParams['use30HourFormat'];
    if (use30HourFormat is bool && use30HourFormat) {
      requestData["use30HourFormat"] = true;
    } else if (use30HourFormat == 'true') {
      requestData["use30HourFormat"] = true;
    }

    // 经纬度参数（用于附近影院查询）
    if (position != null) {
      requestData['latitude'] = position!.latitude;
      requestData['longitude'] = position!.longitude;
    }

    return requestData;
  }

  Future<void> getData({bool refresh = false}) async {
    // 记录调用接口前的tab日期（如果有的话），用于接口返回后恢复tab
    String? previousTabDate;
    if (_tabController != null && 
        _tabController!.index >= 0 && 
        _tabController!.index < data.length &&
        data[_tabController!.index].date != null) {
      previousTabDate = data[_tabController!.index].date;
    }
    
    if (!refresh) {
      if (!mounted) return;
      setState(() {
        loading = true;
        error = false;
      });
    }

    final requestData = _buildRequestData();

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
        
        // 查找新数据中对应日期的index
        int? targetIndex;
        if (previousTabDate != null) {
          targetIndex = list.indexWhere((item) => item.date == previousTabDate);
          // 如果找不到相同的日期，使用第一个tab（index 0）
          if (targetIndex < 0 || targetIndex >= list.length) {
            targetIndex = 0;
          }
        } else {
          // 如果没有之前的tab日期，使用第一个tab（index 0）
          targetIndex = 0;
        }
        
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
          _tabController?.dispose();
          _tabController = TabController(
            length: tabLength, 
            vsync: this,
            initialIndex: targetIndex ?? 0,
          );
          // 添加tab切换监听，更新时间范围筛选器的日期
          _tabController!.addListener(_onTabChanged);
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



  /// Tab切换监听：更新时间范围筛选器的日期部分，保持时间不变，并重新加载数据
  void _onTabChanged() {
    if (_tabController == null) {
      return;
    }
    
    // 只在tab切换完成时执行（不是切换过程中）
    if (_tabController!.indexIsChanging) {
      return;
    }
    
    // 检查是否有时间范围筛选
    final timeRange = filterParams['timeRange'];
    if (timeRange is List && timeRange.length >= 2) {
      try {
        final startTimeStr = timeRange[0]?.toString();
        final endTimeStr = timeRange[1]?.toString();
        
        if (startTimeStr != null && startTimeStr.isNotEmpty &&
            endTimeStr != null && endTimeStr.isNotEmpty) {
          // 解析当前时间范围
          final startDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(startTimeStr);
          final endDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endTimeStr);
          
          // 获取新的基准日期
          final newBaseDate = _getCurrentTabDate();
          
          // 提取时间部分（小时、分钟、秒）
          final startTimeOnly = TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute);
          final endTimeOnly = TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute);
          final endSecond = endDateTime.second;
          
          // 构建新的日期时间（使用新日期 + 原时间）
          DateTime newStartDateTime;
          DateTime newEndDateTime;
          
          // 检查结束时间是否是下一天（30小时制）
          final use30HourFormat = filterParams['use30HourFormat'];
          final isUse30HourFormat = (use30HourFormat is bool && use30HourFormat) || 
                                    (use30HourFormat == 'true' || use30HourFormat == true);
          
          if (isUse30HourFormat && endDateTime.day > startDateTime.day) {
            // 结束时间是下一天，保持这个逻辑
            newStartDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day,
              startTimeOnly.hour,
              startTimeOnly.minute,
            );
            newEndDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day + 1,
              endTimeOnly.hour,
              endTimeOnly.minute,
              endSecond,
            );
          } else {
            // 同一天的情况
            newStartDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day,
              startTimeOnly.hour,
              startTimeOnly.minute,
            );
            newEndDateTime = DateTime(
              newBaseDate.year,
              newBaseDate.month,
              newBaseDate.day,
              endTimeOnly.hour,
              endTimeOnly.minute,
              endSecond,
            );
          }
          
          // 更新时间范围
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
          setState(() {
            filterParams['timeRange'] = [
              dateFormat.format(newStartDateTime),
              dateFormat.format(newEndDateTime),
            ];
          });
        }
      } catch (e) {
        // 解析失败，忽略时间范围更新，但依然要重新加载数据
        print('更新时间范围失败: $e');
      }
      // 无论是否有时间范围筛选，tab切换时都重新加载数据
    getData();
    }
    
    
  }

  /// 获取当前 tab 对应的日期
  DateTime _getCurrentTabDate() {
    if (_tabController != null && 
        _tabController!.index >= 0 && 
        _tabController!.index < data.length &&
        data[_tabController!.index].date != null) {
      try {
        return DateTime.parse(data[_tabController!.index].date!);
      } catch (e) {
        // 解析失败，返回当前日期
        return DateTime.now();
      }
    }
    // 如果没有 tab 或数据为空，返回当前日期
    return DateTime.now();
  }

  /// 创建 Drawer 筛选项配置
  List<FilterOption> _buildDrawerFilters(BuildContext context) {
    // 从 filterParams 中获取 use30HourFormat 的值，默认为 false（24小时制）
    final use30HourFormat = filterParams['use30HourFormat'];
    final isUse30HourFormat = (use30HourFormat is bool && use30HourFormat) || 
                              (use30HourFormat == 'true' || use30HourFormat == true);
    
    return [
      // 时间范围筛选（动态30小时制，根据 use30HourFormat 开关决定）
      FilterOption(
        key: 'timeRange',
        title: S.of(context).about_components_showTimeList_timeRange,
        type: FilterType.timeRange,
        use30HourFormat: isUse30HourFormat, // 根据开关动态使用30小时制或24小时制
        values: [], // 时间范围不需要 values
      ),
      // 时间范围筛选（30小时制示例，可根据需要启用）
      // FilterOption(
      //   key: 'timeRange30h',
      //   title: '开场时间',
      //   type: 'timeRange',
      //   use30HourFormat: true, // 使用30小时制（0-5点显示为24-29点）
      //   values: [],
      // ),
      // FilterOption(
      //   key: 'use30HourFormat',
      //   title: '30小时制', // TODO: 添加国际化
      //   type: FilterType.switch_,
      //   icon: Icons.schedule_rounded,
      //   values: [], // Switch 类型不需要 values，只有选中和未选中两种状态
      // ),
      // Switch 开关示例（吹き替え版）
      // FilterOption(
      //   key: 'dubbingVersion',
      //   title: S.of(context).about_components_showTimeList_dubbingVersion,
      //   type: FilterType.switch_,
      //   values: [], // Switch 类型不需要 values，只有选中和未选中两种状态
      //   drawerDisplayConfig: DrawerFilterDisplayConfig(
      //     icon: Icons.record_voice_over_rounded,
      //     iconSize: 24.sp,
      //   ),
      // ),
      FilterOption(
                  key: 'subtitleId',
                  title: S.of(context).about_movieShowList_dropdown_subtitle,
                  icon: Icons.subtitles_rounded,
                  values: [
                    // FilterValue(id: '', name: S.of(context).about_components_showTimeList_all), // 添加"全部"选项
                    ...languageList.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
                      return FilterValue(id: item.id.toString(), name: item.name!);
                    }).toList(),
                  ],
                ),
      // 上映标签
      FilterOption(
        key: 'showTimeTagId',
        title: S.of(context).about_movieShowList_dropdown_tag,
        icon: Icons.local_activity_rounded,
        values: [
          FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
          ...showTimeTagList
              .where((item) => item.name != null && item.name!.isNotEmpty)
              .map((item) => FilterValue(id: item.id.toString(), name: item.name!)),
        ],
        
      ),
     
      FilterOption(
        key: 'versionCode',
        title: S.of(context).about_movieShowList_dropdown_version,
        icon: Icons.movie_filter_rounded,
        type: FilterType.single, // 单选模式
        values: [
          FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
          ...versionList
              .where((item) => item.name != null && item.name!.isNotEmpty)
              .map((item) => FilterValue(id: item.code.toString(), name: item.name!)),
        ],
        
      ),
    ];
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
          actions: [
            // 搜索图标按钮
            IconButton(
              icon: Icon(Icons.search, color: Colors.white, size: 42.sp),
              onPressed: () {
                GoRouter.of(context).pushNamed("home", queryParameters: {
                  'tab': '2'
                });
              },
            ),
          ],
          bottom: (data.isNotEmpty && _tabController != null && mounted)
              ? TabBar(
                  controller: _tabController!,
                  tabs: generateTab(),
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 0.h),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
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
                  drawerWidth: 600.w, // 设置 drawer 宽度为 600.w（使用 screenutil 适配）
                  iconSize: 24.sp,
                ),
                drawerFilters: _buildDrawerFilters(context),
                baseDate: _getCurrentTabDate(),
              filters: [
                 FilterOption(
                  key: 'areaId',
                  title: S.of(context).about_movieShowList_dropdown_area,
                  type: FilterType.single, // 单选模式
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
                  key: 'dimensionType',
                  title: S.of(context).about_movieShowList_dropdown_dimensionType,
                  icon: Icons.visibility_rounded,
                  type: FilterType.single,
                  values: [
                    FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
                    ...dimensionList
                        .where((item) => item.name != null && item.name!.isNotEmpty)
                        .map((item) => FilterValue(id: item.code.toString(), name: item.name!)),
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
              ],
              initialSelected: filterParams, // 只初始化时传递
              onConfirm: (selected) {
                setState(() {
                  filterParams = selected;
                });
                print(selected);
                print('--------------------------------');
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
                                          color: Colors.black.withValues(alpha: 0.05),
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
                                                  color: const Color(0xFF1989FA).withValues(alpha: 0.1),
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
    await getVersionList();
    await getLocation();
  }

  FutureOr _onLoad() {
  }

  // 获取版本名称
  // 构建场次信息
  Widget _buildShowTimeInfo(Cinema children) {
    // 过滤已禁用的场次（open == false）
    final availableShowTimes = (children.showTimes ?? [])
        .where((s) => s.open != false)
        .toList();
    if (availableShowTimes.isEmpty) {
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
          // height: 200.h, // 简洁设计后的高度
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableShowTimes.map((showTime) {
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

    // 计算时长
    String? durationText;
    if (showTime.startTime != null && showTime.endTime != null) {
      final duration = showTime.endTime!.difference(showTime.startTime!);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (hours > 0) {
        durationText = S.of(context).movieDetail_detail_duration_hoursMinutes(hours, minutes);
      } else {
        durationText = '${minutes}${S.of(context).movieDetail_detail_duration_minutes}';
      }
    }

    return GestureDetector(
      onTap: () {
        // 直接跳转到选座页面
        if (showTime.id != null && showTime.theaterHallId != null) {
          context.pushNamed(
            'selectSeat',
            queryParameters: {
              "id": '${showTime.id}',
              "theaterHallId": '${showTime.theaterHallId}'
            }
          );
        }
      },
      child: Container(
      width: 240.w,
      constraints: BoxConstraints(
        minHeight: 200.h, // 设置最小高度，确保卡片高度统一
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.r),
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部时间区域（带渐变背景）
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1989FA).withValues(alpha: 0.1),
                  const Color(0xFF1989FA).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 开始时间和座位状态（同一行，右对齐）
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 开始时间（大字体突出显示）
                    Text(
                      DateFormatUtil.formatShowTime(
                        dateTime: showTime.startTime,
                        use30HourFormat: (filterParams['use30HourFormat'] is bool && filterParams['use30HourFormat']) || 
                                        (filterParams['use30HourFormat'] == 'true' || filterParams['use30HourFormat'] == true),
                        baseDate: _getCurrentTabDate(),
                      ),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    // 右侧座位状态（图标形式）
                    Tooltip(
                      message: seatStatusText,
                      child: Container(
                        margin: EdgeInsets.only(left: 12.w),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: seatStatusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: seatStatusColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          seatStatusIcon,
                          size: 24.sp,
                          color: seatStatusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // 结束时间和时长
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 结束时间（左对齐）
                    Text(
                      DateFormatUtil.formatShowTime(
                        dateTime: showTime.endTime,
                        use30HourFormat: (filterParams['use30HourFormat'] is bool && filterParams['use30HourFormat']) || 
                                        (filterParams['use30HourFormat'] == 'true' || filterParams['use30HourFormat'] == true),
                        baseDate: _getCurrentTabDate(),
                      ),
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // 时长（右对齐）
                    if (durationText != null)
                      Text(
                        durationText,
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // 中间内容区域
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 规格+2D/3D、版本信息（规格在前、2D/3D 在后合并为一块，同一行 Wrap）
                if ((showTime.specNames != null && showTime.specNames!.isNotEmpty) ||
                    showTime.dimensionType != null ||
                    showTime.versionCode != null)
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // 规格信息：规格名在前、2D/3D 在后，合并为一块如 "IMAX 3D"
                      if (showTime.specNames != null && showTime.specNames!.isNotEmpty)
                        ...showTime.specNames!.map((name) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1989FA).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFF1989FA).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.movie_filter_rounded,
                                size: 20.sp,
                                color: const Color(0xFF1989FA),
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF1989FA),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (showTime.dimensionType != null) ...[
                                SizedBox(width: 4.w),
                                Dict(
                                  code: showTime.dimensionType,
                                  name: 'dimensionType',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: const Color(0xFF1989FA),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ))
                      else if (showTime.dimensionType != null)
                        // 仅有 2D/3D 无规格时单独显示（字典 dimensionType）
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7232DD).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFF7232DD).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.visibility_rounded,
                                size: 20.sp,
                                color: const Color(0xFF7232DD),
                              ),
                              SizedBox(width: 4.w),
                              Dict(
                                code: showTime.dimensionType,
                                name: 'dimensionType',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: const Color(0xFF7232DD),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      // 版本信息（如果顶部没有显示，则在这里显示）
                      if (showTime.versionCode != null)
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity, // 限制最大宽度，避免过长
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 20.sp,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Dict(
                                  code: showTime.versionCode,
                                  name: 'dubbingVersion',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

}

