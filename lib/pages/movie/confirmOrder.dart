import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/response/order/payment_method_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:easy_refresh/easy_refresh.dart';

class ConfirmOrder extends StatefulWidget {
  final String? id;

  const ConfirmOrder({super.key, this.id});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<ConfirmOrder> {
  OrderDetailResponse data = OrderDetailResponse();
  List<PaymentMethodResponse> paymentMethodData = [];
  bool payLoading = false;
  bool loading = false;
  final EasyRefreshController _refreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  List<Map<String, dynamic>> pay  = [
    {
      "path": 'assets/icons/pay/paypay.svg',
      "name": 'paypay'
    },
    {
      "path": 'assets/icons/pay/amazon pay.svg',
      "name": 'amazon pay'
    }
  ];
  
  int countDown = 15 * 60;
  int allTime = 15 * 60;
  int? defaultPay;
  Timer? _timer;


  getData({bool isRefresh = false}) {
    if (!isRefresh) {
    setState(() {
      loading = true;
    });
    }
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
        // 调试信息：打印specName的值
        print('specName: ${data.specName}');
      }
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
      if (isRefresh) {
        _refreshController.finishRefresh(IndicatorResult.success);
      }
    });
  }
  getPaymentMethodData({bool isRefresh = false}) {
    if (!isRefresh) {
    setState(() {
      loading = true;
    });
    }
    ApiRequest().request(
      path: '/paymentMethod/list',
      method: 'GET', 
      queryParameters: {},
      fromJsonT: (json) {
        if (json is List) {
          return json.map((item) {
            return PaymentMethodResponse.fromJson(item);
          }).toList();
        }
        
      },
    ).then((res) {
      if (res.data != null && res.data is List && (res.data as List).isNotEmpty) {
        setState(() {
          paymentMethodData = res.data as List<PaymentMethodResponse>;
          defaultPay = res.data![0].id;
        });
      }
      if (isRefresh) {
        _refreshController.finishRefresh(IndicatorResult.success);
      }
    });
  }

  // 刷新数据
  Future<void> _onRefresh() async {
    await Future.wait([
      Future(() => getData(isRefresh: true)),
      Future(() => getPaymentMethodData(isRefresh: true)),
    ]);
  }

  @override
  void initState() {
    super.initState();
    getPaymentMethodData();
    getData();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown <= 0) {
        _timer?.cancel();  // 取消计时器
        return;
      }
      
      setState(() {
        countDown--;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  // 根据支付方式名称获取图标
  IconData _getPaymentIcon(String paymentName) {
    switch (paymentName) {
      case '支付宝':
        return Icons.account_balance_wallet;
      case '微信':
        return Icons.wechat;
      case 'PayPay':
        return Icons.payment;
      case 'クレジットカード':
        return Icons.credit_card;
      case 'LINE Pay':
        return Icons.chat;
      case '楽天Pay':
        return Icons.shopping_bag;
      case 'd払い':
        return Icons.phone_android;
      case 'au PAY':
        return Icons.phone_android;
      case 'メルペイ':
        return Icons.account_balance;
      case 'Suica':
        return Icons.train;
      case 'PASMO':
        return Icons.train;
      case 'nanaco':
        return Icons.card_giftcard;
      case 'WAON':
        return Icons.card_giftcard;
      default:
        return Icons.payment;
    }
  }

  // 根据支付方式名称获取图标颜色
  Color _getPaymentIconColor(String paymentName) {
    switch (paymentName) {
      case '支付宝':
        return Colors.blue.shade600; // 支付宝蓝色
      case '微信':
        return Colors.green.shade600; // 微信绿色
      case 'PayPay':
        return Colors.orange.shade600; // PayPay橙色
      case 'クレジットカード':
        return Colors.purple.shade600; // 信用卡紫色
      case 'LINE Pay':
        return Colors.green.shade500; // LINE绿色
      case '楽天Pay':
        return Colors.red.shade600; // 楽天红色
      case 'd払い':
        return Colors.blue.shade500; // NTT Docomo蓝色
      case 'au PAY':
        return Colors.orange.shade500; // au橙色
      case 'メルペイ':
        return Colors.amber.shade600; // メルカリ黄色
      case 'Suica':
        return Colors.blue.shade700; // JR东日本蓝色
      case 'PASMO':
        return Colors.purple.shade500; // 私铁紫色
      case 'nanaco':
        return Colors.pink.shade500; // セブン-イレブン粉色
      case 'WAON':
        return Colors.orange.shade400; // AEON橙色
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(S.of(context).confirmOrder_title, style: const TextStyle(color: Colors.white)),
      ),
      body: AppErrorWidget(
        loading: loading,
        child: Column(
        children: [
          Expanded(
              child: EasyRefresh(
                controller: _refreshController,
                onRefresh: _onRefresh,
                header: customHeader(context),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.grey.shade50,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                      children: [
                          // 电影海报
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                            child: CustomExtendedImage(
                              data.moviePoster ?? '',
                                width: 230.w,
                                height: 250.h,
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
                                // 电影标题和倒计时
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                          data.movieName ?? '',
                                          style: TextStyle(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    // 倒计时容器 - 固定宽度防止布局变化
                                    SizedBox(
                                      width: 125.w, // 固定宽度
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(color: Colors.red.shade200, width: 1),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.access_time, size: 18.sp, color: Colors.red.shade600),
                                            SizedBox(width: 6.w),
                                            Flexible(
                                              child: Text(
                                              formatNumberToTime(countDown),
                                              style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.red.shade600,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                        ),
                                      ],
                                    ),
                                    
                                SizedBox(height: 16.h),
                                
                                // 时间信息
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: Colors.blue.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.schedule,
                                        size: 20.sp,
                                        color: Colors.blue.shade600,
                                      ),
                                      SizedBox(width: 8.w),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            fontSize: 24.sp,
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: formatTime(
                                                timeString: data.date,
                                                format: S.of(context).cinemaList_selectSeat_dateFormat,
                                              ),
                                          ),
                                          TextSpan(
                                            text: '（${getDay(data.date ?? '', context)}）',
                                              style: TextStyle(
                                                color: Colors.blue.shade600,
                                                fontWeight: FontWeight.w500,
                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ),
                                
                                SizedBox(height: 12.h),
                                
                                // 时间段和规格
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: Colors.orange.shade200,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                  children: [
                                      Icon(
                                        Icons.movie,
                                        size: 20.sp,
                                        color: Colors.orange.shade600,
                                      ),
                                      SizedBox(width: 8.w),
                                    Text(
                                        '${data.startTime} ~ ${data.endTime}',
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          data.specName ?? '无规格信息',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.orange.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                SizedBox(height: 16.h),
                                
                                // 影院信息
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            size: 18.sp,
                                            color: Colors.red.shade600,
                                          ),
                                          SizedBox(width: 6.w),
                                          Expanded(
                                            child: Text(
                                              data.cinemaName ?? '',
                                              style: TextStyle(
                                                fontSize: 22.sp,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.chair,
                                            size: 16.sp,
                                            color: Colors.purple.shade600,
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            data.theaterHallName ?? '',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.w500,
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
                        ],
                      ),
                    ),
                    // 座位信息卡片 - 柔和色调设计
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade50,
                            Colors.grey.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题区域
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.1),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.event_seat,
                                    size: 24.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.of(context).confirmOrder_selectedSeats,
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800,
                                        ),
                                ),
                                 SizedBox(height: 4.h),
                                Text(
                                        S.of(context).confirmOrder_seatCount(data.seat?.length ?? 0),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            // 座位列表
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                              child: Row(
                                    children: data.seat == null ? [] : data.seat!.map((item) {
                                  return Container(
                                    margin: EdgeInsets.only(right: 16.w),
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.blue.shade100,
                                          Colors.blue.shade200,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.15),
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // 座位号
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Text(
                                            '${item.seatName}',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              color: Colors.blue.shade800,
                                              fontWeight: FontWeight.bold,
                                            ), 
                                          ),
                                        ),
                                        if (item.movieTicketTypeName != null) ...[
                                          SizedBox(height: 8.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Text(
                                              '${item.movieTicketTypeName}',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                      );
                                    }).toList(),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // 支付方式选择标题
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20.h, bottom: 16.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue.shade50,
                            Colors.blue.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.payment,
                              size: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            S.of(context).confirmOrder_selectPayMethod,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    ),
                    
                    // 支付方式列表
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: paymentMethodData.asMap().entries.map((entry) {
                          int index = entry.key;
                          var item = entry.value;
                          bool isLast = index == paymentMethodData.length - 1;
                          bool isSelected = defaultPay == item.id;
                          
                          return Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.shade50 : Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: index == 0 ? Radius.circular(16.r) : Radius.zero,
                                topRight: index == 0 ? Radius.circular(16.r) : Radius.zero,
                                bottomLeft: isLast ? Radius.circular(16.r) : Radius.zero,
                                bottomRight: isLast ? Radius.circular(16.r) : Radius.zero,
                              ),
                              border: isSelected 
                                ? Border.all(color: Colors.blue.shade300, width: 2)
                                : null,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                        onTap: () {
                          setState(() {
                            defaultPay = item.id;
                          });
                        },
                                borderRadius: BorderRadius.only(
                                  topLeft: index == 0 ? Radius.circular(16.r) : Radius.zero,
                                  topRight: index == 0 ? Radius.circular(16.r) : Radius.zero,
                                  bottomLeft: isLast ? Radius.circular(16.r) : Radius.zero,
                                  bottomRight: isLast ? Radius.circular(16.r) : Radius.zero,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                                  child: Row(
                                    children: [
                                      // 支付方式图标
                                      Container(
                                        width: 50.w,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: isSelected 
                                            ? Border.all(color: Colors.blue.shade300, width: 2)
                                            : null,
                                        ),
                                        child: Icon(
                                          _getPaymentIcon(item.name ?? ''),
                                          size: 28.sp,
                                          color: isSelected 
                                            ? _getPaymentIconColor(item.name ?? '')
                                            : _getPaymentIconColor(item.name ?? '').withOpacity(0.6),
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      
                                      // 支付方式名称
                                      Expanded(
                                        child: Text(
                                          item.name ?? '',
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                            color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800,
                                          ),
                                        ),
                                      ),
                                      
                                      // 选中状态指示器
                                      Container(
                                        width: 28.w,
                                        height: 28.w,
                          decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                                          border: isSelected 
                                            ? Border.all(color: Colors.blue.shade600, width: 2)
                                            : Border.all(color: Colors.grey.shade400, width: 1),
                                        ),
                                        child: isSelected 
                                          ? Icon(
                                              Icons.check,
                                              size: 20.sp,
                                              color: Colors.white,
                                            )
                                          : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  // 价格信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.of(context).confirmOrder_total,
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                Row(
                  children: [
                            Text(
                              '${data.orderTotal}',
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 42.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              S.of(context).common_unit_jpy,
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: 20.w),
                  
                  // 支付按钮
                  Container(
                    width: 200.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: payLoading ? Colors.blue.shade300 : Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.r),
                        onTap: payLoading ? null : () {
                      setState(() {
                        payLoading = true;
                      });

                      ApiRequest().request(
                        path: '/movieOrder/pay',
                        method: 'POST', 
                        data: {
                          'orderId': data.id,
                          'payId': defaultPay
                        },
                        fromJsonT: (json) {},
                      ).then((res) {
                        context.pushNamed('paySuccess', queryParameters: {
                          'orderId': '${data.id}'
                        });
                      }).whenComplete(() {
                          setState(() {
                            payLoading = false;
                          });
                        });
                    },
                        child: Center(
                          child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                              if (payLoading) ...[
                                LoadingAnimationWidget.hexagonDots(
                                  color: Colors.white,
                                  size: 24.w,
                                ),
                                SizedBox(width: 10.w),
                              ] else ...[
                                Icon(
                                  Icons.payment,
                          color: Colors.white,
                                  size: 24.sp,
                                ),
                                SizedBox(width: 10.w),
                              ],
                        Text(
                          S.of(context).confirmOrder_pay,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                ),
              ],
            ),
            ),

          )],
        ),
      ),
    );
  }
}

