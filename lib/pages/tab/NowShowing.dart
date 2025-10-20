import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_image/extended_image.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/HelloMovie.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import 'package:otaku_movie/response/response.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/utils/toast.dart';

class NowShowing extends StatefulWidget {

  const NowShowing({super.key});

  @override
  State<NowShowing> createState() => _PageState();
}

class _PageState extends State<NowShowing> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持页面的状态

  EasyRefreshController easyRefreshController = EasyRefreshController();
  List<MovieNowShowingResponse> data = [];
  int currentPage = 1;
  bool loading = false;
  bool error = false;
  bool loadFinished  = false;

  void getData({int page = 1}) {
    ApiRequest().request(
      path: '/app/movie/nowShowing',
      method: 'GET',
      queryParameters: {
        "page": page,
        "pageSize": 10,
      },
      fromJsonT: (json) {
        return ApiPaginationResponse<MovieNowShowingResponse>.fromJson(
          json,
          (data) => MovieNowShowingResponse.fromJson(data as Map<String, dynamic>),
        );
      },
    ).then((res) {
      if (res.data?.list != null) {
        List<MovieNowShowingResponse> list = res.data!.list!;
        
        setState(() {
          if (list.isNotEmpty && !loadFinished) {
            data.addAll(list); // 追加数据
          }
          if (page == 1) {
            data = list;
          }
          currentPage = page;
          loadFinished = list.isEmpty; // 更新加载完成标志
          
        });

        easyRefreshController.finishLoad(
          list.isEmpty ? IndicatorResult.noMore : IndicatorResult.success,
          true
        );
      }
    }).catchError((err) {
      setState(() {
        error = true;
      });
    })
    .whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); 

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: EasyRefresh(
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
          child: ListView.builder(
              // physics: widget.physics,
              itemCount: data.length,
              itemBuilder: (context, index) {
                MovieNowShowingResponse item = data[index];
                return _buildMovieItem(context, item);
              },
            ),
          ),
        )
    );
  }

  Widget _buildMovieItem(BuildContext context, MovieNowShowingResponse item) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Color(0xFFE6E6E6)),
        ),
      ),
      child: Space(
        direction: "row",
        right: 10.w,
        children: [
          GestureDetector(
            onTap: () {
              context.pushNamed('movieDetail',
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
                    child: CustomExtendedImage(
                      item.cover ?? '',
                      width: 240.w,
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: HelloMovie(
                    guideData: item.helloMovie, 
                    type: HelloMovieGuide.audio,
                    width: 80.w,
                  )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: HelloMovie(
                    guideData: item.helloMovie, 
                    type: HelloMovieGuide.sub,
                    width: 80.w,
                  )
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
                MaterialButton(
                  color: const Color(0xFF069EF0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  onPressed: () {
                    context.pushNamed(
                      'showTimeList', 
                      pathParameters: {
                        "id": '${item.id}'
                      }, 
                      queryParameters: {
                        'movieName': item.name
                      }
                    );
                  },
                  child: Text(
                    S.of(context).movieList_buy,
                    style: TextStyle(color: Colors.white, fontSize: 32.sp),
                  ),
                ),
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
              context.pushNamed('movieDetail',
                pathParameters: {
                "id": '${item.id}'
              });
            },
            child: Text(item.name ?? '', style: TextStyle(fontSize: 30.sp)),
          ),
          // Text("监督：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          // Text("声优：XXXXX、XXXXX", style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
          Text('${S.of(context).movieList_currentlyShowing_level}：${item.levelName}', style: TextStyle(fontSize: 24.sp, color: Colors.black38)),
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

}
