import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/HelloMovie.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import '../../controller/LanguageController.dart';

class ComingSoon extends StatefulWidget {

  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _PageState();
}

class _PageState extends State<ComingSoon> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  EasyRefreshController easyRefreshController = EasyRefreshController();

  @override
  bool get wantKeepAlive => true; // 保持页面的状态
  bool loading = false;
  bool error = false;
  bool loadFinished  = false;
  Map<String, List<MovieResponse>> data = {};
  
  List<MovieResponse> movie = [];
  int currentPage = 1;

  void getData({int page = 1}) {
    ApiRequest().request(
      path: '/app/movie/comingSoon',
      method: 'GET',
      queryParameters: {
        "page": page,
        "pageSize": 20,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieResponse>.fromJson(
          json,
          (data) => MovieResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      if (res.data?.list != null) {
        List<MovieResponse> list = res.data!.list!;

         setState(() {
          if (list.isNotEmpty && !loadFinished) {
            movie.addAll(list); // 追加数据
          }
          if (page == 1) {
            movie = list;
          }
          currentPage = page;
          loadFinished = list.isEmpty; // 更新加载完成标志
        });
      }

      Map<String, List<MovieResponse>> groupMovie = dataToGroupBy(movie);

      setState(() {
        movie = movie;
        data = groupMovie;
      });
    }).whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  dataToGroupBy (List<MovieResponse> list) {
    Map<String, List<MovieResponse>> result = {};

    for (var item in list) {
      String key = item.startDate ?? S.of(context).movieList_comingSoon_noDate;

      result.putIfAbsent(key, () => []);
      result[key]?.add(item);
    }

    return result;
  }

   @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    getData();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    return EasyRefresh(
      header: customHeader(context),
      footer: customFooter(context),
       onRefresh: () {
        getData();
      },
      onLoad: () {
        getData(page: currentPage + 1);
      },
      child: AppErrorWidget(
        loading: loading,
        error: error,
              child: CustomScrollView(
                    slivers: data.keys.toList().map((section) {
            return SliverStickyHeader(
              header: Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Text(
                  section,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 28.sp),
                ),
              ),
              sliver: SliverPadding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h), // Add padding around the SliverGrid
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of items per row
                    crossAxisSpacing: 25.w, // Horizontal space between items
                    mainAxisSpacing: 0.h, // Vertical space between items
                    childAspectRatio: 0.58, // Adjust the aspect ratio of each item (width/height)
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = data[section]?[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed('movieDetail', pathParameters: {
                            "id": '${item?.id}'
                          });
                        },
                        child: Space(
                          direction: 'column',
                          bottom: 5.h,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 260.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CustomExtendedImage(
                                      item?.cover ?? '',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Positioned(
                                //   bottom: 0,
                                //   left: 0,
                                //   child: HelloMovie(
                                //     guideData: item?.helloMovie,
                                //     type: HelloMovieGuide.audio,
                                //     width: 80.w,
                                //   ),
                                // ),
                                // Positioned(
                                //   bottom: 0,
                                //   right: 0,
                                //   child: HelloMovie(
                                //     guideData: item?.helloMovie,
                                //     type: HelloMovieGuide.sub,
                                //     width: 80.w,
                                //   ),
                                // ),
                              ],
                            ),
                            Text(
                              item?.name ?? '', 
                              style: TextStyle(fontSize: 28.sp, color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: data[section]?.length ?? 0,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      )
    );
  }
}
