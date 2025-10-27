import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_show_time_detail_response.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_showing_response.dart';
import '../../generated/l10n.dart';

class ShowTimeDetail extends StatefulWidget {
  final String? cinemaId;
  final String? movieId;

  const ShowTimeDetail({super.key, this.cinemaId, this.movieId});

  @override
  State<ShowTimeDetail> createState() => _PageState();
}

class _PageState extends State<ShowTimeDetail> with TickerProviderStateMixin {
  TabController? _tabController;
  CarouselSliderController carouselSliderController = CarouselSliderController();

  int currentMovieIndex = 0;
  List<Widget> tabWidget = [];
  CinemaMovieShowTimeDetailResponse data = CinemaMovieShowTimeDetailResponse();
  List<CinemaMovieShowingResponse> cinemaMovieShowingList = [];
  bool is24HourFormat = true; // 默认使用24小时制

  // 转换时间格式（24小时制 <-> 30小时制）
  String convertTimeFormat(String? time) {
    if (time == null || time.isEmpty) return '';
    
    try {
      final parts = time.split(':');
      if (parts.length < 2) return time;
      
      int hour = int.parse(parts[0]);
      final minute = parts[1];
      
      if (!is24HourFormat) {
        // 转换为30小时制：凌晨0-5点显示为24-29点
        if (hour >= 0 && hour <= 5) {
          hour += 24;
        }
      }
      
      return '$hour:$minute';
    } catch (e) {
      return time;
    }
  }

  // 格式化电影时长（分钟 -> 小时分钟）
  String _formatDuration(int? minutes) {
    if (minutes == null || minutes == 0) return '';
    
    if (minutes < 60) {
      return '${minutes}${S.of(context).showTimeDetail_time}';
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      
      if (remainingMinutes == 0) {
        return '${hours}小时';
      } else {
        return '${hours}小时${remainingMinutes}分钟';
      }
    }
  }

  // 获取座位状态信息
  Map<String, dynamic> _getSeatStatusInfo(TheaterHallShowTime showTime) {
    int seatStatus = showTime.seatStatus ?? 0;
    int availableSeats = showTime.availableSeats ?? 0;
    int totalSeats = showTime.totalSeats ?? 0;
    
    String statusText;
    Color statusColor;
    IconData statusIcon;
    
    switch (seatStatus) {
      case 0: // 充足
        statusText = S.of(context).showTimeDetail_seatStatus_available;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 1: // 紧张
        statusText = S.of(context).showTimeDetail_seatStatus_tight;
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber_outlined;
        break;
      case 2: // 售罄
        statusText = S.of(context).showTimeDetail_seatStatus_soldOut;
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusText = S.of(context).showTimeDetail_seatStatus_available;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
    }
    
    return {
      'text': statusText,
      'color': statusColor,
      'icon': statusIcon,
      'availableSeats': availableSeats,
      'totalSeats': totalSeats,
    };
  }

  getData(int movieId) {
    ApiRequest().request(
      path: '/app/cinema/movie/showTime',
      method: 'POST',
      data: {
        "movieId": movieId,
        "cinemaId": int.parse(widget.cinemaId!)
      },
      fromJsonT: (json) {
        return CinemaMovieShowTimeDetailResponse.fromJson(json);
      },
    ).then((res) {
          if (res.data != null) {
            if (_tabController != null) {
            _tabController!.dispose();
        }
        // _tabController.dispose();
        setState(() {
          data = res.data!;
          tabWidget = generateTab();
          // 在数据加载后初始化 TabController
          _tabController =
              TabController(length: res.data!.data!.length, vsync: this);
        });

        
      } else {
        setState(() {
          data = CinemaMovieShowTimeDetailResponse();
          tabWidget = [];
             _tabController =
            TabController(length: 0, vsync: this);
        });
      
      }
    });
  }

