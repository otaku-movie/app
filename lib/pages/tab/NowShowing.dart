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
import 'package:otaku_movie/utils/date_format_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NowShowing extends StatefulWidget {

  const NowShowing({super.key});

  @override
  State<NowShowing> createState() => _PageState();
}

class _PageState extends State<NowShowing> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 保持页面的状态

  /// 持久化 key：视图模式（false=列表，true=网格）
  static const String _viewModePrefsKey = 'now_showing_view_grid';

  EasyRefreshController easyRefreshController = EasyRefreshController();
  List<MovieNowShowingResponse> data = [];
  int currentPage = 1;
  bool loading = false;
  bool error = false;
  bool loadFinished  = false;
  /// 分页（page>1）加载进行中：用于在列表/网格底部内联展示 loading。
  bool loadingMore = false;
  /// 视图模式：false=列表，true=网格
  bool _isGridView = false;

  /// 分级为 G 时不显示
  bool _shouldShowRating(String? levelName) {
    final level = levelName?.trim();
    if (level == null || level.isEmpty) return false;
    return level.toUpperCase().replaceAll('-', '').replaceAll('+', '') != 'G';
  }

  /// 获取分级对应的特殊颜色
  Color _getRatingColor(String? levelName) {
    if (levelName == null || levelName.isEmpty) return const Color(0xFF1989FA);
    final level = levelName.toUpperCase().replaceAll('-', '').replaceAll('+', '');
    switch (level) {
      case 'PG12':
        return const Color(0xFF4CAF50); // 绿色 - 12岁以下需家长陪同
      case 'R15':
        return const Color(0xFFFF9800); // 橙色 - 15岁以上
      case 'R18':
        return const Color(0xFFF44336); // 红色 - 18岁以上
      default:
        return const Color(0xFF1989FA); // 默认蓝色
    }
  }

  /// 把监督列表拼成展示用字符串：多人用 `、` 顿号连接，全空返回 null
  String? _buildDirectorText(List<Cast>? directors) {
    if (directors == null || directors.isEmpty) return null;
    final names = directors
        .map((d) => d.name?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
    if (names.isEmpty) return null;
    return names.join('、');
  }

  /// 监督一行：「監督：A、B」纯文本展示，单行截断
  Widget _buildDirectorRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${S.of(context).movieList_currentlyShowing_director}：',
          style: TextStyle(
            fontSize: 22.sp,
            color: const Color(0xFF969799),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22.sp,
              color: const Color(0xFF323233),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelTag(String levelName) {
    final color = _getRatingColor(levelName);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '${S.of(context).movieList_currentlyShowing_level}：$levelName',
        style: TextStyle(
          fontSize: 22.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 判断是否为预售（上映时间未到）
  bool _isPresale(String? startDate) {
    if (startDate == null || startDate.isEmpty) return false;
    
    try {
      final releaseDate = DateTime.parse(startDate);
      final now = DateTime.now();
      return releaseDate.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  Future<void> getData({int page = 1, bool refresh = false}) async {
    if (page > 1 && loadFinished) {
      easyRefreshController.finishLoad(IndicatorResult.noMore, true);
      return;
    }

    final isFirstLoad = page == 1 && !refresh && data.isEmpty;
    if (isFirstLoad && mounted) {
      setState(() {
        loading = true;
        error = false;
      });
    }

    // 分页加载（非首屏、非下拉刷新）：标记 loadingMore，底部展示 loading。
    final isLoadMore = page > 1 && !refresh;
    if (isLoadMore && mounted) {
      setState(() {
        loadingMore = true;
      });
    }

    try {
      final res = await ApiRequest().request(
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
      );

      final list = res.data?.list ?? [];
      final pageSize = res.data?.pageSize ?? 10;
      final total = res.data?.total ?? 0;

      if (mounted) {
        setState(() {
          if (page == 1) {
            data = list;
          } else if (list.isNotEmpty) {
            final existingIds = data.map((item) => item.id).whereType<int>().toSet();
            data.addAll(list.where((item) {
              final id = item.id;
              return id == null || existingIds.add(id);
            }));
          }

          currentPage = page;
          loadFinished = list.isEmpty ||
              (total > 0 && data.length >= total) ||
              list.length < pageSize;
          loading = false;
          loadingMore = false;
          error = false;
        });
      }

      if (refresh) {
        easyRefreshController.finishRefresh(IndicatorResult.success, true);
      } else if (page > 1) {
        easyRefreshController.finishLoad(
          loadFinished ? IndicatorResult.noMore : IndicatorResult.success,
          true,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          loading = false;
          loadingMore = false;
          if (page == 1 && data.isEmpty) {
            error = true;
          }
        });
      }

      if (refresh) {
        easyRefreshController.finishRefresh(IndicatorResult.fail, true);
      } else if (page > 1) {
        easyRefreshController.finishLoad(IndicatorResult.fail, true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadViewMode();
    getData();
  }

  Future<void> _loadViewMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_viewModePrefsKey);
      if (saved != null && mounted) {
        setState(() {
          _isGridView = saved;
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleViewMode() async {
    setState(() {
      _isGridView = !_isGridView;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_viewModePrefsKey, _isGridView);
    } catch (_) {}
  }


  @override
  Widget build(BuildContext context) {
    super.build(context); 

    return Column(
      children: [
        _buildViewModeToolbar(),
        Expanded(
          child: EasyRefresh(
            header: customHeader(context),
            // 预加载阈值约 1~1.5 张电影卡片：列表/网格视图下用户还能看到下一张时
            // 就提前触发下一页加载，避免出现「滚到底才看到 loading」。
            footer: customFooter(context, infiniteOffset: 400.h),
            onRefresh: () {
              getData(refresh: true);
            },
            onLoad: () {
              getData(page: currentPage + 1);
            },
            child: AppErrorWidget(
              loading: loading,
              error: error,
              empty: !loading && !error && data.isEmpty,
              emptyWidget: _buildEmptyState(),
              onRetry: () {
                getData();
              },
              child: _buildMovieScrollView(),
            ),
          ),
        ),
      ],
    );
  }

  /// 顶部视图模式切换栏
  Widget _buildViewModeToolbar() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 16.w, 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildViewModeSwitcher(),
        ],
      ),
    );
  }

  Widget _buildViewModeSwitcher() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewModeButton(
            icon: Icons.view_list_rounded,
            tooltip: S.of(context).movieList_view_list,
            isSelected: !_isGridView,
            onTap: () {
              if (_isGridView) _toggleViewMode();
            },
          ),
          _buildViewModeButton(
            icon: Icons.grid_view_rounded,
            tooltip: S.of(context).movieList_view_grid,
            isSelected: _isGridView,
            onTap: () {
              if (!_isGridView) _toggleViewMode();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewModeButton({
    required IconData icon,
    required String tooltip,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1989FA)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              icon,
              size: 28.sp,
              color: isSelected ? Colors.white : const Color(0xFF969799),
            ),
          ),
        ),
      ),
    );
  }


  /// 列表 / 网格统一用 CustomScrollView 承载，底部追加一个内联 loading：
  /// 分页加载进行中（loadingMore）且仍有下一页时展示，解决「预加载触发后要等一会
  /// 才出现下一页，期间没有可见 loading」的问题。
  Widget _buildMovieScrollView() {
    final showBottomLoader = loadingMore && !loadFinished;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: _isGridView
              ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)
              : EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          sliver: _isGridView ? _buildSliverGrid() : _buildSliverList(),
        ),
        if (showBottomLoader)
          SliverToBoxAdapter(child: _buildBottomLoader()),
      ],
    );
  }

  Widget _buildSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildMovieItem(context, data[index]),
        childCount: data.length,
      ),
    );
  }

  Widget _buildSliverGrid() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.48,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildGridItem(context, data[index]),
        childCount: data.length,
      ),
    );
  }

  /// 底部内联 loading 指示器
  Widget _buildBottomLoader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: SizedBox(
          width: 40.w,
          height: 40.w,
          child: const CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1989FA)),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, MovieNowShowingResponse item) {
    final isPresale = _isPresale(item.startDate);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 海报区
          GestureDetector(
            onTap: () {
              context.pushNamed('movieDetail', pathParameters: {
                'id': '${item.id}',
              });
            },
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: Container(
                      color: Colors.grey.shade200,
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomExtendedImage(
                        item.cover ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (item.hasPresaleTicket == true || item.presaleId != null)
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: GestureDetector(
                        onTap: (item.presaleId != null)
                            ? () {
                                context.pushNamed(
                                  'presaleDetail',
                                  pathParameters: {'id': '${item.presaleId}'},
                                );
                              }
                            : null,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B35)
                                    .withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            S.of(context).comingSoon_presaleTicketBadge,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (item.hasBenefits == true)
                    Positioned(
                      top: 6.h,
                      right: 6.w,
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            'movieBenefits',
                            pathParameters: {'id': '${item.id}'},
                            queryParameters: {
                              'movieName': item.name,
                              if (item.cover != null &&
                                  item.cover!.trim().isNotEmpty)
                                'movieCoverUrl': item.cover!.trim(),
                              if (item.isReRelease == true &&
                                  item.reReleaseId != null)
                                'reReleaseId': '${item.reReleaseId}',
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple
                                    .withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            (item.isReRelease == true)
                                ? S
                                    .of(context)
                                    .benefit_hasBenefitsLabel_reRelease
                                : S.of(context).benefit_hasBenefitsLabel,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (item.helloMovie != null) ...[
                    Positioned(
                      bottom: 6.h,
                      left: 6.w,
                      child: HelloMovie(
                        guideData: item.helloMovie,
                        type: HelloMovieGuide.audio,
                        width: 36.w,
                      ),
                    ),
                    Positioned(
                      bottom: 6.h,
                      right: 6.w,
                      child: HelloMovie(
                        guideData: item.helloMovie,
                        type: HelloMovieGuide.sub,
                        width: 36.w,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // 信息区
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.pushNamed('movieDetail', pathParameters: {
                        'id': '${item.id}',
                      });
                    },
                    child: Text(
                      item.name ?? '',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323233),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (_shouldShowRating(item.levelName))
                    _buildGridLevelTag(item.levelName!)
                  else if (isPresale && item.startDate != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 14.sp,
                            color: const Color(0xFFFF6B35),
                          ),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              DateFormatUtil.formatDate(
                                  item.startDate, context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFFFF6B35),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  _buildGridActionButton(context, item),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 网格视图专用：紧凑评级标签（不含"分级："前缀，节省宽度）
  Widget _buildGridLevelTag(String levelName) {
    final color = _getRatingColor(levelName);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        levelName,
        style: TextStyle(
          fontSize: 16.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGridActionButton(
      BuildContext context, MovieNowShowingResponse item) {
    final isPresale = _isPresale(item.startDate);
    final buttonColors = isPresale
        ? [const Color(0xFFFF6B35), const Color(0xFFFF8A50)]
        : [const Color(0xFF1989FA), const Color(0xFF069EF0)];
    final shadowColor =
        isPresale ? const Color(0xFFFF6B35) : const Color(0xFF1989FA);

    return Container(
      width: double.infinity,
      height: 46.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: buttonColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: () {
            context.pushNamed(
              'showTimeList',
              pathParameters: {'id': '${item.id}'},
              queryParameters: {
                'movieName': item.name,
                if (item.isReRelease == true && item.reReleaseId != null)
                  'reReleaseId': '${item.reReleaseId}',
              },
            );
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  isPresale
                      ? S.of(context).comingSoon_presale
                      : S.of(context).movieList_buy,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
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


  Widget _buildMovieItem(BuildContext context, MovieNowShowingResponse item) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                          color: Colors.black.withValues(alpha: 0.1),
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
                  // ムビチケ/前売り券角标（有前卖券则可点击跳转）
                  if (item.hasPresaleTicket == true || item.presaleId != null)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: GestureDetector(
                        onTap: (item.presaleId != null)
                            ? () {
                                context.pushNamed(
                                  'presaleDetail',
                                  pathParameters: {'id': '${item.presaleId}'},
                                );
                              }
                            : null,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
                            S.of(context).comingSoon_presaleTicketBadge,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ),
                  // 入场者特典标识：点击跳转该电影特典页
                  if (item.hasBenefits == true)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            'movieBenefits',
                            pathParameters: { 'id': '${item.id}' },
                            queryParameters: {
                              'movieName': item.name,
                              if (item.cover != null && item.cover!.trim().isNotEmpty)
                                'movieCoverUrl': item.cover!.trim(),
                              if (item.isReRelease == true && item.reReleaseId != null)
                                'reReleaseId': '${item.reReleaseId}',
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                          (item.isReRelease == true)
                              ? S.of(context).benefit_hasBenefitsLabel_reRelease
                              : S.of(context).benefit_hasBenefitsLabel,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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

        // 重映标识/版本信息
        if (item.isReRelease == true || (item.reReleaseVersionInfo != null && item.reReleaseVersionInfo!.isNotEmpty))
          Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
              children: [
                if (item.isReRelease == true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF07C160).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      S.of(context).movieList_tag_reRelease,
                      style: TextStyle(fontSize: 22.sp, color: const Color(0xFF07C160), fontWeight: FontWeight.w600),
                    ),
                  ),
                if (item.reReleaseVersionInfo != null && item.reReleaseVersionInfo!.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1989FA).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      item.reReleaseVersionInfo!,
                      style: TextStyle(fontSize: 22.sp, color: const Color(0xFF1989FA), fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        
        // 等级信息（G 不显示，PG12/PG13/R15/R18 使用特殊颜色）
        if (_shouldShowRating(item.levelName))
          _buildLevelTag(item.levelName!),
        SizedBox(height: 16.h),

        // 監督（导演）信息：列表视图独占一行，最多 1 行截断
        if (_buildDirectorText(item.director) != null) ...[
          _buildDirectorRow(_buildDirectorText(item.director)!),
          SizedBox(height: 12.h),
        ],
        
        // 上映日期（预售时显示）
        if (_isPresale(item.startDate) && item.startDate != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 20.sp,
                  color: const Color(0xFFFF6B35),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${DateFormatUtil.formatDate(item.startDate, context)} ${S.of(context).comingSoon_releaseDate}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    color: const Color(0xFFFF6B35),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        if (_isPresale(item.startDate)) SizedBox(height: 16.h),
        
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
    final isPresale = _isPresale(item.startDate);
    final buttonColors = isPresale 
      ? [const Color(0xFFFF6B35), const Color(0xFFFF8A50)]  // 预售：橙色渐变
      : [const Color(0xFF1989FA), const Color(0xFF069EF0)]; // 正常：蓝色渐变
    final shadowColor = isPresale 
      ? const Color(0xFFFF6B35) 
      : const Color(0xFF1989FA);
    
    return Container(
      width: double.infinity,
      height: 68.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: buttonColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.3),
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
                'movieName': item.name,
                if (item.isReRelease == true && item.reReleaseId != null)
                  'reReleaseId': '${item.reReleaseId}',
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
                  _isPresale(item.startDate) 
                    ? S.of(context).comingSoon_presale
                    : S.of(context).movieList_buy,
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
              color: const Color(0xFF1989FA).withValues(alpha: 0.1),
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
            S.of(context).comingSoon_noMovies,
            style: TextStyle(
              fontSize: 28.sp,
              color: const Color(0xFF323233),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            S.of(context).comingSoon_tryLaterOrRefresh,
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
              S.of(context).comingSoon_pullToRefresh,
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
