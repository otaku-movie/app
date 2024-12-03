import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_show_time_detail_response.dart';
import '../../generated/l10n.dart';

import '../../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';

class ShowTimeDetail extends StatefulWidget {
  final String? id;

  const ShowTimeDetail({super.key,required this.id});

  @override
  State<ShowTimeDetail> createState() => _PageState();
}

class _PageState extends State<ShowTimeDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> tabWidget = [];
  CinemaMovieShowTimeDetailResponse data =  CinemaMovieShowTimeDetailResponse();


  getData() {
    ApiRequest().request(
      path: '/app/cinema/movie/showTime',
      method: 'POST',
      data: {"movieId": int.parse(widget.id!)},
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
        _tabController = TabController(length: res.data!.data!.length, vsync: this);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: Colors.white), // 自定义返回按钮图标
        //     onPressed: () {
        //       // 使用 Navigator.pop(context) 返回上一级页面
        //       context.pop();
        //     },
        //   ),
        //    backgroundColor: Colors.blue,
        //   title: const Text('加载中...', style: TextStyle(color: Colors.white)),
        // ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      initialIndex: 0,
      length: tabWidget.length, // tab的数量.
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  title: Text(data.cinemaName ?? '', style: TextStyle(color: Colors.white, fontSize: 32.sp)),
                  floating: true,
                  snap: true,
                  pinned: true,
                  forceElevated: innerBoxIsScrolled,
                  collapsedHeight: 100.h >= 56.0 ? 100.h : 56.0,
                  backgroundColor: Colors.blue,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white), // 自定义返回按钮图标
                    onPressed: () {
                      // 使用 Navigator.pop(context) 返回上一级页面
                      context.pop();
                    },
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    tabs:  tabWidget,
                    isScrollable: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.h),
                    labelColor: Colors.white, // 设置选中标签的颜色
                    unselectedLabelColor: Colors.white70, // 设置未选中标签的颜色
                    indicatorColor: Colors.blue, // 设置选中时的指示器颜色
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: data.data!.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(item.date!), // 使用日期作为唯一标识
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(0.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: item.data!.length,
                            (BuildContext context, int index) {
                              TheaterHallShowTime children = item.data![index];
                              
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
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  direction: Axis.vertical,
                                  spacing: 15.w,
                                  children: [
                                    Text('${children.startTime} ~ ${children.endTime}', style: TextStyle(fontSize: 28.sp)),
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
                                      width: MediaQuery.of(context).size.width - 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(children.theaterHallName ?? '')),
                                          MaterialButton(
                                            color: const Color.fromARGB(255, 5, 136, 243), // 按钮颜色
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(50)), // 按钮圆角
                                            ),
                                            onPressed: () {
                                              context.goNamed('selectSeat', queryParameters: {
                                                "id": '${children.id}',
                                                "theaterHallId": '${children.theaterHallId}'
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min, // 让按钮根据内容自适应宽度
                                              children: [
                                                Text(
                                                  S.of(context).movieList_button_buy,
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
          )

        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //     appBar: CustomAppBar(title:  Text("東宝シネマズ　新宿", style: TextStyle(fontSize: 33.sp, color: Colors.white))),
    //     // body: 
    //     body: SingleChildScrollView(
    //       child: Container(
    //         padding: const EdgeInsets.all(10),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // const Row(
    //             //   children: [Text('東京都新宿区歌舞伎町 1-19-1　新宿東宝ビル３階')],
    //             // ),
    //             // const Text('联系方式：080-1111-1111'),
    //             // const Text('联系方式：080-1111-1111'),
    //             Center(
    //                 child: Column(
    //               children: [
    //                 Container(
    //                   // height: 200, // 设置固定高度
    //                   // decoration: BoxDecoration(
    //                   //   borderRadius: BorderRadius.circular(18)
    //                   // ),
    //                   padding: EdgeInsets.symmetric(vertical: 20.h),
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(8.0), // 设置圆角大小
    //                     child: ExtendedImage.asset(
    //                       'assets/image/raligun.webp',
    //                       width: 244.w,
    //                     ),
    //                   ),
    //                 ),
    //                 Text('某科学的超电磁炮', style: TextStyle(fontSize: 44.sp)),
    //                 Text('G 120分 | 山本泰一郎 | 御坂美琴、御坂美琴、御坂美琴',
    //                     style: TextStyle(
    //                         fontSize: 24.sp, color: Colors.grey.shade600))
    //               ],
    //             )),
    //             const SizedBox(height: 20), // 增加间距
    //             ...List.generate(5, (index) {
    //               return Container(
    //                 width: double.infinity,
    //                 padding: const EdgeInsets.all(10),
    //                 decoration: const BoxDecoration(
    //                   border: Border(
    //                     top: BorderSide(
    //                       width: 1.0,
    //                       color: Color(0XFFe6e6e6),
    //                     ),
    //                   ),
    //                 ),
    //                 child: Wrap(
    //                   crossAxisAlignment: WrapCrossAlignment.start,
    //                   direction: Axis.vertical,
    //                   spacing: 15.w,
    //                   children: [
    //                     Text('20:00 ~ 22:00',
    //                         style: TextStyle(fontSize: 28.sp)),
    //                     Wrap(
    //                         spacing: 20.w,
    //                         children: ['舞台挨拶', '日本語字幕'].map((item) {
    //                           return Container(
    //                             padding: EdgeInsets.symmetric(
    //                                 vertical: 8.w, horizontal: 20.w),
    //                             decoration: BoxDecoration(
    //                                 border:
    //                                     Border.all(color: Colors.grey.shade400),
    //                                 borderRadius: BorderRadius.circular(6)),
    //                             child: Text(item,
    //                                 style: TextStyle(fontSize: 24.sp)),
    //                           );
    //                         }).toList()),
    //                     SizedBox(
    //                         width: MediaQuery.of(context).size.width - 30,
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             const Expanded(
    //                               child: Text('スクリーン8'),
    //                             ),
    //                             MaterialButton(
    //                               color: const Color.fromARGB(
    //                                   255, 5, 136, 243), // 按钮颜色
    //                               shape: const RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.all(
    //                                     Radius.circular(50)), // 按钮圆角
    //                               ),
    //                               onPressed: () {
    //                                 context.go("/movie/selectSeat");
    //                               },
    //                               child: Row(
    //                                 mainAxisSize:
    //                                     MainAxisSize.min, // 让按钮根据内容自适应宽度
    //                                 children: [
    //                                   // const Icon(Icons.favorite, color: Colors.white, size: 24), // 添加的图标
    //                                   // const SizedBox(width: 8), // 图标和文字之间的间距
    //                                   Text(
    //                                     S.of(context).movieList_button_buy,
    //                                     style: TextStyle(
    //                                       color: Colors.white,
    //                                       fontSize: 32.sp,
    //                                     ),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ),
    //                           ],
    //                         ))
    //                   ],
    //                 ),
    //               );
    //             })
    //           ],
    //         ),
    //       ),
    //     ));
  }
}
