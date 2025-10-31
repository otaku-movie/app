import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/cinema/cinemaList.dart';
import 'package:otaku_movie/response/cinema/cinema_spec_response.dart';
import 'package:otaku_movie/response/cinema/brand_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:otaku_movie/utils/location_util.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/error.dart';

class CinemaList extends StatefulWidget {
  const CinemaList({Key? key}) : super(key: key);

  @override
  State<CinemaList> createState() => _CinemaListState();
}

class _CinemaListState extends State<CinemaList> with AutomaticKeepAliveClientMixin {
  List<CinemaListResponse> data = [];
  List<AreaResponse> areaTreeList = [];
  List<CinemaSpecResponse> cinemaSpecList = [];
  List<BrandResponse> brandList = [];
  bool loading = true;
  bool error = false;
  bool isSearching = false;
  bool showFilterBar = false;
  String? selectedArea;
  Map<String, dynamic> filterParams = {};
  TextEditingController searchController = TextEditingController();
  Placemark? location;
  Position? position;
  String? currentAddressFull;
  bool locationLoading = false;
  ScrollController scrollController = ScrollController();
  bool showAppBarShadow = false;
  EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );
  int currentPage = 1;
  bool loadFinished = false;
  int totalCount = 0; // 影院总数

  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    getData();
    getAreaTree();
    getCinemaSpec();
    getBrandList();
    getLocation();
    
    // 添加滚动监听
    scrollController.addListener(_onScroll);
  }

  String _currentLocalityText(BuildContext context) {
    if (location == null) return S.of(context).cinemaList_address;
    if (location!.subLocality != null && location!.subLocality!.isNotEmpty) {
      return location!.subLocality!;
    }
    if (location!.locality != null && location!.locality!.isNotEmpty) {
      return location!.locality!;
    }
    if (location!.administrativeArea != null && location!.administrativeArea!.isNotEmpty) {
      return location!.administrativeArea!;
    }
    return S.of(context).cinemaList_address;
  }

  String _currentFullAddressText(BuildContext context) {
    if (location == null) return S.of(context).cinemaList_address;
    final parts = <String>[];
    void add(String? v) { if (v != null && v.trim().isNotEmpty) parts.add(v.trim()); }
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'zh') {
      // 中文：省/州 -> 市 -> 区/町 -> 街道 -> 国家 -> 邮编
      add(location!.administrativeArea);
      add(location!.locality);
      add(location!.subLocality);
      add(location!.street);
      add(location!.postalCode);
    } else if (lang == 'ja') {
      // 日文（日本地址习惯）：邮编 -> 都/道/府/県 -> 市区町村 -> 丁目番地 -> 国
      add(location!.postalCode);
      add(location!.administrativeArea);
      add(location!.locality);
      add(location!.subLocality);
      add(location!.street);
    } else {
      // 英文等：街道 -> 区/镇 -> 市 -> 省/州 -> 邮编 -> 国家
      add(location!.street);
      add(location!.subLocality);
      add(location!.locality);
      add(location!.administrativeArea);
      add(location!.postalCode);
    }
    if (currentAddressFull != null && currentAddressFull!.isNotEmpty) {
      // 去掉末尾国家名（如果有）
      String text = currentAddressFull!;
      final country = location?.country;
      if (country != null && country.trim().isNotEmpty) {
        final trimmed = country.trim();
        // 移除诸如 ", Japan" / ", 中国" / " Japan" 的结尾国家
        text = text.replaceAll(RegExp(r"\s*,\s*" + RegExp.escape(trimmed) + r"\s*$"), '');
        text = text.replaceAll(RegExp(r"\s+" + RegExp.escape(trimmed) + r"\s*$"), '');
      }
      return text;
    }
    if (parts.isEmpty) return _currentLocalityText(context);
    return parts.join(' ');
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
    easyRefreshController.dispose();
    super.dispose();
  }

  Future<void> getLocation() async {
    try {
      if (mounted) {
        setState(() {
          locationLoading = true;
        });
      }
      final current = await LocationUtil.getCurrentPosition(accuracy: LocationAccuracy.high);
      if (current == null) return;
      final place = await LocationUtil.reverseGeocode(current);
      final full = await LocationUtil.reverseGeocodeTextLocalized(context, current);
      if (!mounted) return;
      setState(() {
        location = place;
        position = current;
        currentAddressFull = full;
      });
      // 获取到位置信息后，重新获取影院数据，以便后端根据经纬度查询附近影院
      getData();
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      if (mounted) {
        setState(() {
          locationLoading = false;
        });
      }
    }
  }

  Future<void> getData({int page = 1, bool refresh = false}) async {
    if (!mounted) return;
    
    // 如果是刷新，重置页面和数据
    if (refresh) {
      currentPage = 1;
      loadFinished = false;
    }
    
    // 如果是加载更多，不显示 loading，只显示加载底部指示器
    if (page == 1) {
      setState(() {
        loading = true;
        error = false;
      });
    }

    try {
      // 处理筛选参数：将筛选参数映射为 API 需要的格式
      Map<String, dynamic> requestParams = {
        'page': page,
        'pageSize': 10,
      };
      
      // 处理 name 搜索字段
      if (filterParams.containsKey('name') && filterParams['name'] != null && filterParams['name'].toString().isNotEmpty) {
        requestParams['name'] = filterParams['name'];
      }
      
      // 处理嵌套地区筛选：将 areaId 数组映射到 regionId, prefectureId, cityId
      if (filterParams.containsKey('areaId') && filterParams['areaId'] != null) {
        final areaIds = filterParams['areaId'] as List?;
        if (areaIds != null && areaIds.isNotEmpty && areaIds.first != '') {
          // 嵌套筛选：第一级是 regionId，第二级是 prefectureId，第三级是 cityId
          if (areaIds.length >= 1) {
            final regionId = int.tryParse(areaIds[0].toString());
            if (regionId != null) {
              requestParams['regionId'] = regionId;
            }
          }
          if (areaIds.length >= 2) {
            final prefectureId = int.tryParse(areaIds[1].toString());
            if (prefectureId != null) {
              requestParams['prefectureId'] = prefectureId;
            }
          }
          if (areaIds.length >= 3) {
            final cityId = int.tryParse(areaIds[2].toString());
            if (cityId != null) {
              requestParams['cityId'] = cityId;
            }
          }
        }
      }
      
      // 处理 brandId
      if (filterParams.containsKey('brandId')) {
        final brandId = filterParams['brandId'];
        if (brandId != null) {
          if (brandId is List) {
            if (brandId.isNotEmpty) {
              final first = brandId.first;
              if (first != null && first != '' && first.toString() != '') {
                final parsed = int.tryParse(first.toString());
                if (parsed != null) {
                  requestParams['brandId'] = parsed;
                }
              }
            }
          } else {
            final str = brandId.toString();
            if (str.isNotEmpty && str != '') {
              final parsed = int.tryParse(str);
              if (parsed != null) {
                requestParams['brandId'] = parsed;
              }
            }
          }
        }
      }
      
      // 处理 specId
      if (filterParams.containsKey('specId')) {
        final specId = filterParams['specId'];
        if (specId != null) {
          if (specId is List) {
            if (specId.isNotEmpty) {
              final first = specId.first;
              if (first != null && first != '' && first.toString() != '') {
                final parsed = int.tryParse(first.toString());
                if (parsed != null) {
                  requestParams['specId'] = parsed;
                }
              }
            }
          } else {
            final str = specId.toString();
            if (str.isNotEmpty && str != '') {
              final parsed = int.tryParse(str);
              if (parsed != null) {
                requestParams['specId'] = parsed;
              }
            }
          }
        }
      }
      
      // 添加经纬度参数，用于后端查询附近影院
      if (position != null) {
        requestParams['latitude'] = position!.latitude;
        requestParams['longitude'] = position!.longitude;
      }
      
      final apiRequest = ApiRequest();
      final response = await apiRequest.request<ApiPaginationResponse<CinemaListResponse>>(
      path: '/cinema/list',
      method: 'POST',
        data: requestParams,
      fromJsonT: (json) {
        return ApiPaginationResponse<CinemaListResponse>.fromJson(
          json,
          (data) => CinemaListResponse.fromJson(data as Map<String, dynamic>),
        );
      },
      );
      
      if (mounted) {
        final list = response.data?.list ?? [];
        final total = response.data?.total ?? 0;
        final pageSize = response.data?.pageSize ?? 10;
        
        // 计算距离并排序
        if (position != null && list.isNotEmpty) {
          _computeDistancesForList(list);
        }
        
        setState(() {
          if (page == 1) {
            // 刷新：替换数据
            data = list;
            totalCount = total; // 保存总数
          } else {
            // 加载更多：追加数据
            data.addAll(list);
          }
          
          loading = false;
          currentPage = page;
          
          // 判断是否加载完成
          final totalPages = (total / pageSize).ceil();
          loadFinished = page >= totalPages || list.isEmpty;
        });
        
        // 刷新时重新计算距离（如果有定位信息）
        if (refresh && position != null && data.isNotEmpty) {
          _computeDistancesForList(data);
          if (mounted) {
            setState(() {
              // 触发UI更新
            });
          }
        }
        
        // 通知 EasyRefresh 刷新/加载完成
        if (refresh) {
          easyRefreshController.finishRefresh(IndicatorResult.success, true);
        } else if (page > 1) {
          if (loadFinished) {
            easyRefreshController.finishLoad(IndicatorResult.noMore, true);
          } else {
            easyRefreshController.finishLoad(IndicatorResult.success, true);
          }
        }
      }
    } catch (e) {
      print('❌ 获取影院数据失败: $e');
      if (mounted) {
        setState(() {
          error = true;
          loading = false;
        });
        
        // 通知 EasyRefresh 失败
        if (refresh) {
          easyRefreshController.finishRefresh(IndicatorResult.fail, true);
        } else if (page > 1) {
          easyRefreshController.finishLoad(IndicatorResult.fail, true);
        }
      }
    }
  }

  void _computeDistances() {
    if (position == null || data.isEmpty) return;
    _computeDistancesForList(data);
    if (mounted) {
      setState(() {
        // 触发UI更新，显示排序后的数据
      });
    }
  }

  void _computeDistancesForList(List<CinemaListResponse> list) {
    if (position == null || list.isEmpty) return;
    for (final c in list) {
      final lat = c.latitude;
      final lng = c.longitude;
      if (lat != null && lng != null) {
        c.distance = LocationUtil.distanceBetweenMeters(position!, lat, lng);
      }
    }
    list.sort((a, b) {
      final da = a.distance;
      final db = b.distance;
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return da.compareTo(db);
    });
  }

  String _formatDistance(BuildContext context, double meters) => LocationUtil.formatDistanceLocalized(context, meters);

  Future<void> getAreaTree() async {
    if (!mounted) return;
    
    try {
      
      final apiRequest = ApiRequest();
      final response = await apiRequest.request<List<dynamic>>(
        path: '/areas/tree',
        method: 'GET',
        fromJsonT: (json) => json as List<dynamic>,
      );
      
      if (mounted) {
        setState(() {
          areaTreeList = (response.data ?? [])
              .map((item) => AreaResponse.fromJson(item))
              .toList();
        });
        
      }
    } catch (e) {
    }
  }

  Future<void> getCinemaSpec() async {
    if (!mounted) return;
    
    try {
      final apiRequest = ApiRequest();
      final response = await apiRequest.request<ApiPaginationResponse<CinemaSpecResponse>>(
        path: '/cinema/spec/list',
        method: 'POST',
        data: {
          'page': 1,
          'pageSize': 100,
        },
        fromJsonT: (json) {
          return ApiPaginationResponse<CinemaSpecResponse>.fromJson(
            json,
            (data) => CinemaSpecResponse.fromJson(data as Map<String, dynamic>),
          );
        },
      );
      
      if (mounted) {
        setState(() {
          cinemaSpecList = response.data?.list ?? [];
        });
      }
    } catch (e) {
      print('获取规格列表失败: $e');
    }
  }

  Future<void> getBrandList() async {
    if (!mounted) return;
    
    try {
      final apiRequest = ApiRequest();
      final response = await apiRequest.request<ApiPaginationResponse<BrandResponse>>(
        path: '/brand/list',
        method: 'POST',
        data: {
          'page': 1,
          'pageSize': 100,
        },
        fromJsonT: (json) {
          return ApiPaginationResponse<BrandResponse>.fromJson(
            json,
            (data) => BrandResponse.fromJson(data as Map<String, dynamic>),
          );
        },
      );
      
      if (mounted) {
        setState(() {
          brandList = response.data?.list ?? [];
        });
      }
    } catch (e) {
      print('获取品牌列表失败: $e');
    }
  }


  void _performSearch(String query) {
    if (!mounted) return;
    
    setState(() {
      isSearching = query.isNotEmpty;
      // 更新筛选参数，添加 name 字段
      if (query.isNotEmpty) {
        filterParams['name'] = query;
      } else {
        filterParams.remove('name');
      }
    });
    
    // 执行 API 搜索
    if (query.isNotEmpty || filterParams.isNotEmpty) {
      getData(refresh: true);
    } else {
      // 如果搜索为空且没有其他筛选，重新获取数据
      filterParams.remove('name');
      getData(refresh: true);
    }
  }

  void _clearSearch() {
    if (!mounted) return;
    
    setState(() {
      searchController.clear();
      isSearching = false;
      filterParams.remove('name');
    });
    // 重新获取数据
    getData(refresh: true);
  }

  void _handleFilterChange(Map<String, dynamic> selected) {
    if (!mounted) return;
    
    setState(() {
      // 保留 name 搜索字段（如果存在）
      if (filterParams.containsKey('name')) {
        selected['name'] = filterParams['name'];
      }
      
      filterParams = selected;
      
      // 更新 selectedArea 用于显示
      if (selected.containsKey('areaId') && selected['areaId'] != null) {
        final areaIds = selected['areaId'] as List?;
        if (areaIds != null && areaIds.isNotEmpty) {
          selectedArea = areaIds.last.toString();
        } else {
          selectedArea = null;
        }
      } else {
        selectedArea = null;
      }
    });
    getData(refresh: true);
  }

  FilterValue convertToFilterValue(AreaResponse item) {
    return FilterValue(
      id: item.id.toString(),
      name: item.name ?? '',
      children: item.children?.map((child) => convertToFilterValue(child)).toList(),
    );
  }

  // 检查是否有活跃的筛选条件
  bool _hasActiveFilters() {
    // 检查是否有地区筛选
    if (filterParams.containsKey('areaId') && 
        filterParams['areaId'] != null &&
        filterParams['areaId'] is List &&
        (filterParams['areaId'] as List).isNotEmpty &&
        (filterParams['areaId'] as List).first != '') {
      return true;
    }
    // 检查是否有品牌筛选
    if (filterParams.containsKey('brandId') && 
        filterParams['brandId'] != null) {
      final brandId = filterParams['brandId'];
      if (brandId is List && brandId.isNotEmpty && brandId.first != '' && brandId.first.toString() != '') {
        return true;
      } else if (brandId != null && brandId.toString() != '') {
        return true;
      }
    }
    // 检查是否有规格筛选
    if (filterParams.containsKey('specId') && 
        filterParams['specId'] != null) {
      final specId = filterParams['specId'];
      if (specId is List && specId.isNotEmpty && specId.first != '' && specId.first.toString() != '') {
        return true;
      } else if (specId != null && specId.toString() != '') {
        return true;
      }
    }
    return false;
  }

  Widget _buildCinemaList(ScrollPhysics? physics) {
    final displayData = data;
    
    // 检查是否有地区筛选
    final hasAreaFilter = filterParams.containsKey('areaId') && 
                          filterParams['areaId'] != null &&
                          filterParams['areaId'] is List &&
                          (filterParams['areaId'] as List).isNotEmpty &&
                          (filterParams['areaId'] as List).first != '';
    
    // 如果没有地区筛选，显示标题（有定位显示"附近影院"，无定位显示"全部影院"）
    final showTitle = !hasAreaFilter;
    
    // 如果数据为空，显示空状态（支持下拉刷新）
    if (displayData.isEmpty) {
      return SingleChildScrollView(
        physics: physics ?? const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 300.h, // 确保有足够高度支持下拉刷新
          padding: EdgeInsets.symmetric(vertical: 100.h),
          child: Center(
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
          ),
        ),
      );
    }
    
    // 计算 itemCount
    final itemCount = displayData.length + (showTitle ? 1 : 0);
    
    return ListView.builder(
      controller: scrollController,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // 如果没有地区筛选，第一项显示标题
        if (showTitle && index == 0) {
          final hasLocation = position != null;
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(
                  hasLocation ? Icons.location_on_rounded : Icons.movie_rounded,
                  size: 24.sp,
                  color: const Color(0xFF1989FA),
                ),
                SizedBox(width: 8.w),
                Text(
                  hasLocation 
                    ? S.of(context).cinemaList_title 
                    : S.of(context).cinemaList_allCinemas,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1989FA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$totalCount',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1989FA),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        final cinemaIndex = showTitle ? index - 1 : index;
        final cinema = displayData[cinemaIndex];
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
                      if (cinema.distance != null)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
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
                                size: 16.sp,
                                color: Colors.blue.shade600,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _formatDistance(context, cinema.distance!),
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
                      // Spacer(),
                      // // "更多"按钮
                      // GestureDetector(
                      //   onTap: () {
                      //     // 跳转到电影详情页面或显示更多电影
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      //     // decoration: BoxDecoration(
                      //     //   color: Colors.blue.shade50,
                      //     //   borderRadius: BorderRadius.circular(16.r),
                      //     //   border: Border.all(
                      //     //     color: Colors.blue.shade200,
                      //     //     width: 1,
                      //     //   ),
                      //     // ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                            
                      //       children: [
                      //         Text(
                      //           '更多',
                      //           style: TextStyle(
                      //             fontSize: 20.sp,
                      //             color: Colors.grey.shade500,
                      //             // fontWeight: FontWeight.w600,
                      //           ),
                      //         ),
                      //         SizedBox(width: 4.w),
                      //         Icon(
                      //           Icons.arrow_forward_ios_rounded,
                      //           size: 20.sp,
                      //           color: Colors.grey.shade500,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  
                  // 电影海报列表 - 占满整行
                  SizedBox(
                    height: 240.h, // 保持高度限制以避免布局错误
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
                                  context.pushNamed('showTimeDetail',
                                    pathParameters: {
                                      'id': '${movie.id}'
                                    },
                                   queryParameters: {
                                    'movieId': '${movie.id}',
                                    'cinemaId': '${cinema.id}'
                                  });
                                },
                                child: Container(
                                  width: 160.w, // 固定宽度，适合显示更多电影
                                  height: double.infinity, // 添加高度限制，确保卡片有固定高度
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
                                      // if (movie.rate != null && movie.rate! > 0)
                                      //   Container(
                                      //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                                      //     decoration: BoxDecoration(
                                      //       color: Colors.orange.shade50,
                                      //       borderRadius: BorderRadius.circular(24.r),
                                      //       border: Border.all(
                                      //         color: Colors.orange.shade200,
                                      //         width: 2,
                                      //       ),
                                      //       boxShadow: [
                                      //         BoxShadow(
                                      //           color: Colors.orange.withOpacity(0.2),
                                      //           blurRadius: 12,
                                      //           offset: const Offset(0, 3),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     child: Row(
                                      //       mainAxisSize: MainAxisSize.min,
                                      //       children: [
                                      //         Icon(
                                      //           Icons.star_rounded,
                                      //           size: 28.sp,
                                      //           color: Colors.orange.shade600,
                                      //         ),
                                      //         SizedBox(width: 6.w),
                                      //         Text(
                                      //           movie.rate!.toStringAsFixed(1),
                                      //           style: TextStyle(
                                      //             fontSize: 18.sp,
                                      //             color: Colors.orange.shade700,
                                      //             fontWeight: FontWeight.bold,
                                      //             letterSpacing: 0.5,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
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
                  Colors.white,
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
                              location?.subLocality ?? S.of(context).cinemaList_allArea,
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
                  SizedBox(height: 12.h),
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
                    : FilterBar(
                          filters: [
                            FilterOption(
                              key: 'areaId',
                              title: S.of(context).cinemaList_filter_title,
                              multi: false,
                              nested: true,
                              values: [
                                FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
                                ...areaTreeList.map((item) => convertToFilterValue(item)).toList(),
                              ],
                            ),
                            FilterOption(
                              key: 'brandId',
                              title: S.of(context).cinemaList_filter_brand,
                              multi: false,
                              nested: false,
                              values: [
                                FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
                                ...brandList.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
                                  return FilterValue(
                                    id: item.id.toString(),
                                    name: item.name!
                                  );
                                }).toList(),
                              ],
                            ),
                            FilterOption(
                              key: 'specId',
                              title: S.of(context).about_movieShowList_dropdown_screenSpec,
                              multi: false,
                              nested: false,
                              values: [
                                FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
                                ...cinemaSpecList.where((item) => item.name != null && item.name!.isNotEmpty).map((item) {
                                  return FilterValue(
                                    id: item.id.toString(),
                                    name: item.name!,
                                  );
                                }).toList(),
                              ],
                            ),
                          ],
                          initialSelected: filterParams,
                          onConfirm: _handleFilterChange,
                        ),
                ],
              ],
            ),
          ),
          
          // 搜索时的清除按钮 - 仅在搜索时显示
          if (isSearching)
            Container(
              margin: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _clearSearch,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1989FA),
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
                onLoad: () async {
                  if (!loadFinished) {
                    await getData(page: currentPage + 1);
                  } else {
                    easyRefreshController.finishLoad(IndicatorResult.noMore, true);
                  }
                },
                childBuilder: (context, physics) {
                  return _buildCinemaList(physics);
                },
              ),
            ),
          ),
          // Container(
          //     width: double.infinity,
          //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.06),
          //           blurRadius: 10,
          //           offset: const Offset(0, -2),
          //         ),
          //       ],
          //     ),
              // child: SafeArea(
              //   top: false,
              //   child: Row(
              //     children: [
              //       Container(
              //         padding: EdgeInsets.all(6.w),
              //         decoration: BoxDecoration(
              //           color: const Color(0xFF1989FA).withOpacity(0.12),
              //           borderRadius: BorderRadius.circular(8.r),
              //         ),
              //         child: Icon(
              //           Icons.my_location_rounded,
              //           size: 18.sp,
              //           color: const Color(0xFF1989FA),
              //         ),
              //       ),
              //       SizedBox(width: 10.w),
              //       Text(
              //         '${S.of(context).cinemaList_currentLocation}: ',
              //         style: TextStyle(
              //           fontSize: 22.sp,
              //           color: const Color(0xFF646566),
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //       Expanded(
              //         child: Text(
              //           locationLoading
              //             ? S.of(context).cinemaList_address
              //             : _currentFullAddressText(context),
              //           style: TextStyle(
              //             fontSize: 24.sp,
              //             color: const Color(0xFF323233),
              //             fontWeight: FontWeight.w600,
              //           ),
              //           maxLines: 2,
              //           softWrap: true,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
    //         ),
        ],
      ),
    );
  }
}