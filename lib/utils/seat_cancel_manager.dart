import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:otaku_movie/generated/l10n.dart';

/// 座位取消管理工具类
class SeatCancelManager {

  /// 保存座位选择信息到本地存储
  static Future<void> saveSeatSelection({
    required int movieShowTimeId,
    required int theaterHallId,
    required List<Map<String, dynamic>> selectedSeats,
  }) async {
    // 这里可以使用SharedPreferences或其他本地存储方式
    // 暂时使用内存存储，实际项目中建议使用SharedPreferences
    _SeatSelectionData.seatData = {
      'movieShowTimeId': movieShowTimeId,
      'theaterHallId': theaterHallId,
      'selectedSeats': selectedSeats,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  /// 获取当前保存的座位选择信息
  static Map<String, dynamic>? getCurrentSeatSelection() {
    return _SeatSelectionData.seatData;
  }

  /// 清除座位选择信息
  static void clearSeatSelection() {
    _SeatSelectionData.seatData = null;
  }

  /// 检查是否有已选择的座位
  static bool hasSelectedSeats() {
    final data = getCurrentSeatSelection();
    if (data == null) return false;
    
    final selectedSeats = data['selectedSeats'] as List?;
    return selectedSeats != null && selectedSeats.isNotEmpty;
  }

  /// 显示统一的取消确认对话框
  static Future<bool> showCancelDialog(BuildContext context, {
    required String title,
    required String content,
    required String cancelText,
    required String confirmText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: 640.w,
            margin: EdgeInsets.symmetric(horizontal: 32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                Padding(
                  padding: EdgeInsets.only(top: 52.h, bottom: 16.h),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323233),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                
                // 内容
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // 按钮组 - Vant 风格的横向分割按钮
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFEBEDF0),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // 取消按钮
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(false);
                            },
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(32.r),
                            ),
                            child: Container(
                              height: 100.h,
                              alignment: Alignment.center,
                              child: Text(
                                cancelText,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xFF323233),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      // 分割线
                      Container(
                        width: 1,
                        height: 100.h,
                        color: const Color(0xFFEBEDF0),
                      ),
                      
                      // 确认按钮
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(32.r),
                            ),
                            child: Container(
                              height: 100.h,
                              alignment: Alignment.center,
                              child: Text(
                                confirmText,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xFFEE0A24),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  /// 显示取消座位确认对话框
  static Future<bool> showCancelSeatDialog(BuildContext context) async {
    return await showCancelDialog(
      context,
      title: S.of(context).seatSelection_cancelSeatTitle,
      content: S.of(context).seatSelection_cancelSeatConfirm,
      cancelText: S.of(context).confirmOrder_continuePay,
      confirmText: S.of(context).confirmOrder_confirmCancel,
    );
  }

  /// 显示取消订单确认对话框
  static Future<bool> showCancelOrderDialog(BuildContext context) async {
    return await showCancelDialog(
      context,
      title: S.of(context).confirmOrder_cancelOrder,
      content: S.of(context).confirmOrder_cancelOrderConfirm,
      cancelText: S.of(context).confirmOrder_continuePay,
      confirmText: S.of(context).confirmOrder_confirmCancel,
    );
  }

  /// 取消座位选择
  static Future<bool> cancelSeatSelection(BuildContext context) async {
    try {
      final data = getCurrentSeatSelection();
      if (data == null) return true;

      final movieShowTimeId = data['movieShowTimeId'] as int;
      final theaterHallId = data['theaterHallId'] as int;
      final selectedSeats = data['selectedSeats'] as List<Map<String, dynamic>>;

      if (selectedSeats.isEmpty) return true;

      // 调用取消座位接口
      await ApiRequest().request(
        path: '/movie_show_time/select_seat/cancel',
        method: 'POST',
        data: {
          'movieShowTimeId': movieShowTimeId,
          'theaterHallId': theaterHallId,
          'seatPosition': selectedSeats,
        },
        fromJsonT: (json) => json,
      );

      // 清除本地存储的座位选择信息
      clearSeatSelection();
      
      ToastService.showSuccess(S.of(context).seatSelection_seatCanceled);
      return true;
    } catch (e) {
      ToastService.showError(S.of(context).seatSelection_cancelSeatFailed);
      return false;
    }
  }

  /// 处理返回按钮点击
  /// [orderId] 订单ID，如果为null则调用取消座位接口，否则调用取消订单接口
  static Future<bool> handleBackButton(BuildContext context, {int? orderId}) async {
    if (!hasSelectedSeats()) {
      return true; // 没有选择座位，直接返回
    }

    // 显示确认对话框
    final shouldCancel = orderId != null 
        ? await showCancelOrderDialog(context)
        : await showCancelSeatDialog(context);
        
    if (shouldCancel == true) {
      if (orderId != null) {
        // 用户确认取消，调用取消订单接口
        try {
          await ApiRequest().request(
            path: '/api/movieOrder/cancel',
            method: 'POST',
            data: {
              'orderId': orderId,
            },
            fromJsonT: (json) => json,
          );
          
          // 清除座位选择信息
          clearSeatSelection();
          
          ToastService.showSuccess(S.of(context).confirmOrder_orderCanceled);
          return true;
        } catch (e) {
          ToastService.showError(S.of(context).confirmOrder_cancelOrderFailed);
          return false;
        }
      } else {
        // 没有订单ID，调用取消座位选择接口
        return await cancelSeatSelection(context);
      }
    }
    
    return false; // 用户取消操作，不返回
  }

  /// 处理应用意外退出
  static Future<void> handleAppExit() async {
    if (hasSelectedSeats()) {
      // 静默取消座位选择，不显示对话框
      try {
        final data = getCurrentSeatSelection();
        if (data == null) return;

        final movieShowTimeId = data['movieShowTimeId'] as int;
        final theaterHallId = data['theaterHallId'] as int;
        final selectedSeats = data['selectedSeats'] as List<Map<String, dynamic>>;

        if (selectedSeats.isNotEmpty) {
          await ApiRequest().request(
            path: '/movie_show_time/select_seat/cancel',
            method: 'POST',
            data: {
              'movieShowTimeId': movieShowTimeId,
              'theaterHallId': theaterHallId,
              'seatPosition': selectedSeats,
            },
            fromJsonT: (json) => json,
          );
        }
      } catch (e) {
        // 静默处理错误，不显示toast
        print('Failed to cancel seats on app exit: $e');
      } finally {
        clearSeatSelection();
      }
    }
  }
}

/// 座位选择数据存储类
class _SeatSelectionData {
  static Map<String, dynamic>? seatData;
}
