import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/movie/movieList/movie.dart';

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
      String key = formatDate(item.startDate);

      result.putIfAbsent(key, () => []);
      result[key]?.add(item);
    }

    return result;
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return S.of(context).movieList_comingSoon_noDate;
    }
    
    try {
      // 直接处理 yyyy-mm-dd 格式
      List<String> parts = dateString.split('-');
      if (parts.length >= 2) {
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        return '${year}年${month.toString().padLeft(2, '0')}月';
      }
      return dateString;
    } catch (e) {
      // 如果解析失败，返回原始字符串
      return dateString;
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
                  margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFF1989FA).withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1989FA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.schedule_outlined,
                          color: const Color(0xFF1989FA),
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          section,
                          style: TextStyle(
                            color: const Color(0xFF323233),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                sliver: SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 20.h,
                      childAspectRatio: 0.60,
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
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                      ),
                                      child: CustomExtendedImage(
                                        item?.cover ?? '',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item?.name ?? '',
                                            style: TextStyle(
                                              fontSize: 24.sp,
                                              color: const Color(0xFF323233),
                                              fontWeight: FontWeight.w600,
                                              height: 1.2,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        if (item?.startDate != null) ...[
                                          SizedBox(height: 2.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today_outlined,
                                                size: 12.sp,
                                                color: const Color(0xFF1989FA),
                                              ),
                                              SizedBox(width: 3.w),
                                              Expanded(
                                                child: Text(
                                                  formatDate(item!.startDate),
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: const Color(0xFF1989FA),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
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
