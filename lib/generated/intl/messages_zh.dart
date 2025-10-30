// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(count) => "还有 ${count} 个场次...";

  static String m1(seatCount) => "${seatCount}个座位";

  static String m2(count) => "找到 ${count} 个相关影院";

  static String m3(count) => "确认选择 ${count} 个座位";

  static String m4(count) => "已选择 ${count} 个座位";

  static String m5(reply) => "给 ${reply} 回复";

  static String m6(total) => "共${total}条回复";

  static String m7(count) => "${count}个座位";

  static String m8(reply) => "回复@${reply}";

  static String m9(language) => "翻译为${language}";

  static String m10(hours, minutes) => "${hours}小时${minutes}分钟";

  static String m11(total) => "共${total}条回复";

  static String m12(hours, minutes) => "距离开场还有 ${hours} 小时 ${minutes} 分钟";

  static String m13(minutes, seconds) => "距离开场还有 ${minutes} 分钟 ${seconds} 秒";

  static String m14(seconds) => "距离开场还有 ${seconds} 秒";

  static String m15(ticketCount) => "${ticketCount}张电影票";

  static String m16(date) => "有效期: ${date}";

  static String m17(maxSeat) => "最大选座数量不能超过${maxSeat}个";

  static String m18(movieName) => "分享电影票: ${movieName}";

  static String m19(days) => "还有${days}天";

  static String m20(hours) => "还有${hours}小时";

  static String m21(minutes) => "还有${minutes}分钟";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_components_filterBar_confirm":
            MessageLookupByLibrary.simpleMessage("确认"),
        "about_components_filterBar_pleaseSelect":
            MessageLookupByLibrary.simpleMessage("请选择"),
        "about_components_filterBar_reset":
            MessageLookupByLibrary.simpleMessage("重置"),
        "about_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage("验证码发送成功"),
        "about_components_showTimeList_all":
            MessageLookupByLibrary.simpleMessage("全部"),
        "about_components_showTimeList_moreShowTimes": m0,
        "about_components_showTimeList_noData":
            MessageLookupByLibrary.simpleMessage("暂无数据"),
        "about_components_showTimeList_noShowTimeInfo":
            MessageLookupByLibrary.simpleMessage("暂无场次信息"),
        "about_components_showTimeList_seatStatus_available":
            MessageLookupByLibrary.simpleMessage("充足"),
        "about_components_showTimeList_seatStatus_limited":
            MessageLookupByLibrary.simpleMessage("紧张"),
        "about_components_showTimeList_seatStatus_soldOut":
            MessageLookupByLibrary.simpleMessage("售罄"),
        "about_components_showTimeList_unnamed":
            MessageLookupByLibrary.simpleMessage("未命名"),
        "about_copyright":
            MessageLookupByLibrary.simpleMessage("© 2025 Otaku Movie 版权所有"),
        "about_description":
            MessageLookupByLibrary.simpleMessage("致力于为电影爱好者提供便捷的购票体验。"),
        "about_login_email_text": MessageLookupByLibrary.simpleMessage("邮箱"),
        "about_login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("请输入有效的邮箱地址"),
        "about_login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("邮箱不能为空"),
        "about_login_forgotPassword":
            MessageLookupByLibrary.simpleMessage("忘记密码？"),
        "about_login_googleLogin":
            MessageLookupByLibrary.simpleMessage("Google登录"),
        "about_login_loginButton": MessageLookupByLibrary.simpleMessage("登录"),
        "about_login_noAccount": MessageLookupByLibrary.simpleMessage("还没有账号？"),
        "about_login_or": MessageLookupByLibrary.simpleMessage("或"),
        "about_login_password_text": MessageLookupByLibrary.simpleMessage("密码"),
        "about_login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage("密码长度至少6位"),
        "about_login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "about_login_verificationCode":
            MessageLookupByLibrary.simpleMessage("验证码"),
        "about_login_welcomeText": MessageLookupByLibrary.simpleMessage("欢迎回来"),
        "about_movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("地区"),
        "about_movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("放映规格"),
        "about_movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("字幕"),
        "about_privacy_policy": MessageLookupByLibrary.simpleMessage("查看隐私协议"),
        "about_register_haveAccount":
            MessageLookupByLibrary.simpleMessage("已有账号？"),
        "about_register_loginHere":
            MessageLookupByLibrary.simpleMessage("立即登录"),
        "about_register_passwordNotMatchRepeatPassword":
            MessageLookupByLibrary.simpleMessage("两次密码输入不一致"),
        "about_register_registerButton":
            MessageLookupByLibrary.simpleMessage("注册"),
        "about_register_repeatPassword_text":
            MessageLookupByLibrary.simpleMessage("确认密码"),
        "about_register_send": MessageLookupByLibrary.simpleMessage("发送"),
        "about_register_username_text":
            MessageLookupByLibrary.simpleMessage("用户名"),
        "about_register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "about_register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage("验证码格式不正确"),
        "about_title": MessageLookupByLibrary.simpleMessage("关于"),
        "about_version": MessageLookupByLibrary.simpleMessage("版本号"),
        "cinemaDetail_address": MessageLookupByLibrary.simpleMessage("地址"),
        "cinemaDetail_homepage": MessageLookupByLibrary.simpleMessage("官网"),
        "cinemaDetail_maxSelectSeat":
            MessageLookupByLibrary.simpleMessage("最大可选座位数"),
        "cinemaDetail_seatCount": m1,
        "cinemaDetail_showing": MessageLookupByLibrary.simpleMessage("正在上映"),
        "cinemaDetail_specialSpecPrice":
            MessageLookupByLibrary.simpleMessage("特殊上映价格"),
        "cinemaDetail_tel": MessageLookupByLibrary.simpleMessage("联系方式"),
        "cinemaDetail_theaterSpec":
            MessageLookupByLibrary.simpleMessage("影厅信息"),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage("普通影票价格"),
        "cinemaList_address": MessageLookupByLibrary.simpleMessage("正在获取当前位置"),
        "cinemaList_empty_noData":
            MessageLookupByLibrary.simpleMessage("暂无影院数据"),
        "cinemaList_empty_noDataTip":
            MessageLookupByLibrary.simpleMessage("请稍后再试"),
        "cinemaList_empty_noSearchResults":
            MessageLookupByLibrary.simpleMessage("没有找到相关影院"),
        "cinemaList_empty_noSearchResultsTip":
            MessageLookupByLibrary.simpleMessage("请尝试其他关键词"),
        "cinemaList_filter_loading":
            MessageLookupByLibrary.simpleMessage("正在加载区域数据..."),
        "cinemaList_filter_title":
            MessageLookupByLibrary.simpleMessage("按区域筛选"),
        "cinemaList_loading": MessageLookupByLibrary.simpleMessage("加载失败，请重试"),
        "cinemaList_movies_empty":
            MessageLookupByLibrary.simpleMessage("暂无上映电影"),
        "cinemaList_movies_nowShowing":
            MessageLookupByLibrary.simpleMessage("正在上映"),
        "cinemaList_search_clear": MessageLookupByLibrary.simpleMessage("清除"),
        "cinemaList_search_hint":
            MessageLookupByLibrary.simpleMessage("搜索影院名称或地址"),
        "cinemaList_search_results_found": m2,
        "cinemaList_search_results_notFound":
            MessageLookupByLibrary.simpleMessage("未找到相关影院，请尝试其他关键词"),
        "cinemaList_selectSeat_confirmSelection": m3,
        "cinemaList_selectSeat_dateFormat":
            MessageLookupByLibrary.simpleMessage("yyyy年MM月dd日"),
        "cinemaList_selectSeat_pleaseSelectSeats":
            MessageLookupByLibrary.simpleMessage("请选择座位"),
        "cinemaList_selectSeat_seatsSelected": m4,
        "cinemaList_selectSeat_selectedSeats":
            MessageLookupByLibrary.simpleMessage("已选座位"),
        "cinemaList_title": MessageLookupByLibrary.simpleMessage("附近影院"),
        "comingSoon_noMovies":
            MessageLookupByLibrary.simpleMessage("暂无正在上映的电影"),
        "comingSoon_presale": MessageLookupByLibrary.simpleMessage("预售"),
        "comingSoon_pullToRefresh":
            MessageLookupByLibrary.simpleMessage("下拉刷新"),
        "comingSoon_releaseDate": MessageLookupByLibrary.simpleMessage("上映"),
        "comingSoon_tryLaterOrRefresh":
            MessageLookupByLibrary.simpleMessage("请稍后再试或下拉刷新"),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("回复"),
        "commentDetail_comment_hint":
            MessageLookupByLibrary.simpleMessage("写下你的回复..."),
        "commentDetail_comment_placeholder": m5,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("评论回复"),
        "commentDetail_title": MessageLookupByLibrary.simpleMessage("评论详情"),
        "commentDetail_totalReplyMessage": m6,
        "common_components_cropper_actions_flip":
            MessageLookupByLibrary.simpleMessage("翻转"),
        "common_components_cropper_actions_redo":
            MessageLookupByLibrary.simpleMessage("重做"),
        "common_components_cropper_actions_reset":
            MessageLookupByLibrary.simpleMessage("重置"),
        "common_components_cropper_actions_rotateLeft":
            MessageLookupByLibrary.simpleMessage("向左旋转"),
        "common_components_cropper_actions_rotateRight":
            MessageLookupByLibrary.simpleMessage("向右旋转"),
        "common_components_cropper_actions_undo":
            MessageLookupByLibrary.simpleMessage("撤销"),
        "common_components_cropper_title":
            MessageLookupByLibrary.simpleMessage("裁剪"),
        "common_components_easyRefresh_loadMore_armedText":
            MessageLookupByLibrary.simpleMessage("松开加载更多"),
        "common_components_easyRefresh_loadMore_dragText":
            MessageLookupByLibrary.simpleMessage("上拉加载更多"),
        "common_components_easyRefresh_loadMore_failedText":
            MessageLookupByLibrary.simpleMessage("加载失败"),
        "common_components_easyRefresh_loadMore_noMoreText":
            MessageLookupByLibrary.simpleMessage("没有更多数据了"),
        "common_components_easyRefresh_loadMore_processedText":
            MessageLookupByLibrary.simpleMessage("加载完成"),
        "common_components_easyRefresh_loadMore_processingText":
            MessageLookupByLibrary.simpleMessage("加载中..."),
        "common_components_easyRefresh_loadMore_readyText":
            MessageLookupByLibrary.simpleMessage("正在加载..."),
        "common_components_easyRefresh_refresh_armedText":
            MessageLookupByLibrary.simpleMessage("松开刷新"),
        "common_components_easyRefresh_refresh_dragText":
            MessageLookupByLibrary.simpleMessage("下拉刷新"),
        "common_components_easyRefresh_refresh_failedText":
            MessageLookupByLibrary.simpleMessage("刷新失败"),
        "common_components_easyRefresh_refresh_noMoreText":
            MessageLookupByLibrary.simpleMessage("没有更多数据了"),
        "common_components_easyRefresh_refresh_processedText":
            MessageLookupByLibrary.simpleMessage("刷新完成"),
        "common_components_easyRefresh_refresh_processingText":
            MessageLookupByLibrary.simpleMessage("刷新中..."),
        "common_components_easyRefresh_refresh_readyText":
            MessageLookupByLibrary.simpleMessage("正在刷新..."),
        "common_components_filterBar_confirm":
            MessageLookupByLibrary.simpleMessage("确认"),
        "common_components_filterBar_pleaseSelect":
            MessageLookupByLibrary.simpleMessage("请选择"),
        "common_components_filterBar_reset":
            MessageLookupByLibrary.simpleMessage("重置"),
        "common_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage("验证码发送成功"),
        "common_enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("情侣座"),
        "common_enum_seatType_locked":
            MessageLookupByLibrary.simpleMessage("锁定"),
        "common_enum_seatType_sold": MessageLookupByLibrary.simpleMessage("已售"),
        "common_enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("轮椅座"),
        "common_error_message":
            MessageLookupByLibrary.simpleMessage("数据加载失败，请稍后重试"),
        "common_error_title": MessageLookupByLibrary.simpleMessage("出错了"),
        "common_loading": MessageLookupByLibrary.simpleMessage("加载中..."),
        "common_retry": MessageLookupByLibrary.simpleMessage("重新加载"),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("日元"),
        "common_unit_point": MessageLookupByLibrary.simpleMessage("分"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("周五"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("周一"),
        "common_week_saturday": MessageLookupByLibrary.simpleMessage("周六"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("周日"),
        "common_week_thursday": MessageLookupByLibrary.simpleMessage("周四"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("周二"),
        "common_week_wednesday": MessageLookupByLibrary.simpleMessage("周三"),
        "confirmOrder_cancelOrder":
            MessageLookupByLibrary.simpleMessage("取消订单"),
        "confirmOrder_cancelOrderConfirm":
            MessageLookupByLibrary.simpleMessage("您已选择了座位，确定要取消订单并释放已选择的座位吗？"),
        "confirmOrder_cancelOrderFailed":
            MessageLookupByLibrary.simpleMessage("取消订单失败，请重试"),
        "confirmOrder_cinemaInfo": MessageLookupByLibrary.simpleMessage("影院信息"),
        "confirmOrder_confirmCancel":
            MessageLookupByLibrary.simpleMessage("确认取消"),
        "confirmOrder_continuePay":
            MessageLookupByLibrary.simpleMessage("继续支付"),
        "confirmOrder_countdown": MessageLookupByLibrary.simpleMessage("剩余时间"),
        "confirmOrder_noSpec": MessageLookupByLibrary.simpleMessage("无规格信息"),
        "confirmOrder_orderCanceled":
            MessageLookupByLibrary.simpleMessage("订单已取消"),
        "confirmOrder_orderTimeout":
            MessageLookupByLibrary.simpleMessage("订单超时处理中..."),
        "confirmOrder_orderTimeoutMessage":
            MessageLookupByLibrary.simpleMessage("订单已超时，已自动取消"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("支付"),
        "confirmOrder_payFailed":
            MessageLookupByLibrary.simpleMessage("支付失败，请重试"),
        "confirmOrder_seatCount": m7,
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage("选择支付方式"),
        "confirmOrder_selectedSeats":
            MessageLookupByLibrary.simpleMessage("已选座位"),
        "confirmOrder_timeInfo": MessageLookupByLibrary.simpleMessage("时间信息"),
        "confirmOrder_timeoutFailed":
            MessageLookupByLibrary.simpleMessage("订单超时处理失败，请重试"),
        "confirmOrder_title": MessageLookupByLibrary.simpleMessage("确认订单"),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("合计"),
        "enum_seatType_coupleSeat": MessageLookupByLibrary.simpleMessage("情侣座"),
        "enum_seatType_disabled": MessageLookupByLibrary.simpleMessage("已禁用"),
        "enum_seatType_locked": MessageLookupByLibrary.simpleMessage("已锁定"),
        "enum_seatType_selected": MessageLookupByLibrary.simpleMessage("已选择"),
        "enum_seatType_sold": MessageLookupByLibrary.simpleMessage("已售出"),
        "enum_seatType_wheelChair": MessageLookupByLibrary.simpleMessage("轮椅座"),
        "forgotPassword_backToLogin":
            MessageLookupByLibrary.simpleMessage("返回登录"),
        "forgotPassword_description":
            MessageLookupByLibrary.simpleMessage("输入您的邮箱地址，我们将发送验证码给您"),
        "forgotPassword_emailAddress":
            MessageLookupByLibrary.simpleMessage("邮箱地址"),
        "forgotPassword_emailInvalid":
            MessageLookupByLibrary.simpleMessage("请输入有效的邮箱地址"),
        "forgotPassword_emailRequired":
            MessageLookupByLibrary.simpleMessage("请输入邮箱"),
        "forgotPassword_newPassword":
            MessageLookupByLibrary.simpleMessage("新密码"),
        "forgotPassword_newPasswordRequired":
            MessageLookupByLibrary.simpleMessage("请输入新密码"),
        "forgotPassword_passwordResetSuccess":
            MessageLookupByLibrary.simpleMessage("密码重置成功"),
        "forgotPassword_passwordTooShort":
            MessageLookupByLibrary.simpleMessage("密码至少需要6位"),
        "forgotPassword_rememberPassword":
            MessageLookupByLibrary.simpleMessage("想起密码了？"),
        "forgotPassword_resetPassword":
            MessageLookupByLibrary.simpleMessage("重置密码"),
        "forgotPassword_sendVerificationCode":
            MessageLookupByLibrary.simpleMessage("发送验证码"),
        "forgotPassword_title": MessageLookupByLibrary.simpleMessage("忘记密码"),
        "forgotPassword_verificationCode":
            MessageLookupByLibrary.simpleMessage("验证码"),
        "forgotPassword_verificationCodeRequired":
            MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "forgotPassword_verificationCodeSent":
            MessageLookupByLibrary.simpleMessage("验证码已发送至您的邮箱"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("电影院"),
        "home_home": MessageLookupByLibrary.simpleMessage("首页"),
        "home_me": MessageLookupByLibrary.simpleMessage("我的"),
        "home_ticket": MessageLookupByLibrary.simpleMessage("我的票"),
        "login_backToLogin": MessageLookupByLibrary.simpleMessage("返回登录"),
        "login_emailAddress": MessageLookupByLibrary.simpleMessage("邮箱地址"),
        "login_emailInvalid":
            MessageLookupByLibrary.simpleMessage("请输入有效的邮箱地址"),
        "login_emailRequired": MessageLookupByLibrary.simpleMessage("请输入邮箱"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("邮箱"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("邮箱不合法"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("邮箱不能为空"),
        "login_forgotPassword": MessageLookupByLibrary.simpleMessage("忘记密码？"),
        "login_forgotPasswordDescription":
            MessageLookupByLibrary.simpleMessage("输入您的邮箱地址，我们将发送验证码给您"),
        "login_forgotPasswordTitle":
            MessageLookupByLibrary.simpleMessage("忘记密码"),
        "login_googleLogin":
            MessageLookupByLibrary.simpleMessage("使用 Google 登录"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("登录"),
        "login_newPassword": MessageLookupByLibrary.simpleMessage("新密码"),
        "login_newPasswordRequired":
            MessageLookupByLibrary.simpleMessage("请输入新密码"),
        "login_noAccount": MessageLookupByLibrary.simpleMessage("还没有注册账号？"),
        "login_or": MessageLookupByLibrary.simpleMessage("或"),
        "login_passwordResetSuccess":
            MessageLookupByLibrary.simpleMessage("密码重置成功"),
        "login_passwordTooShort":
            MessageLookupByLibrary.simpleMessage("密码至少需要6位"),
        "login_password_text": MessageLookupByLibrary.simpleMessage("密码"),
        "login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage("密码必须为8-16位，包含数字、字母和下划线"),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "login_rememberPassword":
            MessageLookupByLibrary.simpleMessage("想起密码了？"),
        "login_resetPassword": MessageLookupByLibrary.simpleMessage("重置密码"),
        "login_sendVerificationCode":
            MessageLookupByLibrary.simpleMessage("发送验证码"),
        "login_sendVerifyCodeButton":
            MessageLookupByLibrary.simpleMessage("发送验证码"),
        "login_verificationCode": MessageLookupByLibrary.simpleMessage("验证码"),
        "login_verificationCodeRequired":
            MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "login_verificationCodeSent":
            MessageLookupByLibrary.simpleMessage("验证码已发送至您的邮箱"),
        "login_welcomeText":
            MessageLookupByLibrary.simpleMessage("欢迎回来，请登录您的账户"),
        "movieDetail_button_buy": MessageLookupByLibrary.simpleMessage("购票"),
        "movieDetail_button_saw": MessageLookupByLibrary.simpleMessage("看过"),
        "movieDetail_button_want": MessageLookupByLibrary.simpleMessage("想看"),
        "movieDetail_comment_delete":
            MessageLookupByLibrary.simpleMessage("删除"),
        "movieDetail_comment_reply": MessageLookupByLibrary.simpleMessage("回复"),
        "movieDetail_comment_replyTo": m8,
        "movieDetail_comment_translate": m9,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage("基本信息"),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage("角色"),
        "movieDetail_detail_comment":
            MessageLookupByLibrary.simpleMessage("评论"),
        "movieDetail_detail_duration_hours":
            MessageLookupByLibrary.simpleMessage("小时"),
        "movieDetail_detail_duration_hoursMinutes": m10,
        "movieDetail_detail_duration_minutes":
            MessageLookupByLibrary.simpleMessage("分钟"),
        "movieDetail_detail_duration_unknown":
            MessageLookupByLibrary.simpleMessage("未知"),
        "movieDetail_detail_homepage":
            MessageLookupByLibrary.simpleMessage("官网"),
        "movieDetail_detail_level": MessageLookupByLibrary.simpleMessage("分级"),
        "movieDetail_detail_noDate":
            MessageLookupByLibrary.simpleMessage("上映日期待定"),
        "movieDetail_detail_originalName":
            MessageLookupByLibrary.simpleMessage("原名"),
        "movieDetail_detail_spec": MessageLookupByLibrary.simpleMessage("上映规格"),
        "movieDetail_detail_staff":
            MessageLookupByLibrary.simpleMessage("工作人员"),
        "movieDetail_detail_state":
            MessageLookupByLibrary.simpleMessage("上映状态"),
        "movieDetail_detail_tags": MessageLookupByLibrary.simpleMessage("标签"),
        "movieDetail_detail_time": MessageLookupByLibrary.simpleMessage("时长"),
        "movieDetail_detail_totalReplyMessage": m11,
        "movieDetail_writeComment": MessageLookupByLibrary.simpleMessage("写评论"),
        "movieList_buy": MessageLookupByLibrary.simpleMessage("购票"),
        "movieList_comingSoon_noDate":
            MessageLookupByLibrary.simpleMessage("日期待定"),
        "movieList_currentlyShowing_level":
            MessageLookupByLibrary.simpleMessage("分级"),
        "movieList_placeholder": MessageLookupByLibrary.simpleMessage("搜索全部电影"),
        "movieList_tabBar_comingSoon":
            MessageLookupByLibrary.simpleMessage("即将上映"),
        "movieList_tabBar_currentlyShowing":
            MessageLookupByLibrary.simpleMessage("上映中"),
        "movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("地区"),
        "movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("放映规格"),
        "movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("字幕"),
        "movieTicketType_actualPrice":
            MessageLookupByLibrary.simpleMessage("实付"),
        "movieTicketType_cinema": MessageLookupByLibrary.simpleMessage("影院"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("确认订单"),
        "movieTicketType_movieInfo":
            MessageLookupByLibrary.simpleMessage("电影信息"),
        "movieTicketType_price": MessageLookupByLibrary.simpleMessage("价格"),
        "movieTicketType_seatInfo":
            MessageLookupByLibrary.simpleMessage("座位信息"),
        "movieTicketType_seatNumber":
            MessageLookupByLibrary.simpleMessage("座位号"),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage("请选择电影票类型"),
        "movieTicketType_selectTicketType":
            MessageLookupByLibrary.simpleMessage("选择票种"),
        "movieTicketType_selectTicketTypeForSeats":
            MessageLookupByLibrary.simpleMessage("请为每个座位选择合适的票种"),
        "movieTicketType_showTime":
            MessageLookupByLibrary.simpleMessage("放映时间"),
        "movieTicketType_ticketType":
            MessageLookupByLibrary.simpleMessage("票种"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("选择电影票类型"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("合计"),
        "movieTicketType_totalPrice":
            MessageLookupByLibrary.simpleMessage("总价"),
        "orderDetail_countdown_hoursMinutes": m12,
        "orderDetail_countdown_minutesSeconds": m13,
        "orderDetail_countdown_seconds": m14,
        "orderDetail_countdown_started":
            MessageLookupByLibrary.simpleMessage("已开场"),
        "orderDetail_countdown_title":
            MessageLookupByLibrary.simpleMessage("即将开场提醒"),
        "orderDetail_orderCreateTime":
            MessageLookupByLibrary.simpleMessage("订单创建时间"),
        "orderDetail_orderMessage":
            MessageLookupByLibrary.simpleMessage("订单信息"),
        "orderDetail_orderNumber": MessageLookupByLibrary.simpleMessage("订单号"),
        "orderDetail_orderState": MessageLookupByLibrary.simpleMessage("订单状态"),
        "orderDetail_payMethod": MessageLookupByLibrary.simpleMessage("支付方式"),
        "orderDetail_payTime": MessageLookupByLibrary.simpleMessage("支付时间"),
        "orderDetail_seatMessage": MessageLookupByLibrary.simpleMessage("座位信息"),
        "orderDetail_ticketCode": MessageLookupByLibrary.simpleMessage("取票码"),
        "orderDetail_ticketCount": m15,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage("订单详情"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("评论"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage("订单号"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("订单列表"),
        "payResult_qrCodeTip":
            MessageLookupByLibrary.simpleMessage("请凭此二维码或取票码前往影院取票"),
        "payResult_success": MessageLookupByLibrary.simpleMessage("支付成功"),
        "payResult_ticketCode": MessageLookupByLibrary.simpleMessage("取票码"),
        "payResult_title": MessageLookupByLibrary.simpleMessage("支付完成"),
        "payResult_viewMyTickets":
            MessageLookupByLibrary.simpleMessage("查看我的电影票"),
        "payment_addCreditCard_cardConfirmed":
            MessageLookupByLibrary.simpleMessage("信用卡信息已确认"),
        "payment_addCreditCard_cardHolderName":
            MessageLookupByLibrary.simpleMessage("持卡人姓名"),
        "payment_addCreditCard_cardHolderNameError":
            MessageLookupByLibrary.simpleMessage("请输入持卡人姓名"),
        "payment_addCreditCard_cardHolderNameHint":
            MessageLookupByLibrary.simpleMessage("请输入持卡人姓名"),
        "payment_addCreditCard_cardNumber":
            MessageLookupByLibrary.simpleMessage("卡号"),
        "payment_addCreditCard_cardNumberError":
            MessageLookupByLibrary.simpleMessage("请输入有效的卡号"),
        "payment_addCreditCard_cardNumberHint":
            MessageLookupByLibrary.simpleMessage("请输入卡号"),
        "payment_addCreditCard_cardNumberLength":
            MessageLookupByLibrary.simpleMessage("卡号长度不正确"),
        "payment_addCreditCard_cardSaved":
            MessageLookupByLibrary.simpleMessage("信用卡已保存"),
        "payment_addCreditCard_confirmAdd":
            MessageLookupByLibrary.simpleMessage("确认添加"),
        "payment_addCreditCard_cvv":
            MessageLookupByLibrary.simpleMessage("CVV"),
        "payment_addCreditCard_cvvError":
            MessageLookupByLibrary.simpleMessage("請输入CVV"),
        "payment_addCreditCard_cvvHint":
            MessageLookupByLibrary.simpleMessage("•••"),
        "payment_addCreditCard_cvvLength":
            MessageLookupByLibrary.simpleMessage("长度不正确"),
        "payment_addCreditCard_expiryDate":
            MessageLookupByLibrary.simpleMessage("有效期"),
        "payment_addCreditCard_expiryDateError":
            MessageLookupByLibrary.simpleMessage("请输入有效期"),
        "payment_addCreditCard_expiryDateExpired":
            MessageLookupByLibrary.simpleMessage("卡片已过期"),
        "payment_addCreditCard_expiryDateHint":
            MessageLookupByLibrary.simpleMessage("MM/YY"),
        "payment_addCreditCard_expiryDateInvalid":
            MessageLookupByLibrary.simpleMessage("有效期格式不正确"),
        "payment_addCreditCard_operationFailed":
            MessageLookupByLibrary.simpleMessage("操作失败，请重试"),
        "payment_addCreditCard_saveCard":
            MessageLookupByLibrary.simpleMessage("保存此信用卡"),
        "payment_addCreditCard_saveToAccount":
            MessageLookupByLibrary.simpleMessage("将保存到您的账户，方便下次使用"),
        "payment_addCreditCard_title":
            MessageLookupByLibrary.simpleMessage("添加信用卡"),
        "payment_addCreditCard_useOnce":
            MessageLookupByLibrary.simpleMessage("仅本次使用，不会保存"),
        "payment_selectCreditCard_addNewCard":
            MessageLookupByLibrary.simpleMessage("添加新信用卡"),
        "payment_selectCreditCard_confirmPayment":
            MessageLookupByLibrary.simpleMessage("确认支付"),
        "payment_selectCreditCard_expiryDate": m16,
        "payment_selectCreditCard_loadFailed":
            MessageLookupByLibrary.simpleMessage("加载信用卡列表失败"),
        "payment_selectCreditCard_noCreditCard":
            MessageLookupByLibrary.simpleMessage("暂无信用卡"),
        "payment_selectCreditCard_paymentFailed":
            MessageLookupByLibrary.simpleMessage("支付失败，请重试"),
        "payment_selectCreditCard_paymentSuccess":
            MessageLookupByLibrary.simpleMessage("支付成功"),
        "payment_selectCreditCard_pleaseAddCard":
            MessageLookupByLibrary.simpleMessage("请添加一张信用卡"),
        "payment_selectCreditCard_pleaseSelectCard":
            MessageLookupByLibrary.simpleMessage("请选择一张信用卡"),
        "payment_selectCreditCard_removeTempCard":
            MessageLookupByLibrary.simpleMessage("移除临时卡片"),
        "payment_selectCreditCard_tempCard":
            MessageLookupByLibrary.simpleMessage("临时卡片（仅本次使用）"),
        "payment_selectCreditCard_tempCardRemoved":
            MessageLookupByLibrary.simpleMessage("已移除临时卡片"),
        "payment_selectCreditCard_tempCardSelected":
            MessageLookupByLibrary.simpleMessage("已选择临时信用卡"),
        "payment_selectCreditCard_title":
            MessageLookupByLibrary.simpleMessage("选择信用卡"),
        "register_haveAccount": MessageLookupByLibrary.simpleMessage("已经有账号了？"),
        "register_loginHere": MessageLookupByLibrary.simpleMessage("点击登录"),
        "register_passwordNotMatchRepeatPassword":
            MessageLookupByLibrary.simpleMessage("两次输入的密码不一致"),
        "register_registerButton":
            MessageLookupByLibrary.simpleMessage("注册并登录"),
        "register_repeatPassword_text":
            MessageLookupByLibrary.simpleMessage("重复密码"),
        "register_repeatPassword_verify_isValid":
            MessageLookupByLibrary.simpleMessage("重复密码必须为8-16位，包含数字、字母和下划线"),
        "register_repeatPassword_verify_notNull":
            MessageLookupByLibrary.simpleMessage("重复密码不能为空"),
        "register_send": MessageLookupByLibrary.simpleMessage("发送"),
        "register_username_text": MessageLookupByLibrary.simpleMessage("用户名称"),
        "register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage("验证码必须是6位纯数字"),
        "register_verifyCode_verify_notNull":
            MessageLookupByLibrary.simpleMessage("验证码不能为空"),
        "search_history": MessageLookupByLibrary.simpleMessage("搜索历史"),
        "search_level": MessageLookupByLibrary.simpleMessage("分级"),
        "search_noData": MessageLookupByLibrary.simpleMessage("暂无数据"),
        "search_placeholder": MessageLookupByLibrary.simpleMessage("搜索全部电影"),
        "search_removeHistoryConfirm_cancel":
            MessageLookupByLibrary.simpleMessage("取消"),
        "search_removeHistoryConfirm_confirm":
            MessageLookupByLibrary.simpleMessage("确定"),
        "search_removeHistoryConfirm_content":
            MessageLookupByLibrary.simpleMessage("是否确定要删除历史记录?"),
        "search_removeHistoryConfirm_title":
            MessageLookupByLibrary.simpleMessage("删除历史记录"),
        "seatCancel_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "seatCancel_confirm": MessageLookupByLibrary.simpleMessage("确定"),
        "seatCancel_confirmMessage":
            MessageLookupByLibrary.simpleMessage("您已选择了座位，确定要取消已选择的座位吗？"),
        "seatCancel_confirmTitle":
            MessageLookupByLibrary.simpleMessage("取消座位选择"),
        "seatCancel_errorMessage":
            MessageLookupByLibrary.simpleMessage("取消座位选择失败，请重试"),
        "seatCancel_successMessage":
            MessageLookupByLibrary.simpleMessage("座位选择已取消"),
        "seatSelection_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "seatSelection_cancelSeatConfirm":
            MessageLookupByLibrary.simpleMessage("您已选择了座位，确定要取消已选择的座位吗？"),
        "seatSelection_cancelSeatFailed":
            MessageLookupByLibrary.simpleMessage("取消座位选择失败，请重试"),
        "seatSelection_cancelSeatTitle":
            MessageLookupByLibrary.simpleMessage("取消座位选择"),
        "seatSelection_confirm": MessageLookupByLibrary.simpleMessage("确定"),
        "seatSelection_seatCanceled":
            MessageLookupByLibrary.simpleMessage("选择的座位已取消"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("确认选座"),
        "selectSeat_maxSelectSeatWarn": m17,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("请选择座位"),
        "showTimeDetail_address": MessageLookupByLibrary.simpleMessage("地址"),
        "showTimeDetail_buy": MessageLookupByLibrary.simpleMessage("选座"),
        "showTimeDetail_seatStatus_available":
            MessageLookupByLibrary.simpleMessage("座位充足"),
        "showTimeDetail_seatStatus_soldOut":
            MessageLookupByLibrary.simpleMessage("已售罄"),
        "showTimeDetail_seatStatus_tight":
            MessageLookupByLibrary.simpleMessage("座位紧张"),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("分"),
        "ticket_buyTickets": MessageLookupByLibrary.simpleMessage("去购票"),
        "ticket_endTime": MessageLookupByLibrary.simpleMessage("预计结束"),
        "ticket_noData": MessageLookupByLibrary.simpleMessage("暂无电影票"),
        "ticket_noDataTip": MessageLookupByLibrary.simpleMessage("快去购买电影票吧！"),
        "ticket_seatCount": MessageLookupByLibrary.simpleMessage("座位数"),
        "ticket_shareTicket": m18,
        "ticket_showTime": MessageLookupByLibrary.simpleMessage("放映时间"),
        "ticket_status_cancelled": MessageLookupByLibrary.simpleMessage("已取消"),
        "ticket_status_expired": MessageLookupByLibrary.simpleMessage("已过期"),
        "ticket_status_used": MessageLookupByLibrary.simpleMessage("已使用"),
        "ticket_status_valid": MessageLookupByLibrary.simpleMessage("有效"),
        "ticket_tapToView": MessageLookupByLibrary.simpleMessage("点击查看详情"),
        "ticket_ticketCount": MessageLookupByLibrary.simpleMessage("票数"),
        "ticket_tickets": MessageLookupByLibrary.simpleMessage("张票"),
        "ticket_time_formatError":
            MessageLookupByLibrary.simpleMessage("时间格式错误"),
        "ticket_time_remaining_days": m19,
        "ticket_time_remaining_hours": m20,
        "ticket_time_remaining_minutes": m21,
        "ticket_time_remaining_soon":
            MessageLookupByLibrary.simpleMessage("即将开始"),
        "ticket_time_unknown": MessageLookupByLibrary.simpleMessage("时间未知"),
        "ticket_time_weekdays_friday":
            MessageLookupByLibrary.simpleMessage("周五"),
        "ticket_time_weekdays_monday":
            MessageLookupByLibrary.simpleMessage("周一"),
        "ticket_time_weekdays_saturday":
            MessageLookupByLibrary.simpleMessage("周六"),
        "ticket_time_weekdays_sunday":
            MessageLookupByLibrary.simpleMessage("周日"),
        "ticket_time_weekdays_thursday":
            MessageLookupByLibrary.simpleMessage("周四"),
        "ticket_time_weekdays_tuesday":
            MessageLookupByLibrary.simpleMessage("周二"),
        "ticket_time_weekdays_wednesday":
            MessageLookupByLibrary.simpleMessage("周三"),
        "ticket_totalPurchased": MessageLookupByLibrary.simpleMessage("共购买"),
        "unit_jpy": MessageLookupByLibrary.simpleMessage("日元"),
        "unit_point": MessageLookupByLibrary.simpleMessage("分"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage("头像"),
        "userProfile_edit_tip":
            MessageLookupByLibrary.simpleMessage("点击保存按钮保存更改"),
        "userProfile_edit_username_placeholder":
            MessageLookupByLibrary.simpleMessage("请输入用户名"),
        "userProfile_edit_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("用户名不能为空"),
        "userProfile_email": MessageLookupByLibrary.simpleMessage("邮箱"),
        "userProfile_registerTime":
            MessageLookupByLibrary.simpleMessage("注册时间"),
        "userProfile_save": MessageLookupByLibrary.simpleMessage("保存"),
        "userProfile_title": MessageLookupByLibrary.simpleMessage("个人信息"),
        "userProfile_username": MessageLookupByLibrary.simpleMessage("用户名"),
        "user_about": MessageLookupByLibrary.simpleMessage("关于"),
        "user_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "user_checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
        "user_currentVersion": MessageLookupByLibrary.simpleMessage("当前版本"),
        "user_data_characterCount": MessageLookupByLibrary.simpleMessage("演员数"),
        "user_data_orderCount": MessageLookupByLibrary.simpleMessage("订单数"),
        "user_data_staffCount": MessageLookupByLibrary.simpleMessage("工作人员数"),
        "user_data_wantCount": MessageLookupByLibrary.simpleMessage("想看数"),
        "user_data_watchHistory": MessageLookupByLibrary.simpleMessage("观影记录"),
        "user_editProfile": MessageLookupByLibrary.simpleMessage("编辑个人信息"),
        "user_language": MessageLookupByLibrary.simpleMessage("语言"),
        "user_latestVersion": MessageLookupByLibrary.simpleMessage("最新版本"),
        "user_logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "user_ok": MessageLookupByLibrary.simpleMessage("确定"),
        "user_privateAgreement": MessageLookupByLibrary.simpleMessage("隐私协议"),
        "user_registerTime": MessageLookupByLibrary.simpleMessage("注册时间"),
        "user_title": MessageLookupByLibrary.simpleMessage("我的"),
        "user_update": MessageLookupByLibrary.simpleMessage("更新"),
        "user_updateAvailable":
            MessageLookupByLibrary.simpleMessage("发现新版本，是否立即更新？"),
        "user_updateError": MessageLookupByLibrary.simpleMessage("更新失败"),
        "user_updateErrorMessage":
            MessageLookupByLibrary.simpleMessage("更新过程中出现错误，请稍后重试。"),
        "user_updateProgress":
            MessageLookupByLibrary.simpleMessage("正在下载更新，请稍候..."),
        "user_updateSuccess": MessageLookupByLibrary.simpleMessage("更新成功"),
        "user_updateSuccessMessage":
            MessageLookupByLibrary.simpleMessage("应用已成功更新到最新版本！"),
        "user_updating": MessageLookupByLibrary.simpleMessage("正在更新"),
        "writeComment_contentTitle":
            MessageLookupByLibrary.simpleMessage("写下你的观影感受"),
        "writeComment_hint": MessageLookupByLibrary.simpleMessage("写下你的评论..."),
        "writeComment_publishFailed":
            MessageLookupByLibrary.simpleMessage("评论发布失败，请重试"),
        "writeComment_rateTitle":
            MessageLookupByLibrary.simpleMessage("为这部电影评分"),
        "writeComment_release": MessageLookupByLibrary.simpleMessage("发布"),
        "writeComment_shareExperience":
            MessageLookupByLibrary.simpleMessage("分享你的观影体验，帮助其他人做出选择"),
        "writeComment_title": MessageLookupByLibrary.simpleMessage("写评论"),
        "writeComment_verify_movieIdEmpty":
            MessageLookupByLibrary.simpleMessage("电影ID不能为空"),
        "writeComment_verify_notNull":
            MessageLookupByLibrary.simpleMessage("评论不能为空"),
        "writeComment_verify_notRate":
            MessageLookupByLibrary.simpleMessage("请给电影评分")
      };
}
