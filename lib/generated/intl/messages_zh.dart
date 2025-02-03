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

  static String m0(seatCount) => "${seatCount}个座位";

  static String m1(reply) => "给 ${reply} 回复";

  static String m2(total) => "共${total}条回复";

  static String m3(reply) => "回复@${reply}";

  static String m4(language) => "翻译为${language}";

  static String m5(total) => "共${total}条回复";

  static String m6(ticketCount) => "${ticketCount}张电影票";

  static String m7(maxSeat) => "最大选座数量不能超过${maxSeat}个";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cinemaDetail_address": MessageLookupByLibrary.simpleMessage("地址"),
        "cinemaDetail_homepage": MessageLookupByLibrary.simpleMessage("官网"),
        "cinemaDetail_maxSelectSeat":
            MessageLookupByLibrary.simpleMessage("最大可选座位数"),
        "cinemaDetail_seatCount": m0,
        "cinemaDetail_showing": MessageLookupByLibrary.simpleMessage("正在上映"),
        "cinemaDetail_specialSpecPrice":
            MessageLookupByLibrary.simpleMessage("特殊上映价格"),
        "cinemaDetail_tel": MessageLookupByLibrary.simpleMessage("联系方式"),
        "cinemaDetail_theaterSpec":
            MessageLookupByLibrary.simpleMessage("影厅信息"),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage("普通影票价格"),
        "cinemaList_address": MessageLookupByLibrary.simpleMessage("正在获取当前位置"),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("回复"),
        "commentDetail_comment_placeholder": m1,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("评论回复"),
        "commentDetail_title": MessageLookupByLibrary.simpleMessage("评论详情"),
        "commentDetail_totalReplyMessage": m2,
        "common_components_cropper_actions_flip":
            MessageLookupByLibrary.simpleMessage("翻转"),
        "common_components_cropper_actions_redo":
            MessageLookupByLibrary.simpleMessage("恢复撤销"),
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
            MessageLookupByLibrary.simpleMessage("准备加载更多"),
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
        "common_components_sendVerifyCode_send":
            MessageLookupByLibrary.simpleMessage("发送验证码"),
        "common_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage("验证码发送成功"),
        "common_enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("情侣座"),
        "common_enum_seatType_disabled":
            MessageLookupByLibrary.simpleMessage("已禁用"),
        "common_enum_seatType_locked":
            MessageLookupByLibrary.simpleMessage("已锁定"),
        "common_enum_seatType_selected":
            MessageLookupByLibrary.simpleMessage("已选择"),
        "common_enum_seatType_sold":
            MessageLookupByLibrary.simpleMessage("已售出"),
        "common_enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("轮椅座"),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("日元"),
        "common_unit_point": MessageLookupByLibrary.simpleMessage("分"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("五"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("一"),
        "common_week_saturday": MessageLookupByLibrary.simpleMessage("六"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("日"),
        "common_week_thursday": MessageLookupByLibrary.simpleMessage("四"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("二"),
        "common_week_wednesday": MessageLookupByLibrary.simpleMessage("三"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("支付"),
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage("选择支付方式"),
        "confirmOrder_title": MessageLookupByLibrary.simpleMessage("确认订单"),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("合计"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("电影院"),
        "home_home": MessageLookupByLibrary.simpleMessage("首页"),
        "home_me": MessageLookupByLibrary.simpleMessage("我的"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("邮箱"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("邮箱不合法"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("邮箱不能为空"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("登录"),
        "login_noAccount": MessageLookupByLibrary.simpleMessage("还没有注册账号？"),
        "login_password_text": MessageLookupByLibrary.simpleMessage("密码"),
        "login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage("密码必须为8-16位，包含数字、字母和下划线"),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("密码不能为空"),
        "login_sendVerifyCodeButton":
            MessageLookupByLibrary.simpleMessage("发送验证码"),
        "login_verificationCode": MessageLookupByLibrary.simpleMessage("验证码"),
        "movieDetail_button_buy": MessageLookupByLibrary.simpleMessage("购票"),
        "movieDetail_button_saw": MessageLookupByLibrary.simpleMessage("看过"),
        "movieDetail_button_want": MessageLookupByLibrary.simpleMessage("想看"),
        "movieDetail_comment_delete":
            MessageLookupByLibrary.simpleMessage("删除"),
        "movieDetail_comment_reply": MessageLookupByLibrary.simpleMessage("回复"),
        "movieDetail_comment_replyTo": m3,
        "movieDetail_comment_replyTo_translate": m4,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage("基本信息"),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage("角色"),
        "movieDetail_detail_comment":
            MessageLookupByLibrary.simpleMessage("评论"),
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
        "movieDetail_detail_totalReplyMessage": m5,
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
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("确认订单"),
        "movieTicketType_seatNumber":
            MessageLookupByLibrary.simpleMessage("座位号"),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage("请选择电影票类型"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("选择电影票类型"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("合计"),
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
        "orderDetail_ticketCount": m6,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage("订单详情"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("评论"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage("订单号"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("订单列表"),
        "payResult_success": MessageLookupByLibrary.simpleMessage(
            "您的订单已经支付完成，请在以下时间之前到达以下地点，祝您观影愉快。"),
        "payResult_ticketCode": MessageLookupByLibrary.simpleMessage("取票码"),
        "payResult_title": MessageLookupByLibrary.simpleMessage("支付完成"),
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
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("确认选座"),
        "selectSeat_maxSelectSeatWarn": m7,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("请选择座位"),
        "showTimeDetail_address": MessageLookupByLibrary.simpleMessage("地址"),
        "showTimeDetail_buy": MessageLookupByLibrary.simpleMessage("购票"),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("分"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage("头像"),
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
        "user_checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
        "user_data_characterCount": MessageLookupByLibrary.simpleMessage("演员数"),
        "user_data_orderCount": MessageLookupByLibrary.simpleMessage("订单数"),
        "user_data_staffCount": MessageLookupByLibrary.simpleMessage("工作人员数"),
        "user_data_wantCount": MessageLookupByLibrary.simpleMessage("想看数"),
        "user_editProfile": MessageLookupByLibrary.simpleMessage("编辑个人信息"),
        "user_language": MessageLookupByLibrary.simpleMessage("语言"),
        "user_logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "user_privateAgreement": MessageLookupByLibrary.simpleMessage("隐私协议"),
        "user_title": MessageLookupByLibrary.simpleMessage("我的"),
        "writeComment_hint": MessageLookupByLibrary.simpleMessage("写下你的评论..."),
        "writeComment_release": MessageLookupByLibrary.simpleMessage("发布"),
        "writeComment_title": MessageLookupByLibrary.simpleMessage("写评论"),
        "writeComment_verify_notNull":
            MessageLookupByLibrary.simpleMessage("评论不能为空"),
        "writeComment_verify_notRate":
            MessageLookupByLibrary.simpleMessage("请给电影评分")
      };
}
