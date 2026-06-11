import 'dart:async';
import 'dart:ui';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/analytics/analytics.dart';
import 'package:otaku_movie/analytics/events.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/FilterBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/response/benefit/benefit_cinema_availability_response.dart';
import 'package:otaku_movie/utils/area_i18n_util.dart';
import 'package:otaku_movie/utils/location_util.dart';
import 'package:otaku_movie/utils/toast.dart';

/// 某特典在各影院的库存与反馈（可筛选、分页）
class BenefitCinemaAvailability extends StatefulWidget {
  final String movieId;
  final String benefitId;
  final String? benefitName;
  final String? movieName;
  /// 特典物料图（优先作 header 背景）
  final String? benefitCoverUrl;
  /// 电影封面（无特典图时使用）
  final String? movieCoverUrl;
  final String? reReleaseId;
  final String? phaseStatus;

  const BenefitCinemaAvailability({
    super.key,
    required this.movieId,
    required this.benefitId,
    this.benefitName,
    this.movieName,
    this.benefitCoverUrl,
    this.movieCoverUrl,
    this.reReleaseId,
    this.phaseStatus,
  });

  @override
  State<BenefitCinemaAvailability> createState() => _BenefitCinemaAvailabilityState();
}

class _BenefitCinemaAvailabilityState extends State<BenefitCinemaAvailability> {
  final TextEditingController _searchController = TextEditingController();
  final EasyRefreshController _refreshController =
      EasyRefreshController(controlFinishLoad: true, controlFinishRefresh: true);
  final ScrollController _scrollController = ScrollController();

  List<BenefitCinemaAvailabilityItem> _list = [];
  bool _loading = true;
  String? _error;
  int _page = 1;
  static const int _pageSize = 20;
  bool _loadFinished = false;
  int _total = 0;
  bool _showAppBarShadow = false;

  String _sort = 'remainingDesc';
  int? _regionId;
  int? _prefectureId;
  Map<String, dynamic> _filterParams = {};
  List<AreaResponse> _areaTreeList = [];
  Position? _position;
  Timer? _searchDebounce;
  /// 提交后、接口返回前：乐观标记「已反馈」；列表刷新后若后端 [currentUserFeedbackSubmitted] 为 true 则从此集合移除
  final Set<int> _localFeedbackSubmitted = {};

  bool get _phaseEnded => widget.phaseStatus == '3';

  /// 优先特典图，其次电影封面
  String? get _resolvedHeaderCoverUrl {
    final b = widget.benefitCoverUrl?.trim();
    if (b != null && b.isNotEmpty) return b;
    final m = widget.movieCoverUrl?.trim();
    if (m != null && m.isNotEmpty) return m;
    return null;
  }

