import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/customExtendedImage.dart';
import 'package:otaku_movie/components/dict.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/response/cinema/movie_ticket_type_response.dart';
import 'package:otaku_movie/response/movie/user_select_seat_data_response.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/utils/seat_cancel_manager.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/controller/SeatSelectionController.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../api/index.dart';
import '../../utils/index.dart';

class SelectMovieTicketType extends StatefulWidget {
  final String? movieShowTimeId;
  final String? cinemaId;

  const SelectMovieTicketType({super.key, this.movieShowTimeId, this.cinemaId});

  @override
  // ignore: library_private_types_in_public_api
  _SelectMovieTicketPageState createState() => _SelectMovieTicketPageState();
}

class _SelectMovieTicketPageState extends State<SelectMovieTicketType> {
  List<MovieTicketTypeResponse> movieTicketTypeData = [];
  UserSelectSeatDataResponse data = UserSelectSeatDataResponse();
  bool loading = true;
  bool error = false;

  /// 创建订单请求进行中，防止重复点击产生多个订单
  bool _creatingOrder = false;

  /// ムビチケ前売り券：购票号码（10位）、密码（4位）、使用张数
  final TextEditingController _mubitikeCodeController = TextEditingController();
  final TextEditingController _mubitikePasswordController =
      TextEditingController();
  int _mubitikeUseCount = 1;
  bool _mubitikePasswordObscure = true;

  Timer? _ticketTimer;
  late final SeatSelectionController seatSelectionController =
      Get.isRegistered<SeatSelectionController>()
          ? Get.find<SeatSelectionController>()
          : Get.put(SeatSelectionController(), permanent: true);

  int ticketCountDown = 0; // 秒

  /// 获取当前场次可用票种，成功返回 true，接口报错返回 false。
  /// 有 movieShowTimeId 时调用场次可用票种接口；否则按影院查票种列表。
  Future<bool> getMovieTicketType() async {
    try {
      final String path;
      final Map<String, dynamic> body;
      if (widget.movieShowTimeId != null) {
        path = '/movie_show_time/ticketType/list';
        body = {'movieShowTimeId': int.parse(widget.movieShowTimeId!)};
      } else {
        path = '/cinema/ticketType/list';
        body = {'cinemaId': int.parse(widget.cinemaId!)};
      }
      final res = await ApiRequest().request(
        path: path,
        method: 'POST',
        data: body,
        fromJsonT: (json) {
          if (json is List) {
            return json.map((item) {
              return MovieTicketTypeResponse.fromJson(item);
            }).toList();
          }
          return <MovieTicketTypeResponse>[];
        },
      );

      if (mounted) {
        setState(() {
          movieTicketTypeData = res.data ?? [];
        });
      }
      return true;
    } catch (e) {
      if (mounted) {
        setState(() {
          error = true;
          loading = false;
        });
      }
      return false;
    }
  }

