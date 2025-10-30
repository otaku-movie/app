import 'package:get/get.dart';
import 'package:otaku_movie/api/index.dart';
import 'package:otaku_movie/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/seat_cancel_manager.dart';

class SeatSelectionController extends GetxController {
  /// 触发清空选座的信号，每次自增通知订阅方
  final RxInt clearTick = 0.obs;
  int? _movieShowTimeId;
  int? _theaterHallId;
  /// 由状态管理统一存储的“总倒计时时长（秒）”，各页面按需消费
  final RxInt totalSeconds = (15 * 60).obs;
  /// 在支付流程等场景下，抑制超时/取消等自动清理动作
  final RxBool suppressOps = false.obs;

  void triggerClearSelection() {
    clearTick.value = clearTick.value + 1;
  }

  /// 配置当前场次信息，便于在超时时执行清理
  void configure({int? movieShowTimeId, int? theaterHallId}) {
    _movieShowTimeId = movieShowTimeId;
    _theaterHallId = theaterHallId;
  }

  /// 设置/更新总倒计时时长（秒）
  void setTotalSeconds(int seconds) {
    if (seconds <= 0) return;
    totalSeconds.value = seconds;
  }

  /// 统一调用：订单超时
  Future<void> timeoutOrder(BuildContext context, {required int orderId}) async {
    if (suppressOps.value) return; // 抑制时不做任何处理
    try {
      ToastService.showInfo(S.of(context).confirmOrder_orderTimeout);
      await ApiRequest().request(
        path: '/movieOrder/timeout',
        method: 'POST',
        data: { 'orderId': orderId },
        fromJsonT: (json) => json,
      );
    } catch (_) {}
    // 无论服务端结果如何：仅清本地与UI，不再调用取消选座接口
    SeatCancelManager.clearSeatSelection();
    triggerClearSelection();
    ToastService.showWarning(S.of(context).confirmOrder_orderTimeoutMessage);
  }

  /// 统一调用：用户取消订单
  Future<void> cancelOrder(BuildContext context, {required int orderId}) async {
    try {
      await ApiRequest().request(
        path: '/movieOrder/cancel',
        method: 'POST',
        data: { 'orderId': orderId },
        fromJsonT: (json) => json,
      );
      ToastService.showWarning(S.of(context).confirmOrder_orderCanceled);
    } catch (_) {
      ToastService.showError(S.of(context).confirmOrder_cancelOrderFailed);
    }
    await _clearSeatAndNotify(context);
  }

  /// 统一调用：仅取消已选座（不涉及订单）
  Future<void> cancelSeatAndClear(BuildContext context) async {
    if (suppressOps.value) return; // 抑制时不做任何处理
    await _clearSeatAndNotify(context);
  }

  Future<void> _clearSeatAndNotify(BuildContext context) async {
    try {
      await SeatCancelManager.cancelSeatSelection(context);
    } catch (_) {}
    SeatCancelManager.clearSeatSelection();
    triggerClearSelection();
  }
}


