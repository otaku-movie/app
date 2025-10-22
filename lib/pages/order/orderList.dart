import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/enum/index.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/order/order_detail_response.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
                context.pushNamed('orderDetail', queryParameters: {
                  'id': '${item.id}'
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
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
                    // 订单号和状态
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 28.sp,
                              color: const Color(0xFF969799),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${S.of(context).orderList_orderNumber}：${item.id ?? ''}',
                              style: TextStyle(
                                fontSize: 26.sp,
                                color: const Color(0xFF969799),
                              ),
                            ),
                          ],
                        ),
                        _buildOrderStateTag(item.orderState)
                      ],
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
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
                        Container(
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
                              item.moviePoster ?? '',
                              width: 200.w,
                              height: 240.h,
                              fit: BoxFit.cover,
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
                                      item.movieName ?? '',
                                      style: TextStyle(
                                        fontSize: 32.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF323233),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 12.h),
                                    
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
                                            size: 20.sp,
                                            color: const Color(0xFF969799),
                                          ),
                                          SizedBox(width: 4.w),
                                          Flexible(
                                            child: Text(
                                              '${item.date ?? ''} ${item.startTime}',
                                              style: TextStyle(
                                                fontSize: 22.sp,
                                                color: const Color(0xFF646566),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    SizedBox(height: 8.h),
                                    
                                    // 影院信息
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 20.sp,
                                          color: const Color(0xFF969799),
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: Text(
                                            item.cinemaName ?? '',
                                            style: TextStyle(
                                              fontSize: 22.sp,
                                              color: const Color(0xFF646566),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    // 座位信息
                                    if (item.seat != null && item.seat!.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Wrap(
                                          spacing: 6.w,
                                          runSpacing: 6.h,
                                          children: item.seat!.take(3).map((seat) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1989FA).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6.r),
                                              ),
                                              child: Text(
                                                seat.seatName ?? '',
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: const Color(0xFF1989FA),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                                
                                // 价格和操作按钮
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // 价格
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${item.orderTotal}',
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
                                    
                                    // 评论按钮
                                    if (item.orderState == OrderState.succeed)
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
            );
          },
        ),
      ),
      ),
    );
  }
}
