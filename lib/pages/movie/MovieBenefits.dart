import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/CustomEasyRefresh.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/benefit/app_benefit_detail_response.dart';
import 'package:otaku_movie/response/cinema/cinemaList.dart';
import 'package:otaku_movie/response/api_pagination_response.dart';
import 'package:otaku_movie/response/area_response.dart';
import 'package:otaku_movie/utils/toast.dart';

/// 电影入场者特典页（C 端）- 展示该电影下所有特典阶段与物料
class MovieBenefits extends StatefulWidget {
  final String? id;
  final String? movieName;
  final String? reReleaseId;

  const MovieBenefits({super.key, this.id, this.movieName, this.reReleaseId});

  @override
  State<MovieBenefits> createState() => _MovieBenefitsState();
}

class _MovieBenefitsState extends State<MovieBenefits> {
  List<AppBenefitDetailResponse> _list = [];
  bool _loading = true;
  String? _error;
  List<CinemaListResponse> _cinemaList = [];
  List<CinemaListResponse> _allCinemaList = [];
  List<AreaResponse> _areaTreeList = [];
  int? _selectedPrefectureId; // 特典反馈弹窗中选中的地区（按都道府县/省份维度）
  final Map<int, int> _feedbackCinemaIds = {};
  final Set<int> _feedbackSubmitting = {};

  @override
  void initState() {
    super.initState();
    _load();
    _loadCinemaList();
    _loadAreaTree();
  }

  /// 加载全部影院列表，缓存到 _allCinemaList，再根据当前选中的地区做一次前端过滤
  Future<void> _loadCinemaList() async {
    try {
      final res = await ApiRequest().request<ApiPaginationResponse<CinemaListResponse>>(
        path: '/cinema/list',
        method: 'POST',
        data: {'page': 1, 'pageSize': 500},
        fromJsonT: (json) => ApiPaginationResponse<CinemaListResponse>.fromJson(
          json as Map<String, dynamic>,
          (data) => CinemaListResponse.fromJson(data as Map<String, dynamic>),
        ),
      );
      if (!mounted) return;
      final list = res.data?.list ?? [];
      setState(() {
        _allCinemaList = list;
        _cinemaList = _filterCinemasByPrefecture(_selectedPrefectureId);
      });
    } catch (_) {
      if (!mounted) return;
    }
  }

  /// 根据选中的地区在前端过滤影院列表
  List<CinemaListResponse> _filterCinemasByPrefecture(int? prefectureId) {
    if (_allCinemaList.isEmpty || prefectureId == null) {
      return List<CinemaListResponse>.from(_allCinemaList);
    }
    final area = _allPrefectures().firstWhere(
      (e) => e.id == prefectureId,
      orElse: () => AreaResponse(),
    );
    final name = area.name?.trim();
    if (name == null || name.isEmpty) {
      return List<CinemaListResponse>.from(_allCinemaList);
    }
    final filtered = _allCinemaList.where((c) {
      final addr = (c.fullAddress ?? c.address ?? '').trim();
      return addr.contains(name);
    }).toList();
    if (filtered.isEmpty) {
      return List<CinemaListResponse>.from(_allCinemaList);
    }
    return filtered;
  }

  void _showPhaseCinemaSheet(BuildContext context, AppBenefitDetailResponse phase) {
    final names = _getCinemaNamesForPhase(phase);
    if (names.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h + MediaQuery.of(ctx).viewPadding.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      margin: EdgeInsets.only(bottom: 20.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCDEE0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  Text(
                    S.of(context).benefit_limit_cinema,
                    style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600, color: const Color(0xFF323233)),
                  ),
                  if ((phase.name ?? '').isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      phase.name!,
                      style: TextStyle(fontSize: 24.sp, color: const Color(0xFF646566)),
                    ),
                  ],
                  SizedBox(height: 16.h),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 360.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: names.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: const Color(0xFFEBEDF0)),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: Text(
                              names[index],
                              style: TextStyle(fontSize: 26.sp, color: const Color(0xFF323233)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
    } catch (_) {
      if (!mounted) return;
    }
  }

  List<AreaResponse> _allPrefectures() {
    final List<AreaResponse> result = [];
    for (final region in _areaTreeList) {
      if (region.children == null) continue;
      for (final pref in region.children!) {
        result.add(pref);
      }
    }
    return result;
  }

