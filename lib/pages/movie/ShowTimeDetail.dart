import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/controller/TimeFormatController.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_show_time_detail_response.dart';
import 'package:otaku_movie/response/cinema/cinema_movie_showing_response.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/utils/date_format_util.dart';
import 'package:otaku_movie/utils/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import '../../generated/l10n.dart';

class ShowTimeDetail extends StatefulWidget {
  final String? cinemaId;
  final String? movieId;
  final String? reReleaseId;
  /// 来源页（ShowTimeList）当前选中的日期 'YYYY-MM-DD'。
  /// 数据回来后会自动把日期 tab 切到这一天；找不到匹配则回落到第一个 tab。
  final String? date;

  const ShowTimeDetail({super.key, this.cinemaId, this.movieId, this.reReleaseId, this.date});

  @override
  State<ShowTimeDetail> createState() => _PageState();
}

class _PageState extends State<ShowTimeDetail> with TickerProviderStateMixin {
  TabController? _tabController;
  CarouselSliderController carouselSliderController = CarouselSliderController();

  int currentMovieIndex = 0;
  List<Widget> tabWidget = [];
  CinemaMovieShowTimeDetailResponse data = CinemaMovieShowTimeDetailResponse();
  List<CinemaMovieShowingResponse> cinemaMovieShowingList = [];
  // 首次进入页面时显示全屏 loading，避免 SliverAppBar 在数据未到时
  // 露出底色（蓝/深色占位）造成「闪一下颜色」的视觉跳变。
  // 只在第一次 getData 完成后单向置 false；切换 carousel 电影时不再触发，
  // 否则用户每选一部电影主页就消失换 loading 屏，体验更差。
  bool _initialLoading = true;
  late final TimeFormatController timeFormatController =
      Get.find<TimeFormatController>();

  /// 把场次的 "HH:mm[:ss]" 字符串按当前全局 24h/30h 偏好格式化。
  /// 当 [referenceStartTime] 提供且当前时间字符串小于它（即结束时间跨日）时，
  /// 30h 模式会自动把次日凌晨 0–5 点显示为 24–29 点。
  String _formatShowTime(
    String? time, {
    String? dateStr,
    String? referenceStartTime,
  }) {
    final fullStr = DateFormatUtil.combineDateTime(
      date: dateStr,
      time: time,
      referenceStartTime: referenceStartTime,
    );
    return DateFormatUtil.formatShowTimeFromString(
      timeStr: fullStr,
      use30HourFormat: timeFormatController.use30HourFormat.value,
    );
  }

  // 格式化电影时长（分钟 -> 小时分钟）
  String _formatDuration(int? minutes) {
    if (minutes == null || minutes == 0) return '';
    
    if (minutes < 60) {
      return '${minutes}${S.of(context).showTimeDetail_time}';
    } else {
      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;
      
      if (remainingMinutes == 0) {
        return '${hours}小时';
      } else {
        return '${hours}小时${remainingMinutes}分钟';
      }
    }
  }

  // 获取座位状态信息
  Map<String, dynamic> _getSeatStatusInfo(TheaterHallShowTime showTime) {
    int seatStatus = showTime.seatStatus ?? 0;
    int availableSeats = showTime.availableSeats ?? 0;
    int totalSeats = showTime.totalSeats ?? 0;
    
    String statusText;
    Color statusColor;
    IconData statusIcon;
    
    switch (seatStatus) {
      case 0: // 充足
        statusText = S.of(context).showTimeDetail_seatStatus_available;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 1: // 紧张
        statusText = S.of(context).showTimeDetail_seatStatus_tight;
        statusColor = Colors.orange;
        statusIcon = Icons.warning_amber_outlined;
        break;
      case 2: // 售罄
        statusText = S.of(context).showTimeDetail_seatStatus_soldOut;
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusText = S.of(context).showTimeDetail_seatStatus_available;
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
    }
    return {
      'text': statusText,
      'color': statusColor,
      'icon': statusIcon,
      'availableSeats': availableSeats,
      'totalSeats': totalSeats,
    };
  }

