import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/presale/presale_detail_response.dart';

/// 预售券详情页（C 端）- 完整信息与规格
class PresaleDetail extends StatefulWidget {
  final String? id;

  const PresaleDetail({super.key, this.id});

  @override
  State<PresaleDetail> createState() => _PresaleDetailState();
}

class _PresaleDetailState extends State<PresaleDetail> {
  PresaleDetailResponse? _data;
  bool _loading = true;
  String? _error;
  int _selectedSpecIndex = 0;
  int _selectedBonusIndex = 0;
  int _carouselPageIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  final PageController _bonusPageController = PageController();
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() {
        if (_scrollController.offset > 200 && !_showTitle) {
          setState(() => _showTitle = true);
        } else if (_scrollController.offset <= 200 && _showTitle) {
          setState(() => _showTitle = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _bonusPageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (widget.id == null || widget.id!.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'ID missing';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ApiRequest().request<PresaleDetailResponse?>(
        path: '/app/presale/detail',
        method: 'GET',
        queryParameters: {'id': widget.id},
        fromJsonT: (json) => json is Map<String, dynamic> ? PresaleDetailResponse.fromJson(json) : null,
      );
      if (!mounted) return;
      setState(() {
        _data = res.data;
        _loading = false;
        _error = _data == null ? 'Failed to load' : null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Failed to load';
      });
    }
  }

  String _formatDate(dynamic v) {
    if (v == null) return '—';
    if (v is String) {
      final d = DateTime.tryParse(v);
      return d != null ? DateFormat('yyyy/MM/dd HH:mm').format(d) : v;
    }
    if (v is int) {
      final d = DateTime.fromMillisecondsSinceEpoch(v);
      return DateFormat('yyyy/MM/dd HH:mm').format(d);
    }
    return '—';
  }

  static const double _bottomBarHeight = 72;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: AppErrorWidget(
        loading: _loading,
        error: _error != null,
        onRetry: _load,
        errorMessage: _error,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                color: const Color(0xFFFF6B35),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
              if (_data != null)
                _buildAppBar(context)
                    else
                      SliverAppBar(
                        pinned: true,
                        leading: Padding(
                          padding: EdgeInsets.only(top: topPadding),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        backgroundColor: const Color(0xFFFF6B35),
                      ),
                    SliverToBoxAdapter(
                      child: _data != null ? _buildContent(context) : const SizedBox.shrink(),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: _bottomBarHeight + bottomPadding + 16.h),
                    ),
                  ],
                ),
              ),
            ),
            // 底部栏
            // if (_data != null) _buildBottomBar(context, bottomPadding),
          ],
        ),
      ),
    );
  }

  /// 顶部轮播图：优先用当前选中规格的图片，否则用全局 gallery/cover
  List<String> _topImageUrls() {
    final d = _data!;
    final specs = d.specifications ?? [];
    if (specs.isNotEmpty) {
      final spec = specs[_selectedSpecIndex.clamp(0, specs.length - 1)];
      final images = spec.images;
      if (images != null && images.isNotEmpty) return images;
    }
    final gallery = d.gallery;
    if (gallery != null && gallery.isNotEmpty) return gallery;
    final cover = d.cover;
    if (cover != null && cover.isNotEmpty) return [cover];
    return [];
  }

  Widget _buildAppBar(BuildContext context) {
    final urls = _topImageUrls();
    final expandedH = 810.h;
    final s = S.of(context);
    return SliverAppBar(
      floating: false,
      snap: false,
      expandedHeight: expandedH,
      pinned: true,
      collapsedHeight: 100.h >= 56.0 ? 100.h : 56.0,
      backgroundColor: Colors.blue,
      title: _showTitle
          ? Text(
              _data?.title ?? s.presaleDetail_title,
              style: TextStyle(color: Colors.white, fontSize: 34.sp),
            )
          : null,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: SvgPicture.asset('assets/icons/back.svg', width: 48.sp),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            urls.isNotEmpty
                ? CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: double.infinity,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: urls.length > 1,
                      autoPlay: urls.length > 1,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(milliseconds: 400),
                      onPageChanged: (index, _) {
                        if (mounted) setState(() => _carouselPageIndex = index);
                      },
                    ),
                    items: urls.map((url) {
                      return Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            color: const Color(0xFF1A1A1A),
                            child: CustomExtendedImage(url, fit: BoxFit.contain),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : Container(
                    color: const Color(0xFFFF6B35),
                    child: Center(child: Icon(Icons.confirmation_number_outlined, size: 80.sp, color: Colors.white70)),
                  ),
            if (urls.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.6, 1.0],
                      colors: [Colors.transparent, Colors.transparent, Colors.black26],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_carouselPageIndex + 1}/${urls.length}',
                        style: TextStyle(fontSize: 26.sp, color: Colors.white70),
                      ),
                      if (urls.length > 1)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: urls.asMap().entries.map((e) {
                            final isActive = e.key == _carouselPageIndex;
                            return Container(
                              width: isActive ? 8.w : 6.w,
                              height: 6.w,
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final d = _data!;
    final s = S.of(context);
    final gallery = d.gallery;
    final specs = d.specifications ?? [];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 14.h),
          // 标题
          Text(
            d.title ?? '',
            style: TextStyle(fontSize: 44.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
          ),
          SizedBox(height: 14.h),
          // 规格选择（加大卡片，点击后顶部图+下方详情同步切换为当前规格）
          if (specs.isNotEmpty) ...[
            // Text(s.presaleDetail_specs, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A))),
            SizedBox(height: 12.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(specs.length, (i) {
                  final spec = specs[i];
                  final name = spec.name ?? '';
                  final images = spec.images ?? [];
                  final firstImg = images.isNotEmpty ? images[0] : null;
                  final selected = i == _selectedSpecIndex;
                  final ticketTypeCode = spec.ticketType;
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedSpecIndex = i;
                            _carouselPageIndex = 0;
                            _selectedBonusIndex = 0;
                          });
                          _carouselController.animateToPage(0);
                          if (_bonusPageController.hasClients) {
                            _bonusPageController.jumpToPage(0);
                          }
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: 200.w,
                          height: 210.h,
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: selected ? const Color(0xFFE53935) : Colors.grey.shade300,
                              width: selected ? 1 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (firstImg != null && firstImg.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: SizedBox(
                                    height: 120.h,
                                    width: double.infinity,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        CustomExtendedImage(firstImg, fit: BoxFit.cover),
                                        if (ticketTypeCode != null)
                                          Positioned(
                                            top: 6.h,
                                            left: 6.w,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.6),
                                                borderRadius: BorderRadius.circular(10.r),
                                              ),
                                              child: Dict(
                                                name: 'presaleMubitikeType',
                                                code: ticketTypeCode,
                                                style: TextStyle(fontSize: 26.sp, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  height: 120.h,
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.confirmation_number_outlined, size: 36.sp, color: Colors.grey.shade400),
                                        if (ticketTypeCode != null) ...[
                                          SizedBox(height: 6.h),
                                          Dict(
                                            name: 'presaleMubitikeType',
                                            code: ticketTypeCode,
                                            style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(height: 8.h),
                              Text(
                                name.isEmpty ? '${s.presaleDetail_specs} ${i + 1}' : name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 26.sp, fontWeight: selected ? FontWeight.w600 : FontWeight.w500, color: const Color(0xFF333333)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 16.h),
            // 当前规格详情（随上方选中规格联动：价格、库存、特典等）
            _buildSpecCard(context, specs[_selectedSpecIndex.clamp(0, specs.length - 1)], isSelected: true),
            SizedBox(height: 16.h),
          ],
          // 销售期间高亮说明（参考图黄底提示）
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFFFE082), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.presaleDetail_salePeriodNote,
                  style: TextStyle(fontSize: 26.sp, color: const Color(0xFF5D4037), height: 1.4),
                ),
                SizedBox(height: 6.h),
                Text(
                  '${_formatDate(d.launchTime)} ～ ${_formatDate(d.endTime)}',
                  style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600, color: const Color(0xFF795548)),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // 基本信息卡片
          _buildInfoCard(
            context,
            children: [
              _infoRow(s.presaleDetail_applyMovie, d.movieName ?? '—'),
              _infoRow(s.presaleDetail_salePeriod, '${_formatDate(d.launchTime)} ～ ${_formatDate(d.endTime)}'),
              _infoRow(s.presaleDetail_usagePeriod, '${_formatDate(d.usageStart)} ～ ${_formatDate(d.usageEnd)}'),
              _infoRow(
                s.presaleDetail_perUserLimit,
                (d.perUserLimit == null || d.perUserLimit == 0) ? s.presaleDetail_noLimit : '${d.perUserLimit}',
              ),
              if (d.pickupNotes != null && d.pickupNotes!.isNotEmpty)
                _infoRow(s.presaleDetail_pickupNotes, d.pickupNotes!),
            ],
          ),
          SizedBox(height: 16.h),
          // 图集
          if (gallery != null && gallery.isNotEmpty) ...[
            _sectionTitle(s.presaleDetail_gallery),
            SizedBox(height: 6.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gallery.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, i) {
                final url = gallery[i];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      color: Colors.black12,
                      child: CustomExtendedImage(url, fit: BoxFit.contain),
                    ),
                  ),
                );

              },
            ),
            SizedBox(height: 20.h),
          ],
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A1A)),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade600)),
          SizedBox(width: 20.w),
          Expanded(child: Text(value, style: TextStyle(fontSize: 26.sp, color: const Color(0xFF333333)))),
        ],
      ),
    );
  }

  Widget _buildSpecCard(BuildContext context, PresaleSpecification spec, {bool isSelected = false}) {
    final s = S.of(context);
    final priceItems = spec.priceItems ?? [];
    final bonusTitle = spec.bonusTitle;
    final bonusDescription = spec.bonusDescription;
    final bonusImages = spec.bonusImages ?? [];
    final bonusIncluded = spec.bonusIncluded ?? false;
    final hasBonus = (bonusTitle != null && bonusTitle.isNotEmpty) || bonusIncluded;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (name.isNotEmpty)
          //   Padding(
          //     padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 12.h),
          //     child: Text(
          //       name,
          //       style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A1A)),
          //     ),
          //   ),
          if (priceItems.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.presaleDetail_price, style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w700, color: const Color(0xFF333333))),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        ...priceItems.asMap().entries.map((entry) {
                          final index = entry.key;
                          final p = entry.value;
                          final label = p.label ?? '';
                          final price = p.price ?? '';
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      label.isEmpty ? s.presaleDetail_price : label,
                                      style: TextStyle(fontSize: 26.sp, color: const Color(0xFF333333)),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700, color: const Color(0xFFE53935)),
                                      children: [
                                        TextSpan(text: '¥', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: const Color(0xFFE53935))),
                                        TextSpan(text: '$price'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (index != priceItems.length - 1) ...[
                                SizedBox(height: 10.h),
                                Divider(height: 1, color: Colors.grey.shade200),
                                SizedBox(height: 10.h),
                              ],
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 16.h),
          ],
          // 库存 / 配送
          // if (stock != null || deliveryType != null)
          //   Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16.w),
          //     child: Row(
          //       children: [
          //         if (stock != null)
          //           Text(
          //             '${s.presaleDetail_stock}: $stock',
          //             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF444444)),
          //           ),
          //         if (stock != null && deliveryType != null) SizedBox(width: 22.w),
          //         if (deliveryType != null)
          //           Text(
          //             '${s.presaleDetail_delivery}: ${deliveryType == 1 ? '虚拟' : deliveryType == 2 ? '实体' : '—'}',
          //             style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color(0xFF444444)),
          //           ),
          //       ],
          //     ),
          //   ),
          // if (stock != null || deliveryType != null) SizedBox(height: 16.h),
          // 特典
          if (hasBonus) ...[
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16.h, top: 32.h),
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 244, 231),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.card_giftcard, size: 32.sp, color: Colors.orange.shade700),
                            SizedBox(width: 8.w),
                            Text(s.presaleDetail_bonus, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700, color: Colors.orange.shade800)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right, size: 30.sp, color: Colors.orange.shade400),
                    ],
                  ),
                  if (bonusTitle != null && bonusTitle.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Text(bonusTitle, style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700, color: const Color(0xFF333333))),
                  ],
                  if (bonusDescription != null && bonusDescription.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Text(s.presaleDetail_bonusDescription, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w700, color: const Color(0xFF333333))),
                    SizedBox(height: 8.h),
                    Text(bonusDescription, style: TextStyle(fontSize: 26.sp, color: const Color(0xFF555555), height: 1.6)),
                  ],
                  if (bonusImages.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Text(s.presaleDetail_bonusCount(bonusImages.length), style: TextStyle(fontSize: 26.sp, color: Colors.grey.shade700)),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        color: Colors.black12,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PageView.builder(
                            controller: _bonusPageController,
                            itemCount: bonusImages.length,
                            onPageChanged: (index) => setState(() => _selectedBonusIndex = index),
                            itemBuilder: (_, i) {
                              return CustomExtendedImage(bonusImages[i], fit: BoxFit.contain);
                            },
                          ),
                        ),
                      ),
                    ),
                    if (bonusImages.length > 1) ...[
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 120.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: bonusImages.length,
                          separatorBuilder: (_, __) => SizedBox(width: 12.w),
                          itemBuilder: (_, i) {
                            final url = bonusImages[i];
                            final selected = i == _selectedBonusIndex;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: 120.w,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                    color: selected ? const Color(0xFFE53935) : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                              child: InkWell(
                                onTap: () {
                                  setState(() => _selectedBonusIndex = i);
                                  if (_bonusPageController.hasClients) {
                                    _bonusPageController.animateToPage(
                                      i,
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.r),
                                  child: CustomExtendedImage(url, fit: BoxFit.cover),
                                ),
                              ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            SizedBox(height: 18.h),
          ],
        ],
      ),
    );
  }
}
