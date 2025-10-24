import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/cinema/cinema_detail_response.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_showing_response.dart';
import 'package:otaku_movie/response/cinema/movie_ticket_type_response.dart';
import 'package:otaku_movie/response/cinema/theater_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import '../../generated/l10n.dart';
import 'package:geocoding/geocoding.dart';


class CinemaDetail extends StatefulWidget {
  String? id;

  CinemaDetail({super.key, this.id});

  @override
  State<CinemaDetail> createState() => _PageState();
}

class _PageState extends State<CinemaDetail> with SingleTickerProviderStateMixin {
  bool loading = false;
  bool error = false;
  int currentPage = 1;

  CinemaDetailResponse data = CinemaDetailResponse();
  List<TheaterDetailResponse> theaterList = [];
  List<MovieTicketTypeResponse> movieTicketTypeList = [];
  List<CinemaMovieShowingResponse> cinemaMovieShowingList = [];

  void getData({page = 1}) {
    setState(() {
      loading = true;
    });
    ApiRequest().request(
      path: '/cinema/detail',
      method: 'GET',
      queryParameters: {
        "id": widget.id
      },
      fromJsonT: (json) {
        return CinemaDetailResponse.fromJson(json as Map<String, dynamic>);
      },
    ).then((res) async {
      if (res.data != null) {
        setState(() {
          data = res.data!;
        });
      }
    }).catchError((err) {
      setState(() {
        error = true;
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  void getTheaterData() {
    ApiRequest().request(
      path: '/theater/hall/list',
      method: 'POST',
      data: {
        "cinemaId": widget.id
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<TheaterDetailResponse>.fromJson(
          json,
          (data) => TheaterDetailResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) async {
      if (res.data?.list != null) {
        List<TheaterDetailResponse> list = res.data!.list!;
        
        setState(() {
          theaterList = list;
        });
      }
    });
  }

  getMovieTicketType() {
    ApiRequest().request(
      path: '/cinema/ticketType/list',
      method: 'POST',
      data: {"cinemaId": int.parse(widget.id!)},
      fromJsonT: (json) {
        if (json is List) {
          return json.map((item) {
            return MovieTicketTypeResponse.fromJson(item);
          }).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          movieTicketTypeList = res.data!;
        });
      }
    });
  }
  getCinemaMovieShowingData() {
    ApiRequest().request<List<CinemaMovieShowingResponse>>(
      path: '/cinema/movieShowing',
      method: 'GET',
      queryParameters: {
        "id": int.parse(widget.id!)
      },
      fromJsonT: (json) {
        if (json is List) {
          return json.map((item) {
            return CinemaMovieShowingResponse.fromJson(item);
          }).toList();
        }
        return [];
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          cinemaMovieShowingList = res.data ?? [];
        });
      }
    });
  }

  // 打开地图导航
  Future<void> _openMap(String address) async {
    if (address.isEmpty) return;
    
    try {
      // 使用地理编码将地址转换为经纬度
      List<Location> locations = await locationFromAddress(address);
      
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;
        await callMap(latitude, longitude);
      }
    } catch (e) {
      print('Error geocoding address: $e');
      // 如果地理编码失败，可以考虑直接使用地址打开地图搜索
      // 或者显示错误提示
    }
  }

