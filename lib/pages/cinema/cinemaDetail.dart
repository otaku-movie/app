import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/cinema/cinema_detail_response.dart';
import 'package:otaku_movie/response/cinema/movie_ticket_type_response.dart';
import 'package:otaku_movie/response/cinema/theater_detail_response.dart';
import 'package:otaku_movie/utils/index.dart';
import '../../generated/l10n.dart';


class CinemaDetail extends StatefulWidget {
  String? id;

  CinemaDetail({super.key, this.id});

  @override
  State<CinemaDetail> createState() => _PageState();
}

class _PageState extends State<CinemaDetail> with SingleTickerProviderStateMixin {
  bool loading = false;
  bool error = false;
  int currentPage = 1;

  CinemaDetailResponse data = CinemaDetailResponse();
  List<TheaterDetailResponse> theaterList = [];
  List<MovieTicketTypeResponse> movieTicketTypeList = [];

  void getData({page = 1}) {
    setState(() {
      loading = true;
    });
    ApiRequest().request(
      path: '/cinema/detail',
      method: 'GET',
      queryParameters: {
        "id": widget.id
      },
      fromJsonT: (json) {
        return CinemaDetailResponse.fromJson(json as Map<String, dynamic>);
      },
    ).then((res) async {
      setState(() {
        data = res.data;
      });
    }).catchError((err) {
      setState(() {
        error = true;
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  void getTheaterData() {
    ApiRequest().request(
      path: '/theater/hall/list',
      method: 'POST',
      data: {
        "cinemaId": widget.id
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<TheaterDetailResponse>.fromJson(
          json,
          (data) => TheaterDetailResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) async {
      setState(() {
        theaterList = res.data.list;
      });
    });
  }

  getMovieTicketType() {
    ApiRequest().request(
      path: '/cinema/ticketType/list',
      method: 'POST',
      data: {"cinemaId": int.parse(widget.id!)},
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
          movieTicketTypeList = res.data!;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();  // 获取其他数据
    getTheaterData();
    getMovieTicketType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  CustomAppBar(
        title: data.name ?? '',
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
      ),
      body: AppErrorWidget(
        loading: loading,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Space(
                direction: 'column',
                bottom: 10.h,
                children: [
                  GestureDetector(
                    onTap: () async {
                        double latitude = 31.2304; // 示例: 上海经度
                        double longitude = 121.4737;
                        await callMap(latitude, longitude);
                      },
                    child: Space(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(data.address ?? ''),
                        ),
                        const Icon(Icons.location_on, color: Colors.red)
                      ],
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: () async {
                        double latitude = 31.2304; // 示例: 上海经度
                        double longitude = 121.4737;
                        await callMap(latitude, longitude);
                      },
                    child: Space(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('${S.of(context).cinemaDetail_tel}：${data.tel}'),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await callTel('+81-080-1234-5678');
                          },
                          child: const Icon(Icons.call, color: Colors.blue),
                        ),
                      ]
                    ),
                  ),
                  Space(
                    children: [
                      Text('${S.of(context).cinemaDetail_homepage}：'),
                      GestureDetector(
                        onTap: () {
                          launchURL(data.homePage ?? '');
                        },
                        child:  Text(data.homePage ?? '', style: const TextStyle(
                          color: Color.fromARGB(255, 5, 32, 239)
                        )),
                      ),
                    ]
                  ),
                  Space(
                    children: [
                      Text('${S.of(context).cinemaDetail_maxSelectSeat}：'),
                      Text('${data.maxSelectSeatCount}'),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child:  Text(S.of(context).cinemaDetail_specialSpecPrice, style: TextStyle(
                      fontSize: 36.sp
                    )),
                  ),
                  Space(
                    direction: 'column',
                    children: data.spec == null ? [] : data.spec!.map((item) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)
                        )
                      ),
                      child: Space(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name ?? ''),
                          Text('+${item.plusPrice}円', style: const TextStyle(color: Colors.red))
                      ]),
                    );
                  }).toList()),
                  Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child:  Text(S.of(context).cinemaDetail_ticketTypePrice, style: TextStyle(
                      fontSize: 36.sp
                    )),
                  ),
                  Space(
                    direction: 'column',
                    children: movieTicketTypeList.map((item) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)
                        )
                      ),
                      child: Space(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.name ?? ''),
                          Text('${item.price}円', style: const TextStyle(color: Colors.red))
                      ]),
                    );
                  }).toList()),
                  Padding(
                    padding: EdgeInsets.only(top: 50.h),
                    child:  Text(S.of(context).cinemaDetail_theaterSpec, style: TextStyle(
                      fontSize: 36.sp
                    )),
                  ),
                  Space(
                    direction: 'column',
                    children: theaterList.map((item) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)
                        )
                      ),
                      child: Space(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.name ?? ''}（${item.cinemaSpecName}）'),
                          Text(S.of(context).cinemaDetail_seatCount(item.seatCount ?? 0))
                      ]),
                    );
                  }).toList())
                ]
              )],
            )
          ),
        ),
      )
    );
  }
}
