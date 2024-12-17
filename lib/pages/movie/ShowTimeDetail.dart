import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_show_time_detail_response.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_showing_response.dart';
import 'package:otaku_movie/response/response.dart';
import '../../generated/l10n.dart';

import '../../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';

class ShowTimeDetail extends StatefulWidget {
  final String? cinemaId;
  final String? movieId;

  const ShowTimeDetail({super.key, this.cinemaId, this.movieId});

  @override
  State<ShowTimeDetail> createState() => _PageState();
}

class _PageState extends State<ShowTimeDetail> with TickerProviderStateMixin {
  late TabController _tabController;
  CarouselSliderController carouselSliderController = CarouselSliderController();

  int currentMovieIndex = 0;
  List<Widget> tabWidget = [];
  CinemaMovieShowTimeDetailResponse data = CinemaMovieShowTimeDetailResponse();
  List<CinemaMovieShowingResponse> cinemaMovieShowingList = [];

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
        setState(() {
          data = res.data!;
          tabWidget = generateTab();
        });

        // 在数据加载后初始化 TabController
        _tabController =
            TabController(length: res.data!.data!.length, vsync: this);
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
    _tabController.dispose();
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
    if (tabWidget.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                  // width: 240.w,
                  // height: 180.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8.0),
                    child: ExtendedImage.network(
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
                    text: '  ${movie.time ?? ''}${S.of(context).showTimeDetail_time}',
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
      backgroundColor: Colors.white,
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
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: cinemaMovieShowingList.isEmpty ? [] : [
                          ExtendedImage.network(
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    '${S.of(context).showTimeDetail_address}：${data.cinemaAddress ?? ''}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    '${S.of(context).cinemaDetail_tel}：${data.cinemaTel}',
                                    style: const TextStyle(color: Colors.white),
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
                        child: TabBar(
                          controller: _tabController,
                          tabs: tabWidget,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 0.h),
                          labelColor: Colors.white, // Selected label color
                          unselectedLabelColor:
                              Colors.white70, // Unselected label color
                          indicatorColor: Colors.white, // Indicator color
                        ),
                      ),
                    )),
              ),
            ];
          },
          body: DefaultTabController(
              initialIndex: 0,
              length: tabWidget.length, // tab的数量.
              child: TabBarView(
                controller: _tabController,
                children: data.data!.map((item) {
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
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: Color(0XFFe6e6e6),
                                        ),
                                      ),
                                    ),
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      direction: Axis.vertical,
                                      spacing: 15.w,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                            '${children.startTime} ~ ${children.endTime}',
                                              style: TextStyle(fontSize: 28.sp)),
                                          ]
                                        ),
                                        
                                        // Wrap(
                                        //   spacing: 20.w,
                                        //   children: ['舞台挨拶', '日本語字幕'].map((item) {
                                        //     return Container(
                                        //       padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 20.w),
                                        //       decoration: BoxDecoration(
                                        //         border: Border.all(color: Colors.grey.shade400),
                                        //         borderRadius: BorderRadius.circular(6),
                                        //       ),
                                        //       child: Text(item, style: TextStyle(fontSize: 24.sp)),
                                        //     );
                                        //   }).toList(),
                                        // ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              30,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Text(children
                                                          .theaterHallName ??
                                                      '')),
                                              MaterialButton(
                                                // height: 50.h,
                                                // padding: EdgeInsets.symmetric(horizontal: 5.w),
                                                color: const Color.fromARGB(
                                                    255, 5, 136, 243), // 按钮颜色
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50)), // 按钮圆角
                                                ),
                                                elevation: 0,
                                                onPressed: () {
                                                  context.pushNamed(
                                                      'selectSeat',
                                                      queryParameters: {
                                                        "id": '${children.id}',
                                                        "theaterHallId":
                                                            '${children.theaterHallId}'
                                                      });
                                                },
                                                child: Row(
                                                  mainAxisSize: MainAxisSize
                                                      .min, // 让按钮根据内容自适应宽度
                                                  children: [
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .showTimeDetail_buy,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 32.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
