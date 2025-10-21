import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/cinema/movie_ticket_type_response.dart';
import 'package:otaku_movie/response/movie/user_select_seat_data_response.dart';
import 'package:otaku_movie/utils/toast.dart';

import '../../api/index.dart';
import '../../utils/index.dart';

class SelectMovieTicketType extends StatefulWidget {
  final String? movieShowTimeId;
  final String? cinemaId;

  const SelectMovieTicketType({
    super.key,
    this.movieShowTimeId,
    this.cinemaId
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectMovieTicketPageState createState() => _SelectMovieTicketPageState();
}

class _SelectMovieTicketPageState extends State<SelectMovieTicketType> {
  List<MovieTicketTypeResponse> movieTicketTypeData = [];
  UserSelectSeatDataResponse data = UserSelectSeatDataResponse();

  getMovieTicketType() {
    ApiRequest().request(
      path: '/cinema/ticketType/list',
      method: 'POST',
      data: {"cinemaId": int.parse(widget.cinemaId!)},
      fromJsonT: (json) {
        if (json is List) {
          return json.map((item) {
            return MovieTicketTypeResponse.fromJson(item);
          }).toList();
        }
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          movieTicketTypeData = res.data!;
        });
      }
    });
  }

  getData() {
    ApiRequest().request(
      path: '/movie_show_time/user_select_seat',
      method: 'GET', 
      queryParameters: {"movieShowTimeId": int.parse(widget.movieShowTimeId!)},
      fromJsonT: (json) {
        return UserSelectSeatDataResponse.fromJson(json);
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          data = res.data!;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.cinemaId != null) {
      getData();
      getMovieTicketType();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
         title: Text(S.of(context).movieTicketType_title, style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 电影信息卡片 - 重新设计
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
                                // 电影标题
                                    Text(
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
                                          data.specName ?? '',
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
                    SizedBox(height: 40.h),
                    
                    // 票种选择标题 - 优化设计
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.blue.shade100,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.confirmation_number,
                              color: Colors.blue.shade600,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                  S.of(context).movieTicketType_selectMovieTicketType,
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                    Text(
                                  S.of(context).movieTicketType_selectTicketTypeForSeats,
                                  style: TextStyle(
                                    fontSize: 18.sp,
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
                    
                    SizedBox(height: 30.h),
                    
                    // 座位信息列表 - 优化设计
                    ...data.seat == null ? [] : data.seat!.map((item) {
                       return Container(
                        width: double.infinity,
                         margin: EdgeInsets.only(bottom: 24.h),
                        decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(20.r),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.05),
                               blurRadius: 8,
                               offset: const Offset(0, 2),
                             ),
                           ],
                         ),
                         child: Padding(
                           padding: EdgeInsets.all(24.w),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                               // 座位信息头部
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                   // 座位号标签
                                   Container(
                                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                     decoration: BoxDecoration(
                                       color: Colors.blue.shade50,
                                       borderRadius: BorderRadius.circular(24.r),
                                       border: Border.all(color: Colors.blue.shade200),
                                     ),
                                     child: Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         Icon(
                                           Icons.event_seat,
                                           size: 18.sp,
                                           color: Colors.green.shade600,
                                         ),
                                         SizedBox(width: 6.w),
                                         Text(
                                           '${S.of(context).movieTicketType_seatNumber}：${item.seatName}',
                                           style: TextStyle(
                                             fontSize: 20.sp,
                                             fontWeight: FontWeight.w600,
                                             color: Colors.blue.shade700,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   // 区域价格标签
                                   if (item.areaName != null)
                                     Container(
                                       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                         color: Colors.orange.shade50,
                                         borderRadius: BorderRadius.circular(20.r),
                                         border: Border.all(color: Colors.orange.shade200),
                                       ),
                                       child: Text(
                                         '${item.areaName}（+${item.plusPrice}${S.of(context).common_unit_jpy}）',
                                         style: TextStyle(
                                           fontSize: 18.sp,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.orange.shade700,
                                         ),
                                       ),
                                     ),
                                 ],
                               ),
                               
                               SizedBox(height: 16.h),
                               
                               // 票种选择按钮
                               GestureDetector(
                               onTap: () {
                                _showActionSheet(context, item);
                              },
                              child: Container(
                                   width: double.infinity,
                                   padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                                decoration: BoxDecoration(
                                     color: item.movieTicketTypeId == null 
                                         ? Colors.grey.shade100
                                         : Colors.blue.shade500,
                                     borderRadius: BorderRadius.circular(16.r),
                                     border: Border.all(
                                       color: item.movieTicketTypeId == null 
                                           ? Colors.grey.shade300 
                                           : Colors.blue.shade400,
                                       width: 2,
                                     ),
                                     boxShadow: [
                                       BoxShadow(
                                         color: item.movieTicketTypeId == null 
                                             ? Colors.grey.withOpacity(0.1)
                                             : Colors.blue.withOpacity(0.2),
                                         blurRadius: 8,
                                         offset: const Offset(0, 2),
                                       ),
                                     ],
                                   ),
                                   child: item.movieTicketTypeId == null 
                                       ? Row(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           children: [
                                             Icon(
                                               Icons.add_circle_outline,
                                               size: 24.sp,
                                               color: Colors.grey.shade600,
                                             ),
                                             SizedBox(width: 12.w),
                                             Text(
                                               S.of(context).movieTicketType_selectMovieTicketType,
                                               style: TextStyle(
                                                 fontSize: 22.sp,
                                                 fontWeight: FontWeight.w600,
                                                 color: Colors.grey.shade700,
                                               ),
                                             ),
                                           ],
                                         )
                                       : getTicketType(item),
                                 ),
                               ),
                             ],
                        ),
                      ),
                    );
                    }).toList(),
                    
                  ],
                ),
              ),
            ),
          ),
          // 底部操作栏 - 优化设计
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
                          S.of(context).movieTicketType_total,
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
                              '${getTotalPrice()}',
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
                  
                  // 确认按钮
                  Container(
                    width: 200.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade500,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.r),
                        onTap: () {
                          bool every = data.seat!.every((item) => item.movieTicketTypeId != null);

                      if (every) {
                         ApiRequest().request(
                          path: '/movieOrder/create',
                          method: 'POST', 
                          data: {
                            "movieShowTimeId": int.parse(widget.movieShowTimeId!),
                            "seat": data.seat
                          },
                          fromJsonT: (json) {
                            return json;
                          },
                        ).then((res) {
                          // ignore: use_build_context_synchronously
                          context.pushNamed('confirmOrder', queryParameters: {
                            'id': '${res.data?['id']}'
                          });
                        });
                      } else {
                        ToastService.showWarning(S.of(context).movieTicketType_selectMovieTicketType);
                      }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                      S.of(context).movieTicketType_confirmOrder,
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
          ),
        ],
      ),
      ),
    );
  }

  int getTotalPrice () {
    if (data.seat == null) return 0;
    return data.seat!.fold(0, (prev, current) {
      if (current.movieTicketTypeId != null) {
        try {
        MovieTicketTypeResponse ticketType = movieTicketTypeData.firstWhere((el) => el.id == current.movieTicketTypeId);
        return prev + (ticketType.price ?? 0) + (current.plusPrice ?? 0);
        } catch (e) {
          // 如果没有找到匹配的票种，返回原价格
          return prev + (current.plusPrice ?? 0);
        }
      }

      return prev;
    });
  }

  Widget getTicketType (item) {
    try {
    MovieTicketTypeResponse data = movieTicketTypeData.firstWhere((el) => el.id == item.movieTicketTypeId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.confirmation_number,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              data.name ?? '',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            '${data.price}${S.of(context).common_unit_jpy}',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
    } catch (e) {
      // 如果没有找到匹配的票种，返回默认显示
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.help_outline,
                  size: 20.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '未知票种',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '0${S.of(context).common_unit_jpy}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
    }
  }
  void _showActionSheet(BuildContext context, Seat seat) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示器
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              
              // 标题
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number,
                      size: 24.sp,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      S.of(context).movieTicketType_selectMovieTicketType,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // 票种列表
              ...movieTicketTypeData.map((el) {
                bool isSelected = el.id == seat.movieTicketTypeId;
                
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.blue.shade50
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
              onTap: () {
                seat.movieTicketTypeId = el.id;
                int index = data.seat!.indexWhere((item) => item.seatName == seat.seatName);
                
                if (index != -1 && data.seat != null && index < data.seat!.length) {
                setState(() {
                    data.seat![index].movieTicketTypeId = el.id;
                });
                }
                
                Navigator.pop(context);
              },
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          children: [
                            // 票种图标
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.blue.shade100
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.r),
                                border: isSelected 
                                    ? Border.all(color: Colors.blue.shade200, width: 1)
                                    : null,
                              ),
                              child: Icon(
                                Icons.confirmation_number,
                                size: 24.sp,
                                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                              ),
                            ),
                            
                            SizedBox(width: 20.w),
                            
                            // 票种信息
                            Expanded(
                              child: Text(
                                el.name ?? '',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                                ),
                              ),
                            ),
                            
                            // 价格
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? Colors.blue.shade100
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20.r),
                                border: isSelected 
                                    ? Border.all(color: Colors.blue.shade200, width: 1)
                                    : Border.all(color: Colors.blue.shade200, width: 1),
                              ),
                              child: Text(
                                '${el.price}${S.of(context).common_unit_jpy}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.blue.shade700 : Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }
  
}
