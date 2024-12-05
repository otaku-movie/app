import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/space.dart';
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          color: Colors.grey.shade200,
                          margin: EdgeInsets.only(right: 20.w),
                          // clipBehavior: Clip.hardEdge,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ExtendedImage.network(
                              data.moviePoster ?? '',
                              width: 240.w,
                              height: 285.h,
                              fit: BoxFit.cover,

                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 285.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.movieName ?? '',
                                      style: TextStyle(
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.bold
                                      ),
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
                                            text: ' ${data.startTime} ~ ${data.endTime} ${data.specName}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data.cinemaName}',
                                      style: TextStyle(fontSize: 28.sp),
                                    ),
                                    Text(
                                      '${data.theaterHallName}',
                                      style: TextStyle(fontSize: 26.sp, color: Colors.black45),
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    ...data.seat == null ? [] : data.seat!.map((item) {
                      return ClipRRect(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical:  25.w, horizontal: 20.w),
                        margin: EdgeInsets.only(bottom: 30.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          runSpacing: 10,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${S.of(context).movieTicketType_seatNumber}：${item.seatName}'),
                                item.areaName == null ? const Text('') : Text('${item.areaName ?? ''}（${item.plusPrice ?? ''}）'),
                              ],
                            ),
                            item.movieTicketTypeId == null ? GestureDetector(
                               onTap: () {
                                _showActionSheet(context, item);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Text(S.of(context).movieTicketType_selectMovieTicketType)),
                              ) : GestureDetector(
                               onTap: () {
                                _showActionSheet(context, item);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: getTicketType(item)
                              ),
                            )
                          ]
                        ),
                      ),
                    );
                    }).toList(),
                    
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 120.h,
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
                    Text('${S.of(context).movieTicketType_total}：', style: TextStyle(fontSize: 28.sp)),
                    Text('${getTotalPrice()}円', style: TextStyle(color: Colors.red, fontSize: 48.sp)),
                    // Text('円', style: TextStyle(color: Colors.red, fontSize: 32.sp))
                  ],
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  width: 280.w,
                  height: 120.h,                  
                  child: MaterialButton(
                    color: const Color.fromARGB(255, 2, 162, 255),
                    textColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    onPressed: () {
                      bool every =  data.seat!.every((item) => item.movieTicketTypeId != null);

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
                    child: Text(
                      S.of(context).movieTicketType_confirmOrder,
                      style: TextStyle(color: Colors.white, fontSize: 32.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int getTotalPrice () {
    if (data.seat == null) return 0;
    return data.seat!.fold(0, (prev, current) {
      if (current.movieTicketTypeId != null) {
        MovieTicketTypeResponse ticketType = movieTicketTypeData.firstWhere((el) => el.id == current.movieTicketTypeId);

        return prev + (ticketType.price ?? 0) + (current.plusPrice ?? 0);
      }

      return prev;
    });
  }

  Widget getTicketType (item) {
    MovieTicketTypeResponse data = movieTicketTypeData.firstWhere((el) => el.id == item.movieTicketTypeId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(data.name ?? ''), 
        Text('${data.price}円', style: const TextStyle(color: Colors.red),)
      ]);
  }
  void _showActionSheet(BuildContext context, Seat seat) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: movieTicketTypeData.map((el) {
            Color activeColor = el.id == seat.movieTicketTypeId ? Colors.red : Colors.black;
              
            return ListTile(
              title: Text(el.name ?? '', style: TextStyle(
                color: activeColor
              ),),
              trailing: Text('${el.price}円', style: TextStyle(fontSize: 32.sp,  color: activeColor)),
              onTap: () {
                seat.movieTicketTypeId = el.id;
                int index = data.seat!.indexWhere((item) => item.movieTicketTypeId == el.id);
                
                setState(() {
                  data.seat?[index].movieTicketTypeId = el.id;
                });
                
                Navigator.pop(context);
              },
            );
          }).toList()
        );
      },
    );
  }
  
}
