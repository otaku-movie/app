import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/FilterBar.dart';
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

  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    getData();
    getAreaTree();
    getLocation();
  }

  @override
  void dispose() {
    searchController.dispose();
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: displayData.length,
      itemBuilder: (context, index) {
        final cinema = displayData[index];
        return _buildCinemaCard(cinema);
      },
    );
  }

  Widget _buildCinemaCard(CinemaListResponse cinema) {
    return Container(
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
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 14.sp,
                              color: Colors.blue.shade600,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '2.5km',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
          ],
        ),
      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  
                  // 地址信息
                  Row(
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 18.sp,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          cinema.fullAddress ?? '',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // 影院特色标签
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildFeatureTag('IMAX', Colors.red.shade600),
                      _buildFeatureTag('4DX', Colors.orange.shade600),
                      _buildFeatureTag('DOLBY', Colors.purple.shade600),
                      _buildFeatureTag('3D', Colors.green.shade600),
                    ],
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
                      Icon(
                        Icons.movie_rounded,
                        size: 20.sp,
                        color: Colors.grey.shade700,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        S.of(context).cinemaList_movies_nowShowing,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4, // 只显示4部电影
                      physics: ClampingScrollPhysics(), // 添加物理滚动
                      itemBuilder: (context, index) {
                        final movies = [
                          {'title': '鬼灭之刃', 'poster': 'assets/image/kimetsu-movie.jpg', 'rating': '9.2'},
                          {'title': '铃芽之旅', 'poster': 'assets/image/lycoris recoil.webp', 'rating': '8.8'},
                          {'title': '你的名字', 'poster': 'assets/image/raligun.webp', 'rating': '9.0'},
                          {'title': '天气之子', 'poster': 'assets/image/kimetsu-movie.jpg', 'rating': '8.5'},
                        ];
                        
                        final movie = movies[index];
                        return Container(
                          width: (MediaQuery.of(context).size.width - 60.w) / 4, // 考虑间距的宽度
                          height: 280.h, // 添加高度限制，确保卡片有固定高度
                          margin: EdgeInsets.only(right: 12.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 电影海报
                              Container(
                                width: (MediaQuery.of(context).size.width - 60.w) / 4,
                                height: 200.h, // 添加高度限制，防止没有数据时布局问题
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
                                  child: Image.asset(
                                    movie['poster']!,
                                    fit: BoxFit.contain, // 保持图片比例，不变形
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: Icon(
                                          Icons.movie_rounded,
                                          color: Colors.grey.shade600,
                                          size: 32.sp,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 6.h), // 减少间距

                              // 电影标题
                              Expanded(
                                child: Text(
                                  movie['title']!,
                                  style: TextStyle(
                                    fontSize: 24.sp, // 进一步增加字体大小
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5, // 设置行高
                                  ),
                                  maxLines: 1, // 改为1行
                                  overflow: TextOverflow.ellipsis, // 超出显示省略号
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              // 评分
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
                                      movie['rating']!,
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
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          S.of(context).cinemaList_title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade900,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20.w,
      ),
      body: Column(
          children: [
          // 搜索和筛选区域
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade50,
                  Colors.white,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // 位置信息
                if (location?.subLocality != null && location!.subLocality!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade50, Colors.blue.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
          children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
              child: Text(
                            location!.subLocality!,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade600,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.my_location_rounded,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '定位',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
                        setState(() {
                          showFilterBar = true;
                  });
                },
                child: Container(
                        height: 60.h,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: showFilterBar 
                              ? [Colors.blue.shade600, Colors.blue.shade700]
                              : [Colors.grey.shade100, Colors.grey.shade200],
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: showFilterBar 
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              color: showFilterBar ? Colors.white : Colors.grey.shade600,
                              size: 22.sp,
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              location?.subLocality ?? '全部地区',
                              style: TextStyle(
                                color: showFilterBar ? Colors.white : Colors.grey.shade700,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: showFilterBar ? Colors.white : Colors.grey.shade600,
                              size: 20.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(width: 12.w),
                    
                    // 搜索框
                        Expanded(
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: _performSearch,
                          decoration: InputDecoration(
                            hintText: S.of(context).cinemaList_search_hint,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            prefixIcon: Container(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.search_rounded,
                                color: Colors.grey.shade600,
                                size: 24.sp,
                              ),
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                              ? GestureDetector(
                                  onTap: _clearSearch,
                                  child: Icon(
                                    Icons.clear_rounded,
                                    color: Colors.grey.shade600,
                                    size: 20.sp,
                                  ),
                                )
                              : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 筛选栏 - 只在showFilterBar为true时显示
                if (showFilterBar) ...[
                  SizedBox(height: 24.h),
                  areaTreeList.isEmpty 
                    ? Container(
                        height: 56.h,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade50, Colors.blue.shade100],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28.r),
                          border: Border.all(color: Colors.blue.shade200, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Text(
                                S.of(context).cinemaList_filter_loading,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey.shade50, Colors.white],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
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
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: filteredData.isEmpty ? Colors.orange.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: filteredData.isEmpty ? Colors.orange.shade200 : Colors.blue.shade200, 
                  width: 1
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    filteredData.isEmpty ? Icons.search_off_rounded : Icons.search_rounded,
                    color: filteredData.isEmpty ? Colors.orange.shade600 : Colors.blue.shade600,
                    size: 18.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      filteredData.isEmpty 
                        ? S.of(context).cinemaList_search_results_notFound
                        : S.of(context).cinemaList_search_results_found(filteredData.length),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: filteredData.isEmpty ? Colors.orange.shade800 : Colors.blue.shade800,
                        fontWeight: FontWeight.w500,
                              ), 
                            ),
                          ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: filteredData.isEmpty ? Colors.orange.shade600 : Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.clear_rounded,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            S.of(context).cinemaList_search_clear,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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