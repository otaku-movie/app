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
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/utils/seat_cancel_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (countDown <= 0) {
        _timer?.cancel();  // 取消计时器
        
        // 倒计时结束，自动取消订单并返回到选座页面
        await _cancelOrderAndReturn();
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

  // 取消订单并返回到选座页面
  Future<void> _cancelOrderAndReturn() async {
    try {
      // 调用取消订单接口
      await ApiRequest().request(
        path: '/api/movieOrder/cancel',
        method: 'POST',
        data: {
          'orderId': int.parse(widget.id!),
        },
        fromJsonT: (json) => json,
      );
      
      // 获取座位选择信息用于跳转
      final seatData = SeatCancelManager.getCurrentSeatSelection();
      
      // 清除座位选择信息
      SeatCancelManager.clearSeatSelection();
      
      if (!mounted) return;
      
      // 显示提示
      ToastService.showWarning(S.of(context).confirmOrder_orderCanceled);
      
      // 跳转回座位选择页面
      if (seatData != null && 
          seatData['movieShowTimeId'] != null && 
          seatData['theaterHallId'] != null) {
        context.pushReplacementNamed(
          'selectSeat',
          queryParameters: {
            'id': seatData['movieShowTimeId'].toString(),
            'theaterHallId': seatData['theaterHallId'].toString(),
          }
        );
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.showError(S.of(context).confirmOrder_cancelOrderFailed);
    }
  }

  // 根据支付方式名称获取图标
  Widget _getPaymentIcon(String paymentName) {
    switch (paymentName) {
      case '支付宝':
        return SvgPicture.asset(
          'assets/icons/pay/zhifubaozhifu.svg',
          width: 28.w,
          height: 28.w,
        );
      case '微信':
        return SvgPicture.asset(
          'assets/icons/pay/zhifu-weixinzhifu.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'PayPay':
        return SvgPicture.asset(
          'assets/icons/pay/paypay.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'クレジットカード':
        return Icon(
          Icons.credit_card,
          size: 28.sp,
          color: Colors.purple.shade600,
        );
      case 'Visa':
        return SvgPicture.asset(
          'assets/icons/pay/visa.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'MasterCard':
        return SvgPicture.asset(
          'assets/icons/pay/master-card.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'JCB':
        return SvgPicture.asset(
          'assets/icons/pay/jcb.svg',
          width: 28.w,
          height: 28.w,
        );
      case '银联':
        return SvgPicture.asset(
          'assets/icons/pay/yinlian.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'LINE Pay':
        return Icon(
          Icons.chat,
          size: 28.sp,
          color: Colors.green.shade500,
        );
      case '楽天Pay':
        return Icon(
          Icons.shopping_bag,
          size: 28.sp,
          color: Colors.red.shade600,
        );
      case 'd払い':
        return Icon(
          Icons.phone_android,
          size: 28.sp,
          color: Colors.blue.shade500,
        );
      case 'au PAY':
        return SvgPicture.asset(
          'assets/icons/pay/auPay.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'メルペイ':
        return Icon(
          Icons.account_balance,
          size: 28.sp,
          color: Colors.amber.shade600,
        );
      case 'Suica':
        return Icon(
          Icons.train,
          size: 28.sp,
          color: Colors.blue.shade700,
        );
      case 'PASMO':
        return SvgPicture.asset(
          'assets/icons/pay/logo-pasmo.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'Apple Pay':
      case 'apple-pay':
        return SvgPicture.asset(
          'assets/icons/pay/apple-pay.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'PayPal':
      case 'paypal':
        return SvgPicture.asset(
          'assets/icons/pay/paypal.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'Amazon Pay':
      case 'amazon-pay':
        return SvgPicture.asset(
          'assets/icons/pay/amazon pay.svg',
          width: 28.w,
          height: 28.w,
        );
      case 'nanaco':
        return Icon(
          Icons.card_giftcard,
          size: 28.sp,
          color: Colors.pink.shade500,
        );
      case 'WAON':
        return Icon(
          Icons.card_giftcard,
          size: 28.sp,
          color: Colors.orange.shade400,
        );
      default:
        return Icon(
          Icons.payment,
          size: 28.sp,
          color: Colors.grey.shade600,
        );
    }
  }


  // 检查是否为信用卡支付方式
  bool _isCreditCardPayment(String paymentName) {
    String name = paymentName.toLowerCase();
    return name.contains('信用卡') || 
           name.contains('クレジット') || 
           name.contains('credit') ||
           name.contains('card');
  }

  // 获取信用卡品牌标识
  Widget _getCreditCardBrand(String paymentName) {
    // 检查是否为信用卡支付方式
    if (!_isCreditCardPayment(paymentName)) {
      return SizedBox.shrink();
    }

    // 如果是信用卡，显示所有品牌标识
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Visa标识
        Container(
          width: 60.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Center(
            child: Container(
              width: 50.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: ClipRect(
                child: SvgPicture.asset(
                  'assets/icons/pay/visa.svg',
                  width: 50.w,
                  height: 28.h,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        
        // MasterCard标识
        Container(
          width: 60.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Center(
            child: Container(
              width: 50.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: ClipRect(
                child: SvgPicture.asset(
                  'assets/icons/pay/master-card.svg',
                  width: 50.w,
                  height: 28.h,
                  // fit: BoxFit.,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        
        // JCB标识
        Container(
          width: 60.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Center(
            child: Container(
              width: 50.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: ClipRect(
                child: SvgPicture.asset(
                  'assets/icons/pay/jcb.svg',
                  width: 50.w,
                  height: 28.h,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        
        // 银联标识
        Container(
          width: 60.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Center(
            child: ClipRect(
              child: SvgPicture.asset(
                'assets/icons/pay/yinlian.svg',
                width: 40.w,
                height: 22.h,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(S.of(context).confirmOrder_title, style: const TextStyle(color: Colors.white)),
        onBackButtonPressed: () async {
          // 显示确认对话框
          final shouldCancel = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  S.of(context).confirmOrder_cancelOrder,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  S.of(context).confirmOrder_cancelOrderConfirm,
                  style: const TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      S.of(context).confirmOrder_continuePay,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      S.of(context).confirmOrder_confirmCancel,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          );

          if (shouldCancel == true) {
            // 用户确认取消，调用取消订单接口
            try {
              await ApiRequest().request(
                path: '/movieOrder/cancel',
                method: 'POST',
                data: {
                  'orderId': int.parse(widget.id!),
                },
                fromJsonT: (json) => json,
              );
              
              // 获取座位选择信息用于跳转
              final seatData = SeatCancelManager.getCurrentSeatSelection();
              
              // 清除座位选择信息
              SeatCancelManager.clearSeatSelection();
              
              ToastService.showSuccess(S.of(context).confirmOrder_orderCanceled);
              
              if (mounted) {
                // 跳转回座位选择页面
                if (seatData != null && 
                    seatData['movieShowTimeId'] != null && 
                    seatData['theaterHallId'] != null) {
                  context.pushReplacementNamed(
                    'selectSeat',
                    queryParameters: {
                      'id': seatData['movieShowTimeId'].toString(),
                      'theaterHallId': seatData['theaterHallId'].toString(),
                    }
                  );
                } else {
                  Navigator.of(context).pop();
                }
              }
            } catch (e) {
              ToastService.showError(S.of(context).confirmOrder_cancelOrderFailed);
            }
          }
        },
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
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: index == 0 ? Radius.circular(16.r) : Radius.zero,
                                topRight: index == 0 ? Radius.circular(16.r) : Radius.zero,
                                bottomLeft: isLast ? Radius.circular(16.r) : Radius.zero,
                                bottomRight: isLast ? Radius.circular(16.r) : Radius.zero,
                              ),
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
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                        child: _getPaymentIcon(item.name ?? ''),
                                      ),
                                      SizedBox(width: 16.w),
                                      
                                      // 支付方式名称和信用卡品牌标识
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                            Text(
                                              item.name ?? '',
                                              style: TextStyle(
                                                fontSize: 22.sp,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            _getCreditCardBrand(item.name ?? ''),
                                          ],
                                        ),
                                      ),
                                      
                                      // 选中状态指示器
                                      Container(
                                        width: 32.w,
                                        height: 32.w,
                          decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
                                        ),
                                        child: isSelected 
                                          ? Icon(
                                              Icons.check,
                                              size: 22.sp,
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
                        onTap: payLoading ? null : () async {
                      // 检查选择的支付方式
                      final selectedPayment = paymentMethodData.firstWhere(
                        (payment) => payment.id == defaultPay,
                        orElse: () => PaymentMethodResponse(),
                      );
                      
                      // 如果是信用卡支付，跳转到选择信用卡页面
                      if (selectedPayment.name == 'クレジットカード') {
                        // 跳转到选择信用卡页面
                        await context.pushNamed(
                          'selectCreditCard',
                          queryParameters: {
                            'orderId': '${data.id}',
                          },
                        );
                        return;
                      }
                      
                      // 其他支付方式，直接调用支付接口
                      setState(() {
                        payLoading = true;
                      });

                      try {
                        await ApiRequest().request<dynamic>(
                          path: '/movieOrder/pay',
                          method: 'POST', 
                          data: {
                            'orderId': data.id,
                            'payId': defaultPay
                          },
                          fromJsonT: (json) => json,
                        );
                        
                        if (mounted) {
                          setState(() {
                            payLoading = false;
                          });
                          
                          context.pushNamed('paySuccess', queryParameters: {
                            'orderId': '${data.id}'
                          });
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            payLoading = false;
                          });
                          ToastService.showError('支付失败，请重试');
                        }
                      }
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

