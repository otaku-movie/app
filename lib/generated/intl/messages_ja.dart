// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(seatCount) => "${seatCount}席";

  static String m1(reply) => "${reply} に返信";

  static String m2(total) => "合計 ${total} 件の返信";

  static String m3(reply) => "@${reply} に返信";

  static String m4(language) => "${language}へ翻訳";

  static String m5(total) => "合計 ${total} 件の返信";

  static String m6(ticketCount) => "";

  static String m7(maxSeat) => "最大${maxSeat}席までお選びいただけます";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cinemaDetail_address": MessageLookupByLibrary.simpleMessage("アドレス"),
        "cinemaDetail_homepage": MessageLookupByLibrary.simpleMessage("ホームページ"),
        "cinemaDetail_maxSelectSeat":
            MessageLookupByLibrary.simpleMessage("利用可能な座席数"),
        "cinemaDetail_seatCount": m0,
        "cinemaDetail_showing": MessageLookupByLibrary.simpleMessage("上映中"),
        "cinemaDetail_specialSpecPrice":
            MessageLookupByLibrary.simpleMessage("特別上映料金"),
        "cinemaDetail_tel": MessageLookupByLibrary.simpleMessage("連絡先"),
        "cinemaDetail_theaterSpec": MessageLookupByLibrary.simpleMessage(""),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage("基本料金"),
        "cinemaList_address": MessageLookupByLibrary.simpleMessage(""),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage(""),
        "commentDetail_comment_placeholder": m1,
        "commentDetail_replyComment": MessageLookupByLibrary.simpleMessage(""),
        "commentDetail_title": MessageLookupByLibrary.simpleMessage(""),
        "commentDetail_totalReplyMessage": m2,
        "common_components_cropper_actions_flip":
            MessageLookupByLibrary.simpleMessage("フリップ"),
        "common_components_cropper_actions_redo":
            MessageLookupByLibrary.simpleMessage("元に戻す"),
        "common_components_cropper_actions_reset":
            MessageLookupByLibrary.simpleMessage("リセット"),
        "common_components_cropper_actions_rotateLeft":
            MessageLookupByLibrary.simpleMessage("左へ回転"),
        "common_components_cropper_actions_rotateRight":
            MessageLookupByLibrary.simpleMessage("右へ回転"),
        "common_components_cropper_actions_undo":
            MessageLookupByLibrary.simpleMessage("キャンセル"),
        "common_components_cropper_title":
            MessageLookupByLibrary.simpleMessage("写真をトリミングする"),
        "common_components_easyRefresh_loadMore_armedText":
            MessageLookupByLibrary.simpleMessage("さらに読み込むために離してください"),
        "common_components_easyRefresh_loadMore_dragText":
            MessageLookupByLibrary.simpleMessage("上に引っ張ってさらに読み込む"),
        "common_components_easyRefresh_loadMore_failedText":
            MessageLookupByLibrary.simpleMessage("読み込み失敗"),
        "common_components_easyRefresh_loadMore_noMoreText":
            MessageLookupByLibrary.simpleMessage("これ以上のデータはありません"),
        "common_components_easyRefresh_loadMore_processedText":
            MessageLookupByLibrary.simpleMessage("読み込み完了"),
        "common_components_easyRefresh_loadMore_processingText":
            MessageLookupByLibrary.simpleMessage("読み込み中..."),
        "common_components_easyRefresh_loadMore_readyText":
            MessageLookupByLibrary.simpleMessage("さらに読み込む準備"),
        "common_components_easyRefresh_refresh_armedText":
            MessageLookupByLibrary.simpleMessage("更新するために離してください"),
        "common_components_easyRefresh_refresh_dragText":
            MessageLookupByLibrary.simpleMessage("下に引っ張って更新"),
        "common_components_easyRefresh_refresh_failedText":
            MessageLookupByLibrary.simpleMessage("更新失敗"),
        "common_components_easyRefresh_refresh_noMoreText":
            MessageLookupByLibrary.simpleMessage("もうデータはありません"),
        "common_components_easyRefresh_refresh_processedText":
            MessageLookupByLibrary.simpleMessage("更新完了"),
        "common_components_easyRefresh_refresh_processingText":
            MessageLookupByLibrary.simpleMessage("更新しています..."),
        "common_components_easyRefresh_refresh_readyText":
            MessageLookupByLibrary.simpleMessage("更新中..."),
        "common_components_sendVerifyCode_send":
            MessageLookupByLibrary.simpleMessage("検証コードを送信"),
        "common_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage(""),
        "common_enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("カップルシート"),
        "common_enum_seatType_disabled":
            MessageLookupByLibrary.simpleMessage("選択不可"),
        "common_enum_seatType_locked":
            MessageLookupByLibrary.simpleMessage("ロック済み"),
        "common_enum_seatType_selected":
            MessageLookupByLibrary.simpleMessage("選択済み"),
        "common_enum_seatType_sold":
            MessageLookupByLibrary.simpleMessage("販売済み"),
        "common_enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("輪椅シート"),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("円"),
        "common_unit_point": MessageLookupByLibrary.simpleMessage("点"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("金"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("月"),
        "common_week_saturday": MessageLookupByLibrary.simpleMessage("土"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("日"),
        "common_week_thursday": MessageLookupByLibrary.simpleMessage("木"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("火"),
        "common_week_wednesday": MessageLookupByLibrary.simpleMessage("水"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("支払いへ"),
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage(""),
        "confirmOrder_title": MessageLookupByLibrary.simpleMessage(""),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("合計"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("映画館"),
        "home_home": MessageLookupByLibrary.simpleMessage("ホーム"),
        "home_me": MessageLookupByLibrary.simpleMessage("マイページ"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("メール"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("メールアドレスが正しくありません"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("メールアドレスを入力してください"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("ログイン"),
        "login_noAccount": MessageLookupByLibrary.simpleMessage(""),
        "login_password_text": MessageLookupByLibrary.simpleMessage("パスワード"),
        "login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage(""),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "login_sendVerifyCodeButton": MessageLookupByLibrary.simpleMessage(""),
        "login_verificationCode": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_button_buy": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_button_saw": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_button_want": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_comment_delete": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_comment_reply": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_comment_replyTo": m3,
        "movieDetail_comment_replyTo_translate": m4,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_comment": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_homepage": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_level": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_noDate": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_originalName":
            MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_spec": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_staff": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_state": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_tags": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_time": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_detail_totalReplyMessage": m5,
        "movieDetail_writeComment": MessageLookupByLibrary.simpleMessage(""),
        "movieList_buy": MessageLookupByLibrary.simpleMessage(""),
        "movieList_comingSoon_noDate": MessageLookupByLibrary.simpleMessage(""),
        "movieList_currentlyShowing_level":
            MessageLookupByLibrary.simpleMessage("映倫"),
        "movieList_placeholder": MessageLookupByLibrary.simpleMessage(""),
        "movieList_tabBar_comingSoon":
            MessageLookupByLibrary.simpleMessage("近日公開"),
        "movieList_tabBar_currentlyShowing":
            MessageLookupByLibrary.simpleMessage("現在上映中"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("注文確認"),
        "movieTicketType_seatNumber": MessageLookupByLibrary.simpleMessage(""),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage(""),
        "movieTicketType_title": MessageLookupByLibrary.simpleMessage(""),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("合計"),
        "orderDetail_orderCreateTime": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_orderMessage": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_orderNumber": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_orderState": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_payMethod": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_payTime": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_seatMessage": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_ticketCode":
            MessageLookupByLibrary.simpleMessage("チケットコード"),
        "orderDetail_ticketCount": m6,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage(""),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("コメント"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage(""),
        "orderList_title": MessageLookupByLibrary.simpleMessage(""),
        "payResult_success": MessageLookupByLibrary.simpleMessage(
            "ご注文の支払いは完了しましたので、下記の時間までに下記の場所にお越しください。"),
        "payResult_ticketCode": MessageLookupByLibrary.simpleMessage("チケットコード"),
        "payResult_title": MessageLookupByLibrary.simpleMessage("支払い完了"),
        "register_haveAccount": MessageLookupByLibrary.simpleMessage(""),
        "register_loginHere": MessageLookupByLibrary.simpleMessage(""),
        "register_passwordNotMatchRepeatPassword":
            MessageLookupByLibrary.simpleMessage("2回入力したパスワードは一致しません"),
        "register_registerButton": MessageLookupByLibrary.simpleMessage(""),
        "register_repeatPassword_text":
            MessageLookupByLibrary.simpleMessage(""),
        "register_repeatPassword_verify_isValid":
            MessageLookupByLibrary.simpleMessage(""),
        "register_repeatPassword_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "register_send": MessageLookupByLibrary.simpleMessage(""),
        "register_username_text": MessageLookupByLibrary.simpleMessage(""),
        "register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage(""),
        "register_verifyCode_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "search_history": MessageLookupByLibrary.simpleMessage("検索履歴"),
        "search_level": MessageLookupByLibrary.simpleMessage("映倫"),
        "search_noData": MessageLookupByLibrary.simpleMessage("まだデータがありません"),
        "search_placeholder": MessageLookupByLibrary.simpleMessage(""),
        "search_removeHistoryConfirm_cancel":
            MessageLookupByLibrary.simpleMessage(""),
        "search_removeHistoryConfirm_confirm":
            MessageLookupByLibrary.simpleMessage(""),
        "search_removeHistoryConfirm_content":
            MessageLookupByLibrary.simpleMessage(""),
        "search_removeHistoryConfirm_title":
            MessageLookupByLibrary.simpleMessage(""),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("座席を確定する"),
        "selectSeat_maxSelectSeatWarn": m7,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("座席を選択してください"),
        "showTimeDetail_address": MessageLookupByLibrary.simpleMessage("アドレス"),
        "showTimeDetail_buy": MessageLookupByLibrary.simpleMessage(""),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("分"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_edit_username_placeholder":
            MessageLookupByLibrary.simpleMessage(""),
        "userProfile_edit_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "userProfile_email": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_registerTime": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_save": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_title": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_username": MessageLookupByLibrary.simpleMessage(""),
        "user_about": MessageLookupByLibrary.simpleMessage(""),
        "user_checkUpdate": MessageLookupByLibrary.simpleMessage(""),
        "user_data_characterCount": MessageLookupByLibrary.simpleMessage(""),
        "user_data_orderCount": MessageLookupByLibrary.simpleMessage(""),
        "user_data_staffCount": MessageLookupByLibrary.simpleMessage(""),
        "user_data_wantCount": MessageLookupByLibrary.simpleMessage(""),
        "user_editProfile": MessageLookupByLibrary.simpleMessage(""),
        "user_language": MessageLookupByLibrary.simpleMessage("言語"),
        "user_logout": MessageLookupByLibrary.simpleMessage(""),
        "user_privateAgreement": MessageLookupByLibrary.simpleMessage(""),
        "user_title": MessageLookupByLibrary.simpleMessage(""),
        "writeComment_hint": MessageLookupByLibrary.simpleMessage(""),
        "writeComment_release": MessageLookupByLibrary.simpleMessage(""),
        "writeComment_title": MessageLookupByLibrary.simpleMessage(""),
        "writeComment_verify_notNull": MessageLookupByLibrary.simpleMessage(""),
        "writeComment_verify_notRate": MessageLookupByLibrary.simpleMessage("")
      };
}
