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

  static String m1(name) => "${name}字幕";

  static String m2(names) => "※ 原声 + ${names} 字幕的场次";

  static String m3(count) => "共 ${count} 场";

  static String m4(cinemaCount, showTimeCount) =>
      "${cinemaCount} 家影院 · ${showTimeCount} 场";

  static String m5(n) => "${n} 家影院可领";

  static String m6(km) => "${km} km";

  static String m7(n) => "${n} 人反馈已领完";

  static String m8(time) => "最近场次：${time}";

  static String m9(n) => "配额 ${n}";

  static String m10(n) => "${n} 场未来场次";

  static String m11(seatCount) => "${seatCount}个座位";

  static String m12(count) => "找到 ${count} 个相关影院";

  static String m13(count) => "确认选择 ${count} 个座位";

  static String m14(count) => "已选择 ${count} 个座位";

  static String m15(reply) => "给 ${reply} 回复";

  static String m16(total) => "共${total}条回复";

  static String m17(count) => "${count}个座位";

  static String m18(reply) => "回复@${reply}";

  static String m19(language) => "翻译为${language}";

  static String m20(hours, minutes) => "${hours}小时${minutes}分钟";

  static String m21(total) => "共${total}条回复";

  static String m22(names) => "部分座位不可用，请重新选择：${names}";

  static String m23(hours, minutes) => "距离开场还有 ${hours} 小时 ${minutes} 分钟";

  static String m24(minutes, seconds) => "距离开场还有 ${minutes} 分钟 ${seconds} 秒";

  static String m25(seconds) => "距离开场还有 ${seconds} 秒";

  static String m26(ticketCount) => "${ticketCount}张电影票";

  static String m27(date) => "有效期: ${date}";

  static String m28(count) => "共${count}张";

  static String m29(maxSeat) => "最大选座数量不能超过${maxSeat}个";

  static String m30(movieName) => "分享电影票: ${movieName}";

  static String m31(days) => "还有${days}天";

  static String m32(hours) => "还有${hours}小时";

  static String m33(minutes) => "还有${minutes}分钟";

  static String m34(version) => "v${version} 更新内容";

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
        "about_components_showTimeList_benefitBadge":
            MessageLookupByLibrary.simpleMessage("特典"),
        "about_components_showTimeList_dubbingVersion":
            MessageLookupByLibrary.simpleMessage("配音版"),
        "about_components_showTimeList_moreShowTimes": m0,
        "about_components_showTimeList_noData":
            MessageLookupByLibrary.simpleMessage("暂无数据"),
        "about_components_showTimeList_noShowTimeInfo":
            MessageLookupByLibrary.simpleMessage("暂无场次信息"),
        "about_components_showTimeList_notPurchasableHint":
            MessageLookupByLibrary.simpleMessage("影院官网尚未开放此场次购票，请稍后再试"),
        "about_components_showTimeList_seatStatus_available":
            MessageLookupByLibrary.simpleMessage("充足"),
        "about_components_showTimeList_seatStatus_closed":
            MessageLookupByLibrary.simpleMessage("停售"),
        "about_components_showTimeList_seatStatus_limited":
            MessageLookupByLibrary.simpleMessage("紧张"),
        "about_components_showTimeList_seatStatus_preSale":
            MessageLookupByLibrary.simpleMessage("预售"),
        "about_components_showTimeList_seatStatus_saleEnded":
            MessageLookupByLibrary.simpleMessage("已结束"),
        "about_components_showTimeList_seatStatus_soldOut":
            MessageLookupByLibrary.simpleMessage("售罄"),
        "about_components_showTimeList_seatStatus_unknown":
            MessageLookupByLibrary.simpleMessage("未知"),
        "about_components_showTimeList_subtitleChipShort":
            MessageLookupByLibrary.simpleMessage("字"),
        "about_components_showTimeList_subtitleChipWith": m1,
        "about_components_showTimeList_subtitleHint": m2,
        "about_components_showTimeList_timeRange":
            MessageLookupByLibrary.simpleMessage("开场时间"),
        "about_components_showTimeList_unnamed":
            MessageLookupByLibrary.simpleMessage("未命名"),
        "about_copyright":
            MessageLookupByLibrary.simpleMessage("© 2025-2026 シネコ 版权所有"),
        "about_dataDisclaimer": MessageLookupByLibrary.simpleMessage(
            "本应用展示的电影名称、海报、剧照、预告片等相关内容，其版权均归原电影制作公司、发行方或相应权利人所有，本应用仅用于信息展示与购票服务，不主张对上述内容的任何版权。如涉及版权问题，请通过 diy4869@gmail.com 联系我们及时处理。"),
        "about_dataSource": MessageLookupByLibrary.simpleMessage(
            "本应用展示的电影信息、排片及影院数据来源于各影院官方网站及公开信息，仅供查询与参考。排片、价格、余票等可能随时变化，最终以影院或实际购票渠道为准。"),
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
        "about_movieShowList_cinemaSessionCount": m3,
        "about_movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("地区"),
        "about_movieShowList_dropdown_brand":
            MessageLookupByLibrary.simpleMessage("品牌"),
        "about_movieShowList_dropdown_dimensionType":
            MessageLookupByLibrary.simpleMessage("放映类型"),
        "about_movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("规格"),
        "about_movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("字幕"),
        "about_movieShowList_dropdown_tag":
            MessageLookupByLibrary.simpleMessage("标签"),
        "about_movieShowList_dropdown_version":
            MessageLookupByLibrary.simpleMessage("版本"),
        "about_movieShowList_summary": m4,
        "about_nonOfficial": MessageLookupByLibrary.simpleMessage(
            "本应用并非任何影院、发行方、制片方或票务平台的官方应用，除页面明确标注外，与上述主体不存在官方合作或授权关系。"),
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
        "agreement_consent_agree":
            MessageLookupByLibrary.simpleMessage("同意并继续"),
        "agreement_consent_currentVersion":
            MessageLookupByLibrary.simpleMessage("当前版本"),
        "agreement_consent_disagree":
            MessageLookupByLibrary.simpleMessage("暂不同意"),
        "agreement_consent_disagreeWarning":
            MessageLookupByLibrary.simpleMessage("未同意最新协议，部分功能可能无法正常使用。"),
        "agreement_consent_readAndAgree":
            MessageLookupByLibrary.simpleMessage("我已阅读并同意以上全部协议内容。"),
        "agreement_consent_subtitle": MessageLookupByLibrary.simpleMessage(
            "我们已更新以下协议，请您仔细阅读并同意后继续使用本应用。"),
        "agreement_consent_title":
            MessageLookupByLibrary.simpleMessage("协议更新提示"),
        "agreement_consent_viewDetail":
            MessageLookupByLibrary.simpleMessage("查看"),
        "agreement_emptyContent":
            MessageLookupByLibrary.simpleMessage("暂无内容，请稍后再试或联系客服。"),
        "benefit_availability_action_buy":
            MessageLookupByLibrary.simpleMessage("去购票"),
        "benefit_availability_action_feedback":
            MessageLookupByLibrary.simpleMessage("反馈已领完"),
        "benefit_availability_action_feedback_done":
            MessageLookupByLibrary.simpleMessage("已反馈"),
        "benefit_availability_count_label": m5,
        "benefit_availability_distance_km": m6,
        "benefit_availability_empty":
            MessageLookupByLibrary.simpleMessage("暂无可领取该特典的影院"),
        "benefit_availability_feedback_n": m7,
        "benefit_availability_feedback_submit_failed":
            MessageLookupByLibrary.simpleMessage("提交失败，请重试"),
        "benefit_availability_filter_region":
            MessageLookupByLibrary.simpleMessage("地区"),
        "benefit_availability_filter_search_clear":
            MessageLookupByLibrary.simpleMessage("清除搜索"),
        "benefit_availability_filter_search_hint":
            MessageLookupByLibrary.simpleMessage("搜索影院名"),
        "benefit_availability_filter_sort":
            MessageLookupByLibrary.simpleMessage("排序"),
        "benefit_availability_nearest_showtime": m8,
        "benefit_availability_pageTitle":
            MessageLookupByLibrary.simpleMessage("可领影院"),
        "benefit_availability_phase_ended_banner":
            MessageLookupByLibrary.simpleMessage("本期特典已结束，仅供参考"),
        "benefit_availability_remaining_not_reported":
            MessageLookupByLibrary.simpleMessage("未登记"),
        "benefit_availability_remaining_quota_label": m9,
        "benefit_availability_showtime_n": m10,
        "benefit_availability_showtime_none":
            MessageLookupByLibrary.simpleMessage("暂无未来场次"),
        "benefit_availability_sort_default":
            MessageLookupByLibrary.simpleMessage("默认"),
        "benefit_availability_sort_distance":
            MessageLookupByLibrary.simpleMessage("距离近优先"),
        "benefit_availability_sort_locationDenied":
            MessageLookupByLibrary.simpleMessage("未授权定位，无法按距离排序"),
        "benefit_availability_sort_remainingDesc":
            MessageLookupByLibrary.simpleMessage("剩余多优先"),
        "benefit_availability_status_few":
            MessageLookupByLibrary.simpleMessage("少量"),
        "benefit_availability_status_soldOutAdmin":
            MessageLookupByLibrary.simpleMessage("已领完"),
        "benefit_availability_status_soldOutFeedback":
            MessageLookupByLibrary.simpleMessage("已领完（用户反馈）"),
        "benefit_availability_status_sufficient":
            MessageLookupByLibrary.simpleMessage("充足"),
        "benefit_availability_status_unknown":
            MessageLookupByLibrary.simpleMessage("未知"),
        "benefit_availability_status_veryFew":
            MessageLookupByLibrary.simpleMessage("极少"),
        "benefit_availability_view_cinemas":
            MessageLookupByLibrary.simpleMessage("查看可领影院"),
        "benefit_empty": MessageLookupByLibrary.simpleMessage("该电影暂无特典信息"),
        "benefit_feedback_button": MessageLookupByLibrary.simpleMessage("反馈"),
        "benefit_feedback_hint": MessageLookupByLibrary.simpleMessage(
            "如果你在某家影院观影时发现下方这份特典已经领完，请选择影院并提交反馈，我们会更新库存提示，方便其他观众。"),
        "benefit_feedback_please_select_cinema":
            MessageLookupByLibrary.simpleMessage("请先选择影院"),
        "benefit_feedback_please_select_phase":
            MessageLookupByLibrary.simpleMessage("请先选择阶段"),
        "benefit_feedback_select_cinema":
            MessageLookupByLibrary.simpleMessage("选择影院"),
        "benefit_feedback_select_phase":
            MessageLookupByLibrary.simpleMessage("选择阶段"),
        "benefit_feedback_submit":
            MessageLookupByLibrary.simpleMessage("反馈：该影院已领完"),
        "benefit_feedback_success":
            MessageLookupByLibrary.simpleMessage("感谢您的反馈"),
        "benefit_hasBenefitsLabel":
            MessageLookupByLibrary.simpleMessage("有入场者特典"),
        "benefit_hasBenefitsLabel_reRelease":
            MessageLookupByLibrary.simpleMessage("重映特典"),
        "benefit_items": MessageLookupByLibrary.simpleMessage("物料"),
        "benefit_limit": MessageLookupByLibrary.simpleMessage("限定"),
        "benefit_limit_cinema": MessageLookupByLibrary.simpleMessage("仅限指定影院"),
        "benefit_limit_dimension_2d":
            MessageLookupByLibrary.simpleMessage("2D"),
        "benefit_limit_dimension_3d":
            MessageLookupByLibrary.simpleMessage("3D"),
        "benefit_pageTitle": MessageLookupByLibrary.simpleMessage("入场者特典"),
        "benefit_period": MessageLookupByLibrary.simpleMessage("期间"),
        "benefit_phase": MessageLookupByLibrary.simpleMessage("阶段"),
        "benefit_phaseStatus_before":
            MessageLookupByLibrary.simpleMessage("之前"),
        "benefit_phaseStatus_ended":
            MessageLookupByLibrary.simpleMessage("已结束"),
        "benefit_phaseStatus_ongoing":
            MessageLookupByLibrary.simpleMessage("进行中"),
        "benefit_remaining": MessageLookupByLibrary.simpleMessage("剩余"),
        "benefit_status_few": MessageLookupByLibrary.simpleMessage("少量"),
        "benefit_status_soldOut": MessageLookupByLibrary.simpleMessage("已领完"),
        "benefit_status_sufficient": MessageLookupByLibrary.simpleMessage("充足"),
        "benefit_status_unknown": MessageLookupByLibrary.simpleMessage("未知"),
        "benefit_status_veryFew": MessageLookupByLibrary.simpleMessage("极少"),
        "benefit_total": MessageLookupByLibrary.simpleMessage("总数"),
        "benefit_unit_tenThousand": MessageLookupByLibrary.simpleMessage("万"),
        "benefit_unit_thousand": MessageLookupByLibrary.simpleMessage("千"),
        "cinemaDetail_address": MessageLookupByLibrary.simpleMessage("地址"),
        "cinemaDetail_homepage": MessageLookupByLibrary.simpleMessage("官网"),
        "cinemaDetail_maxSelectSeat":
            MessageLookupByLibrary.simpleMessage("最大可选座位数"),
        "cinemaDetail_seatCount": m11,
        "cinemaDetail_showing": MessageLookupByLibrary.simpleMessage("正在上映"),
        "cinemaDetail_specialSpecPrice":
            MessageLookupByLibrary.simpleMessage("特殊上映价格"),
        "cinemaDetail_tel": MessageLookupByLibrary.simpleMessage("联系方式"),
        "cinemaDetail_theaterSpec":
            MessageLookupByLibrary.simpleMessage("影厅信息"),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage("普通影票价格"),
        "cinemaList_address": MessageLookupByLibrary.simpleMessage("正在获取当前位置"),
        "cinemaList_allArea": MessageLookupByLibrary.simpleMessage("全部地区"),
        "cinemaList_allCinemas": MessageLookupByLibrary.simpleMessage("全部影院"),
        "cinemaList_currentLocation":
            MessageLookupByLibrary.simpleMessage("当前所在地"),
        "cinemaList_empty_noData":
            MessageLookupByLibrary.simpleMessage("暂无影院数据"),
        "cinemaList_empty_noDataTip":
            MessageLookupByLibrary.simpleMessage("请稍后再试"),
        "cinemaList_empty_noSearchResults":
            MessageLookupByLibrary.simpleMessage("没有找到相关影院"),
        "cinemaList_empty_noSearchResultsTip":
            MessageLookupByLibrary.simpleMessage("请尝试其他关键词"),
        "cinemaList_filter_brand": MessageLookupByLibrary.simpleMessage("品牌"),
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
        "cinemaList_search_results_found": m12,
        "cinemaList_search_results_notFound":
            MessageLookupByLibrary.simpleMessage("未找到相关影院，请尝试其他关键词"),
        "cinemaList_selectSeat_confirmSelection": m13,
        "cinemaList_selectSeat_dateFormat":
            MessageLookupByLibrary.simpleMessage("yyyy年MM月dd日"),
        "cinemaList_selectSeat_pleaseSelectSeats":
            MessageLookupByLibrary.simpleMessage("请选择座位"),
        "cinemaList_selectSeat_seatsSelected": m14,
        "cinemaList_selectSeat_selectedSeats":
            MessageLookupByLibrary.simpleMessage("已选座位"),
        "cinemaList_title": MessageLookupByLibrary.simpleMessage("附近影院"),
        "comingSoon_noMovies":
            MessageLookupByLibrary.simpleMessage("暂无正在上映的电影"),
        "comingSoon_presale": MessageLookupByLibrary.simpleMessage("预售"),
        "comingSoon_presaleTicketBadge":
            MessageLookupByLibrary.simpleMessage("ムビチケ"),
        "comingSoon_pullToRefresh":
            MessageLookupByLibrary.simpleMessage("下拉刷新"),
        "comingSoon_releaseDate": MessageLookupByLibrary.simpleMessage("上映"),
        "comingSoon_tryLaterOrRefresh":
            MessageLookupByLibrary.simpleMessage("请稍后再试或下拉刷新"),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("回复"),
        "commentDetail_comment_hint":
            MessageLookupByLibrary.simpleMessage("写下你的回复..."),
        "commentDetail_comment_placeholder": m15,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("评论回复"),
        "commentDetail_title": MessageLookupByLibrary.simpleMessage("评论详情"),
        "commentDetail_totalReplyMessage": m16,
        "common_callTelFailed":
            MessageLookupByLibrary.simpleMessage("无法拨打电话，请检查电话号码或设备拨号功能"),
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
        "common_components_filterBar_allDay":
            MessageLookupByLibrary.simpleMessage("全天"),
        "common_components_filterBar_confirm":
            MessageLookupByLibrary.simpleMessage("确定"),
        "common_components_filterBar_noData":
            MessageLookupByLibrary.simpleMessage("暂无数据"),
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
        "common_network_error_connectionError":
            MessageLookupByLibrary.simpleMessage("网络连接错误，请检查网络设置"),
        "common_network_error_connectionRefused":
            MessageLookupByLibrary.simpleMessage("服务器拒绝连接，请稍后重试"),
        "common_network_error_connectionTimeout":
            MessageLookupByLibrary.simpleMessage("连接超时，请检查网络或稍后重试"),
        "common_network_error_default":
            MessageLookupByLibrary.simpleMessage("网络请求失败，请稍后重试"),
        "common_network_error_hostLookupFailed":
            MessageLookupByLibrary.simpleMessage("无法解析服务器地址，请检查网络设置"),
        "common_network_error_networkUnreachable":
            MessageLookupByLibrary.simpleMessage("网络不可达，请检查网络设置"),
        "common_network_error_noRouteToHost":
            MessageLookupByLibrary.simpleMessage("无法连接到服务器，请检查网络连接"),
        "common_network_error_receiveTimeout":
            MessageLookupByLibrary.simpleMessage("接收响应超时，请稍后重试"),
        "common_network_error_sendTimeout":
            MessageLookupByLibrary.simpleMessage("发送请求超时，请稍后重试"),
        "common_openMapFailed":
            MessageLookupByLibrary.simpleMessage("无法打开地图，请确认已安装地图应用"),
        "common_retry": MessageLookupByLibrary.simpleMessage("重新加载"),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("日元"),
        "common_unit_kilometer": MessageLookupByLibrary.simpleMessage("公里"),
        "common_unit_meter": MessageLookupByLibrary.simpleMessage("米"),
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
        "confirmOrder_seatCount": m17,
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage("选择支付方式"),
        "confirmOrder_selectedSeats":
            MessageLookupByLibrary.simpleMessage("已选座位"),
        "confirmOrder_timeInfo": MessageLookupByLibrary.simpleMessage("时间信息"),
        "confirmOrder_timeoutFailed":
            MessageLookupByLibrary.simpleMessage("订单超时处理失败，请重试"),
        "confirmOrder_title": MessageLookupByLibrary.simpleMessage("确认订单"),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("合计"),
        "creditCard_action_delete": MessageLookupByLibrary.simpleMessage("删除"),
        "creditCard_action_edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "creditCard_action_setDefault":
            MessageLookupByLibrary.simpleMessage("设为默认"),
        "creditCard_badge_default": MessageLookupByLibrary.simpleMessage("默认"),
        "creditCard_currentDefaultHint":
            MessageLookupByLibrary.simpleMessage("当前已是默认卡片"),
        "creditCard_deleteConfirm_content":
            MessageLookupByLibrary.simpleMessage("删除后将无法恢复，确认删除？"),
        "creditCard_deleteConfirm_title":
            MessageLookupByLibrary.simpleMessage("删除信用卡"),
        "creditCard_deleteHint_selectFirst":
            MessageLookupByLibrary.simpleMessage("请先选择要删除的信用卡"),
        "creditCard_edit_cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "creditCard_edit_expiryDate":
            MessageLookupByLibrary.simpleMessage("有效期 (MM/YY)"),
        "creditCard_edit_holderName":
            MessageLookupByLibrary.simpleMessage("持卡人姓名"),
        "creditCard_edit_save": MessageLookupByLibrary.simpleMessage("保存"),
        "creditCard_edit_title": MessageLookupByLibrary.simpleMessage("编辑信用卡"),
        "creditCard_operationFailed":
            MessageLookupByLibrary.simpleMessage("操作失败，请稍后重试"),
        "creditCard_setDefaultSubtitle":
            MessageLookupByLibrary.simpleMessage("支付时优先选择此卡"),
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
        "login_appleLogin": MessageLookupByLibrary.simpleMessage("使用 Apple 登录"),
        "login_appleLoginFailed":
            MessageLookupByLibrary.simpleMessage("Apple 登录失败，请重试"),
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
        "login_googleLoginFailed":
            MessageLookupByLibrary.simpleMessage("谷歌登录失败，请重试"),
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
        "login_xLogin": MessageLookupByLibrary.simpleMessage("使用 X 登录"),
        "login_xLoginFailed":
            MessageLookupByLibrary.simpleMessage("X 登录失败，请重试"),
        "movieDetail_button_buy": MessageLookupByLibrary.simpleMessage("购票"),
        "movieDetail_button_saw": MessageLookupByLibrary.simpleMessage("看过"),
        "movieDetail_button_want": MessageLookupByLibrary.simpleMessage("想看"),
        "movieDetail_comment_delete":
            MessageLookupByLibrary.simpleMessage("删除"),
        "movieDetail_comment_empty":
            MessageLookupByLibrary.simpleMessage("暂无评论，快来发表第一条评论"),
        "movieDetail_comment_reply": MessageLookupByLibrary.simpleMessage("回复"),
        "movieDetail_comment_replyTo": m18,
        "movieDetail_comment_translate": m19,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage("基本信息"),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage("角色"),
        "movieDetail_detail_comment":
            MessageLookupByLibrary.simpleMessage("评论"),
        "movieDetail_detail_duration_hours":
            MessageLookupByLibrary.simpleMessage("小时"),
        "movieDetail_detail_duration_hoursMinutes": m20,
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
        "movieDetail_detail_totalReplyMessage": m21,
        "movieDetail_presaleHasBonus":
            MessageLookupByLibrary.simpleMessage("含特典"),
        "movieDetail_reReleaseHistory_disabled":
            MessageLookupByLibrary.simpleMessage("未启用"),
        "movieDetail_reReleaseHistory_duration":
            MessageLookupByLibrary.simpleMessage("时长"),
        "movieDetail_reReleaseHistory_end":
            MessageLookupByLibrary.simpleMessage("结束"),
        "movieDetail_reReleaseHistory_start":
            MessageLookupByLibrary.simpleMessage("开始"),
        "movieDetail_reReleaseHistory_title":
            MessageLookupByLibrary.simpleMessage("重映历史"),
        "movieDetail_viewPresaleTicket":
            MessageLookupByLibrary.simpleMessage("预售券"),
        "movieDetail_writeComment": MessageLookupByLibrary.simpleMessage("写评论"),
        "movieList_buy": MessageLookupByLibrary.simpleMessage("购票"),
        "movieList_comingSoon_noDate":
            MessageLookupByLibrary.simpleMessage("日期待定"),
        "movieList_currentlyShowing_director":
            MessageLookupByLibrary.simpleMessage("导演"),
        "movieList_currentlyShowing_level":
            MessageLookupByLibrary.simpleMessage("分级"),
        "movieList_placeholder": MessageLookupByLibrary.simpleMessage("搜索全部电影"),
        "movieList_tabBar_comingSoon":
            MessageLookupByLibrary.simpleMessage("即将上映"),
        "movieList_tabBar_currentlyShowing":
            MessageLookupByLibrary.simpleMessage("上映中"),
        "movieList_tag_reRelease": MessageLookupByLibrary.simpleMessage("重映"),
        "movieList_view_grid": MessageLookupByLibrary.simpleMessage("网格视图"),
        "movieList_view_list": MessageLookupByLibrary.simpleMessage("列表视图"),
        "movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("地区"),
        "movieShowList_dropdown_dimensionType":
            MessageLookupByLibrary.simpleMessage("放映类型"),
        "movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("放映规格"),
        "movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("字幕"),
        "movieShowList_dropdown_tag":
            MessageLookupByLibrary.simpleMessage("标签"),
        "movieShowList_dropdown_version":
            MessageLookupByLibrary.simpleMessage("版本"),
        "movieTicketType_actualPrice":
            MessageLookupByLibrary.simpleMessage("实付"),
        "movieTicketType_cinema": MessageLookupByLibrary.simpleMessage("影院"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("确认订单"),
        "movieTicketType_createOrderNoOrderNumber":
            MessageLookupByLibrary.simpleMessage("创建订单失败，未返回订单号"),
        "movieTicketType_fixedPrice":
            MessageLookupByLibrary.simpleMessage("固定票价"),
        "movieTicketType_movieInfo":
            MessageLookupByLibrary.simpleMessage("电影信息"),
        "movieTicketType_mubitikeCode":
            MessageLookupByLibrary.simpleMessage("购票号码（10位）"),
        "movieTicketType_mubitikeCodeHint":
            MessageLookupByLibrary.simpleMessage("请输入10位购票号码"),
        "movieTicketType_mubitikeDescription":
            MessageLookupByLibrary.simpleMessage("使用后可抵消票面价格，3D、IMAX 等加价需另付。"),
        "movieTicketType_mubitikeDetails": MessageLookupByLibrary.simpleMessage(
            "• 使用后可抵消票面价格\n• 3D、IMAX 等加价需另付\n• 每张券仅限1人1次观影使用"),
        "movieTicketType_mubitikeDetailsTitle":
            MessageLookupByLibrary.simpleMessage("使用明细"),
        "movieTicketType_mubitikePassword":
            MessageLookupByLibrary.simpleMessage("密码（4位）"),
        "movieTicketType_mubitikePasswordHint":
            MessageLookupByLibrary.simpleMessage("请输入4位密码"),
        "movieTicketType_mubitikeTapToInput":
            MessageLookupByLibrary.simpleMessage("点击输入"),
        "movieTicketType_mubitikeTitle":
            MessageLookupByLibrary.simpleMessage("ムビチケ前売り券"),
        "movieTicketType_mubitikeUsageLimit":
            MessageLookupByLibrary.simpleMessage("每张预售券仅限1人1次观影使用"),
        "movieTicketType_mubitikeUseCount":
            MessageLookupByLibrary.simpleMessage("使用张数"),
        "movieTicketType_noSeatInfoRetry":
            MessageLookupByLibrary.simpleMessage("未获取到当前选座信息，请重新选择座位"),
        "movieTicketType_price": MessageLookupByLibrary.simpleMessage("价格"),
        "movieTicketType_priceDetailTitle":
            MessageLookupByLibrary.simpleMessage("价格明细"),
        "movieTicketType_priceDetail_fullPrice":
            MessageLookupByLibrary.simpleMessage("全价"),
        "movieTicketType_priceDetail_mubitikeOffset":
            MessageLookupByLibrary.simpleMessage("券抵"),
        "movieTicketType_priceRuleFormula":
            MessageLookupByLibrary.simpleMessage(
                "单人票价 = 区域价 + 票种价格 + 特效规格加价（3D/IMAX 等，普通 2D 无）"),
        "movieTicketType_priceRuleFormula_fixed":
            MessageLookupByLibrary.simpleMessage(
                "单人票价 = 固定票价 + 区域加价 + 规格加价 + 放映类型加价（2D/3D）"),
        "movieTicketType_priceRuleTitle":
            MessageLookupByLibrary.simpleMessage("价格计算规则"),
        "movieTicketType_seatCountLabel":
            MessageLookupByLibrary.simpleMessage("座"),
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
        "movieTicketType_sessionSurchargeTitle":
            MessageLookupByLibrary.simpleMessage("本场次加价："),
        "movieTicketType_showTime":
            MessageLookupByLibrary.simpleMessage("放映时间"),
        "movieTicketType_singleSeatPrice":
            MessageLookupByLibrary.simpleMessage("单人票价"),
        "movieTicketType_ticketType":
            MessageLookupByLibrary.simpleMessage("票种"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("选择电影票类型"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("合计"),
        "movieTicketType_totalPrice":
            MessageLookupByLibrary.simpleMessage("总价"),
        "movieTicketType_unavailableSeatsWithNames": m22,
        "movieTicketType_unknownTicketType":
            MessageLookupByLibrary.simpleMessage("未知票种"),
        "orderDetail_benefit_feedback_benefit_label":
            MessageLookupByLibrary.simpleMessage("特典"),
        "orderDetail_benefit_feedback_cinema_label":
            MessageLookupByLibrary.simpleMessage("反馈影院"),
        "orderDetail_benefit_feedback_hint":
            MessageLookupByLibrary.simpleMessage(
                "若您在该影院观影时发现下方特典已领完，点击提交后我们会更新库存提示，方便其他观众。"),
        "orderDetail_benefit_feedback_submit":
            MessageLookupByLibrary.simpleMessage("确认：该影院已领完"),
        "orderDetail_benefit_feedback_title":
            MessageLookupByLibrary.simpleMessage("特典反馈"),
        "orderDetail_countdown_hoursMinutes": m23,
        "orderDetail_countdown_minutesSeconds": m24,
        "orderDetail_countdown_seconds": m25,
        "orderDetail_countdown_started":
            MessageLookupByLibrary.simpleMessage("已开场"),
        "orderDetail_countdown_title":
            MessageLookupByLibrary.simpleMessage("即将开场提醒"),
        "orderDetail_failureReason":
            MessageLookupByLibrary.simpleMessage("失败原因"),
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
        "orderDetail_ticketCount": m26,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage("订单详情"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("评论"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage("订单号"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("订单列表"),
        "payError_back": MessageLookupByLibrary.simpleMessage("返回"),
        "payError_message":
            MessageLookupByLibrary.simpleMessage("您的订单似乎遇到了一些问题，请稍后重试。"),
        "payError_title": MessageLookupByLibrary.simpleMessage("支付失败"),
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
        "payment_selectCreditCard_expiryDate": m27,
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
        "presaleDetail_applyMovie":
            MessageLookupByLibrary.simpleMessage("适用电影"),
        "presaleDetail_bonus": MessageLookupByLibrary.simpleMessage("特典"),
        "presaleDetail_bonusCount": m28,
        "presaleDetail_bonusDescription":
            MessageLookupByLibrary.simpleMessage("特典说明"),
        "presaleDetail_gallery": MessageLookupByLibrary.simpleMessage("图集"),
        "presaleDetail_buyOnOfficialSite":
            MessageLookupByLibrary.simpleMessage("前往官网购买"),
        "presaleDetail_noLimit": MessageLookupByLibrary.simpleMessage("不限"),
        "presaleDetail_perUserLimit":
            MessageLookupByLibrary.simpleMessage("每人限购"),
        "presaleDetail_pickupNotes":
            MessageLookupByLibrary.simpleMessage("取票说明"),
        "presaleDetail_price": MessageLookupByLibrary.simpleMessage("价格"),
        "presaleDetail_salePeriod":
            MessageLookupByLibrary.simpleMessage("销售期间"),
        "presaleDetail_salePeriodNote": MessageLookupByLibrary.simpleMessage(
            "※ 销售期间与使用期间可能因影院而异，请以各影院公告为准"),
        "presaleDetail_specs": MessageLookupByLibrary.simpleMessage("规格"),
        "presaleDetail_title": MessageLookupByLibrary.simpleMessage("预售券"),
        "presaleDetail_usagePeriod":
            MessageLookupByLibrary.simpleMessage("使用期间"),
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
        "seatSelection_goToPay": MessageLookupByLibrary.simpleMessage("去支付"),
        "seatSelection_hasLockedOrderMessage":
            MessageLookupByLibrary.simpleMessage("您有未完成的订单，座位已被锁定。请前往支付或取消订单"),
        "seatSelection_hasLockedOrderTitle":
            MessageLookupByLibrary.simpleMessage("未完成订单"),
        "seatSelection_later": MessageLookupByLibrary.simpleMessage("稍后"),
        "seatSelection_screen": MessageLookupByLibrary.simpleMessage("屏幕"),
        "seatSelection_seatCanceled":
            MessageLookupByLibrary.simpleMessage("选择的座位已取消"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("确认选座"),
        "selectSeat_maxSelectSeatWarn": m29,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("请选择座位"),
        "showTimeDetail_address": MessageLookupByLibrary.simpleMessage("地址"),
        "showTimeDetail_buy": MessageLookupByLibrary.simpleMessage("选座"),
        "showTimeDetail_noOnlineTicket":
            MessageLookupByLibrary.simpleMessage("该场次暂无线上购票链接，请到影院现场或官网购票"),
        "showTimeDetail_seatStatus_available":
            MessageLookupByLibrary.simpleMessage("座位充足"),
        "showTimeDetail_seatStatus_soldOut":
            MessageLookupByLibrary.simpleMessage("已售罄"),
        "showTimeDetail_seatStatus_tight":
            MessageLookupByLibrary.simpleMessage("座位紧张"),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("分"),
        "showTime_benefit_feedback_soldOut":
            MessageLookupByLibrary.simpleMessage("网友反馈：今日已领完"),
        "ticket_benefit_feedback_btn":
            MessageLookupByLibrary.simpleMessage("去反馈"),
        "ticket_benefit_feedback_lead":
            MessageLookupByLibrary.simpleMessage("帮其他小伙伴确认下特典库存吧"),
        "ticket_benefit_feedback_select_ticket":
            MessageLookupByLibrary.simpleMessage("选择要反馈的场次"),
        "ticket_buyTickets": MessageLookupByLibrary.simpleMessage("去购票"),
        "ticket_endTime": MessageLookupByLibrary.simpleMessage("预计结束"),
        "ticket_noData": MessageLookupByLibrary.simpleMessage("暂无电影票"),
        "ticket_noDataTip": MessageLookupByLibrary.simpleMessage("快去购买电影票吧！"),
        "ticket_seatCount": MessageLookupByLibrary.simpleMessage("座位数"),
        "ticket_shareTicket": m30,
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
        "ticket_time_remaining_days": m31,
        "ticket_time_remaining_hours": m32,
        "ticket_time_remaining_minutes": m33,
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
        "user_creditCard": MessageLookupByLibrary.simpleMessage("信用卡管理"),
        "user_currentVersion": MessageLookupByLibrary.simpleMessage("当前版本"),
        "user_data_characterCount": MessageLookupByLibrary.simpleMessage("演员数"),
        "user_data_orderCount": MessageLookupByLibrary.simpleMessage("订单数"),
        "user_data_staffCount": MessageLookupByLibrary.simpleMessage("工作人员数"),
        "user_data_wantCount": MessageLookupByLibrary.simpleMessage("想看数"),
        "user_data_watchHistory": MessageLookupByLibrary.simpleMessage("观影记录"),
        "user_editProfile": MessageLookupByLibrary.simpleMessage("编辑个人信息"),
        "user_forceUpdateHint":
            MessageLookupByLibrary.simpleMessage("当前版本过低，请先更新后继续使用"),
        "user_language": MessageLookupByLibrary.simpleMessage("语言"),
        "user_latestVersion": MessageLookupByLibrary.simpleMessage("最新版本"),
        "user_loginSourceMultiple": MessageLookupByLibrary.simpleMessage("已绑定"),
        "user_loginSourceSingle": MessageLookupByLibrary.simpleMessage("通过"),
        "user_logout": MessageLookupByLibrary.simpleMessage("退出登录"),
        "user_logoutConfirmMessage":
            MessageLookupByLibrary.simpleMessage("确认要退出登录吗？"),
        "user_noUpdateAvailable":
            MessageLookupByLibrary.simpleMessage("当前已是最新版本"),
        "user_ok": MessageLookupByLibrary.simpleMessage("确定"),
        "user_privateAgreement": MessageLookupByLibrary.simpleMessage("隐私协议"),
        "user_registerTime": MessageLookupByLibrary.simpleMessage("注册时间"),
        "user_thirdPartySdk":
            MessageLookupByLibrary.simpleMessage("第三方 SDK 清单"),
        "user_timeFormat": MessageLookupByLibrary.simpleMessage("时间显示"),
        "user_timeFormat_24h": MessageLookupByLibrary.simpleMessage("24小时"),
        "user_timeFormat_30h": MessageLookupByLibrary.simpleMessage("30小时"),
        "user_timeFormat_subtitle_24h":
            MessageLookupByLibrary.simpleMessage("标准 24 小时制（00:00 ~ 23:59）"),
        "user_timeFormat_subtitle_30h":
            MessageLookupByLibrary.simpleMessage("30 小时制：次日 0~5 点显示为 24~29 点"),
        "user_title": MessageLookupByLibrary.simpleMessage("我的"),
        "user_update": MessageLookupByLibrary.simpleMessage("更新"),
        "user_updateAvailable":
            MessageLookupByLibrary.simpleMessage("发现新版本，是否立即更新？"),
        "user_updateDialogTitle": MessageLookupByLibrary.simpleMessage("发现新版本"),
        "user_updateError": MessageLookupByLibrary.simpleMessage("更新失败"),
        "user_updateErrorMessage":
            MessageLookupByLibrary.simpleMessage("更新过程中出现错误，请稍后重试。"),
        "user_updatePackageSizeLabel":
            MessageLookupByLibrary.simpleMessage("大小"),
        "user_updateProgress":
            MessageLookupByLibrary.simpleMessage("正在下载更新，请稍候..."),
        "user_updateReleaseNotes": MessageLookupByLibrary.simpleMessage("更新说明"),
        "user_updateRemindLater": MessageLookupByLibrary.simpleMessage("稍后提醒"),
        "user_updateSuccess": MessageLookupByLibrary.simpleMessage("更新成功"),
        "user_updateSuccessMessage":
            MessageLookupByLibrary.simpleMessage("应用已成功更新到最新版本！"),
        "user_updateToLatestHint":
            MessageLookupByLibrary.simpleMessage("更新至最新版本"),
        "user_updateWhatsNewInVersion": m34,
        "user_updating": MessageLookupByLibrary.simpleMessage("正在更新"),
        "user_userTerms": MessageLookupByLibrary.simpleMessage("用户协议"),
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