  @override
  void initState() {
    super.initState();
    getData();  // 获取其他数据
    getTheaterData();
    getMovieTicketType();
    getCinemaMovieShowingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar:  CustomAppBar(
        title: data.name ?? '',
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 34.sp, fontWeight: FontWeight.bold),
      ),
      body: AppErrorWidget(
        loading: loading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 影院基本信息卡片
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 地址
                    _buildCompactInfoRow(
                      icon: Icons.location_on_rounded,
                      iconColor: const Color(0xFF1989FA),
                      content: data.fullAddress ?? '',
                      onTap: () async {
                        await _openMap(data.fullAddress ?? '');
                      },
                    ),
                    
                    Divider(height: 32.h, color: Colors.grey.shade100),
                    
                    // 电话 和 最大选座数
                    Row(
                      children: [
                        Expanded(
                          child: _buildCompactInfoRow(
                            icon: Icons.phone_rounded,
                            iconColor: const Color(0xFF07C160),
                            content: data.tel ?? '',
                            onTap: () async {
                              await callTel(data.tel ?? '');
                            },
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40.h,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          color: Colors.grey.shade100,
                        ),
                        Expanded(
                          child: _buildCompactInfoRow(
                            icon: Icons.event_seat_rounded,
                            iconColor: const Color(0xFFFF976A),
                            content: '${data.maxSelectSeatCount}席',
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                    
                    // 官网
                    if (data.homePage != null && data.homePage!.isNotEmpty) ...[
                      Divider(height: 32.h, color: Colors.grey.shade100),
                      _buildCompactInfoRow(
                        icon: Icons.language_rounded,
                        iconColor: const Color(0xFF7232DD),
                        content: data.homePage ?? '',
                        isLink: true,
                        onTap: () {
                          launchURL(data.homePage ?? '');
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // 正在上映电影
              if (cinemaMovieShowingList.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        child: Text(
                          S.of(context).cinemaDetail_showing,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF323233),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 360.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: cinemaMovieShowingList.length,
                          itemBuilder: (context, index) {
                            final item = cinemaMovieShowingList[index];
                            return GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  'showTimeDetail',
                                  pathParameters: {"id": '${item.id}'},
                                  queryParameters: {
                                    "movieId": '${item.id}',
                                    "cinemaId": '${widget.id}'
                                  },
                                );
                              },
                              child: Container(
                                width: 200.w,
                                margin: EdgeInsets.only(right: 16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 200.w,
                                      height: 230.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: CustomExtendedImage(
                                          item.poster ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      item.name ?? '',
                                      style: TextStyle(
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF323233),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
              
              // 票价信息
              if (movieTicketTypeList.isNotEmpty)
                _buildSection(
                  context,
                  title: S.of(context).cinemaDetail_ticketTypePrice,
                  children: movieTicketTypeList.map((item) {
                    return _buildPriceItem(
                      item.name ?? '',
                      '${item.price}${S.of(context).common_unit_jpy}',
                      false,
                    );
                  }).toList(),
                ),

              // 特殊规格价格
              if (data.spec != null && data.spec!.isNotEmpty)
                _buildSection(
                  context,
                  title: S.of(context).cinemaDetail_specialSpecPrice,
                  children: data.spec!.map((item) {
                    return _buildSpecItem(
                      item.name ?? '',
                      item.plusPrice?.toString() ?? '0',
                    );
                  }).toList(),
                ),

              // 影厅规格
              if (theaterList.isNotEmpty)
                _buildSection(
                  context,
                  title: S.of(context).cinemaDetail_theaterSpec,
                  children: theaterList.map((item) {
                    return _buildTheaterItem(
                      context,
                      '${item.name ?? ''}',
                      item.cinemaSpecName ?? '',
                      item.seatCount ?? 0,
                    );
                  }).toList(),
                ),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // 构建区块
  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF323233),
              ),
            ),
          ),
          // 内容项
          ...children,
        ],
      ),
    );
  }

  // 构建特殊规格项
  Widget _buildSpecItem(String name, String plusPrice) {
    // 定义不同规格的配色方案
    Color getSpecColor(String specName) {
      if (specName.toUpperCase().contains('IMAX')) {
        return const Color(0xFF00BFA5); // 青色
      } else if (specName.toUpperCase().contains('4DX') || specName.toUpperCase().contains('4D')) {
        return const Color(0xFFFF6B6B); // 红色
      } else if (specName.toUpperCase().contains('DOLBY')) {
        return const Color(0xFF667EEA); // 紫色
      } else if (specName.toUpperCase().contains('3D')) {
        return const Color(0xFF48C9B0); // 绿色
      } else {
        return const Color(0xFFFF976A); // 橙色（默认）
      }
    }

    // 定义不同规格的图标
    IconData getSpecIcon(String specName) {
      if (specName.toUpperCase().contains('IMAX')) {
        return Icons.crop_16_9_rounded;
      } else if (specName.toUpperCase().contains('4DX') || specName.toUpperCase().contains('4D')) {
        return Icons.chair_rounded;
      } else if (specName.toUpperCase().contains('DOLBY')) {
        return Icons.surround_sound_rounded;
      } else if (specName.toUpperCase().contains('3D')) {
        return Icons.view_in_ar_rounded;
      } else {
        return Icons.stars_rounded;
      }
    }

    final specColor = getSpecColor(name);
    final specIcon = getSpecIcon(name);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [specColor.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: specColor.withOpacity(0.3), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // 背景装饰
            Positioned(
              right: -20.w,
              bottom: -20.h,
              child: Icon(
                specIcon,
                size: 100.sp,
                color: specColor.withOpacity(0.05),
              ),
            ),
            // 内容
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  // 左侧：规格图标和名称
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: specColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      specIcon,
                      color: specColor,
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: const Color(0xFF323233),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: specColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            '特殊规格',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: specColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // 右侧：加价
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: specColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.currency_yen_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        Text(
                          plusPrice,
                          style: TextStyle(
                            fontSize: 32.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建价格项
  Widget _buildPriceItem(String name, String price, bool isPlus) {
    final priceColor = isPlus ? const Color(0xFFFF976A) : const Color(0xFF1989FA);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧：名称
          Text(
            name,
            style: TextStyle(
              fontSize: 26.sp,
              color: const Color(0xFF323233),
              fontWeight: FontWeight.w500,
            ),
          ),
          // 右侧：价格
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.currency_yen_rounded,
                color: priceColor,
                size: 22.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                price.replaceAll('¥', '').replaceAll('円', ''),
                style: TextStyle(
                  fontSize: 30.sp,
                  color: priceColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 构建影厅项
  Widget _buildTheaterItem(BuildContext context, String name, String spec, int seatCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          // 左侧：影厅图标
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.theaters_rounded,
              color: const Color(0xFF667EEA),
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // 中间：影厅名称和规格
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: const Color(0xFF323233),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (spec.isNotEmpty) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.high_quality_rounded,
                          color: Colors.blue.shade600,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          spec,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // 右侧：座位数
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_seat_rounded,
                  size: 20.sp,
                  color: Colors.white,
                ),
                SizedBox(width: 6.w),
                Text(
                  '$seatCount',
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 构建紧凑信息行
  Widget _buildCompactInfoRow({
    required IconData icon,
    required Color iconColor,
    required String content,
    bool isLink = false,
    bool compact = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // 图标
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 14.w),
          // 内容
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: compact ? 24.sp : 26.sp,
                color: isLink ? iconColor : const Color(0xFF323233),
                fontWeight: FontWeight.w500,
                decoration: isLink ? TextDecoration.underline : TextDecoration.none,
              ),
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 箭头或链接图标
          if (onTap != null && !compact)
            Icon(
              isLink ? Icons.open_in_new_rounded : Icons.chevron_right_rounded,
              color: Colors.grey.shade400,
              size: 28.sp,
            ),
        ],
      ),
    );
  }

  // 构建信息项（旧方法，保留以防其他地方使用）
  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String content,
    bool isLink = false,
    bool showBadge = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          children: [
            // 图标
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            // 内容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  if (isLink)
                    // 链接样式
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: iconColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.link_rounded,
                            color: iconColor,
                            size: 16.sp,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              content,
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: iconColor,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: const Color(0xFF323233),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            // 右侧元素
            if (showBadge)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else if (onTap != null && !isLink)
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: iconColor,
                  size: 16.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
