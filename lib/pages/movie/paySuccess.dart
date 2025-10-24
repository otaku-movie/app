import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:dio/dio.dart';

class PaySuccess extends StatefulWidget {
  final String? orderId;

  const PaySuccess({super.key, this.orderId});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<PaySuccess> {
  OrderDetailResponse data = OrderDetailResponse();
  Uint8List? QRcodeBytes;
  bool loading = false;

  getData() {
    setState(() {
      loading = true;
    });
    if (widget.orderId != null) {
      ApiRequest().request(
        path: '/movieOrder/detail',
        method: 'GET', 
        queryParameters: {
          "id": int.parse(widget.orderId!)
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
   
  }
  generatorQRCode () {
    ApiRequest().request<dynamic>(
      path: '/movieOrder/generatorQRcode',
      method: 'GET', 
      queryParameters: {
        "id": int.parse(widget.orderId!)
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
    return WillPopScope(
      onWillPop: () async => false, // 禁用返回
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
         title: Text(S.of(context).payResult_title, style: const TextStyle(color: Colors.white)),
          showBackButton: false, // 隐藏返回按钮
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
              // 支付成功状态
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 60.h),
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
                    // 成功图标
              Container(
                      width: 140.w,
                      height: 140.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF07C160).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: const Color(0xFF07C160),
                        size: 100.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // 成功提示
                    Text(
                      S.of(context).payResult_success,
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323233),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // 支付金额
                    RichText(
                      text: TextSpan(
                children: [
                          TextSpan(
                            text: '${data.orderTotal}',
                            style: TextStyle(
                              fontSize: 48.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF323233),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: ' ${S.of(context).common_unit_jpy}',
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: const Color(0xFF969799),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
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
                    
                    SizedBox(height: 12.h),
                    
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
                                width: 180.w,
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              
              SizedBox(height: 24.h),
              
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
              
              SizedBox(height: 24.h),
              
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
                            '${S.of(context).payResult_ticketCode}：',
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
                    
                    SizedBox(height: 24.h),
                    
                    // 提示文字
                    Text(
                      S.of(context).payResult_qrCodeTip,
                      style: TextStyle(
                        fontSize: 24.sp,
                        color: const Color(0xFF969799),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // 查看我的电影票按钮
              GestureDetector(
                onTap: () {
                  // 跳转到首页的票务 Tab（索引1）
                  context.go('/home?tab=1');
                },
                child: Container(
                  width: double.infinity,
                  height: 88.h,
                              decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1989FA),
                        const Color(0xFF1989FA).withOpacity(0.9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1989FA).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.confirmation_number_outlined,
                        color: Colors.white,
                        size: 40.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        S.of(context).payResult_viewMyTickets,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
