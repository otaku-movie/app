import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';
import 'package:otaku_movie/utils/date_format_util.dart';
import 'package:otaku_movie/generated/l10n.dart';

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
      String key = _formatDateWithWeekday(item.startDate);

      result.putIfAbsent(key, () => []);
      result[key]?.add(item);
    }

    return result;
  }

  String _formatDateWithWeekday(String? dateString) {
    return DateFormatUtil.formatDateWithWeekday(dateString, context);
  }

  String _extractDatePart(String section) {
    return DateFormatUtil.extractDatePart(section);
  }

  String _extractWeekdayPart(String section) {
    return DateFormatUtil.extractWeekdayPart(section);
  }

  /// 判断是否为预售（预售场次或预售券）
  bool _isPresale(MovieResponse? item) {
    if (item == null) return false;
    if (item.hasPresaleTicket == true || item.presaleId != null) return true;
    return (item.presaleShowTimeCount ?? 0) > 0;
  }

  /// 是否有预售券（可跳转预售券详情）
  bool _hasPresaleTicket(MovieResponse? item) {
    if (item == null) return false;
    return item.presaleId != null;
  }

  bool _shouldShowRating(String? levelName) {
    if (levelName == null || levelName.isEmpty) return false;
    
    // 定义日本分级等级顺序：G < PG12 < R15+ < R18+
    final ratingLevels = ['G', 'PG12', 'R15', 'R18'];
    final currentLevel = levelName.toUpperCase();
    
    // 如果不是标准分级，显示所有非G的分级
    if (!ratingLevels.contains(currentLevel)) {
      return currentLevel != 'G';
    }
    
    // 只有大于G级的才显示
    final currentIndex = ratingLevels.indexOf(currentLevel);
    return currentIndex > 0;
  }

  Color _getRatingColor(String? levelName) {
    if (levelName == null || levelName.isEmpty) return Colors.grey;
    
    final level = levelName.toUpperCase();
    switch (level) {
      case 'PG-12':
        return const Color(0xFF4CAF50); // 绿色 - 12岁以下需家长陪同
      case 'R-15':
        return const Color(0xFFFF9800); // 橙色 - 15岁以上
      case 'R-18':
        return const Color(0xFFF44336); // 红色 - 18岁以上
      default:
        return Colors.grey;
    }
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
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
      ),
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
          child: CustomScrollView(
            slivers: data.keys.toList().map((section) {
              return SliverStickyHeader(
                header: Container(
                  height: 60.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Container(
                          width: 4.w,
                          height: 24.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1989FA),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _extractDatePart(section),
                                style: TextStyle(
                                  color: const Color(0xFF1A1A1A),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_extractWeekdayPart(section).isNotEmpty)
                                Text(
                                  _extractWeekdayPart(section),
                                  style: TextStyle(
                                    color: const Color(0xFF1989FA),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                sliver: SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 24.w,
                      mainAxisSpacing: 24.h,
                      childAspectRatio: 0.55,
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 3 / 4, // 电影海报标准比例 3:4
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                      color: Colors.grey.shade100,
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.r),
                                            topRight: Radius.circular(16.r),
                                          ),
                                          child: CustomExtendedImage(
                                            item?.cover ?? '',
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // 预售券/预售角标（有预售或预售场次时显示，预售券可点击跳转）
                                        if (_isPresale(item))
                                          Positioned(
                                            top: 8.h,
                                            right: 8.w,
                                            child: GestureDetector(
                                              onTap: _hasPresaleTicket(item)
                                                  ? () {
                                                      context.pushNamed(
                                                        'presaleDetail',
                                                        pathParameters: {'id': '${item!.presaleId}'},
                                                      );
                                                    }
                                                  : null,
                                              behavior: HitTestBehavior.opaque,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFFF6B35),
                                                  borderRadius: BorderRadius.circular(8.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  _hasPresaleTicket(item)
                                                      ? S.of(context).comingSoon_presaleTicketBadge
                                                      : S.of(context).comingSoon_presale,
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        // 渐变遮罩
                                        Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withValues(alpha: 0.2),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item?.name ?? '',
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: const Color(0xFF1A1A1A),
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 8.h),
                                      Wrap(
                                        spacing: 8.w,
                                        runSpacing: 6.h,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          // 重映标记
                                          if (item?.isReRelease == true)
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(18.r),
                                              ),
                                              child: Text(
                                                S.of(context).movieList_tag_reRelease,
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          // 预售券/预售标签（有则显示，预售券可点击跳转）
                                          // if (_isPresale(item))
                                          //   GestureDetector(
                                          //     onTap: _hasPresaleTicket(item)
                                          //         ? () {
                                          //             context.pushNamed(
                                          //               'presaleDetail',
                                          //               pathParameters: {'id': '${item!.presaleId}'},
                                          //             );
                                          //           }
                                          //         : null,
                                          //     behavior: HitTestBehavior.opaque,
                                          //     child: Container(
                                          //       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                          //       decoration: BoxDecoration(
                                          //         color: const Color(0xFFFF6B35),
                                          //         borderRadius: BorderRadius.circular(18.r),
                                          //       ),
                                          //       child: Row(
                                          //         mainAxisSize: MainAxisSize.min,
                                          //         children: [
                                          //           Icon(
                                          //             Icons.local_fire_department,
                                          //             size: 20.sp,
                                          //             color: Colors.white,
                                          //           ),
                                          //           SizedBox(width: 4.w),
                                          //           Text(
                                          //             _hasPresaleTicket(item)
                                          //                 ? S.of(context).comingSoon_presaleTicketBadge
                                          //                 : S.of(context).comingSoon_presale,
                                          //             style: TextStyle(
                                          //               fontSize: 18.sp,
                                          //               color: Colors.white,
                                          //               fontWeight: FontWeight.w600,
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // 分级标签
                                          if (_shouldShowRating(item?.levelName))
                                            Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: _getRatingColor(item?.levelName),
                                                borderRadius: BorderRadius.circular(18.r),
                                                border: Border.all(
                                                  color: _getRatingColor(item?.levelName).withValues(alpha: 0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                item?.levelName ?? '',
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      // if (item?.startDate != null) ...[
                                      //   SizedBox(height: 8.h),
                                      //   Container(
                                      //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      //     decoration: BoxDecoration(
                                      //       color: const Color(0xFF1989FA).withValues(alpha: 0.1),
                                      //       borderRadius: BorderRadius.circular(8.r),
                                      //     ),
                                      //     child: Text(
                                      //       DateFormatUtil.formatYearMonth(item!.startDate, context),
                                      //       style: TextStyle(
                                      //         fontSize: 18.sp,
                                      //         color: const Color(0xFF1989FA),
                                      //         fontWeight: FontWeight.w500,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
        ),
      ),
    );
  }
}
