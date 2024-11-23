import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_list.dart';
import 'package:otaku_movie/response/response.dart';
import '../components/Input.dart';
import '../generated/l10n.dart';
import '../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';
import 'package:go_router/go_router.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _PageState();
}

class _PageState extends State<MovieList> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  int _gridCount = 20;
  int _listCount = 0;

  List<MovieListResponse> data = [];
  

  void getData() {
    ApiRequest().request(
      path: '/app/movie/list',
      method: 'GET',
      queryParameters: {
        "page": 1,
        "pageSize": 10
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieListResponse>.fromJson(json, (data) {
          return MovieListResponse.fromJson(data as Map<String, dynamic>);  // 解析每个元素
        });
        
      },
    ).then((res) {
      setState(() {
        data = res.data?.list ?? [];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    getData();
    // await Future.delayed(const Duration(seconds: 2), () {
    //   if (mounted) {
    //     setState(() {
    //       if (_tabController.index == 0) {
    //         _listCount = 20;
    //       } else {
    //         _gridCount = 20;
    //       }
    //     });
    //   }
    // });
  }

  Future<void> _onLoad() async {
    // await Future.delayed(const Duration(seconds: 2), () {
    //   if (mounted) {
    //     setState(() {
    //       if (_tabController.index == 0) {
    //         _listCount += 10;
    //       } else {
    //         _gridCount += 10;
    //       }
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final LanguageController languageController = Get.find();

    final tabs = <Widget>[
      Text(S.of(context).movieList_tabBar_currentlyShowing,
          style: TextStyle(color: Colors.white, fontSize: 32.sp)),
      Text(S.of(context).movieList_tabBar_comingSoon,
          style: TextStyle(color: Colors.white, fontSize: 32.sp)),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     getData();
        //   },
        //   child: const Icon(Icons.refresh),
        // ),
        appBar: AppBar(
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              context.goNamed('search');
            },
            child:  Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 244, 243, 243)),
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('搜索全部电影', style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.grey.shade500
                  ),),
                  Icon(Icons.search_outlined,
                  color: Colors.grey.shade500)
                ],
              ),
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
            indicatorColor: Colors.blue,
            labelPadding: EdgeInsets.only(bottom: 15.h),
          ),
          backgroundColor: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: EasyRefresh.builder(
          header: const ClassicHeader(),
          footer: const ClassicFooter(),
          onRefresh: _onRefresh,
          onLoad: _onLoad,
          childBuilder: (context, physics) {
            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  EasyRefresh(
                    header: const ClassicHeader(),
                    footer: const ClassicFooter(),
                    onRefresh: _onRefresh,
                    onLoad: _onLoad,
                    child: data.isNotEmpty ? ListView.builder(
                      physics: physics,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        // Replace this with your actual list item widget
                        MovieListResponse item = data[index];

                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.0, // 边框D宽度
                                  color: Color(0XFFe6e6e6)),
                            ),
                          ),
                          child: Space(
                            direction: "row",
                            right: 20.w,
                            children: [
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.goNamed('movieDetail');
                                    },
                                    child:  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      height: 280.h,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: ExtendedImage.network(
                                          '${item.cover}',
                                            width: 240.w,
                                            fit: BoxFit.cover,
                                            printError: false,
                                            loadStateChanged: (ExtendedImageState state) {
                                              switch (state.extendedImageLoadState) {
                                                case LoadState.failed:
                                                  return Container(); // 你也可以返回其他占位内容
                                                case LoadState.loading:
                                                  // TODO: Handle this case.
                                                case LoadState.completed:
                                                  // TODO: Handle this case.
                                              }
                                              return null;
                                            },
                                          ),
                                        )
                                      )
                                      
                                  ),
                                 
                                  // Positioned(
                                  //   top: 0,
                                  //   left: 0,
                                  //   child: Container(
                                  //     width: 140.w,
                                      
                                  //     child:MaterialButton(
                                  //       color: Theme.of(context).primaryColor,
                                  //       shape: const RoundedRectangleBorder(
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(5))),
                                  //       onPressed: () {
                                  //         getData();
                                  //         // GoRouter.of(context).push('/register');
                                  //       },
                                  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  //       child: Text("PG13", style: TextStyle(fontSize: 24.sp, color: Colors.white),),
                                  //     ) ,
                                  //   )
                                  // ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: ExtendedImage.asset('assets/image/audio-guide.png', width: 80.w)
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: ExtendedImage.asset('assets/image/sub-guide.png', width: 80.w)
                                  )
                                ],
                              ),
                            
                              SizedBox(
                                  height: 285.h,
                                  child: Space(
                                    direction: "column",
                                    bottom: 10.h,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    // crossAxisAlignment: CrossAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 450.w,
                                        child: Space(
                                            direction: "column",
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  context.goNamed('movieDetail');
                                                },
                                                child: Text("${item.name}", style: TextStyle(fontSize: 36.sp))
                                              ),
                                              
                                              Text("监督：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
                                              Text("声优：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp,  color: Colors.black38)),
                                              Text('映倫：${item.levelName}', style: TextStyle(fontSize: 24.sp,  color: Colors.black38)),
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Wrap(
                                                  spacing: 6,
                                                  children: item.spec != null ? item.spec!.map((spec) {
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
                                                      child: Text('${spec.name}'),
                                                    );
                                                  }).toList() : [],
                                                ),
                                              )
                                              
                                            ]
                                        ),
                                      ),
                                      Space(
                                        direction: "row",
                                        right: 15,
                                        children: [
                                          MaterialButton(
                                            color: const Color.fromARGB(255, 6, 158, 240), // 按钮颜色
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(4)), // 按钮圆角
                                            ),
                                            onPressed: () {
                                              getData();
                                              // GoRouter.of(context).push('/register');
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min, // 让按钮根据内容自适应宽度
                                              children: [
                                                // const Icon(Icons.favorite, color: Colors.white, size: 24), // 添加的图标
                                                // const SizedBox(width: 8), // 图标和文字之间的间距
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
                                      //   MaterialButton(
                                      //   color: Theme.of(context).primaryColor,
                                      //   shape: const RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(5))),
                                      //   onPressed: () {
                                      //     // getData();
                                      //     context.go('/movie/ShowTimeList');
                                      //   },
                                      //   child: Text(
                                      //       S.of(context).movieList_button_buy,
                                      //       style: TextStyle(
                                      //           color: Colors.white,
                                      //           fontSize: 32.sp)),
                                      // )
                                      ])
                                    ],
                                  ),
                                )
                            ],
                          )
                        );
                      },
                    ) : const Center(child: CircularProgressIndicator()),
                  ),
                  EasyRefresh(
                    header: const ClassicHeader(),
                    footer: const ClassicFooter(),
                    onRefresh: _onRefresh,
                    onLoad: _onLoad,
                    child: GridView.builder(
                      physics: physics,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4 / 7, // 可以调整宽高比
                      ),
                      itemCount: _gridCount, // 显示的电影数量
                      itemBuilder: (context, index) {
                        // 获取电影上映日期，这里假设有一个releaseDate字段
                        // String releaseDate = list[index].releaseDate ?? '日期待定';
                        
                        // // 如果没有上映日期，归为“日期待定”组
                        // if (releaseDate == '日期待定') {
                        //   releaseDate = '日期待定';
                        // }

                        // // 获取电影名称和其他信息
                        String movieName =  '电影名称';
                        // String director = list[index].director ?? '未知导演';

                        return GestureDetector(
                          onTap: () {
                            // 跳转到电影详情页面
                            context.goNamed('movieDetail');
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 显示电影封面图
                                ExtendedImage.asset(
                                  'assets/image/raligun.webp', // 替换为实际电影封面路径
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  // height: 120.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    movieName, // 电影名称
                                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    '上映日期: 2024-11-05', // 显示上映日期或“日期待定”
                                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        )
        
      ),
    );
  }
}