  /// 根据爬虫 saleStatus 判断该场次是否可购买，并返回展示用文案/颜色/图标。
  /// pre_sale / sale_ended / closed / unknown 视为"官网未开放"——按钮置灰、点击 toast。
  ({
    bool isPurchasable,
    bool showBadge,
    String text,
    Color color,
    IconData icon,
  }) _resolveSaleStatusInfo(TheaterHallShowTime showTime) {
    final String? saleStatus = showTime.saleStatus;
    if (saleStatus == null || saleStatus.isEmpty) {
      // 老数据 / 自家可选座流程：按可购买处理
      return (
        isPurchasable: true,
        showBadge: false,
        text: '',
        color: Colors.green,
        icon: Icons.event_seat,
      );
    }
    switch (saleStatus) {
      case 'on_sale':
        return (
          isPurchasable: true,
          showBadge: true,
          text: S
              .of(context)
              .about_components_showTimeList_seatStatus_available,
          color: Colors.green,
          icon: Icons.event_seat,
        );
      case 'few':
        return (
          isPurchasable: true,
          showBadge: true,
          text:
              S.of(context).about_components_showTimeList_seatStatus_limited,
          color: Colors.orange,
          icon: Icons.event_seat,
        );
      case 'sold_out':
        return (
          isPurchasable: true,
          showBadge: true,
          text:
              S.of(context).about_components_showTimeList_seatStatus_soldOut,
          color: Colors.red,
          icon: Icons.event_seat,
        );
      case 'pre_sale':
        return (
          isPurchasable: false,
          showBadge: true,
          text:
              S.of(context).about_components_showTimeList_seatStatus_preSale,
          color: const Color(0xFF1989FA),
          icon: Icons.schedule_outlined,
        );
      case 'sale_ended':
        return (
          isPurchasable: false,
          showBadge: true,
          text: S
              .of(context)
              .about_components_showTimeList_seatStatus_saleEnded,
          color: Colors.grey,
          icon: Icons.do_not_disturb_alt_outlined,
        );
      case 'closed':
        return (
          isPurchasable: false,
          showBadge: true,
          text:
              S.of(context).about_components_showTimeList_seatStatus_closed,
          color: Colors.grey,
          icon: Icons.block_outlined,
        );
      case 'unknown':
      default:
        return (
          isPurchasable: false,
          showBadge: true,
          text:
              S.of(context).about_components_showTimeList_seatStatus_unknown,
          color: Colors.grey,
          icon: Icons.help_outline_rounded,
        );
    }
  }

  getData(int movieId) {
    final reReleaseId = widget.reReleaseId != null && widget.reReleaseId!.isNotEmpty
        ? int.tryParse(widget.reReleaseId!)
        : null;
    ApiRequest().request(
      path: '/app/cinema/movie/showTime',
      method: 'POST',
      data: {
        "movieId": movieId,
        "cinemaId": int.parse(widget.cinemaId!),
        if (reReleaseId != null) "reReleaseId": reReleaseId,
      },
      fromJsonT: (json) {
        return CinemaMovieShowTimeDetailResponse.fromJson(json);
      },
    ).then((res) {
          if (res.data != null) {
            if (_tabController != null) {
            _tabController!.dispose();
        }
        // _tabController.dispose();
        // 根据 widget.date 在数据中查找对应日期索引，否则默认 0。
        // 避免用户在 ShowTimeList 选了 6/04，进入详情后又跳回第 1 个 tab。
        int initialTabIndex = 0;
        if (widget.date != null && widget.date!.isNotEmpty) {
          final idx = res.data!.data!
              .indexWhere((g) => g.date == widget.date);
          if (idx >= 0) initialTabIndex = idx;
        }
        setState(() {
          data = res.data!;
          tabWidget = generateTab();
          // 在数据加载后初始化 TabController
          _tabController = TabController(
            length: res.data!.data!.length,
            vsync: this,
            initialIndex: initialTabIndex,
          );
          _initialLoading = false;
        });

        
      } else {
        setState(() {
          data = CinemaMovieShowTimeDetailResponse();
          tabWidget = [];
             _tabController =
            TabController(length: 0, vsync: this);
          _initialLoading = false;
        });
      
      }
    }).catchError((_) {
      // 接口失败也要解锁 loading，否则页面卡在转圈里。
      // 不强制改 data —— 主页面会显示空状态 / 用户可以下拉刷新或返回。
      if (!mounted) return;
      setState(() {
        _initialLoading = false;
      });
    });
  }

