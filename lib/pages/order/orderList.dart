import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<OrderList> {
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
         title: Text(S.of(context).orderList_title, style: const TextStyle(color: Colors.white)),
      ),
      
      body: AppErrorWidget(
        loading:  loading,
        child: EasyRefresh(
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        // onRefresh: _onRefresh,
        // onLoad: _onLoad,
        child: ListView.builder(
          // physics: physics,
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            OrderDetailResponse item = data[index];

            return GestureDetector(
              onTap: () {
                context.pushNamed('orderDetail');
              },
              child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${S.of(context).orderList_orderNumber}：${item.id ?? ''}', style: TextStyle(fontSize: 28.sp)),
                        Dict(
                          name: 'orderState',
                          code: item.orderState,
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 20.w),
                        color: Colors.grey.shade200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ExtendedImage.network(
                            item.moviePoster ?? '',
                            width: 220.w,
                            height: 260.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 265.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.movieName ?? '',
                                        style: TextStyle(
                                          fontSize: 36.sp,
                                        ),
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
                                          text: item.date ?? '',
                                        ),
                                        // 星期几部分
                                        TextSpan(
                                          text: '（${getDay(item.date ?? '', context)}）',
                                        ),
                                        // 时间段部分
                                        TextSpan(
                                          text: ' ${item.startTime} ~ ${item.endTime} ${item.theaterHallSpecName}',
                                        )],
                                      )
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "${item.cinemaName}（${item.theaterHallName}）",
                                      style: TextStyle(fontSize: 24.sp, color: Colors.grey.shade600),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Wrap(
                                        spacing: 6,
                                        children: item.seat == null ? [] : item.seat!.map((item) {
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
                                    ),
                    
                                  ],
                                ),
                                 
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text('${item.orderTotal}円', style: TextStyle(color: Colors.red, fontSize: 40.sp)),
                                      // Text('円', style: TextStyle(color: Colors.red, fontSize: 32.sp))
                                    ],
                                  ),
                                  SizedBox(width: 16.w),
                                  // ignore: unrelated_type_equality_checks
                                  item.orderState == OrderState.succeed ? SizedBox(
                                    width: 120.w,
                                    height: 50.h,                  
                                    child: MaterialButton(
                                      // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      color: const Color.fromARGB(255, 2, 162, 255),
                                      textColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                      ),
                                      onPressed: () {
                                        // context.pushNamed('commentDetail');
                                      },
                                      child: Text(
                                        S.of(context).orderList_comment,
                                        style: TextStyle(color: Colors.white, fontSize: 28.sp),
                                      ),
                                    ),
                                  ) : const SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
            );
          },
        ),
      ),
      ),
    );
  }
}
