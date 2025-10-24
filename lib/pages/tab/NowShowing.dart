import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/HelloMovie.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie_now_showing.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:go_router/go_router.dart';

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
 // 视图模式：false为列表，true为网格

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
        
        if (mounted) {
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
        }

        easyRefreshController.finishLoad(
          list.isEmpty ? IndicatorResult.noMore : IndicatorResult.success,
          true
        );
      }
    }).catchError((err) {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
    })
    .whenComplete(() {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
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
          child: Column(
            children: [
              // 内容区域
              Expanded(
                child: data.isEmpty 
                  ? _buildEmptyState() 
                  : _buildListView(),
              ),
            ],
          ),
        ),
    );
  }


  Widget _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      itemCount: data.length,
      itemBuilder: (context, index) {
        MovieNowShowingResponse item = data[index];
        return _buildMovieItem(context, item);
      },
    );
  }


  Widget _buildMovieItem(BuildContext context, MovieNowShowingResponse item) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 电影海报
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
                    height: 260.h,
                    width: 240.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CustomExtendedImage(
                        item.cover ?? '',
                        width: 240.w,
                        height: 260.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  // 音频/字幕标签
                  if (item.helloMovie != null) ...[
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      child: HelloMovie(
                        guideData: item.helloMovie, 
                        type: HelloMovieGuide.audio,
                        width: 60.w,
                      ),
                    ),
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: HelloMovie(
                        guideData: item.helloMovie, 
                        type: HelloMovieGuide.sub,
                        width: 60.w,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: 20.w),
            // 电影信息
            Expanded(
              child: SizedBox(
                height: 260.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMovieDetails(item),
                    _buildActionButton(context, item),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetails(MovieNowShowingResponse item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 电影标题
        GestureDetector(
          onTap: () {
            context.pushNamed('movieDetail',
              pathParameters: {
                "id": '${item.id}'
              });
          },
          child: Text(
            item.name ?? '',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF323233),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 12.h),
        
        // 等级信息
        if (item.levelName != null && item.levelName!.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: const Color(0xFF1989FA).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${S.of(context).movieList_currentlyShowing_level}：${item.levelName}',
              style: TextStyle(
                fontSize: 22.sp,
                color: const Color(0xFF1989FA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(height: 16.h),
        
        // 规格标签
        if (item.spec != null && item.spec!.isNotEmpty)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: item.spec!.map((spec) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFE6E6E6),
                    width: 1,
                  ),
                ),
                child: Text(
                  spec.name ?? '',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: const Color(0xFF646566),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, MovieNowShowingResponse item) {
    return Container(
      width: double.infinity,
      height: 80.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1989FA), Color(0xFF069EF0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1989FA).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
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
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  S.of(context).movieList_buy,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Icon(
              Icons.movie_outlined,
              size: 80.sp,
              color: const Color(0xFF1989FA),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            '暂无正在上映的电影',
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '请稍后再试或下拉刷新',
            style: TextStyle(
              fontSize: 24.sp,
              color: const Color(0xFF969799),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1989FA),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              '下拉刷新',
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
