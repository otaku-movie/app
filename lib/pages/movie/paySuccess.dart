import 'dart:async';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

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
    ApiRequest().request(
      path: '/movieOrder/generatorQRcode',
      method: 'GET', 
      queryParameters: {
        "id": int.parse(widget.orderId!)
      },
      fromJsonT: (json) {},
      responseType: ResponseType.bytes
    ).then((res) {
      setState(() {
        QRcodeBytes = Uint8List.fromList(res);
      });
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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
         title: Text(S.of(context).payResult_title, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10.h,
                  children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 200.sp),
                      Text('${data.orderTotal}円', style: TextStyle(fontSize: 40.sp)),
                  ],
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 50.h, bottom: 50.h),
                child: Text(S.of(context).payResult_success, style: TextStyle(fontSize: 36.sp)),
              ),
              Space(
                direction: 'column',
                bottom: 30.h,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Space(
                      direction: 'column',
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('cinemaDetail', queryParameters: {
                                    'id': '${data.cinemaId}'
                                  });
                                },
                                child:  Text(
                                  "${data.cinemaName}（${data.theaterHallName}）",
                                  style: TextStyle(fontSize: 28.sp),
                                ),
                              ),
                              Space(
                                right: 4.w,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await callTel('+81-080-1234-5678');
                                    },
                                    child: const Icon(Icons.call, color: Colors.blue),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      double latitude = 31.2304; // 示例: 上海经度
                                      double longitude = 121.4737; // 示例: 上海纬度

                                      await callMap(latitude, longitude);
                                    },
                                    child: const Icon(Icons.location_on, color: Colors.red),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                            //  decoration: BoxDecoration(
                            //   border: Border.all()
                            // ),
                            child: Space(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed('movieDetail', pathParameters: {
                                    'id': '${data.movieId}'
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 20.w),
                                  color: Colors.grey.shade200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: ExtendedImage.network(
                                      data.moviePoster ?? '',
                                      width: 200.w,
                                      height: 230.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              
                              Expanded(
                                child: SizedBox(
                                  width: 415.w,
                                  height: 230.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.movieName ?? '',
                                            style: TextStyle(
                                              fontSize: 34.sp
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 12.h),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 26.sp,
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
                                    
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text('${data.orderTotal}円', style: TextStyle(color: Colors.red, fontSize: 40.sp)),
                                         
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Space(
                        direction: 'column',
                        bottom: 5.h,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.h, top: 0.h),
                            child:  Text(S.of(context).orderDetail_seatMessage, style: TextStyle(
                              // color: Colors.grey.shade700,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold
                            ))
                          ),
                          ...data.seat == null ? [] : data.seat!.map((item) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.seatName}'),
                                Text(item.movieTicketTypeName ?? '', style: TextStyle(color: Colors.grey.shade600))
                              ],
                            );
                          }),
                        ]),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child:  Center(
                        child: Wrap(
                          direction: Axis.vertical,
                          // alignment: WrapAlignment.center,
                          // spacing: 10.h,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: 350.w,
                              child: QRcodeBytes == null ? null : Image.memory(QRcodeBytes!)
                            ),
                            Text(S.of(context).orderDetail_ticketCount(data.seat == null ? 0 :  data.seat!.length), style: TextStyle(fontSize: 32.sp)),
                            Container(
                              width: 600.w,
                              height: 80.h,
                              // padding: Edge,
                              margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade300)
                              ),
                              child: Center(child: Text('${S.of(context).payResult_ticketCode}：1234567890', style: TextStyle(fontSize: 40.sp))) 
                            ),
                          ],
                        )
                      ),
                    ),
                      ]
                    )
            ],
          ),
        ),
      )
    );
  }
}
