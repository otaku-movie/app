import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:jiffy/jiffy.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'dart:ui';

import 'package:otaku_movie/response/ticket/ticket_detail_response.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key});

  @override
  State<Ticket> createState() => _PageState();
}

class _PageState extends State<Ticket> {
  List<TicketDetailResponse> data = [];
  int currentPage = 1;
  bool loading = false;
  bool error = false;
  bool hasMore = true; // 是否还有更多数据
  int totalCount = 0; // 总条数
  late EasyRefreshController easyRefreshController;
  Future<void> getData({bool refresh = true}) async {
    if (mounted) {
      setState(() {
        loading = true;
        error = false;
      });
    }
    try {
      final res = await ApiRequest().request<ApiPaginationResponse<TicketDetailResponse>>(
        path: '/movieOrder/myTickets',
        method: 'POST',
        data: {
          "page": refresh ? 1 : currentPage,
          "pageSize": 10,
        },
        fromJsonT: (json) {
          // 如果json直接是列表
          if (json is List) {
            return ApiPaginationResponse<TicketDetailResponse>(
              page: refresh ? 1 : currentPage,
              pageSize: 10,
              total: json.length,
              list: json.map((item) => TicketDetailResponse.fromJson(item as Map<String, dynamic>)).toList(),
            );
          }
          // 如果json是带分页信息的对象
          return ApiPaginationResponse<TicketDetailResponse>.fromJson(
            json,
            (data) => TicketDetailResponse.fromJson(data as Map<String, dynamic>),
          );
        },
      );

      if (mounted) {
        setState(() {
          if (refresh) {
            data = res.data?.list ?? [];
            currentPage = 2; // 下次加载第2页
            totalCount = res.data?.total ?? 0; // 获取总条数
            hasMore = data.length < totalCount; // 当前数据条数小于总条数说明还有更多
          } else {
            // 只有在有新数据时才添加
            if (res.data?.list != null && res.data!.list!.isNotEmpty) {
              data.addAll(res.data!.list!);
              currentPage++;
              hasMore = data.length < totalCount; // 当前数据条数小于总条数说明还有更多
            } else {
              hasMore = false; // 没有数据了
            }
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    getData();
  }

  @override
  void dispose() {
    easyRefreshController.dispose();
    super.dispose();
  }



  bool _isNearShowTime(String? dateString, String? timeString) {
    if (dateString == null || dateString.isEmpty || timeString == null || timeString.isEmpty) {
      return false;
    }
    
    try {
      final dateTime = DateTime.parse('$dateString $timeString');
      final now = DateTime.now();
      final difference = dateTime.difference(now);
      // 如果距离上映时间不到2小时，显示提示
      return difference.inHours <= 2 && difference.inMinutes > 0;
    } catch (e) {
      return false;
    }
  }

  String _getTimeRemaining(String? dateString, String? timeString) {
    if (dateString == null || dateString.isEmpty || timeString == null || timeString.isEmpty) {
      return S.of(context).ticket_time_unknown;
    }
    
    try {
      final dateTime = DateTime.parse('$dateString $timeString');
      final now = DateTime.now();
      final difference = dateTime.difference(now);
      
      if (difference.inDays > 0) {
        return S.of(context).ticket_time_remaining_days(difference.inDays);
      } else if (difference.inHours > 0) {
        return S.of(context).ticket_time_remaining_hours(difference.inHours);
      } else if (difference.inMinutes > 0) {
        return S.of(context).ticket_time_remaining_minutes(difference.inMinutes);
      } else {
        return S.of(context).ticket_time_remaining_soon;
      }
    } catch (e) {
      return S.of(context).ticket_time_formatError;
    }
  }

  String _formatShowTime(String? dateString, String? timeString) {
    if (dateString == null || dateString.isEmpty || timeString == null || timeString.isEmpty) {
      return S.of(context).ticket_time_unknown;
    }
    
    try {
      // 组合日期和时间
      final dateTime = DateTime.parse('$dateString $timeString');
      final jiffy = Jiffy.parseFromDateTime(dateTime);
      final weekday = _getWeekdayText(dateTime.weekday);
      return '${jiffy.format(pattern: 'yyyy年MM月dd日')} $weekday';
    } catch (e) {
      return S.of(context).ticket_time_formatError;
    }
  }

  String _formatWeekday(String? dateString, String? timeString) {
    if (dateString == null || dateString.isEmpty || timeString == null || timeString.isEmpty) {
      return S.of(context).ticket_time_unknown;
    }
    
    try {
      final dateTime = DateTime.parse('$dateString $timeString');
      return _getWeekdayText(dateTime.weekday);
    } catch (e) {
      return S.of(context).ticket_time_unknown;
    }
  }

  String _getWeekdayText(int weekday) {
    switch (weekday) {
      case 1:
        return S.of(context).ticket_time_weekdays_monday;
      case 2:
        return S.of(context).ticket_time_weekdays_tuesday;
      case 3:
        return S.of(context).ticket_time_weekdays_wednesday;
      case 4:
        return S.of(context).ticket_time_weekdays_thursday;
      case 5:
        return S.of(context).ticket_time_weekdays_friday;
      case 6:
        return S.of(context).ticket_time_weekdays_saturday;
      case 7:
        return S.of(context).ticket_time_weekdays_sunday;
      default:
        return S.of(context).ticket_time_unknown;
    }
  }

  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '--:--';
    
    try {
      // 如果时间字符串只包含时间部分，直接解析
      if (timeString.contains(':')) {
        final parts = timeString.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
      // 如果是完整的日期时间字符串，解析后提取时间
      final dateTime = DateTime.parse(timeString);
      final jiffy = Jiffy.parseFromDateTime(dateTime);
      return jiffy.format(pattern: 'HH:mm');
    } catch (e) {
      return '--:--';
    }
  }


  Widget _buildTicketCard(TicketDetailResponse ticket, int index) {
    return GestureDetector(
            onTap: () {
        context.pushNamed(
          'orderDetail',
          queryParameters: {
            "id": '${ticket.id}'
          }
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
        child: Stack(
          children: [
            // 电影票主体
            ClipPath(
              clipper: TicketClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                  boxShadow: [
                    // 主阴影 - 更深更大
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                      spreadRadius: 0,
                    ),
                    // 次级阴影 - 增加深度
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: -5,
                    ),
                    // 彩色阴影 - 增加质感
                    BoxShadow(
                      color: Color(0xFF667EEA).withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Column(
                children: [
                  // 票头部分 - 电影信息
                 
                  Container(
                    height: 240.h,
                    child: Stack(
                      children: [
                        // 电影海报背景（模糊）
                        Positioned.fill(
                          child: ClipRRect(
                            child: Stack(
                              children: [
                                CustomExtendedImage(
                                  ticket.moviePoster ?? '',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 内容
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Row(
                              children: [
                                // 电影海报（清晰）
                                AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child:  Container(
                                  // width: 180.w,
                                  // height: 200.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.r),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: CustomExtendedImage(
                                      ticket.moviePoster ?? '',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                ),
                               
                                SizedBox(width: 24.w),
                                // 电影信息
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ticket.movieName ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(0.3),
                                              offset: Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 虚线分隔
                  Container(
                    height: 1,
                    child: CustomPaint(
                      painter: DashedLinePainter(),
                    ),
                  ),
                  
                  // 票身部分 - 核心信息
                  Container(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      children: [
                        // 影院和影厅信息
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Color(0xFF667EEA).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.location_city_rounded,
                                color: Color(0xFF667EEA),
                                size: 32.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ticket.cinemaName ?? '',
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF323233),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        ticket.theaterHallName ?? '',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      if (ticket.specName != null && ticket.specName!.isNotEmpty) ...[
                                        SizedBox(width: 12.w),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                                            ),
                                            borderRadius: BorderRadius.circular(12.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFFFFD700).withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            ticket.specName!,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // 时间信息 - 简约风格
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          // decoration: BoxDecoration(
                          //   color: Colors.grey.shade100,
                          //   borderRadius: BorderRadius.circular(16.r),
                          // ),
                          child: Row(
                            children: [
                              // 日期
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today_rounded, size: 20.sp, color: Colors.grey.shade600),
                                        SizedBox(width: 8.w),
                                        Text(
                                          S.of(context).ticket_showTime,
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      _formatShowTime(ticket.date, ticket.startTime),
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF323233),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // 时间
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                                      color: Color(0xFF667EEA).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 16.sp,
                                          color: Color(0xFF667EEA),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '开场',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Color(0xFF667EEA),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "${_formatTime(ticket.startTime)} ~ ${_formatTime(ticket.endTime)}",
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF667EEA),
                                      letterSpacing: 2,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 16.h),
                        
                       
                        
                        SizedBox(height: 16.h),
                        
                        // 座位信息
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6B6B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.event_seat_rounded,
                                color: Color(0xFFFF6B6B),
                                size: 32.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                  Text(
                                    S.of(context).ticket_ticketCount,
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '${ticket.seat?.length ?? 0} ${S.of(context).ticket_tickets}',
                                    style: TextStyle(
                    fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF323233),
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
          ),
            
            // QR码图标装饰（右上角）
            // Positioned(
            //   top: 20.h,
            //   right: 20.w,
            //   child: Container(
            //     padding: EdgeInsets.all(8.w),
            //     decoration: BoxDecoration(
            //       color: Colors.white.withOpacity(0.9),
            //       borderRadius: BorderRadius.circular(8.r),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.1),
            //           blurRadius: 8,
            //           offset: Offset(0, 2),
            //         ),
            //       ],
            //     ),
            //     child: Icon(
            //       Icons.qr_code_rounded,
            //       color: Color(0xFF667EEA),
            //       size: 32.sp,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(
        title: S.of(context).home_ticket,
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 36.sp),
        actions: [
          IconButton(
            onPressed: () {
              getData();
            },
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      
      body: AppErrorWidget(
        loading: loading,
        error: error,
        empty: !loading && !error && data.isEmpty,
        emptyWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.movie_outlined,
                        size: 100.w,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        S.of(context).ticket_noData,
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        S.of(context).ticket_noDataTip,
                        style: TextStyle(
                          fontSize: 26.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      ElevatedButton(
                        onPressed: () {
                          // 跳转到首页购票
                        },
                        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                        ),
                        child: Text(
                          S.of(context).ticket_buyTickets,
                          style: TextStyle(fontSize: 28.sp),
                        ),
                      ),
                    ],
                  ),
                ),
        child: EasyRefresh.builder(
                  controller: easyRefreshController,
                  header: customHeader(context),
                  footer: customFooter(context), // 始终显示footer
                  onRefresh: () async {
                    await getData(refresh: true);
                    easyRefreshController.finishRefresh(IndicatorResult.success);
                  },
                  onLoad: () async {
                    if (hasMore) {
                      await getData(refresh: false);
                      if (hasMore) {
                        easyRefreshController.finishLoad(IndicatorResult.success, true);
                      } else {
                        easyRefreshController.finishLoad(IndicatorResult.noMore, true);
                      }
                    } else {
                      easyRefreshController.finishLoad(IndicatorResult.noMore, true);
                    }
                  },
                  childBuilder: (context, physics) {
                    return ListView.builder(
                      physics: physics,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _buildTicketCard(data[index], index);
                      },
                    );
                  },
                ),
    ));
  }
}

// 电影票裁剪器 - 创建锯齿边缘效果
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 20.0;
    double notchRadius = 10.0;
    double notchPosition = size.height * 0.42; // 锯齿位置在42%处

    // 从左上角开始
    path.moveTo(radius, 0);
    
    // 顶部边缘
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    
    // 右侧边缘到锯齿位置
    path.lineTo(size.width, notchPosition - notchRadius);
    
    // 右侧半圆锯齿（凹进去）
    path.arcToPoint(
      Offset(size.width, notchPosition + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    
    // 右侧边缘继续到底部
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    
    // 底部边缘
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    
    // 左侧边缘到锯齿位置
    path.lineTo(0, notchPosition + notchRadius);
    
    // 左侧半圆锯齿（凹进去）
    path.arcToPoint(
      Offset(0, notchPosition - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    
    // 左侧边缘继续到顶部
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 虚线画笔
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 10.0;
    const dashSpace = 8.0;
    double startX = 20.0; // 从左边距开始

    while (startX < size.width - 20.0) { // 到右边距结束
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
