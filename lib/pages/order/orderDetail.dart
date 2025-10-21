import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

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
    ApiRequest().request(
      path: '/movieOrder/generatorQRcode',
      method: 'GET', 
      queryParameters: {
        "id": int.parse(widget.id!)
      },
      fromJsonT: (json) {},
      responseType: ResponseType.bytes
    ).then((res) {
      setState(() {
        QRcodeBytes = Uint8List.fromList(res as List<int>);
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
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(
         title: Text(S.of(context).orderDetail_title, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.w),
          margin: EdgeInsets.only(top: 10.h, bottom: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: 50.h),
              //   alignment: Alignment.center,
              //   child: Text('距离开始放映时间还有：4天05小时10分5秒', style: TextStyle(fontSize: 32.sp, color: Colors.red)),
              // ),
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
                                child: CustomExtendedImage(
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
                                              text: ' ${data.startTime} ~ ${data.endTime} ${data.specName}',
                                            ),
                                          ],
                                        )
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${data.orderTotal}${S.of(context).common_unit_jpy}', style: TextStyle(color: Colors.red, fontSize: 40.sp)),
                                      data.orderState == OrderState.succeed ? SizedBox(
                                        width: 120.w,
                                        height: 50.h,                  
                                        child: MaterialButton(
                                          // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                          color: const Color.fromARGB(255, 2, 162, 255),
                                          textColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                          ),
                                          elevation: 0,
                                          onPressed: () {
                                            // context.pushNamed('commentDetail');
                                          },
                                          child: Text(
                                            S.of(context).orderList_comment,
                                            style: TextStyle(color: Colors.white, fontSize: 28.sp),
                                          ),
                                        ),
                                      ) : Container()
                                    ],
                                  ),
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
                  padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
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
                        Container(
                          width: 350.w,
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.red)
                          // ),
                          // margin: EdgeInsets.only(top: 20.h),
                          child: QRcodeBytes == null ? null : Image.memory(QRcodeBytes!)
                          // child: PrettyQrView.data(
                          //   data: 'https://www.bilibili.com',
                          //   decoration: const PrettyQrDecoration(
                          //     shape: PrettyQrSmoothSymbol(
                          //       roundFactor: 0
                          //     ),
                          //     // image: PrettyQrDecorationImage(
                          //     //   image: AssetImage('image/audio-guide.png'),
                          //     // ),
                          //   ),
                          // )
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
                          child: Center(child: Text('${S.of(context).orderDetail_ticketCode}：1234567890', style: TextStyle(fontSize: 40.sp))) 
                        ),
                      ],
                    )
                  ),
                ),
             
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
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
                      child:  Text(S.of(context).orderDetail_orderMessage, style: TextStyle(
                        // color: Colors.grey.shade700,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold
                      ))
                    ),
                    Row(
                      children: [
                        Text('${S.of(context).orderDetail_orderNumber}：', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
                        Text('${data.id}', style: TextStyle(fontSize: 28.sp)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${S.of(context).orderDetail_orderState}：', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
                        Dict(
                          name: 'orderState',
                          code: data.orderState,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text('${S.of(context).orderDetail_orderCreateTime}：', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
                        Text('${data.orderTime}', style: TextStyle(fontSize: 28.sp)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${S.of(context).orderDetail_payTime}：', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
                        Text(data.payTime ?? '', style: TextStyle(fontSize: 28.sp)),
                      ],
                    ),
                    Row(
                      children: [
                        Text('${S.of(context).orderDetail_payMethod}：', style: TextStyle(fontSize: 28.sp, color: Colors.grey.shade600)),
                        Text(data.payMethod ?? '', style: TextStyle(fontSize: 28.sp)),
                      ],
                    )
                  ],
                ),
              ),
              
              
                ],
              )
              
            ],
            
          ),
        ),
      )
    );
  }
}
