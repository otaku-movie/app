import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NowShowing extends StatefulWidget {
  final ScrollPhysics physics;

  const NowShowing({super.key, required this.physics});

  @override
  State<NowShowing> createState() => _PageState();
}

class _PageState extends State<NowShowing> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持页面的状态


  List<MovieNowShowingResponse> data = [];
  int currentPage = 1;

  void getData({bool refresh = true}) {
    ApiRequest().request(
      path: '/app/movie/list',
      method: 'GET',
      queryParameters: {
        "page": refresh ? 1 : currentPage + 1,
        "pageSize": 10,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieNowShowingResponse>.fromJson(
          json,
          (data) => MovieNowShowingResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      setState(() {
        if (refresh) {
          data = res.data?.list ?? [];
          currentPage = 1;
        } else {
          data.addAll(res.data?.list ?? []);
          currentPage++;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> _onRefresh() async {
    getData(refresh: true);
  }

  Future<void> _onLoad() async {
    getData(refresh: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); 

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: EasyRefresh(
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        onRefresh: _onRefresh,
        onLoad: _onLoad,
        child: data.isNotEmpty
            ? ListView.builder(
                physics: widget.physics,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  MovieNowShowingResponse item = data[index];
                  return _buildMovieItem(context, item);
                },
              )
            : const Center(child: CircularProgressIndicator()),
        )
    );
  }

  Widget _buildMovieItem(BuildContext context, MovieNowShowingResponse item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
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
              context.goNamed('movieDetail',
                pathParameters: {
                "id": '${item.id}'
              });
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
                      item.cover ?? '',
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
                _buildMovieDetails(item),
                _buildBuyButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails(MovieNowShowingResponse item) {
    return SizedBox(
      width: 450.w,
      child: Space(
        direction: "column",
        children: [
          GestureDetector(
            onTap: () {
              context.goNamed('movieDetail',
                pathParameters: {
                "id": '${item.id}'
              });
            },
            child: Text(item.name ?? '', style: TextStyle(fontSize: 36.sp)),
          ),
          Text("监督：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          Text("声优：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          Text('映倫：${item.levelName}', style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 6,
              children: item.spec?.map((spec) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(0, 50.h),
                    textStyle: TextStyle(fontSize: 20.sp),
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(spec.name ?? ''),
                );
              }).toList() ??
              [],
            ),
          ),
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
}
