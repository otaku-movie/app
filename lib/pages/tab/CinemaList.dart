import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_list.dart';
import 'package:otaku_movie/response/response.dart';
import '../../components/Input.dart';
import '../../generated/l10n.dart';
import '../../controller/LanguageController.dart';
import 'package:get/get.dart'; // Ensure this import is present
import 'package:extended_image/extended_image.dart';

class CinemaList extends StatefulWidget {
  const CinemaList({super.key});

  @override
  State<CinemaList> createState() => _PageState();
}

class _PageState extends State<CinemaList> with SingleTickerProviderStateMixin {
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

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     getData();
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
      appBar: AppBar(
        centerTitle: true,

        title: Row(
          // spacing: 20.w,
          // direction: Axis.horizontal,
          // crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('东京都', style: TextStyle(fontSize: 32.sp)),
            SizedBox(width: 20.w),
            Expanded(
              child: Input(
              placeholder: S.of(context).movieList_placeholder,
              placeholderStyle: const TextStyle(color: Colors.black26),
              textStyle: const TextStyle(color: Colors.white),
              height: ScreenUtil().setHeight(60),
              backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
              borderRadius: BorderRadius.circular(28),
              suffixIcon: const Icon(Icons.search_outlined,
                  color: Color.fromRGBO(255, 255, 255, 0.6)),
              cursorColor: Colors.white,
             ),
            )
          ],
        ),
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 44.sp),
      ),
      body: EasyRefresh.builder(
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        childBuilder: (context, physics) {
          return ListView(
            physics: physics,
            children: List.generate(20, (index) {
              return Container(
                width: double.infinity,
                 padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0, // 边框D宽度
                      color: Color(0XFFe6e6e6)),
                ),
                ),
                child:  Wrap(
                  runSpacing: 4.h,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 4.w,
                          children: [
                            Text('東宝シネマズ　新宿', style: TextStyle(fontSize: 36.sp)),
                            const Icon(Icons.star, color: Color(0xFFebb21b)),
                          ],
                        ),
                        Text('3.7km', style: TextStyle(color: Colors.grey.shade600))
                      ],
                    ),
                    Text('東京都新宿区歌舞伎町 1-19-1　新宿東宝ビル３階',style: TextStyle(color: Colors.grey.shade400)),
                    Wrap(
                      spacing: 6,
                      children: ['IMAX', '4DX', '3D', 'DOLBY CINEMA'].map((item) {
                        return ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(Size(0.w, 50.h)),
                            textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20.sp)),
                            side: WidgetStateProperty.all(const BorderSide(width: 2, color: Color(0xffffffff))),
                            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // 调整圆角大小
                              ), 
                            ),
                          ),
                          onPressed: () {},
                          child: Text(item),
                        );
                      }).toList()
                    ),
              
                    Container(height: 10.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                      spacing: 20.w,
                      children: List.generate(3, (index) {
                        return SizedBox(
                          width: 224.w,
                          child: Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                              children:  [
                                SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0), // 设置圆角大小
                                    child: ExtendedImage.asset(
                                      'assets/image/raligun.webp',
                                      // width: 224.w,
                                    ),
                                  ),
                                ),
                                Text('某科学的超电磁炮234efd', style: TextStyle(color: Colors.grey.shade400, overflow: TextOverflow.ellipsis))
                              ],
                            ),
                          );
                        })                        
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        },
      )
    );
  }
}