  getCinemaMovieShowingData() {
    ApiRequest().request<List<CinemaMovieShowingResponse>>(
      path: '/cinema/movieShowing',
      method: 'GET',
      queryParameters: {
        "id": int.parse(widget.cinemaId!)
      },
      fromJsonT: (json) {
        if (json is List) {
          return json.map((item) {
            return CinemaMovieShowingResponse.fromJson(item);
          }).toList();
        }
        return [];
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          currentMovieIndex = res.data!.indexWhere((item) => item.id == int.parse(widget.movieId!));
          cinemaMovieShowingList = res.data ?? [];
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    
    if (widget.movieId != null) {
      getData(int.parse(widget.movieId!));
    }
    
    getCinemaMovieShowingData();
    // _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {}

  List<Widget> generateTab() {
    List<String> weekList = [
      S.of(context).common_week_monday,
      S.of(context).common_week_tuesday,
      S.of(context).common_week_wednesday,
      S.of(context).common_week_thursday,
      S.of(context).common_week_friday,
      S.of(context).common_week_saturday,
      S.of(context).common_week_sunday,
    ];

    if (data.data != null) {
      return data.data!.map((item) {
        DateTime date = DateTime.parse(item.date!);
        List<String> dateParts = item.date!.split("-");
        String formattedDate = "${dateParts[1]}/${dateParts[2]}";

        return Tab(
          child: Column(
            children: [
              Text(weekList[date.weekday - 1]), // 星期
              Text(formattedDate), // 日期格式为 "月/日"
            ],
          ),
        );
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // if (tabWidget.isEmpty) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }

    List<Widget> renderCarouselSlider () {
      CinemaMovieShowingResponse movie = cinemaMovieShowingList[currentMovieIndex];

      return [
         CarouselSlider(
          carouselController: carouselSliderController,
          options: CarouselOptions(
            // height: 305.h,
            initialPage: currentMovieIndex,
            viewportFraction: 0.40,
            enlargeCenterPage: true,
            enlargeFactor: 0.20,
            onPageChanged: (index, carouselPageChangedReason)  {
              setState(() {
                currentMovieIndex = index;
              });
              // _tabController.dispose();
              getData(cinemaMovieShowingList[index].id!);
            }
          ),
          items: List.generate(cinemaMovieShowingList.length, (index) {
          final item = cinemaMovieShowingList[index];

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                   setState(() {
                    currentMovieIndex = index;
                  });
                  getData(item.id!);
                  carouselSliderController.animateToPage(index);
                },
                child: Container(
                  width: 300.w,
                  // height: 180.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8.0),
                    child: CustomExtendedImage(
                      item.poster ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              );
            },
          );
        }),
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
        child: Center(
            child: Space(
                direction: 'column',
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
              Text(cinemaMovieShowingList[currentMovieIndex].name ?? '',
                  style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.white
                  ),
                  overflow: TextOverflow.ellipsis,
              ),
              RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24.sp,
                        color: Colors.white60
                ),
                children: [
                  TextSpan(
                    text: movie.levelName ?? '',
                  ),
                  movie.time == null 
                  ? const TextSpan(text: '') 
                  : TextSpan(
                    text: '  ${_formatDuration(movie.time)}',
                  ),
                ],
              )
            )
          ],
        )),
      )
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                    title: Text(data.cinemaName ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 32.sp)),
                    floating: true,
                    snap: true,
                    pinned: false,
                    forceElevated: innerBoxIsScrolled,
                    collapsedHeight: 100.h >= 56.0 ? 700.h : 56.0,
                    // backgroundColor: Colors.blue,
                    expandedHeight: 500.h,
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white), // 自定义返回按钮图标
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                    ),
                    actions: [
                      // 时间格式切换按钮
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       is24HourFormat = !is24HourFormat;
                      //     });
                      //   },
                      //   child: Container(
                      //     margin: EdgeInsets.only(right: 16.w),
                      //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white.withOpacity(0.2),
                      //       borderRadius: BorderRadius.circular(20.r),
                      //       border: Border.all(
                      //         color: Colors.white.withOpacity(0.5),
                      //         width: 1,
                      //       ),
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Icon(
                      //           Icons.schedule,
                      //           color: Colors.white,
                      //           size: 18.sp,
                      //         ),
                      //         SizedBox(width: 4.w),
                      //         Text(
                      //           is24HourFormat ? '24h' : '30h',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 24.sp,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: cinemaMovieShowingList.isEmpty ? [] : [
                          CustomExtendedImage(
                            cinemaMovieShowingList[currentMovieIndex].poster ?? '',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 20.0, sigmaY: 20.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 850.h,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x00000000),
                                        Color(0x90000000),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 130.h,
                            left: 0,
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 地址信息
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          data.cinemaFullAddress ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 电话信息
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          Icons.phone_outlined,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        data.cinemaTel ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 50.h),
                                ...renderCarouselSlider()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(
                          60.h), // Set the height of the TabBar
                      child: Container(
                        // height: 75.h,
                        padding: EdgeInsets.only(top: 20.h),
                        // padding: EdgeInsets.symmetric(vertical: 20.h),
                        color: Colors.transparent, // Set the background color
                        child: tabWidget.isNotEmpty ? TabBar(
                          controller: _tabController,
                          tabs: tabWidget,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 0.h),
                          labelColor: Colors.white, // Selected label color
                          unselectedLabelColor:
                              Colors.white70, // Unselected label color
                          indicatorColor: Colors.white, // Indicator color
                        ) : Container(),
                      ),
                    )),
              ),
            ];
          },
          // ignore: prefer_is_empty
          body:data.data?.length == 0 ? Container() :  DefaultTabController(
              initialIndex: 0,
              length: tabWidget.length, // tab的数量.
              child: TabBarView(
                controller: _tabController,
                // ignore: prefer_is_empty
                children: (data.data ?? []).map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>(item.date!), // 使用日期作为唯一标识
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(0.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: item.data!.length,
                                (BuildContext context, int index) {
                                  TheaterHallShowTime children =
                                      item.data![index];

                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 时间和影厅信息行
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 左侧：时间信息
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 时间展示
                                                  Row(
                                                    children: [
                                                      Text(
                                                        convertTimeFormat(children.startTime),
                                                        style: TextStyle(
                                                          fontSize: 44.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: const Color(0xFF323233),
                                                          height: 1,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                        child: Container(
                                                          width: 20.w,
                                                          height: 2.h,
                                                          color: Colors.grey.shade300,
                                                        ),
                                                      ),
                                                      Text(
                                                        convertTimeFormat(children.endTime),
                                                        style: TextStyle(
                                                          fontSize: 28.sp,
                                                          color: Colors.grey.shade500,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 16.h),
                                                  // 影厅和规格信息
                                                  Wrap(
                                                    spacing: 8.w,
                                                    runSpacing: 8.h,
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    children: [
                                                      // 影厅
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFF1989FA).withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(8.r),
                                                          border: Border.all(
                                                            color: const Color(0xFF1989FA).withOpacity(0.3),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.meeting_room_rounded,
                                                              size: 18.sp,
                                                              color: const Color(0xFF1989FA),
                                                            ),
                                                            SizedBox(width: 6.w),
                                                            Text(
                                                              children.theaterHallName ?? '',
                                                              style: TextStyle(
                                                                fontSize: 24.sp,
                                                                color: const Color(0xFF1989FA),
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // 规格
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                        decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              const Color(0xFFFFD700).withOpacity(0.2),
                                                              const Color(0xFFFFA500).withOpacity(0.2),
                                                            ],
                                                          ),
                                                          borderRadius: BorderRadius.circular(8.r),
                                                          border: Border.all(
                                                            color: const Color(0xFFFFA500).withOpacity(0.5),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.high_quality_rounded,
                                                              size: 18.sp,
                                                              color: const Color(0xFFFFA500),
                                                            ),
                                                            SizedBox(width: 6.w),
                                                            Text(
                                                              children.specName ?? '',
                                                              style: TextStyle(
                                                                fontSize: 22.sp,
                                                                color: const Color(0xFFFFA500),
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // 座位状态
                                                      Builder(
                                                        builder: (context) {
                                                          final seatInfo = _getSeatStatusInfo(children);
                                                          return Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                            decoration: BoxDecoration(
                                                              color: seatInfo['color'].withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(8.r),
                                                              border: Border.all(
                                                                color: seatInfo['color'].withOpacity(0.3),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  seatInfo['icon'],
                                                                  size: 18.sp,
                                                                  color: seatInfo['color'],
                                                                ),
                                                                SizedBox(width: 6.w),
                                                                Text(
                                                                  seatInfo['text'],
                                                                  style: TextStyle(
                                                                    fontSize: 22.sp,
                                                                    color: seatInfo['color'],
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                if (seatInfo['availableSeats'] > 0 && seatInfo['totalSeats'] > 0) ...[
                                                                  SizedBox(width: 4.w),
                                                                  Text(
                                                                    '(${seatInfo['availableSeats']}/${seatInfo['totalSeats']})',
                                                                    style: TextStyle(
                                                                      fontSize: 20.sp,
                                                                      color: seatInfo['color'].withOpacity(0.7),
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // 右侧：购票按钮
                                            GestureDetector(
                                              onTap: () {
                                                context.pushNamed(
                                                  'selectSeat',
                                                  queryParameters: {
                                                    "id": '${children.id}',
                                                    "theaterHallId": '${children.theaterHallId}'
                                                  }
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [Color(0xFF1989FA), Color(0xFF0E6FD8)],
                                                  ),
                                                  borderRadius: BorderRadius.circular(25.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0xFF1989FA).withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.event_seat,
                                                      color: Colors.white,
                                                      size: 28.sp,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      S.of(context).showTimeDetail_buy,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // 特殊标签和字幕（如果有）
                                        if ((children.showTimeTags != null && children.showTimeTags!.isNotEmpty) ||
                                            (children.subtitle != null && children.subtitle!.isNotEmpty))
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.h),
                                            child: Wrap(
                                              spacing: 8.w,
                                              runSpacing: 8.h,
                                              children: [
                                                // 特殊标签
                                                if (children.showTimeTags != null)
                                                  ...children.showTimeTags!.map((tag) {
                                                    return Container(
                                                      height: 32.h,
                                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                                                        ),
                                                        borderRadius: BorderRadius.circular(6.r),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(0xFFFF6B6B).withOpacity(0.2),
                                                            blurRadius: 4,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.local_activity,
                                                            color: Colors.white,
                                                            size: 16.sp,
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            tag.name ?? '',
                                                            style: TextStyle(
                                                              fontSize: 20.sp,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                // 字幕信息
                                                if (children.subtitle != null)
                                                  ...children.subtitle!.map((sub) {
                                                    return Container(
                                                      height: 32.h,
                                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFFA500).withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(6.r),
                                                        border: Border.all(
                                                          color: const Color(0xFFFFA500),
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.subtitles_outlined,
                                                            color: const Color(0xFFFFA500),
                                                            size: 16.sp,
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            sub.name ?? '',
                                                            style: TextStyle(
                                                              fontSize: 20.sp,
                                                              color: const Color(0xFFFFA500),
                                                              fontWeight: FontWeight.w600,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ))),
    );
  }
}

