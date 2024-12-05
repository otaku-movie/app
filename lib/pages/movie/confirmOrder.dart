import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/response/order/payment_method_response.dart';
import 'package:otaku_movie/utils/index.dart';

class ConfirmOrder extends StatefulWidget {
  final String? id;

  const ConfirmOrder({super.key, this.id = "29207"});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<ConfirmOrder> {
  OrderDetailResponse data = OrderDetailResponse();
  List<PaymentMethodResponse> paymentMethodData = [];
  bool loading = false;

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
  Timer? _timer;


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
  getPaymentMethodData() {
    setState(() {
      loading = true;
    });
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
      if (res.data != null) {
        setState(() {
          paymentMethodData = res.data as List<PaymentMethodResponse>;
        });
      }
     
    });
  }

  @override
  void initState() {
    super.initState();
    getPaymentMethodData();
    getData();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown <= 0) {
        _timer?.cancel();  // 取消计时器
      }
      
      setState(() {
        countDown--;
      });

    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
        child:  Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.w),
                          color: Colors.grey.shade200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ExtendedImage.network(
                              data.moviePoster ?? '',
                              width: 220.w,
                              height: 260.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 285.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.movieName ?? '',
                                          style: TextStyle(
                                            fontSize: 36.sp,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, size: 36.sp, color: Colors.red),
                                            Text(
                                              formatNumberToTime(countDown),
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                color: Colors.red
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 8.h),
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 28.sp,
                                          color: Colors.black54
                                        ),
                                        children: [
                                          // 日期部分
                                          TextSpan(
                                            text: data.date ?? '',
                                          ),
                                          // 星期几部分
                                          TextSpan(
                                            text: '（${getDay(data.date ?? '', context)}）',
                                          ),
                                          // 时间段部分
                                          TextSpan(
                                            text: ' ${data.startTime} ~ ${data.endTime} ${data.theaterHallSpecName}',
                                          ),
                                        ],
                                      )
                                    )
                                  ],
                                ),
                                 SizedBox(height: 4.h),
                                Text(
                                  "${data.cinemaName}（${data.theaterHallName}）",
                                  style: TextStyle(fontSize: 24.sp, color: Colors.grey.shade600),
                                ),
                                
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    spacing: 6,
                                    children: data.seat == null ? [] : data.seat!.map((item) {
                                      return ElevatedButton(
                                        style: ButtonStyle(
                                          minimumSize: WidgetStateProperty.all(Size(0, 50.h)),
                                          textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20.sp)),
                                          side: WidgetStateProperty.all(const BorderSide(width: 2, color: Color(0xffffffff))),
                                          padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0)),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0), // 调整圆角大小
                                            ), 
                                          ),
                                        ),
                                        
                                        onPressed: () {},
                                        child: Text('${item.seatName}（${item.movieTicketTypeName}）'),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                      child: Text(S.of(context).confirmOrder_selectPayMethod, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    
                    ...paymentMethodData.map((item) {
                      return  Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200)
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.name ?? ''),
                            // SvgPicture.asset(item['path'], height: 28),
                            const Icon(Icons.radio_button_checked, color: Colors.blue)
                          ],
                        ) 
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100, width: 1)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${S.of(context).confirmOrder_total}：', style: TextStyle(fontSize: 28.sp)),
                    Text('${data.orderTotal}円', style: TextStyle(color: Colors.red, fontSize: 48.sp)),
                    // Text('円', style: TextStyle(color: Colors.red, fontSize: 32.sp))
                  ],
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 250.w,
                  height: 70.h,                 
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 2, 162, 255),
                    textColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    onPressed: () {
                      context.go('/movie/order/success');
                    },
                    child: Text(
                      S.of(context).confirmOrder_pay,
                      style: TextStyle(color: Colors.white, fontSize: 32.sp),
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
      )
    );
  }
}
