import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otaku_movie/generated/l10n.dart';

class AppErrorWidget extends StatefulWidget {
  final bool loading;
  final bool error;
  final bool empty;
  final Widget? emptyWidget;
  final Widget child;
  final VoidCallback? onRetry;
  final String? errorMessage;

  const AppErrorWidget({
    super.key,
    this.loading = false,
    this.error = false, 
    this.empty = false,
    this.emptyWidget,
    required this.child,
    this.onRetry,
    this.errorMessage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PageState createState() => _PageState();
}

class _PageState extends State<AppErrorWidget> {
  @override
  Widget build(BuildContext context) {
    
    if (widget.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
              color: Color(0xFF667EEA),
              size: 60.w,
            ),
            SizedBox(height: 20.h),
            Text(
              S.of(context).common_loading,
              style: TextStyle(
                fontSize: 24.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (widget.empty) {
      return widget.emptyWidget ?? Container();
    }
    if (widget.error) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 错误图标
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 80.w,
                  color: Colors.red.shade400,
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // 错误标题
              Text(
                S.of(context).common_error_title,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323233),
                ),
              ),
              
              SizedBox(height: 12.h),
              
              // 错误信息
              Text(
                widget.errorMessage ?? S.of(context).common_error_message,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 32.h),
              
              // 重试按钮
              if (widget.onRetry != null)
                ElevatedButton.icon(
                  onPressed: widget.onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 2,
                  ),
                  icon: Icon(Icons.refresh_rounded, size: 24.sp),
                  label: Text(
                    S.of(context).common_retry,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    
    return widget.child;
  }
}