  /// 获取用户选座数据，成功返回 true，接口报错或无可选座位返回 false
  Future<bool> getData() async {
    try {
      final res = await ApiRequest().request(
        path: '/movie_show_time/user_select_seat',
        method: 'GET',
        queryParameters: {
          "movieShowTimeId": int.parse(widget.movieShowTimeId!)
        },
        fromJsonT: (json) {
          return UserSelectSeatDataResponse.fromJson(json);
        },
      );

      // 如果接口没有返回用户已选择的座位信息，给出提示并显示异常界面
      if (res.data == null ||
          res.data?.seat == null ||
          res.data!.seat!.isEmpty) {
        if (mounted) {
          ToastService.showInfo(S.of(context).movieTicketType_noSeatInfoRetry);
          setState(() {
            error = true;
            loading = false;
          });
        }
        return false;
      }

      if (mounted) {
        setState(() {
          data = res.data ?? UserSelectSeatDataResponse();
        });
        // 配置场次信息（总时间由状态管理统一设置）
        seatSelectionController.configure(
          movieShowTimeId: data.movieShowTimeId,
          theaterHallId: data.theaterHallId,
        );
        // _restartTicketTimer();
      }
      return true;
    } catch (e) {
      if (mounted) {
        setState(() {
          error = true;
          loading = false;
        });
      }
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // 确保不在抑制期，并用状态管理的总时长初始化本页倒计时显示
    seatSelectionController.suppressOps.value = false;

    setState(() {
      ticketCountDown = seatSelectionController.totalSeconds.value;
      final base = seatSelectionController.totalSeconds.value;
      ticketCountDown = base > 0 ? base : ticketCountDown;
    });

    if (widget.cinemaId != null) {
      _loadInitialData();
    }
  }

  @override
  void dispose() {
    _ticketTimer?.cancel();
    _ticketTimer = null;
    _mubitikeCodeController.dispose();
    _mubitikePasswordController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // 页面离开（被覆盖/跳转）时，立即停止倒计时
    _ticketTimer?.cancel();
    _ticketTimer = null;
    super.deactivate();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // 当页面重新显示时，刷新座位数据以确保显示最新状态
  //   if (widget.movieShowTimeId != null) {
  //     getData();
  //   }
  // }

  // 加载初始数据：任一接口报错则显示异常界面
  Future<void> _loadInitialData() async {
    setState(() {
      loading = true;
      error = false;
    });

    final results = await Future.wait([
      getData(),
      getMovieTicketType(),
    ]);

    if (mounted) {
      setState(() {
        loading = false;
        // 任一接口失败则显示异常界面
        error = !(results[0] && results[1]);
      });
    }
  }

  // 刷新数据：任一接口报错则显示异常界面
  Future<void> _refreshData() async {
    setState(() {
      error = false;
    });

    final results = await Future.wait([
      getData(),
      getMovieTicketType(),
    ]);

    if (mounted) {
      setState(() {
        error = !(results[0] && results[1]);
      });
    }
  }

  void _restartTicketTimer() {
    _ticketTimer?.cancel();
    // 仅当当前路由在最前且不处于抑制期，且座位信息存在时启动倒计时
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    if (!mounted || !isCurrent) return;
    if (seatSelectionController.suppressOps.value) return;
    if (data.seat != null && data.seat!.isNotEmpty) {
      // 使用状态管理中的总时长作为初始值
      final base = seatSelectionController.totalSeconds.value;
      setState(() {
        ticketCountDown = (base > 0 ? base : 600);
      });
      // 下一帧启动，确保路由状态稳定
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ticketTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (!mounted) return;
          // 若页面不再最前或进入抑制期，立即停止计时
          final stillCurrent = ModalRoute.of(context)?.isCurrent ?? false;
          if (!stillCurrent || seatSelectionController.suppressOps.value) {
            timer.cancel();
            _ticketTimer = null;
            return;
          }
          if (ticketCountDown <= 0) {
            timer.cancel();
            await _handleTicketTimeout();
            return;
          }
          setState(() {
            ticketCountDown--;
          });
        });
      });
    }
  }

  Future<void> _handleTicketTimeout() async {
    if (!mounted) return;
    try {
      // 统一交由状态管理清理（仅座位，不涉及订单）
      await seatSelectionController.cancelSeatAndClear(context);
      // 返回到选座页（替换）
      if (data.movieShowTimeId != null && data.theaterHallId != null) {
        // 回退到 selectSeat
        Navigator.of(context).popUntil(
          (route) => route.settings.name == 'selectSeat',
        );
      } else {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // 失败也尝试返回
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text(S.of(context).movieTicketType_title,
            style: const TextStyle(color: Colors.white)),
        onBackButtonPressed: () async {
          // 选票页返回：直接回到上一步（选座页），不取消座位
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      body: AppErrorWidget(
        loading: loading,
        error: error,
        onRetry: _refreshData,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade50,
                  Colors.grey.shade100,
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 电影信息卡片 - 重新设计
                          Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white,
                                  Colors.grey.shade50,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // 电影海报
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.r),
                                    child: CustomExtendedImage(
                                      data.moviePoster ?? '',
                                      width: 230.w,
                                      height: 250.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 20.w),

                                // 电影信息
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 电影标题 + 倒计时（与 ConfirmOrder 风格保持一致）
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data.movieName ?? '',
                                              style: TextStyle(
                                                fontSize: 32.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // SizedBox(width: 12.w),
                                          // SizedBox(
                                          //   width: 125.w, // 固定宽度
                                          //   child: Container(
                                          //     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                          //     decoration: BoxDecoration(
                                          //       color: Colors.red.shade50,
                                          //       borderRadius: BorderRadius.circular(20.r),
                                          //       border: Border.all(color: Colors.red.shade200, width: 1),
                                          //     ),
                                          //     child: Row(
                                          //       mainAxisSize: MainAxisSize.min,
                                          //       mainAxisAlignment: MainAxisAlignment.center,
                                          //       children: [
                                          //         Icon(Icons.access_time, size: 18.sp, color: Colors.red.shade600),
                                          //         SizedBox(width: 6.w),
                                          //         Flexible(
                                          //           child: Text(
                                          //           _formatCountDown(ticketCountDown),
                                          //           style: TextStyle(
                                          //               fontSize: 18.sp,
                                          //               color: Colors.red.shade600,
                                          //               fontWeight: FontWeight.bold,
                                          //             ),
                                          //             textAlign: TextAlign.center,
                                          //             overflow: TextOverflow.ellipsis,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          //     ),
                                        ],
                                      ),

                                      SizedBox(height: 16.h),

                                      // 时间信息
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: Colors.blue.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.schedule,
                                              size: 20.sp,
                                              color: Colors.blue.shade600,
                                            ),
                                            SizedBox(width: 8.w),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 24.sp,
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: formatTime(
                                                      timeString: data.date,
                                                      format: S
                                                          .of(context)
                                                          .cinemaList_selectSeat_dateFormat,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '（${getDay(data.date ?? '', context)}）',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.blue.shade600,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 12.h),

                                      // 时间段和规格
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                            color: Colors.orange.shade200,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.movie,
                                              size: 20.sp,
                                              color: Colors.orange.shade600,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              '${data.startTime} ~ ${data.endTime}',
                                              style: TextStyle(
                                                fontSize: 22.sp,
                                                color: Colors.orange.shade700,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (data.specName != null &&
                                                      data.specName!.isNotEmpty)
                                                    Text(
                                                      data.specName!,
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        color: Colors
                                                            .orange.shade800,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  if (data.dimensionType !=
                                                      null) ...[
                                                    if (data.specName != null &&
                                                        data.specName!
                                                            .isNotEmpty)
                                                      SizedBox(width: 6.w),
                                                    Dict(
                                                      code: data.dimensionType,
                                                      name: 'dimensionType',
                                                      style: TextStyle(
                                                        fontSize: 18.sp,
                                                        color: Colors
                                                            .orange.shade800,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 16.h),

                                      // 影院信息
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 18.sp,
                                                  color: Colors.red.shade600,
                                                ),
                                                SizedBox(width: 6.w),
                                                Expanded(
                                                  child: Text(
                                                    data.cinemaName ?? '',
                                                    style: TextStyle(
                                                      fontSize: 22.sp,
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.chair,
                                                  size: 16.sp,
                                                  color: Colors.purple.shade600,
                                                ),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  data.theaterHallName ?? '',
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // ムビチケ前売り券（后端 allowPresale 为 true 时显示）- 改为弹框入口
                          if (data.allowPresale == true) ...[
                            _buildPresaleTicketEntry(),
                            SizedBox(height: 24.h),
                          ],

                          // 票种选择标题（固定票价时不显示）
                          if (data.pricingMode != 2)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 28.w, vertical: 24.h),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: Colors.blue.shade100,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.confirmation_number,
                                      color: Colors.blue.shade600,
                                      size: 22.sp,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S
                                              .of(context)
                                              .movieTicketType_selectMovieTicketType,
                                          style: TextStyle(
                                            fontSize: 26.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          S
                                              .of(context)
                                              .movieTicketType_selectTicketTypeForSeats,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.blue.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (data.pricingMode != 2) SizedBox(height: 20.h),

                          // 价格计算规则
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 22.sp,
                                        color: Colors.amber.shade800),
                                    SizedBox(width: 8.w),
                                    Text(
                                      S
                                          .of(context)
                                          .movieTicketType_priceRuleTitle,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  _isFixedPrice
                                      ? S.of(context).movieTicketType_priceRuleFormula_fixed
                                      : S.of(context).movieTicketType_priceRuleFormula,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.amber.shade800,
                                    height: 1.4,
                                  ),
                                ),
                                // 显示当前场次的规格和放映类型加价信息
                                if (data.specPriceList != null &&
                                        data.specPriceList!.isNotEmpty ||
                                    data.displayTypeSurcharge != null &&
                                        data.displayTypeSurcharge! > 0) ...[
                                  SizedBox(height: 12.h),
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          color: Colors.amber.shade300),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          S.of(context).movieTicketType_sessionSurchargeTitle,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.amber.shade900,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        // 放映类型加价
                                        if (data.displayTypeName != null &&
                                            data.displayTypeSurcharge != null &&
                                            data.displayTypeSurcharge! > 0)
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 4.h),
                                            child: Row(
                                              children: [
                                                Icon(Icons.visibility_rounded,
                                                    size: 16.sp,
                                                    color:
                                                        Colors.purple.shade600),
                                                SizedBox(width: 6.w),
                                                Text(
                                                  '${data.displayTypeName}：+${data.displayTypeSurcharge}${S.of(context).common_unit_jpy}',
                                                  style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color:
                                                        Colors.amber.shade800,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        // 规格加价列表
                                        if (data.specPriceList != null)
                                          ...data.specPriceList!
                                              .map((spec) => Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 4.h),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .movie_filter_rounded,
                                                            size: 16.sp,
                                                            color: Colors
                                                                .blue.shade600),
                                                        SizedBox(width: 6.w),
                                                        Text(
                                                          '${spec.name}：+${spec.plusPrice}${S.of(context).common_unit_jpy}',
                                                          style: TextStyle(
                                                            fontSize: 18.sp,
                                                            color: Colors
                                                                .amber.shade800,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // 座位信息列表 - 优化设计
                          ...data.seat == null
                              ? []
                              : data.seat!.asMap().entries.map((e) {
                                  final seatIndex = e.key;
                                  final item = e.value;
                                  return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 24.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(24.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // 座位信息头部
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // 座位号标签
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 6.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade50,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                  border: Border.all(
                                                      color:
                                                          Colors.blue.shade200),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.event_seat,
                                                      size: 18.sp,
                                                      color:
                                                          Colors.green.shade600,
                                                    ),
                                                    SizedBox(width: 6.w),
                                                    Text(
                                                      '${S.of(context).movieTicketType_seatNumber}：${item.seatName}',
                                                      style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors
                                                            .blue.shade700,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // 区域价格标签
                                              if (item.areaName != null)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.w,
                                                      vertical: 6.h),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.orange.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    border: Border.all(
                                                        color: Colors
                                                            .orange.shade200),
                                                  ),
                                                  child: Text(
                                                    '${item.areaName}（+${item.areaPrice}${S.of(context).common_unit_jpy}）',
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors
                                                          .orange.shade700,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),

                                          SizedBox(height: 16.h),

                                          // 票种选择按钮（固定票价时只显示固定票价标签）
                                          _isFixedPrice
                                              ? Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16.h,
                                                      horizontal: 20.w),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.shade50,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.r),
                                                    border: Border.all(
                                                        color: Colors
                                                            .blue.shade200),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.sell,
                                                          size: 22.sp,
                                                          color: Colors
                                                              .blue.shade700),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        S
                                                            .of(context)
                                                            .movieTicketType_fixedPrice,
                                                        style: TextStyle(
                                                          fontSize: 22.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors
                                                              .blue.shade800,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () => _showActionSheet(
                                                      context, item),
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 16.h,
                                                            horizontal: 20.w),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          item.movieTicketTypeId ==
                                                                  null
                                                              ? Colors
                                                                  .grey.shade100
                                                              : Colors.blue
                                                                  .shade500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.r),
                                                      border: Border.all(
                                                        color:
                                                            item.movieTicketTypeId ==
                                                                    null
                                                                ? Colors.grey
                                                                    .shade300
                                                                : Colors.blue
                                                                    .shade400,
                                                        width: 2,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: item.movieTicketTypeId ==
                                                                  null
                                                              ? Colors.grey
                                                                  .withValues(
                                                                      alpha:
                                                                          0.1)
                                                              : Colors.blue
                                                                  .withValues(
                                                                      alpha:
                                                                          0.2),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child:
                                                        item.movieTicketTypeId ==
                                                                null
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .add_circle_outline,
                                                                    size: 24.sp,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade600,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          12.w),
                                                                  Text(
                                                                    S
                                                                        .of(context)
                                                                        .movieTicketType_selectMovieTicketType,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          22.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : getTicketType(
                                                                item),
                                                  ),
                                                ),
                                          // 单人票价（票种下方、靠右、红色加大）
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${S.of(context).movieTicketType_singleSeatPrice}：',
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              Text(
                                                '${_seatPrice(item, seatIndex)}${S.of(context).common_unit_jpy}',
                                                style: TextStyle(
                                                  fontSize: 30.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          // 底部预留空间，避免最后一项被底部栏遮挡且防止底部溢出
                          SizedBox(
                              height: MediaQuery.of(context).padding.bottom +
                                  100.h),
                        ],
                      ),
                    ),
                  ),
                ),
                // 底部操作栏 - 优化设计（固定高度避免 Column 分配空间时底部溢出）
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.grey.shade50,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: SizedBox(
                      height: 88.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // 价格信息（含座位数量，明细在弹窗中显示）
                          Expanded(
                            child: InkWell(
                              onTap: (data.seat != null && data.seat!.isNotEmpty)
                                  ? () => _showPriceDetailSheet(context)
                                  : null,
                              borderRadius: BorderRadius.circular(8.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          S.of(context).movieTicketType_total,
                                          style: TextStyle(
                                            fontSize: 28.sp,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (data.seat != null && data.seat!.isNotEmpty) ...[
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.info_outline,
                                            size: 22.sp,
                                            color: Colors.grey.shade500,
                                          ),
                                        ],
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Text(
                                          '${getTotalPrice()}',
                                          style: TextStyle(
                                            color: Colors.red.shade600,
                                            fontSize: 42.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          S.of(context).common_unit_jpy,
                                          style: TextStyle(
                                            color: Colors.red.shade600,
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '（${data.seat?.length ?? 0}${S.of(context).movieTicketType_seatCountLabel}）',
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 20.w),

                          // 确认按钮（创建订单中禁用，防止重复提交产生多个订单）
                          Container(
                            width: 200.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: _creatingOrder
                                  ? Colors.grey
                                  : Colors.blue.shade500,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50.r),
                                onTap: _creatingOrder
                                    ? null
                                    : () {
                                        if (_creatingOrder) return;
                                        final canConfirm = _isFixedPrice ||
                                            data.seat!.every((item) =>
                                                item.movieTicketTypeId != null);

                                        if (canConfirm) {
                                          setState(() => _creatingOrder = true);
                                          final seatPayload = _isFixedPrice
                                              ? data.seat!
                                                  .map((s) => {
                                                        'x': s.x,
                                                        'y': s.y,
                                                        'seatId': s.seatId,
                                                        'movieTicketTypeId':
                                                            null,
                                                      })
                                                  .toList()
                                              : data.seat!
                                                  .map((s) => {
                                                        'x': s.x,
                                                        'y': s.y,
                                                        'seatId': s.seatId,
                                                        'movieTicketTypeId':
                                                            s.movieTicketTypeId,
                                                      })
                                                  .toList();
                                          final requestData = <String, dynamic>{
                                            'movieShowTimeId': int.parse(
                                                widget.movieShowTimeId!),
                                            'seat': seatPayload,
                                          };
                                          if (_mubitikeCodeController.text
                                                      .trim()
                                                      .length ==
                                                  10 &&
                                              _mubitikePasswordController.text
                                                      .trim()
                                                      .length ==
                                                  4) {
                                            requestData['mubitikeCode'] =
                                                _mubitikeCodeController.text
                                                    .trim();
                                            requestData['mubitikePassword'] =
                                                _mubitikePasswordController.text
                                                    .trim();
                                            requestData['mubitikeUseCount'] =
                                                _mubitikeUseCount;
                                          }
                                          ApiRequest()
                                              .request(
                                            path: '/movieOrder/create',
                                            method: 'POST',
                                            data: requestData,
                                            fromJsonT: (json) {
                                              return json;
                                            },
                                          )
                                              .then((res) {
                                            if (!mounted) return;
                                            setState(
                                                () => _creatingOrder = false);
                                            // RestBean：200=成功，其他为错误码（如 3203 部分座位不可用）
                                            if (res.code != 200) {
                                              // 创建订单失败：3203 时展示不可用座位名称（文档：unavailableSeatNames）
                                              if (res.code == 3203 &&
                                                  res.data != null &&
                                                  res.data is Map) {
                                                final errData = res.data as Map;
                                                final names = errData[
                                                    'unavailableSeatNames'];
                                                if (names is List &&
                                                    names.isNotEmpty) {
                                                  ToastService.showError(
                                                      S.of(context).movieTicketType_unavailableSeatsWithNames(names.join('、')));
                                                }
                                                // 通用错误文案由 ApiRequest 已 Toast
                                              }
                                              return;
                                            }
                                            final orderNumber =
                                                res.data?['orderNumber'];
                                            if (orderNumber == null) {
                                              ToastService.showError(
                                                  S.of(context).movieTicketType_createOrderNoOrderNumber);
                                              return;
                                            }
                                            // ignore: use_build_context_synchronously
                                            context.pushNamed('confirmOrder',
                                                queryParameters: {
                                                  'orderNumber': '$orderNumber'
                                                });
                                          }).catchError((_) {
                                            if (mounted)
                                              setState(
                                                  () => _creatingOrder = false);
                                          });
                                        } else {
                                          ToastService.showWarning(S
                                              .of(context)
                                              .movieTicketType_selectMovieTicketType);
                                        }
                                      },
                                child: Center(
                                  child: _creatingOrder
                                      ? SizedBox(
                                          width: 28.w,
                                          height: 28.h,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                              size: 24.sp,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              S
                                                  .of(context)
                                                  .movieTicketType_confirmOrder,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 预售券入口：点击打开弹框输入
  Widget _buildPresaleTicketEntry() {
    final isFilled = _isMubitikeFilled;
    return GestureDetector(
      onTap: () => _showPresaleTicketSheet(context),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isFilled ? Colors.green.shade50 : Colors.orange.shade50,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isFilled ? Colors.green.shade200 : Colors.orange.shade200,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: (isFilled ? Colors.green : Colors.orange)
                  .withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: SvgPicture.asset(
                  'assets/icons/movie-ticket-presale.svg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).movieTicketType_mubitikeTitle,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: (isFilled ? Colors.green : Colors.orange).shade900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S.of(context).movieTicketType_mubitikeDescription,
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    S.of(context).movieTicketType_mubitikeUsageLimit,
                    style: TextStyle(
                      fontSize: 22.sp,
                      color: (isFilled ? Colors.green : Colors.orange).shade700,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   isFilled
                  //       ? '${S.of(context).movieTicketType_mubitikeUseCount}：$_mubitikeUseCount'
                  //       : S.of(context).movieTicketType_mubitikeTapToInput,
                  //   style: TextStyle(
                  //     fontSize: 22.sp,
                  //     color: (isFilled ? Colors.green : Colors.orange).shade700,
                  //   ),
                  // ),
                ],
              ),
            ),
            Icon(
              isFilled ? Icons.check_circle : Icons.arrow_forward_ios,
              size: 22.sp,
              color: (isFilled ? Colors.green : Colors.orange).shade700,
            ),
          ],
        ),
      ),
    );
  }

  /// 价格明细弹窗：显示每个座位的实际计算票价（含预售券折扣后）
  void _showPriceDetailSheet(BuildContext context) {
    if (data.seat == null || data.seat!.isEmpty) return;
    final unit = S.of(context).common_unit_jpy;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          24.w, 20.h, 24.w,
          MediaQuery.of(context).padding.bottom + 24.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).movieTicketType_priceDetailTitle,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < data.seat!.length; i++) ...[
                    _priceDetailRow(data.seat![i], i, unit),
                    if (i < data.seat!.length - 1) SizedBox(height: 10.h),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  S.of(context).movieTicketType_total,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${getTotalPrice()}$unit',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  S.of(context).seatSelection_confirm,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 明细中单行：座位名 + 该座实际票价，使用预售券时标注「券抵」
  Widget _priceDetailRow(Seat seat, int seatIndex, String unit) {
    final price = _seatPrice(seat, seatIndex);
    final useMubitike = _isMubitikeFilled && seatIndex < _mubitikeUseCount;
    final seatName = seat.seatName?.isNotEmpty == true
        ? seat.seatName!
        : '${S.of(context).movieTicketType_seatNumber} ${seatIndex + 1}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          useMubitike
              ? '$seatName（${S.of(context).movieTicketType_priceDetail_mubitikeOffset}）'
              : seatName,
          style: TextStyle(
            fontSize: 22.sp,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$price$unit',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  /// 预售券输入弹框
  void _showPresaleTicketSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -4)),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(
                24.w, 16.h, 24.w, MediaQuery.of(context).padding.bottom + 24.h),
            child: StatefulBuilder(
              builder: (context, setStateLocal) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 拖拽指示条
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // 标题行（含关闭按钮）
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: SizedBox(
                        width: 40.w,
                        height: 40.w,
                        child: SvgPicture.asset(
                          'assets/icons/movie-ticket-presale.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Text(
                        S.of(context).movieTicketType_mubitikeTitle,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Icon(
                            Icons.close,
                            size: 32.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  S.of(context).movieTicketType_mubitikeDescription,
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  S.of(context).movieTicketType_mubitikeUsageLimit,
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  S.of(context).movieTicketType_mubitikeCode,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: _mubitikeCodeController,
                  cursorColor: Colors.orange.shade600,
                  style: TextStyle(fontSize: 28.sp, color: Colors.black87),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: S.of(context).movieTicketType_mubitikeCodeHint,
                    hintStyle: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.grey.shade400,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: Colors.orange.shade400, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 16.h),
                Text(
                  S.of(context).movieTicketType_mubitikePassword,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  key: ValueKey(_mubitikePasswordObscure),
                  controller: _mubitikePasswordController,
                  cursorColor: Colors.orange.shade600,
                  style: TextStyle(fontSize: 28.sp, color: Colors.black87),
                  maxLength: 4,
                  obscureText: _mubitikePasswordObscure,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: S.of(context).movieTicketType_mubitikePasswordHint,
                    hintStyle: TextStyle(
                      fontSize: 22.sp,
                      color: Colors.grey.shade400,
                    ),
                    counterText: '',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: Colors.orange.shade400, width: 1.5),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    suffixIcon: IconButton(
                      style: IconButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                      ),
                      icon: Icon(
                        _mubitikePasswordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey.shade600,
                        size: 28.sp,
                      ),
                      onPressed: () {
                        _mubitikePasswordObscure = !_mubitikePasswordObscure;
                        setStateLocal(() {});
                      },
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 20.h),
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.all(16.w),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade100,
                //     borderRadius: BorderRadius.circular(12.r),
                //     border: Border.all(color: Colors.grey.shade300),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         S.of(context).movieTicketType_mubitikeDetailsTitle,
                //         style: TextStyle(
                //           fontSize: 20.sp,
                //           fontWeight: FontWeight.w600,
                //           color: Colors.grey.shade800,
                //         ),
                //       ),
                //       SizedBox(height: 8.h),
                //       Text(
                //         S.of(context).movieTicketType_mubitikeDetails,
                //         style: TextStyle(
                //           fontSize: 22.sp,
                //           color: Colors.grey.shade700,
                //           height: 1.5,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r)),
                    ),
                    child: Text(
                      S.of(context).seatSelection_confirm,
                      style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  /// 单价 = areaPrice + 所选票种价格 + 规格加价之和 + 放映类型加价；总价 = 各座位单价之和
  ///
  /// 计算总规格加价（所有规格的加价之和）
  int get _totalSpecPlusPrice {
    if (data.specPriceList == null || data.specPriceList!.isEmpty) {
      return 0;
    }
    return data.specPriceList!
        .fold(0, (sum, spec) => sum + (spec.plusPrice ?? 0));
  }

  /// 获取放映类型加价（2D/3D）
  int get _displayTypeSurcharge => data.displayTypeSurcharge ?? 0;

  bool get _isFixedPrice => data.pricingMode == 2;

  /// 是否已填写ムビチケ（10位号码+4位密码），用于价格展示与提交
  bool get _isMubitikeFilled =>
      _mubitikeCodeController.text.trim().length == 10 &&
      _mubitikePasswordController.text.trim().length == 4 &&
      _mubitikeUseCount >= 1;

  /// 固定票价时单座价格 = fixedAmount（票种价）+ 区域加价 + 规格加价 + 放映类型加价
  int _fixedPricePerSeat(Seat item) =>
      (data.fixedAmount?.toInt() ?? 0) +
      (item.areaPrice ?? 0) +
      _totalSpecPlusPrice +
      _displayTypeSurcharge;

  /// 使用前売り券时单座价格：区域价 + 规格加价+放映类型加价（票种/固定基础价抵消）
  int _mubitikePricePerSeat(Seat item) =>
      (item.areaPrice ?? 0) + _totalSpecPlusPrice + _displayTypeSurcharge;

  /// 计算单个座位的票价（用于在座位上显示）
  /// 使用ムビチケ时：前 mubitikeUseCount 个座位只收 3D/IMAX 等加价，票价格抵消
  int _seatPrice(Seat item, int seatIndex) {
    final specPlus = _totalSpecPlusPrice;
    final displayPlus = _displayTypeSurcharge;
    final useMubitikeForSeat =
        _isMubitikeFilled && seatIndex < _mubitikeUseCount;
    if (useMubitikeForSeat) return _mubitikePricePerSeat(item);
    if (_isFixedPrice) return _fixedPricePerSeat(item);
    final area = item.areaPrice ?? 0;
    if (item.movieTicketTypeId != null) {
      try {
        final type = movieTicketTypeData
            .firstWhere((el) => el.id == item.movieTicketTypeId);
        return area + (type.price ?? 0) + specPlus + displayPlus;
      } catch (_) {
        return area + specPlus + displayPlus;
      }
    }
    return area + specPlus + displayPlus;
  }

  int getTotalPrice() {
    if (data.seat == null) return 0;
    if (_isMubitikeFilled) {
      int total = 0;
      for (int i = 0; i < data.seat!.length; i++) {
        if (i < _mubitikeUseCount) {
          total += _mubitikePricePerSeat(data.seat![i]);
        } else {
          total += _seatPrice(data.seat![i], i);
        }
      }
      return total;
    }
    if (_isFixedPrice) return data.seat!.fold<int>(0, (sum, s) => sum + _fixedPricePerSeat(s));
    return data.seat!.fold(0, (prev, current) {
      final areaPrice = current.areaPrice ?? 0;
      final specPlus = _totalSpecPlusPrice;
      final displayPlus = _displayTypeSurcharge;
      if (current.movieTicketTypeId != null) {
        try {
          final ticketType = movieTicketTypeData
              .firstWhere((el) => el.id == current.movieTicketTypeId);
          return prev +
              areaPrice +
              (ticketType.price ?? 0) +
              specPlus +
              displayPlus;
        } catch (_) {
          return prev + areaPrice + specPlus + displayPlus;
        }
      }
      return prev;
    });
  }

  Widget getTicketType(item) {
    try {
      MovieTicketTypeResponse data = movieTicketTypeData
          .firstWhere((el) => el.id == item.movieTicketTypeId);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.confirmation_number,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.name ?? '',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (data.description != null &&
                          data.description!.trim().isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          data.description!.trim(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              '${data.price ?? 0}${S.of(context).common_unit_jpy}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      // 如果没有找到匹配的票种，返回默认显示
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.help_outline,
                  size: 20.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                S.of(context).movieTicketType_unknownTicketType,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '0${S.of(context).common_unit_jpy}',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
    }
  }

  String _formatCountDown(int seconds) {
    if (seconds < 0) seconds = 0;
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _showActionSheet(BuildContext context, Seat seat) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 拖拽指示器
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // 标题（选择票种 36）
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 28.sp,
                      color: Colors.blue.shade600,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        S.of(context).movieTicketType_selectMovieTicketType,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // 票种列表（可滚动，避免高度溢出）
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.52,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  itemCount: movieTicketTypeData.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 70.w,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final el = movieTicketTypeData[index];
                    bool isSelected = el.id == seat.movieTicketTypeId;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          seat.movieTicketTypeId = el.id;
                          int idx = data.seat!.indexWhere(
                              (item) => item.seatName == seat.seatName);

                          if (idx != -1 &&
                              data.seat != null &&
                              idx < data.seat!.length) {
                            setState(() {
                              data.seat![idx].movieTicketTypeId = el.id;
                            });
                          }

                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 16.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 选中指示
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                size: 40.sp,
                                color: isSelected
                                    ? Colors.blue.shade600
                                    : Colors.grey.shade400,
                              ),
                              SizedBox(width: 12.w),

                              // 票种信息
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      el.name ?? '',
                                      style: TextStyle(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w500,
                                        color:  Colors.black87,
                                      ),
                                    ),
                                    if (el.description != null &&
                                        el.description!.trim().isNotEmpty) ...[
                                      SizedBox(height: 4.h),
                                      Text(
                                        el.description!.trim(),
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          color: Colors.grey.shade600,
                                          height: 1.35,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // 价格
                              Text(
                                '${el.price ?? 0}${S.of(context).common_unit_jpy}',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
            ],
            ),
          ),
        );
      },
    );
  }
}
