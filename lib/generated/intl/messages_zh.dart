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

  static String m0(maxSeat) => "最大选座数量不能超过${maxSeat}个";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cinemaList_address": MessageLookupByLibrary.simpleMessage("正在获取当前位置"),
        "common_components_sendVerifyCode_send":
            MessageLookupByLibrary.simpleMessage("发送验证码"),
        "common_enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("情侣座"),
        "common_enum_seatType_disabled":
            MessageLookupByLibrary.simpleMessage("已禁用"),
        "common_enum_seatType_locked":
            MessageLookupByLibrary.simpleMessage("已锁定"),
        "common_enum_seatType_selectable":
            MessageLookupByLibrary.simpleMessage("可选择"),
        "common_enum_seatType_sold":
            MessageLookupByLibrary.simpleMessage("已售出"),
        "common_enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("轮椅座"),
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
        "movieDetail_comment_reply": MessageLookupByLibrary.simpleMessage("回复"),
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
        "movieList_button_buy": MessageLookupByLibrary.simpleMessage("购票"),
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
        "register_email": MessageLookupByLibrary.simpleMessage("邮箱"),
        "register_password": MessageLookupByLibrary.simpleMessage("密码"),
        "register_registerButton": MessageLookupByLibrary.simpleMessage("注册"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("确认选座"),
        "selectSeat_maxSelectSeatWarn": m0,
        "user_about": MessageLookupByLibrary.simpleMessage("关于"),
        "user_checkUpdate": MessageLookupByLibrary.simpleMessage("检查更新"),
        "user_editProfile": MessageLookupByLibrary.simpleMessage("编辑个人信息"),
        "user_language": MessageLookupByLibrary.simpleMessage("语言"),
        "user_logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "user_privateAgreement": MessageLookupByLibrary.simpleMessage("隐私协议")
      };
}
