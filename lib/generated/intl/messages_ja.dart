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

  static String m1(count) => "${count} 件の関連映画館が見つかりました";

  static String m2(count) => "${count} 席の選択を確認";

  static String m3(count) => "${count} 席を選択しました";

  static String m4(reply) => "${reply} に返信";

  static String m5(total) => "合計 ${total} 件の返信";

  static String m6(reply) => "@${reply} に返信";

  static String m7(language) => "${language}へ翻訳";

  static String m8(total) => "合計 ${total} 件の返信";

  static String m9(ticketCount) => "映画チケット ${ticketCount} 枚";

  static String m10(maxSeat) => "最大${maxSeat}席までお選びいただけます";

  static String m11(movieName) => "映画チケットをシェア: ${movieName}";

  static String m12(days) => "あと${days}日";

  static String m13(hours) => "あと${hours}時間";

  static String m14(minutes) => "あと${minutes}分";

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
        "cinemaDetail_theaterSpec":
            MessageLookupByLibrary.simpleMessage("シアター情報"),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage("基本料金"),
        "cinemaList_address": MessageLookupByLibrary.simpleMessage("現在地を取得中"),
        "cinemaList_empty_noData":
            MessageLookupByLibrary.simpleMessage("映画館データがありません"),
        "cinemaList_empty_noDataTip":
            MessageLookupByLibrary.simpleMessage("後でもう一度お試しください"),
        "cinemaList_empty_noSearchResults":
            MessageLookupByLibrary.simpleMessage("関連する映画館が見つかりません"),
        "cinemaList_empty_noSearchResultsTip":
            MessageLookupByLibrary.simpleMessage("他のキーワードをお試しください"),
        "cinemaList_filter_loading":
            MessageLookupByLibrary.simpleMessage("地域データを読み込み中..."),
        "cinemaList_filter_title":
            MessageLookupByLibrary.simpleMessage("地域でフィルター"),
        "cinemaList_loading":
            MessageLookupByLibrary.simpleMessage("読み込みに失敗しました。再試行してください"),
        "cinemaList_movies_nowShowing":
            MessageLookupByLibrary.simpleMessage("上映中"),
        "cinemaList_search_clear": MessageLookupByLibrary.simpleMessage("クリア"),
        "cinemaList_search_hint":
            MessageLookupByLibrary.simpleMessage("映画館名または住所を検索"),
        "cinemaList_search_results_found": m1,
        "cinemaList_search_results_notFound":
            MessageLookupByLibrary.simpleMessage(
                "関連する映画館が見つかりません。他のキーワードをお試しください"),
        "cinemaList_selectSeat_confirmSelection": m2,
        "cinemaList_selectSeat_dateFormat":
            MessageLookupByLibrary.simpleMessage("yyyy年MM月dd日"),
        "cinemaList_selectSeat_pleaseSelectSeats":
            MessageLookupByLibrary.simpleMessage("座席を選択してください"),
        "cinemaList_selectSeat_seatsSelected": m3,
        "cinemaList_selectSeat_selectedSeats":
            MessageLookupByLibrary.simpleMessage("選択済み座席"),
        "cinemaList_title": MessageLookupByLibrary.simpleMessage("近くの映画館"),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("返信"),
        "commentDetail_comment_placeholder": m4,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("コメント返信"),
        "commentDetail_title": MessageLookupByLibrary.simpleMessage("コメント詳細"),
        "commentDetail_totalReplyMessage": m5,
        "common_components_cropper_actions_flip":
            MessageLookupByLibrary.simpleMessage("フリップ"),
        "common_components_cropper_actions_redo":
            MessageLookupByLibrary.simpleMessage("やり直す"),
        "common_components_cropper_actions_reset":
            MessageLookupByLibrary.simpleMessage("リセット"),
        "common_components_cropper_actions_rotateLeft":
            MessageLookupByLibrary.simpleMessage("左へ回転"),
        "common_components_cropper_actions_rotateRight":
            MessageLookupByLibrary.simpleMessage("右へ回転"),
        "common_components_cropper_actions_undo":
            MessageLookupByLibrary.simpleMessage("元に戻す"),
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
            MessageLookupByLibrary.simpleMessage("認証コードが送信されました"),
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
            MessageLookupByLibrary.simpleMessage("車椅子席"),
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
            MessageLookupByLibrary.simpleMessage("支払い方法を選択してください"),
        "confirmOrder_title": MessageLookupByLibrary.simpleMessage("注文確認"),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("合計"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("映画館"),
        "home_home": MessageLookupByLibrary.simpleMessage("ホーム"),
        "home_me": MessageLookupByLibrary.simpleMessage("マイページ"),
        "home_ticket": MessageLookupByLibrary.simpleMessage("チケット"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("メール"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("メールアドレスが正しくありません"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("メールアドレスを入力してください"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("ログイン"),
        "login_noAccount":
            MessageLookupByLibrary.simpleMessage("アカウントをお持ちでない方はこちら"),
        "login_password_text": MessageLookupByLibrary.simpleMessage("パスワード"),
        "login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage("8〜16文字の英数字とアンダースコアを含めてください"),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("パスワードを入力してください"),
        "login_sendVerifyCodeButton":
            MessageLookupByLibrary.simpleMessage("認証コードを送信"),
        "login_verificationCode": MessageLookupByLibrary.simpleMessage("認証コード"),
        "movieDetail_button_buy":
            MessageLookupByLibrary.simpleMessage("チケット購入"),
        "movieDetail_button_saw": MessageLookupByLibrary.simpleMessage("見た"),
        "movieDetail_button_want": MessageLookupByLibrary.simpleMessage("見たい"),
        "movieDetail_comment_delete":
            MessageLookupByLibrary.simpleMessage("削除"),
        "movieDetail_comment_reply": MessageLookupByLibrary.simpleMessage("返信"),
        "movieDetail_comment_replyTo": m6,
        "movieDetail_comment_translate": m7,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage("基本情報"),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage("キャラクター"),
        "movieDetail_detail_comment":
            MessageLookupByLibrary.simpleMessage("コメント"),
        "movieDetail_detail_homepage":
            MessageLookupByLibrary.simpleMessage("公式サイト"),
        "movieDetail_detail_level":
            MessageLookupByLibrary.simpleMessage("レーティング"),
        "movieDetail_detail_noDate":
            MessageLookupByLibrary.simpleMessage("上映日未定"),
        "movieDetail_detail_originalName":
            MessageLookupByLibrary.simpleMessage("原題"),
        "movieDetail_detail_spec": MessageLookupByLibrary.simpleMessage("上映仕様"),
        "movieDetail_detail_staff":
            MessageLookupByLibrary.simpleMessage("スタッフ"),
        "movieDetail_detail_state":
            MessageLookupByLibrary.simpleMessage("上映状況"),
        "movieDetail_detail_tags": MessageLookupByLibrary.simpleMessage("タグ"),
        "movieDetail_detail_time": MessageLookupByLibrary.simpleMessage("上映時間"),
        "movieDetail_detail_totalReplyMessage": m8,
        "movieDetail_writeComment":
            MessageLookupByLibrary.simpleMessage("コメントを書く"),
        "movieList_buy": MessageLookupByLibrary.simpleMessage("チケット購入"),
        "movieList_comingSoon_noDate":
            MessageLookupByLibrary.simpleMessage("日程未定"),
        "movieList_currentlyShowing_level":
            MessageLookupByLibrary.simpleMessage("映倫"),
        "movieList_placeholder":
            MessageLookupByLibrary.simpleMessage("すべての映画を検索"),
        "movieList_tabBar_comingSoon":
            MessageLookupByLibrary.simpleMessage("近日公開"),
        "movieList_tabBar_currentlyShowing":
            MessageLookupByLibrary.simpleMessage("現在上映中"),
        "movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("地域"),
        "movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("上映仕様"),
        "movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("字幕"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("注文確認"),
        "movieTicketType_seatNumber":
            MessageLookupByLibrary.simpleMessage("座席番号"),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage("映画チケットの種類を選んでください"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("映画チケットの種類を選択してください"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("合計"),
        "orderDetail_orderCreateTime":
            MessageLookupByLibrary.simpleMessage("注文作成日時"),
        "orderDetail_orderMessage":
            MessageLookupByLibrary.simpleMessage("注文情報"),
        "orderDetail_orderNumber": MessageLookupByLibrary.simpleMessage("注文番号"),
        "orderDetail_orderState": MessageLookupByLibrary.simpleMessage("注文状態"),
        "orderDetail_payMethod": MessageLookupByLibrary.simpleMessage("支払い方法"),
        "orderDetail_payTime": MessageLookupByLibrary.simpleMessage("支払日時"),
        "orderDetail_seatMessage": MessageLookupByLibrary.simpleMessage("座席情報"),
        "orderDetail_ticketCode":
            MessageLookupByLibrary.simpleMessage("チケットコード"),
        "orderDetail_ticketCount": m9,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage("注文詳細"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("コメント"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage("注文番号"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("注文一覧"),
        "payResult_success": MessageLookupByLibrary.simpleMessage(
            "ご注文の支払いは完了しましたので、下記の時間までに下記の場所にお越しください。良い映画鑑賞をお楽しみください。"),
        "payResult_ticketCode": MessageLookupByLibrary.simpleMessage("チケットコード"),
        "payResult_title": MessageLookupByLibrary.simpleMessage("支払い完了"),
        "register_haveAccount":
            MessageLookupByLibrary.simpleMessage("すでにアカウントをお持ちですか？"),
        "register_loginHere": MessageLookupByLibrary.simpleMessage("こちらからログイン"),
        "register_passwordNotMatchRepeatPassword":
            MessageLookupByLibrary.simpleMessage("2回入力したパスワードは一致しません"),
        "register_registerButton":
            MessageLookupByLibrary.simpleMessage("登録してログイン"),
        "register_repeatPassword_text":
            MessageLookupByLibrary.simpleMessage("パスワード（確認）"),
        "register_repeatPassword_verify_isValid":
            MessageLookupByLibrary.simpleMessage("8〜16文字の英数字とアンダースコアを含めてください"),
        "register_repeatPassword_verify_notNull":
            MessageLookupByLibrary.simpleMessage("確認用パスワードを入力してください"),
        "register_send": MessageLookupByLibrary.simpleMessage("送信"),
        "register_username_text": MessageLookupByLibrary.simpleMessage("ユーザー名"),
        "register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("ユーザー名を入力してください"),
        "register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage("6桁の数字を入力してください"),
        "register_verifyCode_verify_notNull":
            MessageLookupByLibrary.simpleMessage("認証コードを入力してください"),
        "search_history": MessageLookupByLibrary.simpleMessage("検索履歴"),
        "search_level": MessageLookupByLibrary.simpleMessage("映倫"),
        "search_noData": MessageLookupByLibrary.simpleMessage("まだデータがありません"),
        "search_placeholder": MessageLookupByLibrary.simpleMessage("すべての映画を検索"),
        "search_removeHistoryConfirm_cancel":
            MessageLookupByLibrary.simpleMessage("キャンセル"),
        "search_removeHistoryConfirm_confirm":
            MessageLookupByLibrary.simpleMessage("確認"),
        "search_removeHistoryConfirm_content":
            MessageLookupByLibrary.simpleMessage("検索履歴を削除してもよろしいですか？"),
        "search_removeHistoryConfirm_title":
            MessageLookupByLibrary.simpleMessage("履歴を削除"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("座席を確定する"),
        "selectSeat_maxSelectSeatWarn": m10,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("座席を選択してください"),
        "showTimeDetail_address": MessageLookupByLibrary.simpleMessage("アドレス"),
        "showTimeDetail_buy": MessageLookupByLibrary.simpleMessage("チケット購入"),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("分"),
        "ticket_buyTickets": MessageLookupByLibrary.simpleMessage("チケットを購入"),
        "ticket_endTime": MessageLookupByLibrary.simpleMessage("予想終了時間"),
        "ticket_noData": MessageLookupByLibrary.simpleMessage("まだチケットがありません"),
        "ticket_noDataTip":
            MessageLookupByLibrary.simpleMessage("チケットを購入してください！"),
        "ticket_seatCount": MessageLookupByLibrary.simpleMessage("座席数"),
        "ticket_shareTicket": m11,
        "ticket_showTime": MessageLookupByLibrary.simpleMessage("上映時間"),
        "ticket_status_cancelled":
            MessageLookupByLibrary.simpleMessage("キャンセル済み"),
        "ticket_status_expired": MessageLookupByLibrary.simpleMessage("期限切れ"),
        "ticket_status_used": MessageLookupByLibrary.simpleMessage("使用済み"),
        "ticket_status_valid": MessageLookupByLibrary.simpleMessage("有効"),
        "ticket_tapToView": MessageLookupByLibrary.simpleMessage("タップして詳細を表示"),
        "ticket_ticketCount": MessageLookupByLibrary.simpleMessage("チケット数"),
        "ticket_tickets": MessageLookupByLibrary.simpleMessage("枚のチケット"),
        "ticket_time_formatError":
            MessageLookupByLibrary.simpleMessage("時間形式エラー"),
        "ticket_time_remaining_days": m12,
        "ticket_time_remaining_hours": m13,
        "ticket_time_remaining_minutes": m14,
        "ticket_time_remaining_soon":
            MessageLookupByLibrary.simpleMessage("まもなく開始"),
        "ticket_time_unknown": MessageLookupByLibrary.simpleMessage("時間不明"),
        "ticket_time_weekdays_friday":
            MessageLookupByLibrary.simpleMessage("金曜日"),
        "ticket_time_weekdays_monday":
            MessageLookupByLibrary.simpleMessage("月曜日"),
        "ticket_time_weekdays_saturday":
            MessageLookupByLibrary.simpleMessage("土曜日"),
        "ticket_time_weekdays_sunday":
            MessageLookupByLibrary.simpleMessage("日曜日"),
        "ticket_time_weekdays_thursday":
            MessageLookupByLibrary.simpleMessage("木曜日"),
        "ticket_time_weekdays_tuesday":
            MessageLookupByLibrary.simpleMessage("火曜日"),
        "ticket_time_weekdays_wednesday":
            MessageLookupByLibrary.simpleMessage("水曜日"),
        "ticket_totalPurchased": MessageLookupByLibrary.simpleMessage("合計購入"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage("アバター"),
        "userProfile_edit_username_placeholder":
            MessageLookupByLibrary.simpleMessage("ユーザー名を入力してください"),
        "userProfile_edit_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("ユーザー名は必須です"),
        "userProfile_email": MessageLookupByLibrary.simpleMessage("メール"),
        "userProfile_registerTime":
            MessageLookupByLibrary.simpleMessage("登録日時"),
        "userProfile_save": MessageLookupByLibrary.simpleMessage("保存"),
        "userProfile_title": MessageLookupByLibrary.simpleMessage("個人情報"),
        "userProfile_username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
        "user_about": MessageLookupByLibrary.simpleMessage("アプリについて"),
        "user_checkUpdate": MessageLookupByLibrary.simpleMessage("アップデート確認"),
        "user_data_characterCount":
            MessageLookupByLibrary.simpleMessage("キャラクター数"),
        "user_data_orderCount": MessageLookupByLibrary.simpleMessage("注文数"),
        "user_data_staffCount": MessageLookupByLibrary.simpleMessage("スタッフ数"),
        "user_data_wantCount": MessageLookupByLibrary.simpleMessage("観たい数"),
        "user_data_watchHistory": MessageLookupByLibrary.simpleMessage("鑑賞履歴"),
        "user_editProfile": MessageLookupByLibrary.simpleMessage("プロフィール編集"),
        "user_language": MessageLookupByLibrary.simpleMessage("言語"),
        "user_logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
        "user_privateAgreement":
            MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
        "user_registerTime": MessageLookupByLibrary.simpleMessage("登録日時"),
        "user_title": MessageLookupByLibrary.simpleMessage("マイページ"),
        "writeComment_hint":
            MessageLookupByLibrary.simpleMessage("コメントを入力してください..."),
        "writeComment_release": MessageLookupByLibrary.simpleMessage("リリース"),
        "writeComment_title": MessageLookupByLibrary.simpleMessage("コメントを書く"),
        "writeComment_verify_notNull":
            MessageLookupByLibrary.simpleMessage("コメントを入力してください"),
        "writeComment_verify_notRate":
            MessageLookupByLibrary.simpleMessage("映画に評価を付けてください")
      };
}
