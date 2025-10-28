import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/cinema/cinemaList.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CinemaList extends StatefulWidget {
  const CinemaList({Key? key}) : super(key: key);

  @override
  State<CinemaList> createState() => _CinemaListState();
}

class _CinemaListState extends State<CinemaList> with AutomaticKeepAliveClientMixin {
  List<CinemaListResponse> data = [];
  List<CinemaListResponse> filteredData = [];
  List<AreaResponse> areaTreeList = [];
  bool loading = true;
  bool error = false;
  bool isSearching = false;
  bool showFilterBar = false;
  String? selectedArea;
  Map<String, dynamic> filterParams = {};
  TextEditingController searchController = TextEditingController();
  Placemark? location;
  ScrollController scrollController = ScrollController();
  bool showAppBarShadow = false;

  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    getData();
    getAreaTree();
    getLocation();
    
    // 添加滚动监听
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    
    if (scrollController.offset > 10 && !showAppBarShadow) {
      setState(() {
        showAppBarShadow = true;
      });
    } else if (scrollController.offset <= 10 && showAppBarShadow) {
      setState(() {
        showAppBarShadow = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (mounted && placemarks.isNotEmpty) {
        setState(() {
          location = placemarks.first;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> getData() async {
    if (!mounted) return;
    
    setState(() {
      loading = true;
      error = false;
    });

    try {
      print('🔍 开始获取影院数据...');
      print('📋 请求参数: $filterParams');
      
      final apiRequest = ApiRequest();
      final response = await apiRequest.request<ApiPaginationResponse<CinemaListResponse>>(
      path: '/cinema/list',
      method: 'POST',
        data: filterParams,
      fromJsonT: (json) {
        return ApiPaginationResponse<CinemaListResponse>.fromJson(
          json,
          (data) => CinemaListResponse.fromJson(data as Map<String, dynamic>),
        );
      },
      );
      
      print('📡 API响应: ${response.data}');
      print('📊 响应状态: ${response.code}');
      print('💬 响应消息: ${response.message}');
      
      if (mounted) {
        setState(() {
          data = response.data?.list ?? [];
          filteredData = List.from(data);
          loading = false;
        });
        
        print('🎬 解析后的影院数据: ${data.length} 个影院');
        if (data.isNotEmpty) {
          print('🏢 第一个影院: ${data.first.name}');
        }
      }
    } catch (e) {
      print('❌ 获取影院数据失败: $e');
      if (mounted) {
      setState(() {
        error = true;
        loading = false;
      });
      }
    }
  }

  Future<void> getAreaTree() async {
    if (!mounted) return;
    
    try {
      print('🌳 开始获取区域树数据...');
      
      final apiRequest = ApiRequest();
      final response = await apiRequest.request<List<dynamic>>(
        path: '/areas/tree',
        method: 'GET',
        fromJsonT: (json) => json as List<dynamic>,
      );
      
      print('📡 区域树API响应: ${response.data}');
      print('📊 响应状态: ${response.code}');
      print('💬 响应消息: ${response.message}');
      
      if (mounted) {
        setState(() {
          areaTreeList = (response.data ?? [])
              .map((item) => AreaResponse.fromJson(item))
              .toList();
        });
        
        print('🌳 解析后的区域数据: ${areaTreeList.length} 个区域');
        if (areaTreeList.isNotEmpty) {
          print('🏘️ 第一个区域: ${areaTreeList.first.name}');
        }
      }
    } catch (e) {
      print('❌ 获取区域树数据失败: $e');
      if (mounted) {
        setState(() {
          areaTreeList = _getFallbackAreaData();
        });
      }
    }
  }

  List<AreaResponse> _getFallbackAreaData() {
    return [
      AreaResponse(id: 1, name: '全部', children: []),
      AreaResponse(id: 2, name: '北京市', children: []),
      AreaResponse(id: 3, name: '上海市', children: []),
      AreaResponse(id: 4, name: '广州市', children: []),
      AreaResponse(id: 5, name: '深圳市', children: []),
    ];
  }

  void _performSearch(String query) {
    if (!mounted) return;
    
          setState(() {
      isSearching = query.isNotEmpty;
      if (isSearching) {
        filteredData = data.where((cinema) {
          final name = cinema.name?.toLowerCase() ?? '';
          final address = cinema.fullAddress?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) || address.contains(query.toLowerCase());
        }).toList();
      } else {
        filteredData = List.from(data);
      }
    });
  }

  void _clearSearch() {
    if (!mounted) return;
    
    setState(() {
      searchController.clear();
      isSearching = false;
      filteredData = List.from(data);
    });
  }

  void _handleFilterChange(Map<String, dynamic> selected) {
    if (!mounted) return;
    
    setState(() {
      filterParams = selected;
      selectedArea = selected['areaId']?.toString();
    });
    getData();
  }

  FilterValue convertToFilterValue(AreaResponse item) {
    return FilterValue(
      id: item.id.toString(),
      name: item.name ?? '',
      children: item.children?.map((child) => convertToFilterValue(child)).toList(),
    );
  }

  Widget _buildCinemaList() {
    final displayData = isSearching ? filteredData : data;
    
    if (displayData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off_rounded : Icons.location_off_rounded,
              size: 64.sp,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16.h),
            Text(
              isSearching 
                ? S.of(context).cinemaList_empty_noSearchResults
                : S.of(context).cinemaList_empty_noData,
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              isSearching 
                ? S.of(context).cinemaList_empty_noSearchResultsTip
                : S.of(context).cinemaList_empty_noDataTip,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: displayData.length,
      itemBuilder: (context, index) {
        final cinema = displayData[index];
        return _buildCinemaCard(cinema);
      },
    );
  }

  Widget _buildCinemaCard(CinemaListResponse cinema) {
    return GestureDetector(
      onTap: () {
        // 跳转到影院详情页
        context.pushNamed('cinemaDetail', queryParameters: {'id': cinema.id.toString()});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // 影院头部信息
            Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 影院名称和距离
                  Row(
          children: [
                      Expanded(
                        child: Text(
                          cinema.name ?? '',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      //   decoration: BoxDecoration(
                      //     color: Colors.blue.shade50,
                      //     borderRadius: BorderRadius.circular(20.r),
                      //     border: Border.all(
                      //       color: Colors.blue.shade200,
                      //       width: 1,
                      //     ),
                      //   ),
      //                   child: Row(
      //                     mainAxisSize: MainAxisSize.min,
      //                     children: [
      //                       Icon(
      //                         Icons.location_on_rounded,
      //                         size: 14.sp,
      //                         color: Colors.blue.shade600,
      //                       ),
      //                       SizedBox(width: 4.w),
      //                       Text(
      //                         '2.5km',
      //                         style: TextStyle(
      //                           fontSize: 12.sp,
      //                           color: Colors.blue.shade700,
      //                           fontWeight: FontWeight.w600,
      //                         ),
      //                       ),
      //     ],
      //   ),
      // ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  // 地址信息
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1989FA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.place_rounded,
                          size: 20.sp,
                          color: const Color(0xFF1989FA),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          cinema.fullAddress ?? '',
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: const Color(0xFF646566),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // 影院特色标签
                  if (cinema.spec != null && cinema.spec!.isNotEmpty)
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: cinema.spec!.map((spec) {
                        return _buildFeatureTag(
                          spec.name ?? '', 
                          _getSpecColor(spec.name ?? '')
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            
            // 分割线
            Container(
              height: 1,
              color: Colors.grey.shade200,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
            ),
            
            // 正在上映电影区域
            Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 电影列表标题
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE5A6F).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.movie_rounded,
                          size: 20.sp,
                          color: const Color(0xFFEE5A6F),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        S.of(context).cinemaList_movies_nowShowing,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF323233),
                        ),
                      ),
                      Spacer(),
                      // "更多"按钮
                      GestureDetector(
                        onTap: () {
                          // 跳转到电影详情页面或显示更多电影
                          print('查看更多电影');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          // decoration: BoxDecoration(
                          //   color: Colors.blue.shade50,
                          //   borderRadius: BorderRadius.circular(16.r),
                          //   border: Border.all(
                          //     color: Colors.blue.shade200,
                          //     width: 1,
                          //   ),
                          // ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            
                            children: [
                              Text(
                                '更多',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey.shade500,
                                  // fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20.sp,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  
                  // 电影海报列表 - 占满整行
                  SizedBox(
                    height: 280.h, // 保持高度限制以避免布局错误
                    child: cinema.nowShowingMovies == null || cinema.nowShowingMovies!.isEmpty
                        ? Center(
                            child: Container(
                              padding: EdgeInsets.all(40.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.movie_outlined,
                                    size: 48.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    S.of(context).cinemaList_movies_empty,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cinema.nowShowingMovies!.length, // 显示全部电影
                            physics: const ClampingScrollPhysics(), // 添加物理滚动
                            itemBuilder: (context, index) {
                              final movie = cinema.nowShowingMovies![index];
                              return GestureDetector(
                                onTap: () {
                                  context.pushNamed('showTimeDetail', pathParameters: {
                                    'id': '${movie.id}',
                                    'cinemaId': '${cinema.id}'
                                  }, queryParameters: {
                                    'movieName': movie.name ?? '',
                                    'cinemaName': cinema.name ?? '',
                                  });
                                },
                                child: Container(
                                  width: 160.w, // 固定宽度，适合显示更多电影
                                  height: 280.h, // 添加高度限制，确保卡片有固定高度
                                  margin: EdgeInsets.only(right: 12.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // 电影海报
                                      Container(
                                        width: 160.w,
                                        height: 173.h, // 调整高度以保持与NowShowing相同的比例 (160:173 ≈ 240:260)
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.r),
                                          color: Colors.grey.shade100, // 使用淡灰色背景
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.r),
                                          child: movie.poster != null && movie.poster!.isNotEmpty
                                              ? CustomExtendedImage(
                                                  movie.poster!,
                                                  width: 160.w,
                                                  height: 173.h,
                                                  fit: BoxFit.contain,
                                                )
                                              : Container(
                                                  color: Colors.grey.shade300,
                                                  child: Icon(
                                                    Icons.movie_rounded,
                                                    color: Colors.grey.shade600,
                                                    size: 32.sp,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(height: 6.h), // 减少间距

                                      // 电影标题
                                      Expanded(
                                        child: Text(
                                          movie.name ?? '',
                                          style: TextStyle(
                                            fontSize: 24.sp, // 进一步增加字体大小
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5, // 设置行高
                                          ),
                                          maxLines: 2, // 改为1行
                                          overflow: TextOverflow.ellipsis, // 超出显示省略号
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      // 评分
                                      if (movie.rate != null && movie.rate! > 0)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(24.r),
                                            border: Border.all(
                                              color: Colors.orange.shade200,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.orange.withOpacity(0.2),
                                                blurRadius: 12,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                size: 28.sp,
                                                color: Colors.orange.shade600,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                movie.rate!.toStringAsFixed(1),
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.orange.shade700,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            
            // 分割线
            Container(
              height: 1,
              color: Colors.grey.shade200,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
            ),
            
            // // 底部操作区域
            // Container(
            //   padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade50,
            //     border: Border(
            //       top: BorderSide(
            //         color: Colors.grey.shade200,
            //         width: 1,
            //       ),
            //     ),
            //   ),
            //   child: Row(
            //     children: [
            //       // 营业时间
            //       Expanded(
            //         child: Row(
            //           children: [
            //             Icon(
            //               Icons.access_time_rounded,
            //               size: 22.sp,
            //               color: Colors.grey.shade600,
            //             ),
            //             SizedBox(width: 6.w),
            //             Text(
            //               '营业中 09:00-24:00',
            //               style: TextStyle(
            //                 fontSize: 14.sp,
            //                 color: Colors.grey.shade700,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
                  
            //       // 查看详情按钮
            //       GestureDetector(
            //         onTap: () {
            //           // 跳转到影院详情页面
            //         },
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            //           decoration: BoxDecoration(
            //             color: Colors.blue.shade600,
            //             borderRadius: BorderRadius.circular(20.r),
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.blue.withOpacity(0.3),
            //                 blurRadius: 8,
            //                 offset: const Offset(0, 2),
            //               ),
            //             ],
            //           ),
            //           child: Row(
            //             mainAxisSize: MainAxisSize.min,
            //             children: [
            //               Text(
            //                 '查看详情',
            //                 style: TextStyle(
            //                   fontSize: 14.sp,
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w600,
            //                 ),
            //               ),
            //               SizedBox(width: 6.w),
            //               Icon(
            //                 Icons.arrow_forward_rounded,
            //                 size: 16.sp,
            //                 color: Colors.white,
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildFeatureTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getSpecColor(String specName) {
    switch (specName.toUpperCase()) {
      case 'IMAX':
        return Colors.red.shade600;
      case '4DX':
        return Colors.orange.shade600;
      case 'DOLBY':
      case 'DOLBY CINEMA':
        return Colors.purple.shade600;
      case '3D':
        return Colors.green.shade600;
      case '2D':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
        title: S.of(context).cinemaList_title,
        titleTextStyle: TextStyle(
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Column(
          children: [
          // 搜索和筛选区域
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              boxShadow: showAppBarShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                      spreadRadius: 0,
                    ),
                  ]
                : [],
            ),
            child: Column(
              children: [
                // 位置信息
                if (location?.subLocality != null && location!.subLocality!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1989FA).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFF1989FA).withOpacity(0.15),
                        width: 1,
                      ),
                    ),
                    child: Row(
          children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1989FA),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
              child: Text(
                            location!.subLocality!,
                            style: TextStyle(
                              fontSize: 26.sp,
                              color: const Color(0xFF323233),
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
                
                // 搜索和筛选区域
                Row(
                  children: [
                    // 地区筛选按钮
                    GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        setState(() {
                          showFilterBar = !showFilterBar;
                        });
                      },
                child: Container(
                        height: 56.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: showFilterBar 
                            ? const Color(0xFF1989FA)
                            : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: showFilterBar 
                              ? const Color(0xFF1989FA)
                              : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                  children: [
                            Icon(
                              Icons.tune_rounded,
                              color: showFilterBar ? Colors.white : const Color(0xFF646566),
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              location?.subLocality ?? '全部地区',
                              style: TextStyle(
                                color: showFilterBar ? Colors.white : const Color(0xFF323233),
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: showFilterBar ? Colors.white : const Color(0xFF646566),
                              size: 22.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    // 搜索框
                    Expanded(
                      child: Container(
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                        ),
                        child: TextField(
                          controller: searchController,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: const Color(0xFF1989FA),
                          cursorWidth: 2,
                          style: TextStyle(
                            color: const Color(0xFF323233),
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                          onChanged: (value) {
                            if (mounted) {
                              _performSearch(value);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: S.of(context).cinemaList_search_hint,
                            hintStyle: TextStyle(
                              color: const Color(0xFF969799),
                              fontSize: 26.sp,
                              fontWeight: FontWeight.normal,
                              height: 1.2,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: const Color(0xFF646566),
                              size: 26.sp,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      _clearSearch();
                                    }
                                  },
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: const Color(0xFF969799),
                                    size: 22.sp,
                                  ),
                                )
                              : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                            isDense: true,
                            isCollapsed: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 筛选栏 - 只在showFilterBar为true时显示
                if (showFilterBar) ...[
                  SizedBox(height: 16.h),
                  areaTreeList.isEmpty 
                    ? Container(
                        height: 52.h,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20.sp,
                                height: 20.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF1989FA)),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                S.of(context).cinemaList_filter_loading,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: const Color(0xFF646566),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                        ),
                        child: FilterBar(
                          filters: [
                            FilterOption(
                              key: 'areaId',
                              title: S.of(context).cinemaList_filter_title,
                              multi: false,
                              nested: true,
                              values: areaTreeList.map((item) => convertToFilterValue(item)).toList(),
                            ),
                          ],
                          initialSelected: filterParams,
                          onConfirm: _handleFilterChange,
                        ),
                      ),
                ],
              ],
            ),
          ),
          
          // 搜索结果统计
          if (isSearching)
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: filteredData.isEmpty 
                  ? const Color(0xFFFF976A).withOpacity(0.1)
                  : const Color(0xFF1989FA).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: filteredData.isEmpty 
                    ? const Color(0xFFFF976A).withOpacity(0.3)
                    : const Color(0xFF1989FA).withOpacity(0.2), 
                  width: 1
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    filteredData.isEmpty ? Icons.search_off_rounded : Icons.search_rounded,
                    color: filteredData.isEmpty ? const Color(0xFFFF976A) : const Color(0xFF1989FA),
                    size: 22.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      filteredData.isEmpty 
                        ? S.of(context).cinemaList_search_results_notFound
                        : S.of(context).cinemaList_search_results_found(filteredData.length),
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: const Color(0xFF323233),
                        fontWeight: FontWeight.w500,
                              ), 
                            ),
                          ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: filteredData.isEmpty ? const Color(0xFFFF976A) : const Color(0xFF1989FA),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        S.of(context).cinemaList_search_clear,
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                                    ),
                                  ),
                                ),
                ],
              ),
            ),
          
          // 影院列表
          Expanded(
            child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : error
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48.sp, color: Colors.grey),
                        SizedBox(height: 16.h),
                        Text(
                          S.of(context).cinemaList_empty_noData,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          S.of(context).cinemaList_empty_noDataTip,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  ],
                ),
              )
                : _buildCinemaList(),
          ),
        ],
      ),
    );
  }
}