import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/components/error.dart';
import 'package:otaku_movie/generated/l10n.dart';

class PayError extends StatefulWidget {
  /// 支付失败原因（可由路由 query 传入）
  final String? reason;

  const PayError({super.key, this.reason});

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<PayError> {
  bool loading = false;
  bool error = false;

  /// 返回选座页面（与 confirmOrder 一致：popUntil 到 selectSeat）
  void _goBackToSelectSeat() {
    setState(() {
      loading = false;
      error = false;
    });
    if (!mounted) return;
    final navigator = Navigator.of(context);
    try {
      navigator.popUntil((route) => route.settings.name == 'selectSeat');
    } catch (_) {
      if (mounted) context.goNamed('home');
    }
  }

  void _retry() {
    _goBackToSelectSeat();
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.reason != null && widget.reason!.isNotEmpty
        ? widget.reason!
        : S.of(context).payError_message;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goBackToSelectSeat();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: CustomAppBar(
          title: Text(
            S.of(context).payError_title,
            style: const TextStyle(color: Colors.white),
          ),
          onBackButtonPressed: () => _goBackToSelectSeat(),
        ),
        body: AppErrorWidget(
        loading: loading,
        error: error,
        onRetry: _retry,
        child: RefreshIndicator(
          onRefresh: () async => _retry(),
          color: const Color(0xFF1989FA),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  SizedBox(height: 48.h),
                  // 失败图标
                  Container(
                    padding: EdgeInsets.all(32.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.red.shade400,
                      size: 120.sp,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    S.of(context).payError_title,
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF323233),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 56.h),
                  // 返回按钮
                  SizedBox(
                    width: double.infinity,
                    height: 96.h,
                    child: ElevatedButton(
                      onPressed: _goBackToSelectSeat,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1989FA),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        S.of(context).payError_back,
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}
