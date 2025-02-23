import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otaku_movie/generated/l10n.dart';


ClassicHeader customHeader (BuildContext context) {
  return ClassicHeader(
    textStyle: TextStyle(
      color: Colors.grey.shade400,    // 修改文本颜色
      fontSize: 28.sp,        // 修改字体大小
    ),
    iconTheme: IconThemeData(
      color: Colors.grey.shade500,   // 修改图标颜色
      size: 46.sp,           // 修改图标大小
    ),
    succeededIcon: const Icon(Icons.check, color: Colors.green),
    showMessage: false,          // 关闭上次更新时间
    dragText: S.of(context).common_components_easyRefresh_refresh_dragText,          // 下拉时的文本
    armedText: S.of(context).common_components_easyRefresh_refresh_armedText,         // 达到刷新条件时的文本
    readyText: S.of(context).common_components_easyRefresh_refresh_readyText,       // 正在刷新时的文本
    processingText: S.of(context).common_components_easyRefresh_refresh_processingText,    // 刷新过程中的文本
    processedText: S.of(context).common_components_easyRefresh_refresh_processedText,      // 刷新完成后的文本
    failedText: S.of(context).common_components_easyRefresh_refresh_failedText,         // 刷新失败时的文本
    noMoreText: S.of(context).common_components_easyRefresh_refresh_noMoreText,    // 没有更多数据时的文本
  );
}

ClassicFooter customFooter (BuildContext context) {
  return ClassicFooter(
    showMessage: false,          // 关闭上次更新时间
    dragText: S.of(context).common_components_easyRefresh_loadMore_dragText, // 上拉加载更多
    armedText: S.of(context).common_components_easyRefresh_loadMore_armedText, // 松开加载更多
    readyText: S.of(context).common_components_easyRefresh_loadMore_readyText, // 正在加载
    processingText: S.of(context).common_components_easyRefresh_loadMore_processingText, // 加载中
    processedText: S.of(context).common_components_easyRefresh_loadMore_processedText, // 加载完成
    failedText: S.of(context).common_components_easyRefresh_loadMore_failedText, // 加载失败
    noMoreText: S.of(context).common_components_easyRefresh_loadMore_noMoreText, // 没有更多数据
  );
}
