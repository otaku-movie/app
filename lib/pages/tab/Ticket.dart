import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:jiffy/jiffy.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'dart:ui';

import 'package:otaku_movie/response/order/order_detail_response.dart';

class Ticket extends StatefulWidget {
  const Ticket({super.key});

  @override
  State<Ticket> createState() => _PageState();
}

class _PageState extends State<Ticket> {
   List<OrderDetailResponse> data = [];
  int currentPage = 1;
  bool loading = false;

  void getData({bool refresh = true}) {
    setState(() {
      loading = true;
    });
    ApiRequest().request(
      path: '/user/orderList',
      method: 'POST',
      data: {
        "page": refresh ? 1 : currentPage + 1,
        "pageSize": 10,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<OrderDetailResponse>.fromJson(
          json,
          (data) => OrderDetailResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      setState(() {
        if (refresh) {
          data = res.data?.list ?? [];
          currentPage = 1;
        } else {
          data.addAll(res.data?.list ?? []);
          currentPage++;
        }
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
      return '${jiffy.format(pattern: 'MM月dd日')} $weekday';
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


  Widget _buildTicketCard(OrderDetailResponse ticket) {
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
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Stack(
          children: [
            // 电影票主体
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 票头部分 - 电影信息
                  Container(
                    height: 280.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 封面背景
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r),
                            ),
                            child: CustomExtendedImage(
                              ticket.moviePoster ?? '',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // 模糊效果
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        // 渐变遮罩
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24.r),
                                topRight: Radius.circular(24.r),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.2),
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // 内容
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Row(
                              children: [
                                // 电影海报
                                Container(
                                  width: 200.w,
                                  // height: 220.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.grey.shade300,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CustomExtendedImage(
                              ticket.moviePoster ?? '',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                                ),
                                SizedBox(width: 20.w),
                        // 电影信息
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket.movieName ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                ticket.movieName ?? '',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 28.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  _buildTag(ticket.theaterHallSpecName ?? ''),
                                  SizedBox(width: 8.w),
                                  // _buildTag(ticket.theaterHallLanguage ?? ''),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // 状态标签
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        //   decoration: BoxDecoration(
                        //     color: _getStatusColor(ticket.status).withOpacity(0.9),
                        //     borderRadius: BorderRadius.circular(24.r),
                        //   ),
                        //   child: Text(
                        //     _getStatusText(ticket.status),
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 26.sp,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 票身部分 - 核心信息
                  Container(
                    padding: EdgeInsets.all(28.w),
                    child: Column(
                      children: [
                        // 影院信息
                        Container(
                          padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(Icons.location_on, color: Colors.blue.shade600, size: 24.sp),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                    Text(
                                      ticket.cinemaName ?? '',
                                      style: TextStyle(
                    fontSize: 28.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      ticket.cinemaFullAddress ?? '',
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: Colors.blue.shade200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.movie, color: Colors.blue.shade700, size: 18.sp),
                                    SizedBox(width: 6.w),
                                    Text(
                                      ticket.theaterHallName ?? '',
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // 放映时间和票数信息 - 简洁现代设计
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // 放映时间 - 主要信息
                              Container(
                                padding: EdgeInsets.all(24.w),
                                child: Column(
                                  children: [
                                    // 时间标题
                                    Row(
                                      children: [
                                        Container(
                                          width: 4.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade600,
                                            borderRadius: BorderRadius.circular(2.r),
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          S.of(context).ticket_showTime,
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            color: Colors.grey.shade800,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    
                                    // 时间信息
                                    Row(
                                      children: [
                                        // 左侧：日期和星期
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _formatShowTime(ticket.date, ticket.startTime),
                                                style: TextStyle(
                                                  fontSize: 24.sp,
                                                  color: Colors.grey.shade800,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: Text(
                                                  _formatWeekday(ticket.date, ticket.startTime),
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.blue.shade700,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        
                                        // 右侧：时间
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatTime(ticket.startTime),
                                              style: TextStyle(
                                                fontSize: 48.sp,
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2.0,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              '${S.of(context).ticket_endTime} ${_formatTime(ticket.endTime)}',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // 分割线
                              Container(
                                height: 1.h,
                                margin: EdgeInsets.symmetric(horizontal: 24.w),
                                color: Colors.grey.shade200,
                              ),
                              
                              // 票数信息
                              Container(
                                padding: EdgeInsets.all(24.w),
                                child: Row(
                                  children: [
                                    // 左侧：票数标签
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 4.w,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade600,
                                                borderRadius: BorderRadius.circular(2.r),
                                              ),
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              S.of(context).ticket_ticketCount,
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.grey.shade800,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          S.of(context).ticket_totalPurchased,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // 右侧：票数数字
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${ticket.seat?.length ?? 0}',
                                            style: TextStyle(
                                              fontSize: 48.sp,
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            S.of(context).ticket_tickets,
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.green.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // 上映时间提示
                              if (_isNearShowTime(ticket.date, ticket.startTime)) ...[
                                Container(
                                  margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.w),
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(color: Colors.orange.shade200),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.access_time, color: Colors.orange.shade600, size: 18.sp),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '${_getTimeRemaining(ticket.date, ticket.startTime)}后开始',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.orange.shade700,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 点击提示
            Positioned(
              top: 16.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                            Text(
                              S.of(context).ticket_tapToView,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                ],
              ),
            ),
          ),
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
      backgroundColor: Colors.grey.shade100,
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : data.isEmpty
              ? Center(
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
                )
              : EasyRefresh.builder(
                  header: customHeader(context),
                  onRefresh: () async {
                    getData();
                  },
                  childBuilder: (context, physics) {
                    return ListView.builder(
                      physics: physics,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return _buildTicketCard(data[index]);
                      },
                    );
                  },
                ),
    );
  }
}
