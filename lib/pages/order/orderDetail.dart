import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';

class OrderDetail extends StatefulWidget {
  final String? id;

  const OrderDetail({super.key, this.id});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<OrderDetail> {
  OrderDetailResponse data = OrderDetailResponse();
  // ignore: non_constant_identifier_names
  Uint8List? QRcodeBytes;
  bool loading = false;

  getData() {
    setState(() {
      loading = true;
    });
    ApiRequest().request(
      path: '/movieOrder/detail',
      method: 'GET', 
      queryParameters: {
        "id": int.parse(widget.id!)
      },
      fromJsonT: (json) {
        return OrderDetailResponse.fromJson(json);
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          data = res.data!;
        });
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }
  generatorQRCode () {
    ApiRequest().request<dynamic>(
      path: '/movieOrder/generatorQRcode',
      method: 'GET', 
      queryParameters: {
        "id": int.parse(widget.id!)
      },
      fromJsonT: (json) => json,
      responseType: ResponseType.bytes
    ).then((res) {
      setState(() {
        // res.data 现在包含图片的字节数据
        if (res.data is List<int>) {
          QRcodeBytes = Uint8List.fromList(res.data as List<int>);
        } else if (res.data is Uint8List) {
          QRcodeBytes = res.data as Uint8List;
        }
      });
    }).catchError((e) {
      print('生成二维码失败: $e');
    });
  }
  
  @override
  void initState() {
    super.initState();
    getData();
    generatorQRCode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
         title: Text(S.of(context).orderDetail_title, style: const TextStyle(color: Colors.white)),
      ),
      body: loading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: const Color(0xFF1989FA),
                ),
                SizedBox(height: 20.h),
                Text(
                  S.of(context).common_loading,
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: const Color(0xFF969799),
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 倒计时提示（距离开场时间小于1天且订单未开始时显示）
              if (_shouldShowCountdown())
                  Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6B6B).withOpacity(0.1),
                        const Color(0xFFFFE66D).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFFFF6B6B).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B6B).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: const Color(0xFFFF6B6B),
                          size: 32.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).orderDetail_countdown_title,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFF6B6B),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _getCountdownText(),
                              style: TextStyle(
                                fontSize: 26.sp,
                                color: const Color(0xFF646566),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              // 订单信息卡片
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 影院信息
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                context.pushNamed('cinemaDetail', queryParameters: {
                                  'id': '${data.cinemaId}'
                                });
                              },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 32.sp,
                                  color: const Color(0xFF1989FA),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    data.cinemaName ?? '',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF323233),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Row(
                              children: [
                            // 电话图标
                                GestureDetector(
                                    onTap: () async {
                                      await callTel('+81-080-1234-5678');
                                    },
                              child: Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1989FA).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Icon(
                                  Icons.call,
                                  color: const Color(0xFF1989FA),
                                  size: 32.sp,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // 地图图标
                                  GestureDetector(
                                    onTap: () async {
                                double latitude = 31.2304;
                                double longitude = 121.4737;
                                      await callMap(latitude, longitude);
                                    },
                              child: Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEE0A24).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Icon(
                                  Icons.map,
                                  color: const Color(0xFFEE0A24),
                                  size: 32.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // 分割线
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Divider(
                        color: const Color(0xFFEBEDF0),
                        height: 1,
                      ),
                    ),
                    
                    // 电影信息
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        // 电影海报
                          GestureDetector(
                            onTap: () {
                              context.pushNamed('movieDetail', pathParameters: {
                                'id': '${data.movieId}'
                              });
                            },
                            child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
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
                                child: CustomExtendedImage(
                                  data.moviePoster ?? '',
                                width: 220.w,
                                height: 240.h,
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 20.w),
                        
                        // 电影详情
                          Expanded(
                            child: SizedBox(
                            height: 240.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    // 电影名称
                                      Text(
                                        data.movieName ?? '',
                                        style: TextStyle(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF323233),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 16.h),
                                    
                                    // 放映时间
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8FA),
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 24.sp,
                                            color: const Color(0xFF969799),
                                          ),
                                          SizedBox(width: 6.w),
                                          Flexible(
                                            child: Text(
                                              '${data.date ?? ''} ${data.startTime} ~ ${data.endTime}',
                                          style: TextStyle(
                                                fontSize: 24.sp,
                                                color: const Color(0xFF646566),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // 版本信息和影厅
                                    if ((data.specName != null && data.specName!.isNotEmpty) || 
                                        (data.theaterHallName != null && data.theaterHallName!.isNotEmpty))
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Row(
                                          children: [
                                            // 影厅名称
                                            if (data.theaterHallName != null && data.theaterHallName!.isNotEmpty)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFFE7BA),
                                                  borderRadius: BorderRadius.circular(6.r),
                                                ),
                                                child: Text(
                                                  data.theaterHallName!,
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    color: const Color(0xFFED6A0C),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            
                                            // 间距
                                            if (data.theaterHallName != null && data.theaterHallName!.isNotEmpty &&
                                                data.specName != null && data.specName!.isNotEmpty)
                                              SizedBox(width: 8.w),
                                            
                                            // 版本信息
                                            if (data.specName != null && data.specName!.isNotEmpty)
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      const Color(0xFF1989FA),
                                                      const Color(0xFF1989FA).withOpacity(0.8),
                                                    ],
                                                  ),
                                                  borderRadius: BorderRadius.circular(6.r),
                                                ),
                                                child: Text(
                                                  data.specName!,
                                                  style: TextStyle(
                                                    fontSize: 22.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                
                                // 价格和评论按钮
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${data.orderTotal}',
                                            style: TextStyle(
                                              fontSize: 36.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFFEE0A24),
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ${S.of(context).common_unit_jpy}',
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: const Color(0xFFEE0A24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (data.orderState == OrderState.succeed)
                                      Container(
                                        height: 50.h,                  
                                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFF1989FA),
                                              const Color(0xFF1989FA).withOpacity(0.9),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(25.r),
                                        ),
                                        child: MaterialButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            // context.pushNamed('commentDetail');
                                          },
                                          child: Text(
                                            S.of(context).orderList_comment,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 26.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              
              // 座位信息卡片
                Container(
                  width: double.infinity,
                padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Row(
                    children: [
                        Icon(
                          Icons.event_seat,
                          size: 32.sp,
                          color: const Color(0xFF1989FA),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).orderDetail_seatMessage,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF323233),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // 座位列表
                    ...data.seat == null ? [] : data.seat!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Container(
                        margin: EdgeInsets.only(bottom: index < data.seat!.length - 1 ? 12.h : 0),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1989FA).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1989FA),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  '${item.seatName}',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF323233),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              item.movieTicketTypeName ?? '',
                              style: TextStyle(
                                fontSize: 26.sp,
                                color: const Color(0xFF969799),
                              ),
                            ),
                          ],
                        ),
                        );
                      }),
                  ],
                ),
              ),
              
              // 二维码取票卡片
                Container(
                width: double.infinity,
                padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 二维码标题
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 32.sp,
                          color: const Color(0xFF1989FA),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).orderDetail_ticketCount(data.seat == null ? 0 : data.seat!.length),
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF323233),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // 二维码
                    if (QRcodeBytes != null)
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: const Color(0xFFEBEDF0),
                            width: 2,
                          ),
                        ),
                        child: Image.memory(
                          QRcodeBytes!,
                          width: 320.w,
                          height: 320.w,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      Container(
                        width: 320.w,
                        height: 320.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xFF1989FA),
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 32.h),
                    
                    // 取票码
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFF7F8FA),
                            const Color(0xFFFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFEBEDF0),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${S.of(context).orderDetail_ticketCode}：',
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: const Color(0xFF969799),
                            ),
                          ),
                          Text(
                            '1234567890',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF323233),
                              letterSpacing: 2,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 订单详情卡片
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // 标题
                    Row(
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 32.sp,
                          color: const Color(0xFF1989FA),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).orderDetail_orderMessage,
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF323233),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    
                    // 订单详情项
                    _buildOrderInfoRow(
                      S.of(context).orderDetail_orderNumber,
                      '${data.id}',
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.of(context).orderDetail_orderState}：',
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: const Color(0xFF969799),
                          ),
                        ),
                        _buildOrderStateTag(data.orderState),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildOrderInfoRow(
                      S.of(context).orderDetail_orderCreateTime,
                      '${data.orderTime}',
                    ),
                    SizedBox(height: 16.h),
                    _buildOrderInfoRow(
                      S.of(context).orderDetail_payTime,
                      data.payTime ?? '',
                    ),
                    SizedBox(height: 16.h),
                    _buildOrderInfoRow(
                      S.of(context).orderDetail_payMethod,
                      data.payMethod ?? '',
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  // 构建订单信息行的辅助方法
  Widget _buildOrderInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label：',
          style: TextStyle(
            fontSize: 28.sp,
            color: const Color(0xFF969799),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
            ),
          ),
        ),
      ],
    );
  }

  // 根据订单状态获取颜色
  Color _getOrderStateColor(int? code) {
    switch (code) {
      case 1: // created - 已创建（蓝色）
        return const Color(0xFF1989FA);
      case 2: // succeed - 已完成（绿色）
        return const Color(0xFF07C160);
      case 3: // failed - 失败（红色）
        return const Color(0xFFEE0A24);
      case 4: // canceledOrder - 已取消（灰色）
        return const Color(0xFF969799);
      case 5: // timeout - 超时（橙色）
        return const Color(0xFFFF976A);
      default:
        return const Color(0xFF323233);
    }
  }

  // 构建订单状态标签
  Widget _buildOrderStateTag(int? code) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getOrderStateColor(code).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 24.sp,
          color: _getOrderStateColor(code),
          fontWeight: FontWeight.w500,
        ),
        child: Dict(
          name: 'orderState',
          code: code,
        ),
      ),
    );
  }

  // 判断是否应该显示倒计时
  bool _shouldShowCountdown() {
    // 只有订单状态为已支付成功时才显示
    if (data.orderState != OrderState.succeed.index + 1) {
      return false;
    }

    // 检查是否有日期和开始时间
    if (data.date == null || data.startTime == null) {
      return false;
    }

    try {
      // 解析日期和时间 (格式: 2024-10-23 14:30:00)
      final dateTimeStr = '${data.date} ${data.startTime}';
      final showDateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = showDateTime.difference(now);

      // 如果距离开场时间小于1天（24小时）且还未开场
      return difference.inHours < 24 && difference.inSeconds > 0;
    } catch (e) {
      print('解析日期时间失败: $e');
      return false;
    }
  }

  // 获取倒计时文本
  String _getCountdownText() {
    if (data.date == null || data.startTime == null) {
      return '';
    }

    try {
      // 解析日期和时间 (格式: 2024-10-23 14:30:00)
      final dateTimeStr = '${data.date} ${data.startTime}';
      final showDateTime = DateTime.parse(dateTimeStr);
      final now = DateTime.now();
      final difference = showDateTime.difference(now);

      if (difference.inSeconds <= 0) {
        return S.of(context).orderDetail_countdown_started;
      }

      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);

      if (hours > 0) {
        return S.of(context).orderDetail_countdown_hoursMinutes(hours, minutes);
      } else if (minutes > 0) {
        return S.of(context).orderDetail_countdown_minutesSeconds(minutes, seconds);
      } else {
        return S.of(context).orderDetail_countdown_seconds(seconds);
      }
    } catch (e) {
      print('获取倒计时文本失败: $e');
      return '';
    }
  }
}
