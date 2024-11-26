import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import '../../controller/LanguageController.dart';

class ComingSoon extends StatefulWidget {
  final ScrollPhysics? physics;

  const ComingSoon({super.key, this.physics});

  @override
  State<ComingSoon> createState() => _PageState();
}

class _PageState extends State<ComingSoon> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true; // 保持页面的状态
  bool loading = false;
  bool error = false;
  Map<String, List<MovieResponse>> data = {};
  
  List<MovieResponse> movie = [];
  int currentPage = 1;

  void getData({bool refresh = true}) {
    setState(() {
      loading = true;
    });
    ApiRequest().request(
      path: '/app/movie/comingSoon',
      method: 'GET',
      queryParameters: {
        "page": refresh ? 1 : currentPage + 1,
        "pageSize": 20,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieResponse>.fromJson(
          json,
          (data) => MovieResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      if (refresh) {
          movie = res.data?.list ?? [];
          currentPage = 1;
        } else {
          movie.addAll(res.data?.list ?? []);
          currentPage++;
        }

      Map<String, List<MovieResponse>> groupMovie = dataToGroupBy(movie);

      setState(() {
        movie = movie;
        data = groupMovie;
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

  dataToGroupBy (List<MovieResponse> list) {
    Map<String, List<MovieResponse>> result = {};

    for (var item in list) {
      String key = item.startDate ?? 'NO_DATE';

      result.putIfAbsent(key, () => []);
      result[key]?.add(item);
    }

    return result;
  }

   @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _onRefresh() async {
    getData();

  }

  Future<void> _onLoad() async {

  }

  Widget _buildMovieDetails(MovieResponse item) {
    return SizedBox(
      width: 450.w,
      child: Space(
        direction: "column",
        children: [
          GestureDetector(
            onTap: () {
              context.goNamed('movieDetail');
            },
            child: Text(item.name ?? '', style: TextStyle(fontSize: 36.sp)),
          ),
          Text("监督：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          Text("声优：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          Text('映倫：${item.startDate}', style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
        ],
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    return MaterialButton(
      color: const Color(0xFF069EF0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      onPressed: () {
        context.goNamed('movieDetail');
      },
      child: Text(
        '购买票',
        style: TextStyle(color: Colors.white, fontSize: 32.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 
    
    final LanguageController languageController = Get.find();

    return EasyRefresh(
      header: const ClassicHeader(),
      footer: const ClassicFooter(),
      onRefresh: _onRefresh,
      onLoad: _onLoad,
      child: 
        loading ? const Center(child: Text('loading...')) : 
        error ? const Center(child: Text('error')) :
        CustomScrollView(
          physics: widget.physics,
          slivers: data.keys.toList().map((section) {
            return SliverStickyHeader(
              header: Container(
                height: 60.h,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: Text(
                  section,
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 28.sp),
                ),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = data[section]?[index];
                    print(item);

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color: Color(0xFFE6E6E6)),
                        ),
                      ),
                      child: Space(
                        direction: "row",
                        right: 20.w,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.goNamed('movieDetail');
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: 280.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: ExtendedImage.network(
                                      item?.cover ?? '',
                                      width: 240.w,
                                      fit: BoxFit.cover,
                                      loadStateChanged: (state) {
                                        if (state.extendedImageLoadState == LoadState.loading) {
                                          return const Center(child: CircularProgressIndicator());
                                        } else if (state.extendedImageLoadState == LoadState.failed) {
                                          return const Icon(Icons.broken_image, color: Colors.grey);
                                        }
                                        return null; // 正常加载完成
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: ExtendedImage.asset(
                                    'assets/image/audio-guide.png',
                                    width: 80.w,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ExtendedImage.asset(
                                    'assets/image/sub-guide.png',
                                    width: 80.w,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 285.h,
                            child: Space(
                              direction: "column",
                              bottom: 10.h,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('======${index}======'),
                                _buildMovieDetails(item!),
                                _buildBuyButton(context),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: data[section]?.length ?? 0,
                ),
              ),
            );
          }).toList(),
        ),
    );
  }
}