  Widget _headerGradientPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3ECFF), Color(0xFFF0F4FF), Color(0xFFF7F8FA)],
        ),
      ),
    );
  }

  Widget _headerBackgroundLayer(String? url) {
    if (url != null && url.isNotEmpty) {
      return CustomExtendedImage(
        url,
        fit: BoxFit.cover,
        loadingWidget: _headerGradientPlaceholder(),
        errorWidget: _headerGradientPlaceholder(),
      );
    }
    return _headerGradientPlaceholder();
  }

  /// AppBar 顶部背景（有界高度，避免 Column/flexibleSpace 传入无限高）
  Widget _buildAppBarFlexibleBackground() {
    final url = _resolvedHeaderCoverUrl;
    return LayoutBuilder(
      builder: (context, constraints) {
        final topPad = MediaQuery.paddingOf(context).top;
        final twoLineTitle =
            widget.movieName != null && widget.movieName!.trim().isNotEmpty;
        final fallbackToolbar = (twoLineTitle ? 88.h : kToolbarHeight) + topPad;
        final h = constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : fallbackToolbar;
        return SizedBox(
          height: h,
          width: double.infinity,
          child: ClipRect(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(child: _headerBackgroundLayer(url)),
                Positioned.fill(
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.78),
                          border: Border(
                            bottom: BorderSide(
                              color: _showAppBarShadow
                                  ? Colors.black.withValues(alpha: 0.08)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 筛选区 header：由 [overlayChild] 撑开高度，底层铺满图 + 毛玻璃
  Widget _buildHeaderImageBackdrop({required Widget overlayChild}) {
    final url = _resolvedHeaderCoverUrl;
    return ClipRect(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(child: _headerBackgroundLayer(url)),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
              ),
            ),
          ),
          overlayChild,
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Analytics.instance.logEvent(Ev.benefitCinemaView, {
      P.movieId: widget.movieId,
      P.benefitId: widget.benefitId,
      P.reReleaseId: widget.reReleaseId,
    });
    _searchController.addListener(() => setState(() {}));
    _scrollController.addListener(_onScroll);
    _loadAreaTree();
    _initLocationThenLoad();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _refreshController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final shouldShadow = _scrollController.hasClients && _scrollController.offset > 10;
    if (shouldShadow != _showAppBarShadow) {
      setState(() => _showAppBarShadow = shouldShadow);
    }
  }

  Future<void> _initLocationThenLoad() async {
    final pos = await LocationUtil.getCurrentPosition();
    if (!mounted) return;
    setState(() => _position = pos);
    await _load(reset: true);
  }

  Future<void> _loadAreaTree() async {
    try {
      final res = await ApiRequest().request<List<dynamic>>(
        path: '/areas/tree',
        method: 'GET',
        fromJsonT: (json) => json as List<dynamic>,
      );
      if (!mounted) return;
      setState(() {
        _areaTreeList = (res.data ?? [])
            .map((item) => AreaResponse.fromJson(item as Map<String, dynamic>))
            .toList();
      });
    } catch (_) {}
  }

  Future<void> _load({required bool reset}) async {
    if (reset) {
      _page = 1;
      _loadFinished = false;
      if (!_loading) setState(() => _loading = true);
    }
    setState(() {
      _error = null;
      if (reset) _loading = true;
    });
    try {
      final bid = int.parse(widget.benefitId);
      final rr = widget.reReleaseId != null ? int.tryParse(widget.reReleaseId!) : null;
      final kw = _searchController.text.trim();
      final query = <String, dynamic>{
        'page': _page,
        'pageSize': _pageSize,
        'sort': _sort,
        if (rr != null) 'reReleaseId': rr,
        if (_regionId != null) 'regionId': _regionId,
        if (_prefectureId != null) 'prefectureId': _prefectureId,
        if (kw.isNotEmpty) 'keyword': kw,
        if (_position != null) 'latitude': _position!.latitude,
        if (_position != null) 'longitude': _position!.longitude,
      };
      final res = await ApiRequest().request<ApiPaginationResponse<BenefitCinemaAvailabilityItem>>(
        path: '/app/benefit/$bid/cinemas',
        method: 'GET',
        queryParameters: query,
        fromJsonT: (json) => ApiPaginationResponse<BenefitCinemaAvailabilityItem>.fromJson(
          json as Map<String, dynamic>,
          (data) => BenefitCinemaAvailabilityItem.fromJson(data as Map<String, dynamic>),
        ),
      );
      if (!mounted) return;
      final pageData = res.data;
      final chunk = pageData?.list ?? [];
      final total = pageData?.total ?? 0;
      setState(() {
        if (reset) {
          _list = List.of(chunk);
        } else {
          _list.addAll(chunk);
        }
        _total = total;
        _loadFinished = _list.length >= total || chunk.length < _pageSize;
        _loading = false;
        for (final item in _list) {
          final c = item.cinemaId;
          if (c != null && item.currentUserFeedbackSubmitted) {
            _localFeedbackSubmitted.remove(c);
          }
        }
      });
      if (reset) {
        _refreshController.finishRefresh();
      } else {
        _refreshController.finishLoad(_loadFinished ? IndicatorResult.noMore : IndicatorResult.success);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load';
      });
      _refreshController.finishRefresh();
      _refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _load(reset: true);
    });
  }

  void _clearSearch() {
    if (!mounted) return;
    _searchController.clear();
    setState(() {});
    _load(reset: true);
  }

  /// 标题下方常驻：影院名搜索（与场次页常见样式一致的大圆角输入框）
  Widget _buildHeaderSearchField() {
    return Container(
      width: double.infinity,
      height: 56.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE6E8EB), width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (_, value, __) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search_rounded, size: 26.sp, color: const Color(0xFF646566)),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  cursorColor: const Color(0xFF1989FA),
                  cursorWidth: 2,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: const Color(0xFF323233),
                    fontWeight: FontWeight.w500,
                    height: 1.0,
                  ),
                  decoration: InputDecoration(
                    hintText: S.of(context).benefit_availability_filter_search_hint,
                    hintStyle: TextStyle(
                      fontSize: 24.sp,
                      color: const Color(0xFF969799),
                      fontWeight: FontWeight.normal,
                      height: 1.0,
                    ),
                    border: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              if (value.text.isNotEmpty)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints.tightFor(width: 36.w, height: 36.h),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.clear_rounded, size: 22.sp, color: const Color(0xFF969799)),
                  onPressed: _clearSearch,
                ),
            ],
          );
        },
      ),
    );
  }

  FilterValue _convertArea(AreaResponse item) {
    return FilterValue(
      id: item.id.toString(),
      name: AreaI18nUtil.displayNameOf(context, item),
      children: item.children?.map(_convertArea).toList(),
    );
  }

  void _handleFilterChange(Map<String, dynamic> selected) {
    if (!mounted) return;
    int? regionId;
    int? prefectureId;
    if (selected.containsKey('areaId') && selected['areaId'] != null) {
      final ids = selected['areaId'] as List?;
        if (ids != null && ids.isNotEmpty && ids.first.toString().isNotEmpty) {
        regionId = int.tryParse(ids[0].toString());
        if (ids.length >= 2) prefectureId = int.tryParse(ids[1].toString());
      }
    }
    String sort = 'remainingDesc';
    if (selected.containsKey('sort') && selected['sort'] != null) {
      final s = selected['sort'];
      if (s is List && s.isNotEmpty && s.first.toString().isNotEmpty) {
        sort = s.first.toString();
      } else if (s is String && s.isNotEmpty) {
        sort = s;
      }
    }
    if (sort == 'distance' && _position == null) {
      ToastService.showInfo(S.of(context).benefit_availability_sort_locationDenied);
      return;
    }
    setState(() {
      _filterParams = Map<String, dynamic>.from(selected);
      _regionId = regionId;
      _prefectureId = prefectureId;
      _sort = sort;
    });
    _load(reset: true);
  }

  Future<void> _submitFeedback(BenefitCinemaAvailabilityItem item) async {
    final cid = item.cinemaId;
    if (cid == null || _phaseEnded) return;
    if (item.currentUserFeedbackSubmitted) return;
    if (_localFeedbackSubmitted.contains(cid)) return;

    setState(() => _localFeedbackSubmitted.add(cid));

    try {
      final res = await ApiRequest().request<void>(
        path: '/app/benefit/feedback',
        method: 'POST',
        data: {'cinemaId': cid, 'benefitId': int.parse(widget.benefitId), 'feedbackType': 1},
        fromJsonT: (_) {},
      );
      if (!mounted) return;
      if (res.code == 200) {
        ToastService.showToast(S.of(context).benefit_feedback_success, type: ToastType.success);
        await _load(reset: true);
      } else {
        setState(() => _localFeedbackSubmitted.remove(cid));
        ToastService.showToast(
          S.of(context).benefit_availability_feedback_submit_failed,
          type: ToastType.error,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _localFeedbackSubmitted.remove(cid));
      ToastService.showToast(
        S.of(context).benefit_availability_feedback_submit_failed,
        type: ToastType.error,
      );
    }
  }

  void _goBuy(BenefitCinemaAvailabilityItem item) {
    final mid = widget.movieId;
    final cid = item.cinemaId;
    if (cid == null) return;
    if ((item.showTimeCount ?? 0) <= 0) return;
    context.pushNamed(
      'showTimeDetail',
      pathParameters: {'id': mid},
      queryParameters: {
        'movieId': mid,
        'cinemaId': '$cid',
        if (widget.reReleaseId != null && widget.reReleaseId!.isNotEmpty) 'reReleaseId': widget.reReleaseId!,
      },
    );
  }

  String _stockLabel(int? status) {
    final s = S.of(context);
    switch (status) {
      case 1:
        return s.benefit_availability_status_sufficient;
      case 2:
        return s.benefit_availability_status_few;
      case 3:
        return s.benefit_availability_status_veryFew;
      case 4:
        return s.benefit_availability_status_soldOutAdmin;
      case 5:
        return s.benefit_availability_status_unknown;
      case 6:
        return s.benefit_availability_status_soldOutFeedback;
      default:
        return s.benefit_status_unknown;
    }
  }

  Color _stockColor(int? status) {
    switch (status) {
      case 1:
        return const Color(0xFF07C160);
      case 2:
        return Colors.amber.shade700;
      case 3:
        return Colors.red.shade600;
      case 4:
      case 6:
        return Colors.grey;
      case 5:
      default:
        return const Color(0xFF969799);
    }
  }

  String _formatNearestTime(String raw) {
    if (raw.length >= 16) return raw.substring(0, 16);
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final mainTitle = (widget.benefitName != null && widget.benefitName!.trim().isNotEmpty)
        ? widget.benefitName!.trim()
        : S.of(context).benefit_availability_pageTitle;
    final hasSubtitle = widget.movieName != null && widget.movieName!.trim().isNotEmpty;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        toolbarHeight: hasSubtitle ? 88.h : kToolbarHeight,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mainTitle,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: const Color(0xFF323233),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              if (hasSubtitle)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    widget.movieName!.trim(),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: const Color(0xFF646566),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFF323233),
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: _buildAppBarFlexibleBackground(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Expanded(
            child: AppErrorWidget(
              loading: _loading,
              error: _error != null,
              empty: !_loading && _error == null && _list.isEmpty,
              onRetry: () => _load(reset: true),
              errorMessage: _error,
              emptyWidget: _buildEmpty(),
              child: EasyRefresh(
                header: customHeader(context),
                footer: customFooter(context),
                controller: _refreshController,
                onRefresh: () async => await _load(reset: true),
                onLoad: () async {
                  if (_loadFinished) {
                    _refreshController.finishLoad(IndicatorResult.noMore);
                    return;
                  }
                  _page += 1;
                  await _load(reset: false);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                  itemCount: _list.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return _buildSummaryHeader();
                    return _buildCard(_list[index - 1]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ClipRect(
      child: _buildHeaderImageBackdrop(
        overlayChild: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            boxShadow: _showAppBarShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_phaseEnded)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7E6),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, size: 22.sp, color: const Color(0xFFED6A0C)),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                S.of(context).benefit_availability_phase_ended_banner,
                                style: TextStyle(fontSize: 22.sp, color: const Color(0xFFED6A0C)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    _buildHeaderSearchField(),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: const Color(0xFFF7F8FA),
                padding: EdgeInsets.only(top: 10.h, left: 12.w, right: 12.w, bottom: 12.h),
                child: _areaTreeList.isEmpty
                    ? SizedBox(
                        height: 52.h,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 18.sp,
                                height: 18.sp,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1989FA)),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                S.of(context).cinemaList_filter_loading,
                                style: TextStyle(fontSize: 22.sp, color: const Color(0xFF646566)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : FilterBar(
                        style: FilterBarStyle(
                          dropdownGap: 10.h,
                          drawerWidth: 600.w,
                          iconSize: 24.sp,
                          height: 56.h,
                          unselectedBackgroundColor: Colors.white,
                          unselectedBorderColor: const Color(0xFFE6E8EB),
                          selectedBackgroundColor: const Color(0xFFE8F3FF),
                          selectedBorderColor: const Color(0xFF1989FA),
                          borderRadius: 28.r,
                          textSize: 22.sp,
                          unselectedTextColor: const Color(0xFF323233),
                          selectedTextColor: const Color(0xFF1989FA),
                          unselectedIconColor: const Color(0xFF646566),
                          selectedIconColor: const Color(0xFF1989FA),
                        ),
                        filters: [
                          FilterOption(
                            key: 'areaId',
                            title: S.of(context).benefit_availability_filter_region,
                            type: FilterType.single,
                            nested: true,
                            icon: Icons.location_on_rounded,
                            values: [
                              FilterValue(id: '', name: S.of(context).about_components_showTimeList_all),
                              ..._areaTreeList
                                  .where((item) => item.name != null && item.name!.isNotEmpty)
                                  .map(_convertArea),
                            ],
                          ),
                          FilterOption(
                            key: 'sort',
                            title: S.of(context).benefit_availability_filter_sort,
                            type: FilterType.single,
                            nested: false,
                            icon: Icons.sort_rounded,
                            values: [
                              FilterValue(
                                id: 'remainingDesc',
                                name: S.of(context).benefit_availability_sort_remainingDesc,
                              ),
                              if (_position != null)
                                FilterValue(
                                  id: 'distance',
                                  name: S.of(context).benefit_availability_sort_distance,
                                ),
                              FilterValue(
                                id: 'default',
                                name: S.of(context).benefit_availability_sort_default,
                              ),
                            ],
                          ),
                        ],
                        initialSelected: _filterParams,
                        onConfirm: _handleFilterChange,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 12.h),
      child: Row(
        children: [
          Icon(Icons.local_activity_rounded, size: 22.sp, color: const Color(0xFF1989FA)),
          SizedBox(width: 6.w),
          Text(
            S.of(context).benefit_availability_count_label(_total),
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: const Color(0xFF323233)),
          ),
          const Spacer(),
          if (_position == null)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Text(
                S.of(context).benefit_availability_sort_locationDenied,
                style: TextStyle(fontSize: 20.sp, color: Colors.grey.shade500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height - 320.h,
        padding: EdgeInsets.symmetric(vertical: 100.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_rounded, size: 64.sp, color: Colors.grey.shade400),
              SizedBox(height: 16.h),
              Text(
                S.of(context).benefit_availability_empty,
                style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockIndicator(BenefitCinemaAvailabilityItem item, Color pc) {
    final remaining = item.remaining;
    final quota = item.quota;
    final unknown = remaining == null;
    final hasQuota = quota != null && quota > 0;
    double? ratio;
    if (!unknown && hasQuota) {
      ratio = (remaining / quota).clamp(0.0, 1.0);
    }
    final feedback = item.feedbackCount ?? 0;
    final stockIconSlot = 26.sp;
    final stockIconGap = 6.w;
    final stockTextInset = stockIconSlot + stockIconGap;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8.r),
        border: Border(left: BorderSide(color: pc, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: unknown ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: stockIconSlot,
                child: unknown
                    ? Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          size: 22.sp,
                          color: const Color(0xFF646566),
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_rounded,
                        size: 22.sp,
                        color: const Color(0xFF646566),
                      ),
              ),
              SizedBox(width: stockIconGap),
              Expanded(
                child: unknown
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Text(
                              S.of(context).benefit_remaining,
                              style: TextStyle(fontSize: 22.sp, color: const Color(0xFF646566)),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).benefit_availability_remaining_not_reported,
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF969799),
                                    height: 1.2,
                                  ),
                                ),
                                if (hasQuota) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    S.of(context).benefit_availability_remaining_quota_label(quota),
                                    style: TextStyle(fontSize: 20.sp, color: const Color(0xFF969799), height: 1.2),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      )
                    : Text.rich(
                        TextSpan(
                          style: TextStyle(height: 1.15),
                          children: [
                            TextSpan(
                              text: S.of(context).benefit_remaining,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: const Color(0xFF646566),
                                height: 1.2,
                              ),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: '$remaining',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: pc,
                                height: 1.05,
                              ),
                            ),
                            if (hasQuota)
                              TextSpan(
                                text: ' / $quota',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: const Color(0xFF969799),
                                  height: 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
              if (feedback > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.feedback_outlined, size: 16.sp, color: const Color(0xFFED6A0C)),
                      SizedBox(width: 4.w),
                      Text(
                        S.of(context).benefit_availability_feedback_n(feedback),
                        style: TextStyle(fontSize: 18.sp, color: const Color(0xFFED6A0C)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (ratio != null) ...[
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: stockTextInset),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6.h,
                  backgroundColor: pc.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(pc),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard(BenefitCinemaAvailabilityItem item) {
    final st = item.stockStatus;
    final ps = _stockLabel(st);
    final pc = _stockColor(st);
    final hasShowTime = (item.showTimeCount ?? 0) > 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        child: InkWell(
          onTap: hasShowTime ? () => _goBuy(item) : null,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.cinemaName ?? '',
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF323233),
                            ),
                          ),
                          if ((item.brandName ?? '').isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 2.h),
                              child: Text(
                                item.brandName!,
                                style: TextStyle(fontSize: 22.sp, color: const Color(0xFF969799)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: pc.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: pc.withValues(alpha: 0.4), width: 1),
                      ),
                      child: Text(
                        ps,
                        style: TextStyle(fontSize: 20.sp, color: pc, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                if ((item.fullAddress ?? '').isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1989FA).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(Icons.place_rounded, size: 18.sp, color: const Color(0xFF1989FA)),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item.fullAddress!,
                          style: TextStyle(fontSize: 22.sp, color: const Color(0xFF646566)),
                        ),
                      ),
                      if (item.distanceKm != null)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.blue.shade200, width: 1),
                          ),
                          child: Text(
                            S.of(context).benefit_availability_distance_km(
                                item.distanceKm!.toStringAsFixed(item.distanceKm! < 10 ? 1 : 0)),
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: hasShowTime ? const Color(0xFFF7F8FA) : const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Icon(
                          hasShowTime ? Icons.event_available_rounded : Icons.event_busy_rounded,
                          size: 28.sp,
                          color: hasShowTime ? const Color(0xFF1989FA) : const Color(0xFFED6A0C),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: hasShowTime
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S.of(context).benefit_availability_showtime_n(item.showTimeCount!),
                                    style: TextStyle(fontSize: 22.sp, color: const Color(0xFF323233)),
                                  ),
                                  if ((item.nearestShowTime ?? '').isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(top: 2.h),
                                      child: Text(
                                        S.of(context).benefit_availability_nearest_showtime(
                                            _formatNearestTime(item.nearestShowTime!)),
                                        style: TextStyle(fontSize: 20.sp, color: const Color(0xFF646566)),
                                      ),
                                    ),
                                ],
                              )
                            : Text(
                                S.of(context).benefit_availability_showtime_none,
                                style: TextStyle(fontSize: 22.sp, color: const Color(0xFFED6A0C)),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                _buildStockIndicator(item, pc),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_phaseEnded) ...[
                      Builder(
                        builder: (context) {
                          final cid = item.cinemaId;
                          final done = item.currentUserFeedbackSubmitted ||
                              (cid != null && _localFeedbackSubmitted.contains(cid));
                          return OutlinedButton.icon(
                            onPressed: done ? null : () => _submitFeedback(item),
                            icon: Icon(
                              done ? Icons.check_circle_outline : Icons.report_outlined,
                              size: 18.sp,
                              color: done ? const Color(0xFF969799) : const Color(0xFFED6A0C),
                            ),
                            label: Text(
                              done
                                  ? S.of(context).benefit_availability_action_feedback_done
                                  : S.of(context).benefit_availability_action_feedback,
                              style: TextStyle(
                                fontSize: 22.sp,
                                color: done ? const Color(0xFF969799) : const Color(0xFFED6A0C),
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: done ? const Color(0xFFDCDEE0) : const Color(0xFFED6A0C),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                              minimumSize: const Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      ),
                    ],
                    SizedBox(width: 10.w),
                    ElevatedButton.icon(
                      onPressed: hasShowTime ? () => _goBuy(item) : null,
                      icon: Icon(Icons.confirmation_number_outlined, size: 18.sp),
                      label: Text(
                        S.of(context).benefit_availability_action_buy,
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1989FA),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