  /// 获取某个特典阶段对应的影院名称列表（优先使用后端返回的 cinemaNames，其次用 cinemaIds 在本地影院列表中匹配）
  List<String> _getCinemaNamesForPhase(AppBenefitDetailResponse phase) {
    final names = <String>[];
    if (phase.cinemaNames != null && phase.cinemaNames!.isNotEmpty) {
      names.addAll(phase.cinemaNames!.where((e) => e.trim().isNotEmpty).map((e) => e.trim()));
    } else if (phase.cinemaIds != null && phase.cinemaIds!.isNotEmpty && _allCinemaList.isNotEmpty) {
      final idSet = phase.cinemaIds!.toSet();
      for (final c in _allCinemaList) {
        final id = c.id;
        if (id != null && idSet.contains(id) && (c.name ?? '').trim().isNotEmpty) {
          names.add(c.name!.trim());
        }
      }
    }
    return names;
  }

  Future<void> _load() async {
    final movieId = widget.id != null ? int.tryParse(widget.id!) : null;
    final reReleaseId = widget.reReleaseId != null ? int.tryParse(widget.reReleaseId!) : null;
    if (movieId == null) {
      setState(() {
        _loading = false;
        _error = 'Invalid movie id';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ApiRequest().request<List<AppBenefitDetailResponse>>(
        path: '/app/benefit/list',
        method: 'GET',
        queryParameters: {
          'movieId': movieId,
          if (reReleaseId != null) 'reReleaseId': reReleaseId,
        },
        fromJsonT: (json) {
          if (json is! List) return <AppBenefitDetailResponse>[];
          return json.map((e) => AppBenefitDetailResponse.fromJson(e as Map<String, dynamic>)).toList();
        },
      );
      if (!mounted) return;
      setState(() {
        _list = res.data ?? [];
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load';
      });
    }
  }

  String _formatDate(String? d) {
    if (d == null || d.isEmpty) return '—';
    final parsed = DateTime.tryParse(d);
    if (parsed == null) return d;
    return '${parsed.year}/${parsed.month.toString().padLeft(2, '0')}/${parsed.day.toString().padLeft(2, '0')}';
  }

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path.startsWith('http') ? path : '${Config.imageBaseUrl}$path';
  }

  /// 数字格式化：千、万（中日用千/万，英文用K/万）
  String _formatNumber(int? n) {
    if (n == null) return '—';
    final s = S.of(context);
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(n % 10000 == 0 ? 0 : 1)}${s.benefit_unit_tenThousand}';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}${s.benefit_unit_thousand}';
    return '$n';
  }

  /// 是否有限定条件（放映类型/规格/影院）
  bool _hasLimit(AppBenefitDetailResponse phase) {
    if (phase.dimensionType != null) return true;
    if (phase.specNames != null && phase.specNames!.isNotEmpty) return true;
    if ((phase.cinemaLimitType != null && phase.cinemaLimitType! > 0) ||
        (phase.cinemaIds != null && phase.cinemaIds!.isNotEmpty)) {
      return true;
    }
    return false;
  }

  List<Widget> _buildLimitTags(AppBenefitDetailResponse phase) {
    final tags = <Widget>[];
    if (phase.dimensionType != null) {
      final label = phase.dimensionType == 1
          ? S.of(context).benefit_limit_dimension_2d
          : phase.dimensionType == 2
              ? S.of(context).benefit_limit_dimension_3d
              : '${phase.dimensionType}D';
      tags.add(_limitTag(label));
    }
    if (phase.specNames != null && phase.specNames!.isNotEmpty) {
      for (final name in phase.specNames!) {
        if (name.isNotEmpty) tags.add(_limitTag(name));
      }
    }
    if ((phase.cinemaLimitType != null && phase.cinemaLimitType! > 0) ||
        (phase.cinemaIds != null && phase.cinemaIds!.isNotEmpty)) {
      if (phase.cinemaNames != null && phase.cinemaNames!.isNotEmpty) {
        for (final name in phase.cinemaNames!) {
          if (name.isNotEmpty) tags.add(_limitTag(name));
        }
      } else {
        tags.add(_limitTag(S.of(context).benefit_limit_cinema));
      }
    }
    return tags;
  }