  getCinemaMovieShowingData() {
    ApiRequest().request<List<CinemaMovieShowingResponse>>(
      path: '/cinema/movieShowing',
      method: 'GET',
      queryParameters: {
        "id": int.parse(widget.cinemaId!)
      },
      fromJsonT: (json) {
        if (json is List) {
          return json.map((item) {
            return CinemaMovieShowingResponse.fromJson(item);
          }).toList();
        }
        return [];
      },
    ).then((res) {
      if (res.data != null) {
        setState(() {
          cinemaMovieShowingList = res.data ?? [];
          final idx = cinemaMovieShowingList.indexWhere(
              (item) => item.id == int.parse(widget.movieId!));
          // indexWhere 未找到时为 -1，避免 cinemaMovieShowingList[-1]
          currentMovieIndex = idx >= 0 ? idx : 0;
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    
    if (widget.movieId != null) {
      getData(int.parse(widget.movieId!));
    }
    
    getCinemaMovieShowingData();
    // _tabController = TabController(length: 0, vsync: this);
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {}

  List<Widget> generateTab() {
    List<String> weekList = [
      S.of(context).common_week_monday,
      S.of(context).common_week_tuesday,
      S.of(context).common_week_wednesday,
      S.of(context).common_week_thursday,
      S.of(context).common_week_friday,
      S.of(context).common_week_saturday,
      S.of(context).common_week_sunday,
    ];

    if (data.data != null) {
      return data.data!.map((item) {
        DateTime date = DateTime.parse(item.date!);
        List<String> dateParts = item.date!.split("-");
        String formattedDate = "${dateParts[1]}/${dateParts[2]}";

        return Tab(
          child: Column(
            children: [
              Text(weekList[date.weekday - 1]), // 星期
              Text(formattedDate), // 日期格式为 "月/日"
            ],
          ),
        );
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // 首次进入：getData 还没回来，先显示和 ShowTimeList 一致的全屏 loading。
    // 只看 _initialLoading（getData 完成后单向置 false），不看 cinemaMovieShowingList，
    // 因为 carousel 数据是辅助内容，可以晚一点出来；主要等场次主体。
    if (_initialLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: CustomAppBar(
          title: data.cinemaName ?? '',
          backgroundColor: const Color(0xFF1989FA),
        ),
        body: AppErrorWidget(loading: true, child: Container()),
      );
    }

    final int carouselSafeIndex = cinemaMovieShowingList.isEmpty
        ? 0
        : currentMovieIndex.clamp(0, cinemaMovieShowingList.length - 1);

    // if (tabWidget.isEmpty) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }

    List<Widget> renderCarouselSlider () {
      if (cinemaMovieShowingList.isEmpty) return [];
      final safeIndex = currentMovieIndex.clamp(
          0, cinemaMovieShowingList.length - 1);
      CinemaMovieShowingResponse movie =
          cinemaMovieShowingList[safeIndex];

      return [
         CarouselSlider(
          carouselController: carouselSliderController,
          options: CarouselOptions(
            // height: 305.h,
            initialPage: safeIndex,
            viewportFraction: 0.40,
            enlargeCenterPage: true,
            enlargeFactor: 0.20,
            onPageChanged: (index, carouselPageChangedReason)  {
              setState(() {
                currentMovieIndex = index;
              });
              // _tabController.dispose();
              getData(cinemaMovieShowingList[index].id!);
            }
          ),
          items: List.generate(cinemaMovieShowingList.length, (index) {
          final item = cinemaMovieShowingList[index];

          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                   setState(() {
                    currentMovieIndex = index;
                  });
                  getData(item.id!);
                  carouselSliderController.animateToPage(index);
                },
                child: Container(
                  width: 300.w,
                  // height: 180.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8.0),
                    child: CustomExtendedImage(
                      item.poster ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              );
            },
          );
        }),
      ),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
        child: Center(
            child: Space(
                direction: 'column',
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
              Text(cinemaMovieShowingList[safeIndex].name ?? '',
                  style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.white
                  ),
                  overflow: TextOverflow.ellipsis,
              ),
              RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 24.sp,
                        color: Colors.white60
                ),
                children: [
                  TextSpan(
                    text: movie.levelName ?? '',
                  ),
                  movie.time == null 
                  ? const TextSpan(text: '') 
                  : TextSpan(
                    text: '  ${_formatDuration(movie.time)}',
                  ),
                ],
              )
            )
          ],
        )),
      )
      ];
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                    title: Text(data.cinemaName ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 32.sp)),
                    // 让顶部条 + TabBar 始终固定在状态栏下方，
                    // 避免滚动后状态栏直接压到第一张场次卡片上。
                    pinned: true,
                    floating: false,
                    snap: false,
                    forceElevated: innerBoxIsScrolled,
                    // 折叠后保留默认 toolbar 高度；底部 TabBar 由 PreferredSize 单独追加。
                    collapsedHeight: kToolbarHeight,
                    // 折叠后由它显示，与其他页面（CustomAppBar 用的 0xFF1989FA）保持一致；
                    // 不设的话会回落到 ColorScheme.fromSeed(red) 派生的粉色，跟全站不搭。
                    // 展开状态下 flexibleSpace 的海报图会盖住这个底色，不影响视觉。
                    backgroundColor: const Color(0xFF1989FA),
                    expandedHeight: 750.h,
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white), // 自定义返回按钮图标
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                    ),
                    actions: const [],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 数据未到时（cinemaMovieShowingList 还在拉），底层先盖一个深色占位，
                          // 避免露出 SliverAppBar 的蓝色 backgroundColor 导致进入页面时闪蓝。
                          // 海报回来后会叠在它上面，过渡到正常视觉。
                          Positioned.fill(
                            child: Container(color: const Color(0xFF1F2430)),
                          ),
                          if (cinemaMovieShowingList.isNotEmpty)
                            CustomExtendedImage(
                              cinemaMovieShowingList[carouselSafeIndex]
                                      .poster ??
                                  '',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          if (cinemaMovieShowingList.isNotEmpty)
                            Positioned(
                              top: 0,
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 20.0, sigmaY: 20.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: 850.h,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0x00000000),
                                          Color(0x90000000),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            top: 130.h,
                            left: 0,
                            right: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 地址信息
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.white,
                                          size: 22.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          data.cinemaFullAddress ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // 电话信息
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Icon(
                                          Icons.phone_outlined,
                                          color: Colors.white,
                                          size: 22.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Text(
                                        data.cinemaTel ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 50.h),
                                ...renderCarouselSlider()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(
                          60.h), // Set the height of the TabBar
                      child: Container(
                        // height: 75.h,
                        padding: EdgeInsets.only(top: 20.h),
                        // padding: EdgeInsets.symmetric(vertical: 20.h),
                        color: Colors.transparent, // Set the background color
                        child: tabWidget.isNotEmpty ? TabBar(
                          controller: _tabController,
                          tabs: tabWidget,
                          isScrollable: true,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 0.h),
                          labelColor: Colors.white, // Selected label color
                          unselectedLabelColor:
                              Colors.white70, // Unselected label color
                          indicatorColor: Colors.white, // Indicator color
                        ) : Container(),
                      ),
                    )),
              ),
            ];
          },
          // 等待 data 与 _tabController 都就绪后再渲染 TabBarView，
          // 否则 TabBarView 在 length 为 0 / controller 为 null 时会在 build 期间
          // 触发 markNeedsBuild，报 "setState() or markNeedsBuild() called during build"。
          body: (data.data == null ||
                  data.data!.isEmpty ||
                  _tabController == null ||
                  _tabController!.length != (data.data?.length ?? 0))
              ? const SizedBox.shrink()
              : TabBarView(
                controller: _tabController,
                // ignore: prefer_is_empty
                children: (data.data ?? []).map((item) {
                  // 过滤已禁用的场次（open == false）
                  final showTimes = (item.data ?? [])
                      .where((s) => s.open != false)
                      .toList();
                  return Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>(item.date!), // 使用日期作为唯一标识
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(0.0),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                childCount: showTimes.length,
                                (BuildContext context, int index) {
                                  TheaterHallShowTime children =
                                      showTimes[index];
                                  final saleInfo =
                                      _resolveSaleStatusInfo(children);
                                  final bool isPurchasable =
                                      saleInfo.isPurchasable;

                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                    padding: EdgeInsets.all(20.w),
                                    decoration: BoxDecoration(
                                      // 不可购买场次用浅灰底 + 灰边框，与可购买的白底投影形成明显对比
                                      color: isPurchasable
                                          ? Colors.white
                                          : const Color(0xFFF5F6F8),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: isPurchasable
                                          ? null
                                          : Border.all(
                                              color: const Color(0xFFE3E5EA),
                                              width: 1,
                                            ),
                                      boxShadow: isPurchasable
                                          ? [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.05),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 时间和影厅信息行
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // 左侧：时间信息
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // 时间展示（响应全局 24h/30h 切换）
                                                  Obx(() => Row(
                                                    children: [
                                                      Text(
                                                        _formatShowTime(
                                                          children.startTime,
                                                          dateStr: item.date,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 44.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: isPurchasable
                                                              ? const Color(
                                                                  0xFF323233)
                                                              : const Color(
                                                                  0xFFB0B5BD),
                                                          height: 1,
                                                          decoration: isPurchasable
                                                              ? TextDecoration
                                                                  .none
                                                              : TextDecoration
                                                                  .lineThrough,
                                                          decorationColor:
                                                              const Color(
                                                                  0xFFB0B5BD),
                                                          decorationThickness:
                                                              1.5,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                                                        child: Container(
                                                          width: 20.w,
                                                          height: 2.h,
                                                          color: Colors.grey.shade300,
                                                        ),
                                                      ),
                                                      Text(
                                                        _formatShowTime(
                                                          children.endTime,
                                                          dateStr: item.date,
                                                          referenceStartTime: children.startTime,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 28.sp,
                                                          color: Colors.grey.shade500,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  SizedBox(height: 16.h),
                                                  // 影厅和规格信息
                                                  Wrap(
                                                    spacing: 8.w,
                                                    runSpacing: 8.h,
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    children: [
                                                      // 影厅
                                                      Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                        decoration: BoxDecoration(
                                                            color: const Color(0xFF1989FA).withValues(alpha: 0.1),
                                                            borderRadius: BorderRadius.circular(8.r),
                                                            border: Border.all(
                                                              color: const Color(0xFF1989FA).withValues(alpha: 0.3),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.meeting_room_rounded,
                                                              size: 22.sp,
                                                              color: const Color(0xFF1989FA),
                                                            ),
                                                            SizedBox(width: 6.w),
                                                            Text(
                                                              children.theaterHallName ?? '',
                                                              style: TextStyle(
                                                                fontSize: 24.sp,
                                                                color: const Color(0xFF1989FA),
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // 规格：specName 由后端用「、」拼接多个 cinema_spec.name（IMAX / Dolby / MX4D / TCX 等）。
                                                      // 2D / 3D 已在 V21 迁移中从字典移除，spec_ids 不会再包含它们，
                                                      // 因此这里直接 split 渲染即可，不再做客户端过滤。
                                                      ...(() {
                                                        final raw = children.specName;
                                                        if (raw == null || raw.isEmpty) return <Widget>[];
                                                        final items = raw
                                                            .split('、')
                                                            .map((e) => e.trim())
                                                            .where((e) => e.isNotEmpty)
                                                            .toList();
                                                        return items.map<Widget>((name) {
                                                          return Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  const Color(0xFFFFD700).withValues(alpha: 0.2),
                                                                  const Color(0xFFFFA500).withValues(alpha: 0.2),
                                                                ],
                                                              ),
                                                              borderRadius: BorderRadius.circular(8.r),
                                                              border: Border.all(
                                                                color: const Color(0xFFFFA500).withValues(alpha: 0.5),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  Icons.high_quality_rounded,
                                                                  size: 22.sp,
                                                                  color: const Color(0xFFFFA500),
                                                                ),
                                                                SizedBox(width: 6.w),
                                                                Text(
                                                                  name,
                                                                  style: TextStyle(
                                                                    fontSize: 22.sp,
                                                                    color: const Color(0xFFFFA500),
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }).toList();
                                                      })(),
                                                      // 放映类型：2D / 3D（dimensionType 字典）。列表页已有，这里详情页补齐。
                                                      if (children.dimensionType != null)
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                          decoration: BoxDecoration(
                                                            color: const Color(0xFF7232DD).withValues(alpha: 0.12),
                                                            borderRadius: BorderRadius.circular(8.r),
                                                            border: Border.all(
                                                              color: const Color(0xFF7232DD).withValues(alpha: 0.3),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(
                                                                Icons.visibility_rounded,
                                                                size: 22.sp,
                                                                color: const Color(0xFF7232DD),
                                                              ),
                                                              SizedBox(width: 6.w),
                                                              Flexible(
                                                                child: Dict(
                                                                  code: children.dimensionType,
                                                                  name: 'dimensionType',
                                                                  style: TextStyle(
                                                                    fontSize: 22.sp,
                                                                    color: const Color(0xFF7232DD),
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      // 原版 / 配音版：dubbingVersion 字典（1=オリジナル版, 2=吹き替え版）。
                                                      // 源数据没有 dub 标记时 versionCode 为空，不强行猜。
                                                      if (children.versionCode != null)
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                          decoration: BoxDecoration(
                                                            color: Colors.orange.withValues(alpha: 0.12),
                                                            borderRadius: BorderRadius.circular(8.r),
                                                            border: Border.all(
                                                              color: Colors.orange.withValues(alpha: 0.3),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(
                                                                Icons.language_rounded,
                                                                size: 22.sp,
                                                                color: Colors.orange,
                                                              ),
                                                              SizedBox(width: 6.w),
                                                              Flexible(
                                                                child: Dict(
                                                                  code: children.versionCode,
                                                                  name: 'dubbingVersion',
                                                                  style: TextStyle(
                                                                    fontSize: 22.sp,
                                                                    color: Colors.orange,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      // 座位/售票状态：
                                                      //   - 优先：爬虫透传的 saleStatus（覆盖 TOHO/T-JOY 这类无自家 seat 表的场次）；
                                                      //   - 回落：自家选座流程的 seatStatus（0/1/2）。
                                                      Builder(
                                                        builder: (context) {
                                                          if (saleInfo
                                                              .showBadge) {
                                                            return Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          12.w,
                                                                      vertical:
                                                                          6.h),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: saleInfo
                                                                    .color
                                                                    .withValues(
                                                                        alpha:
                                                                            0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.r),
                                                                border: Border
                                                                    .all(
                                                                  color: saleInfo
                                                                      .color
                                                                      .withValues(
                                                                          alpha:
                                                                              0.3),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Icon(
                                                                    saleInfo
                                                                        .icon,
                                                                    size: 22.sp,
                                                                    color: saleInfo
                                                                        .color,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          6.w),
                                                                  Text(
                                                                    saleInfo
                                                                        .text,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          22.sp,
                                                                      color: saleInfo
                                                                          .color,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }
                                                          final seatInfo = _getSeatStatusInfo(children);
                                                          return Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                                            decoration: BoxDecoration(
                                                              color: (seatInfo['color'] as Color).withValues(alpha: 0.1),
                                                              borderRadius: BorderRadius.circular(8.r),
                                                              border: Border.all(
                                                                color: (seatInfo['color'] as Color).withValues(alpha: 0.3),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Icon(
                                                                  seatInfo['icon'],
                                                                  size: 22.sp,
                                                                  color: seatInfo['color'],
                                                                ),
                                                                SizedBox(width: 6.w),
                                                                Text(
                                                                  seatInfo['text'],
                                                                  style: TextStyle(
                                                                    fontSize: 22.sp,
                                                                    color: seatInfo['color'],
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                if (seatInfo['availableSeats'] > 0 && seatInfo['totalSeats'] > 0) ...[
                                                                  SizedBox(width: 4.w),
                                                                  Text(
                                                                    '(${seatInfo['availableSeats']}/${seatInfo['totalSeats']})',
                                                                    style: TextStyle(
                                                                      fontSize: 20.sp,
                                                                      color: (seatInfo['color'] as Color).withValues(alpha: 0.7),
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // 右侧：购票按钮
                                            // 当前阶段不再走 app 内置选座流程，统一把购票动作 deeplink
                                            // 到影院官网。reservationUrl 来自爬虫
                                            // `crawl.movie_show_time.reservation_params_json.reservation_url`。
                                            // 覆盖率：aeon/movix/grandCinemaSunshine ≈100%，c109/humax/tjoy/united ≈45%，
                                            // toho 当前为 0%（源站无可直链场次 URL）。缺失时仅提示用户去现场或官网。
                                            GestureDetector(
                                              onTap: () {
                                                final reserveUrl = children.reservationUrl?.trim() ?? '';
                                                final String clickResult = !isPurchasable
                                                    ? 'not_purchasable'
                                                    : (reserveUrl.isNotEmpty ? 'open_url' : 'no_url');
                                                Analytics.instance.logFunnel(Ev.showtimeClick, {
                                                  P.showtimeId: children.id,
                                                  P.saleStatus: children.saleStatus,
                                                  P.type: clickResult,
                                                });
                                                // 不可购买（pre_sale / sale_ended / closed / unknown）：
                                                // 不外跳，提示用户当前状态，避免遇到 ERR-2002 之类的官网错误页
                                                if (!isPurchasable) {
                                                  ToastService.showToast(
                                                    '${S.of(context).about_components_showTimeList_notPurchasableHint}（${saleInfo.text}）',
                                                    type: ToastType.warning,
                                                  );
                                                  return;
                                                }
                                                // 旧实现：跳转 app 内置选座页（暂保留以便回滚）
                                                // context.pushNamed(
                                                //   'selectSeat',
                                                //   queryParameters: {
                                                //     "id": '${children.id}',
                                                //     "theaterHallId": '${children.theaterHallId}'
                                                //   },
                                                // );
                                                final url = children.reservationUrl?.trim() ?? '';
                                                if (url.isNotEmpty) {
                                                  launchURL(url);
                                                  return;
                                                }
                                                ToastService.showToast(
                                                  S.of(context).showTimeDetail_noOnlineTicket,
                                                  type: ToastType.warning,
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                                                decoration: BoxDecoration(
                                                  // 可购买：蓝色渐变 + 投影；不可购买：纯灰底、无投影
                                                  gradient: isPurchasable
                                                      ? const LinearGradient(
                                                          colors: [
                                                            Color(0xFF1989FA),
                                                            Color(0xFF0E6FD8),
                                                          ],
                                                        )
                                                      : null,
                                                  color: isPurchasable
                                                      ? null
                                                      : const Color(0xFFCED2D8),
                                                  borderRadius: BorderRadius.circular(25.r),
                                                  boxShadow: isPurchasable
                                                      ? [
                                                          BoxShadow(
                                                            color: const Color(0xFF1989FA).withValues(alpha: 0.3),
                                                            blurRadius: 8,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ]
                                                      : null,
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      isPurchasable
                                                          ? Icons.event_seat
                                                          : Icons.lock_outline,
                                                      color: Colors.white,
                                                      size: 28.sp,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      isPurchasable
                                                          ? S.of(context).showTimeDetail_buy
                                                          : saleInfo.text,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24.sp,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // 特殊标签和字幕（如果有）
                                        if ((children.showTimeTags != null && children.showTimeTags!.isNotEmpty) ||
                                            (children.subtitle != null && children.subtitle!.isNotEmpty))
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.h),
                                            child: Wrap(
                                              spacing: 8.w,
                                              runSpacing: 8.h,
                                              children: [
                                                // 特殊标签
                                                if (children.showTimeTags != null)
                                                  ...children.showTimeTags!.map((tag) {
                                                    return Container(
                                                      height: 32.h,
                                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                                      decoration: BoxDecoration(
                                                        gradient: const LinearGradient(
                                                          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                                                        ),
                                                        borderRadius: BorderRadius.circular(6.r),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                                                            blurRadius: 4,
                                                            offset: const Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.local_activity,
                                                            color: Colors.white,
                                                            size: 22.sp,
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            tag.name ?? '',
                                                            style: TextStyle(
                                                              fontSize: 20.sp,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              height: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                // 字幕信息：原音 +「该语种字幕」的"字幕版"上映；点击 chip 弹出说明 Tooltip，
                                                // 提示用户这是字幕版而非吹替版，避免误以为是日语配音。
                                                if (children.subtitle != null)
                                                  ...children.subtitle!.map((sub) {
                                                    final subName = sub.name ?? '';
                                                    return Tooltip(
                                                      message: S
                                                          .of(context)
                                                          .about_components_showTimeList_subtitleHint(subName),
                                                      triggerMode: TooltipTriggerMode.tap,
                                                      preferBelow: true,
                                                      child: Container(
                                                        height: 32.h,
                                                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFFE91E63).withValues(alpha: 0.10),
                                                          borderRadius: BorderRadius.circular(6.r),
                                                          border: Border.all(
                                                            color: const Color(0xFFE91E63),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              Icons.subtitles_outlined,
                                                              color: const Color(0xFFE91E63),
                                                              size: 22.sp,
                                                            ),
                                                            SizedBox(width: 4.w),
                                                            Text(
                                                              S.of(context).about_components_showTimeList_subtitleChipWith(subName),
                                                              style: TextStyle(
                                                                fontSize: 20.sp,
                                                                color: const Color(0xFFE91E63),
                                                                fontWeight: FontWeight.w600,
                                                                height: 1,
                                                              ),
                                                            ),
                                                            SizedBox(width: 4.w),
                                                            Icon(
                                                              Icons.info_outline,
                                                              size: 18.sp,
                                                              color: const Color(0xFFE91E63).withValues(alpha: 0.6),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              )),
    );
  }
}

