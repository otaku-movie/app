import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
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

  List<MovieListResponse> list = [];
  

  void getData() {
    // ApiRequest().request<ApiResponse<ApiPaginationResponse<MovieListResponse>>>(
    //   path: '/movie/list',
    //   method: 'POST',
    //   data: {
    //     'page': 1,
    //     'pageSize': 20,
    //   },
    //   // fromJsonT: (json) {
    //   //   return ApiResponse<ApiPaginationResponse<MovieListResponse>>.fromJson(
    //   //     json,
    //   //     (dataJson) => ApiPaginationResponse<MovieListResponse>.fromJson(
    //   //       dataJson as Map<String, dynamic>,
    //   //       (itemJson) => MovieListResponse.fromJson(itemJson as Map<String, dynamic>),
    //   //     ),
    //   //   );
    //   // },
    // ).then((res) {
    //   print(res);
    // }).catchError((error) {
    //   // 处理错误
    //   print('发生错误: $error');
    // });
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
    await Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (_tabController.index == 0) {
            _listCount = 20;
          } else {
            _gridCount = 20;
          }
        });
      }
    });
  }

  Future<void> _onLoad() async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (_tabController.index == 0) {
            _listCount += 10;
          } else {
            _gridCount += 10;
          }
        });
      }
    });
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getData();
          },
          child: const Icon(Icons.refresh),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Input(
            placeholder: S.of(context).movieList_search_placeholder,
            placeholderStyle: const TextStyle(color: Colors.black26),
            textStyle: const TextStyle(color: Colors.white),
            height: ScreenUtil().setHeight(60),
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
            borderRadius: BorderRadius.circular(15),
            suffixIcon: const Icon(Icons.search_outlined,
                color: Color.fromRGBO(255, 255, 255, 0.6)),
            cursorColor: Colors.white,
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
        body: EasyRefresh.builder(
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
                    child: ListView.builder(
                      physics: physics,
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        // Replace this with your actual list item widget
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
                                    child:  SizedBox(
                                    child: ExtendedImage.asset(
                                        'assets/image/raligun.webp',
                                        width: 240.w
                                        ),
                                    ),
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
                                                child: Text("电影名称", style: TextStyle(fontSize: 36.sp))
                                              ),
                                              
                                              Text("监督：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
                                              Text("声优：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp,  color: Colors.black38)),
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Wrap(
                                                  spacing: 6,
                                                  children: ['IMAX', '4DX', '3D', 'DOLBY CINEMA'].map((item) {
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
                                                      child: Text(item),
                                                    );
                                                  }).toList(),
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
                                            color: const Color.fromARGB(255, 240, 6, 127), // 按钮颜色
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(5)), // 按钮圆角
                                            ),
                                            onPressed: () {
                                              getData();
                                              // GoRouter.of(context).push('/register');
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min, // 让按钮根据内容自适应宽度
                                              children: [
                                                const Icon(Icons.favorite, color: Colors.white, size: 24), // 添加的图标
                                                const SizedBox(width: 8), // 图标和文字之间的间距
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
                                        MaterialButton(
                                        color: Theme.of(context).primaryColor,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        onPressed: () {
                                          // getData();
                                          context.go('/movie/ShowTimeList');
                                        },
                                        child: Text(
                                            S.of(context).movieList_button_buy,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 32.sp)),
                                      )
                                      ])
                                    ],
                                  ),
                                )
                            ],
                          )
                        );
                      },
                    ),
                  ),
                  EasyRefresh(
                    header: const ClassicHeader(),
                    footer: const ClassicFooter(),
                    onRefresh: _onRefresh,
                    onLoad: _onLoad,
                    child: GridView.builder(
                      physics: physics,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        // childAspectRatio: 6 / 7,
                      ),
                      itemCount: _gridCount,
                      itemBuilder: (context, index) {
                        // Replace this with your actual grid item widget
                        return Card(
                            child: Center(child: Text('Grid Item $index')));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