  Widget _limitTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1989FA).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 22.sp, color: const Color(0xFF1989FA), fontWeight: FontWeight.w500),
      ),
    );
  }

  /// 阶段状态文案与颜色：1=未开始 2=进行中 3=已结束（与字典 benefitPhaseStatus 一致）
  ({String label, Color color}) _phaseStatusLabel(int? status) {
    switch (status) {
      case 1:
        return (label: S.of(context).benefit_phaseStatus_before, color: const Color(0xFF1989FA));
      case 3:
        return (label: S.of(context).benefit_phaseStatus_ended, color: const Color(0xFF969799));
      case 2:
      default:
        return (label: S.of(context).benefit_phaseStatus_ongoing, color: const Color(0xFF07C160));
    }
  }

  /// 取阶段状态：优先用接口返回的 status，否则按 startDate/endDate 计算（与后端一致）
  int _effectivePhaseStatus(AppBenefitDetailResponse phase) {
    if (phase.status != null) return phase.status!;
    final now = DateTime.now();
    final start = phase.startDate != null && phase.startDate!.isNotEmpty
        ? DateTime.tryParse(phase.startDate!) : null;
    final end = phase.endDate != null && phase.endDate!.isNotEmpty
        ? DateTime.tryParse(phase.endDate!) : null;
    if (end != null && now.isAfter(end)) return 3;
    if (start != null && now.isBefore(start)) return 1;
    return 2;
  }

  /// 特典库存状态：未知(null) | 已领完(0) | 极少/少量/充足(>0)
  ({String label, Color color}) _benefitStatus(AppBenefitDetailResponse phase) {
    final total = phase.quantity ?? 0;
    final remaining = phase.remainingQuantity;
    if (remaining == null) return (label: S.of(context).benefit_status_unknown, color: const Color(0xFF969799));
    if (remaining <= 0) return (label: S.of(context).benefit_status_soldOut, color: Colors.grey);
    if (total > 0) {
      final ratio = remaining / total;
      if (ratio < 0.1) return (label: S.of(context).benefit_status_veryFew, color: Colors.red);
      if (ratio < 0.3) return (label: S.of(context).benefit_status_few, color: Colors.amber);
    }
    return (label: S.of(context).benefit_status_sufficient, color: Colors.green);
  }

  void _showFullImage(BuildContext context, String url) {
    if (url.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: CustomExtendedImage(
                url,
                fit: BoxFit.contain,
                width: MediaQuery.of(ctx).size.width,
                height: MediaQuery.of(ctx).size.height,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.movieName != null && widget.movieName!.isNotEmpty
        ? '${widget.movieName} - ${S.of(context).benefit_pageTitle}'
        : S.of(context).benefit_pageTitle;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF323233),
        elevation: 0,
        actions: const [],
      ),
      body: EasyRefresh(
        header: customHeader(context),
        onRefresh: () async => await _load(),
        child: AppErrorWidget(
          loading: _loading,
          error: _error != null,
          empty: !_loading && _error == null && _list.isEmpty,
          onRetry: _load,
          errorMessage: _error,
          emptyWidget: Center(
            child: Padding(
              padding: EdgeInsets.all(48.w),
              child: Text(
                S.of(context).benefit_empty,
                style: TextStyle(fontSize: 28.sp, color: const Color(0xFF969799)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: _list.length,
            itemBuilder: (context, index) {
              final phase = _list[index];
              return _buildPhaseCard(phase);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    // 1 张：1 列铺满；2 张：平分 2 列；3 张：平分 3 列；超过 3 张：横向滑动
    if (images.length <= 3) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final spacing = 12.w;
          final count = images.length;
          final totalSpacing = spacing * (count - 1);
          final itemWidth = (constraints.maxWidth - totalSpacing) / count;
          return Row(
            children: List.generate(count, (index) {
              final url = _imageUrl(images[index]);
              return Padding(
                padding: EdgeInsets.only(right: index == count - 1 ? 0 : spacing),
                child: GestureDetector(
                  onTap: () => _showFullImage(context, url),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomExtendedImage(
                      url,
                      width: itemWidth,
                      // height: itemWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      );
    }

    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final url = _imageUrl(images[index]);
          return GestureDetector(
            onTap: () => _showFullImage(context, url),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CustomExtendedImage(
                url,
                width: 200.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhaseCard(AppBenefitDetailResponse phase) {
    final images = phase.imageUrls ?? [];
    final items = phase.items ?? [];
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    phase.name ?? '',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323233),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Builder(
                  builder: (context) {
                    final ps = _phaseStatusLabel(_effectivePhaseStatus(phase));
                    return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: ps.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          ps.label,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: ps.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                if (phase.quantity != null || phase.remainingQuantity != null) ...[
                  SizedBox(width: 12.w),
                  Builder(
                    builder: (context) {
                      final status = _benefitStatus(phase);
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: status.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          status.label,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: status.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            SizedBox(height: 8.h),
            if (phase.startDate != null && phase.startDate!.isNotEmpty || phase.endDate != null && phase.endDate!.isNotEmpty)
              Row(
                children: [
                  Text(
                    '${S.of(context).benefit_period}: ',
                    style: TextStyle(fontSize: 24.sp, color: const Color(0xFF969799)),
                  ),
                  Text(
                    '${_formatDate(phase.startDate)} ～ ${phase.endDate != null && phase.endDate!.isNotEmpty ? _formatDate(phase.endDate!) : '—'}',
                    style: TextStyle(fontSize: 24.sp, color: const Color(0xFF646566)),
                  ),
                ],
              ),
            if (_hasLimit(phase)) ...[
              SizedBox(height: 12.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${S.of(context).benefit_limit}：',
                    style: TextStyle(fontSize: 24.sp, color: const Color(0xFF969799)),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _getCinemaNamesForPhase(phase).isNotEmpty
                          ? () => _showPhaseCinemaSheet(context, phase)
                          : null,
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 6.h,
                        children: _buildLimitTags(phase),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (phase.quantity != null || phase.remainingQuantity != null) ...[
              SizedBox(height: 12.h),
              Wrap(
                spacing: 16.w,
                runSpacing: 6.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (phase.quantity != null)
                    Text(
                      '${S.of(context).benefit_total}：${_formatNumber(phase.quantity)}',
                      style: TextStyle(fontSize: 24.sp, color: const Color(0xFF646566)),
                    ),
                  Text(
                    '${S.of(context).benefit_remaining}：${phase.remainingQuantity == null ? S.of(context).benefit_status_unknown : _formatNumber(phase.remainingQuantity)}',
                    style: TextStyle(fontSize: 24.sp, color: const Color(0xFF646566)),
                  ),
                ],
              ),
            ],
            if (phase.description != null && phase.description!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                phase.description!,
                style: TextStyle(fontSize: 26.sp, color: const Color(0xFF646566), height: 1.4),
              ),
            ],
            if (images.isNotEmpty) ...[
              SizedBox(height: 16.h),
              _buildImageGallery(images),
            ],
            if (items.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                S.of(context).benefit_items,
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600, color: const Color(0xFF323233)),
              ),
              SizedBox(height: 8.h),
              ...items.map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: GestureDetector(
                              onTap: () => _showFullImage(context, _imageUrl(item.imageUrl)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: CustomExtendedImage(
                                  _imageUrl(item.imageUrl),
                                  width: 64.w,
                                  height: 64.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        Expanded(
                          child: Text(
                            item.name ?? '',
                            style: TextStyle(fontSize: 24.sp, color: const Color(0xFF646566)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            if (_effectivePhaseStatus(phase) == 2) ...[
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _showFeedbackSheet(context, initialPhase: phase),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: Icon(Icons.feedback_outlined, size: 26.sp, color: const Color(0xFF1989FA)),
                  label: Text(
                    S.of(context).benefit_feedback_button,
                    style: TextStyle(fontSize: 24.sp, color: const Color(0xFF1989FA), fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback(AppBenefitDetailResponse phase) async {
    if (phase.id == null) return;
    final cinemaId = _feedbackCinemaIds[phase.id!];
    if (cinemaId == null) {
      ToastService.showInfo(S.of(context).benefit_feedback_please_select_cinema);
      return;
    }
    setState(() => _feedbackSubmitting.add(phase.id!));
    try {
      final res = await ApiRequest().request<void>(
        path: '/app/benefit/feedback',
        method: 'POST',
        data: {'cinemaId': cinemaId, 'benefitId': phase.id, 'feedbackType': 1},
        fromJsonT: (_) => null,
      );
      if (!mounted) return;
      if (res.code == 200) {
        ToastService.showToast(S.of(context).benefit_feedback_success, type: ToastType.success);
      }
    } finally {
      if (mounted) setState(() => _feedbackSubmitting.remove(phase.id!));
    }
  }

  void _showFeedbackSheet(BuildContext context, {required AppBenefitDetailResponse initialPhase}) {
    final AppBenefitDetailResponse selectedPhase = initialPhase;
    int? selectedCinemaId;
    int? selectedPrefectureId = _selectedPrefectureId;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            top: false,
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h + MediaQuery.of(ctx).viewPadding.bottom),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      Center(
                        child: Container(
                          width: 40.w,
                          height: 4.h,
                          margin: EdgeInsets.only(bottom: 20.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCDEE0),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).benefit_feedback_button,
                        style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600, color: const Color(0xFF323233)),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        S.of(context).benefit_feedback_hint,
                        style: TextStyle(fontSize: 26.sp, color: const Color(0xFF969799), height: 1.45),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).orderDetail_benefit_feedback_benefit_label,
                            style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500, color: const Color(0xFF323233)),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              selectedPhase.name ?? '—',
                              style: TextStyle(fontSize: 26.sp, color: const Color(0xFF323233)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              S.of(context).benefit_feedback_select_cinema,
                              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500, color: const Color(0xFF323233)),
                            ),
                          ),
                          if (selectedPrefectureId != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1989FA).withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(999.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.place_outlined, size: 18.sp, color: const Color(0xFF1989FA)),
                                  SizedBox(width: 4.w),
                                  Text(
                                    _allPrefectures().firstWhere(
                                          (e) => e.id == selectedPrefectureId,
                                          orElse: () => AreaResponse(),
                                        ).name ??
                                        '',
                                    style: TextStyle(fontSize: 22.sp, color: const Color(0xFF1989FA)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (_allPrefectures().isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        DropdownButtonFormField<int?>(
                          initialValue: selectedPrefectureId,
                          isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          filled: true,
                          fillColor: const Color(0xFFF7F8FA),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(color: Color(0xFFEBEDF0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(color: Color(0xFF1989FA), width: 1.5),
                          ),
                        ),
                          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 26.sp, color: const Color(0xFF969799)),
                          dropdownColor: Colors.white,
                          menuMaxHeight: 360.h,
                          hint: Text(
                            S.of(context).cinemaList_filter_title,
                            style: TextStyle(fontSize: 28.sp, color: const Color(0xFF969799)),
                          ),
                          items: _allPrefectures()
                              .map(
                                (item) => DropdownMenuItem<int?>(
                                  value: item.id,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.h),
                                    child: Text(
                                      item.name ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 28.sp, color: const Color(0xFF323233)),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setModalState(() {
                              selectedPrefectureId = v;
                              selectedCinemaId = null;
                            });
                            if (!mounted) return;
                            setState(() {
                              _selectedPrefectureId = v;
                              _cinemaList = _filterCinemasByPrefecture(v);
                            });
                          },
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Builder(
                        builder: (context) {
                          // 去重并过滤无效 id，避免 Dropdown 出现重复 value 或 value 不在列表中的报错
                          final List<CinemaListResponse> uniqueCinemaList = [];
                          final Set<int> seenIds = {};
                          for (final c in _cinemaList) {
                            final id = c.id;
                            if (id == null) continue;
                            if (seenIds.add(id)) {
                              uniqueCinemaList.add(c);
                            }
                          }
                          final Set<int> cinemaIds = uniqueCinemaList.map((e) => e.id!).toSet();
                          final int? safeSelectedCinemaId =
                              (selectedCinemaId != null && cinemaIds.contains(selectedCinemaId)) ? selectedCinemaId : null;

                          return DropdownButtonFormField<int?>(
                            key: ValueKey('cinema_${_cinemaList.length}_${selectedPrefectureId ?? 'all'}'),
                            initialValue: safeSelectedCinemaId,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                              filled: true,
                              fillColor: const Color(0xFFF7F8FA),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: Color(0xFFEBEDF0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: Color(0xFF1989FA), width: 1.5),
                              ),
                            ),
                            icon: Icon(Icons.keyboard_arrow_down_rounded, size: 26.sp, color: const Color(0xFF969799)),
                            dropdownColor: Colors.white,
                            menuMaxHeight: 360.h,
                            hint: Text(
                              S.of(context).benefit_feedback_select_cinema,
                              style: TextStyle(fontSize: 28.sp, color: const Color(0xFF969799)),
                            ),
                            items: [
                              DropdownMenuItem<int?>(
                                value: null,
                                child: Text(
                                  S.of(context).benefit_feedback_select_cinema,
                                  style: TextStyle(fontSize: 28.sp, color: const Color(0xFF969799)),
                                ),
                              ),
                              ...uniqueCinemaList.map(
                                (c) => DropdownMenuItem<int?>(
                                  value: c.id,
                                  child: Text(
                                    c.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 28.sp, color: const Color(0xFF323233)),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (v) => setModalState(() => selectedCinemaId = v),
                          );
                        },
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        height: 88.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1989FA),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          ),
                          onPressed: () async {
                            if (selectedCinemaId == null) {
                              ToastService.showInfo(S.of(context).benefit_feedback_please_select_cinema);
                              return;
                            }
                            setState(() => _feedbackCinemaIds[selectedPhase.id!] = selectedCinemaId!);
                            await _submitFeedback(selectedPhase);
                            if (ctx.mounted) Navigator.of(ctx).pop();
                          },
                          child: Text(S.of(context).benefit_feedback_submit, style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ));
              },
            ),
          ),
        );
      },
    );
  }
}
