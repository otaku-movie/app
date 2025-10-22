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

  static String m6(count) => "${count}席";

  static String m7(reply) => "@${reply} に返信";

  static String m8(language) => "${language}へ翻訳";

  static String m9(total) => "合計 ${total} 件の返信";

  static String m10(hours, minutes) => "上映開始まであと ${hours} 時間 ${minutes} 分";

  static String m11(minutes, seconds) => "上映開始まであと ${minutes} 分 ${seconds} 秒";

  static String m12(seconds) => "上映開始まであと ${seconds} 秒";

  static String m13(ticketCount) => "映画チケット ${ticketCount} 枚";

  static String m14(date) => "有効期限: ${date}";

  static String m15(maxSeat) => "最大${maxSeat}席までお選びいただけます";

  static String m16(movieName) => "映画チケットをシェア: ${movieName}";

  static String m17(days) => "あと${days}日";

  static String m18(hours) => "あと${hours}時間";

  static String m19(minutes) => "あと${minutes}分";

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
        "common_loading": MessageLookupByLibrary.simpleMessage("読み込み中..."),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("円"),
        "common_unit_point": MessageLookupByLibrary.simpleMessage("点"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("金"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("月"),
        "common_week_saturday": MessageLookupByLibrary.simpleMessage("土"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("日"),
        "common_week_thursday": MessageLookupByLibrary.simpleMessage("木"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("火"),
        "common_week_wednesday": MessageLookupByLibrary.simpleMessage("水"),
        "confirmOrder_cancelOrder":
            MessageLookupByLibrary.simpleMessage("注文をキャンセル"),
        "confirmOrder_cancelOrderConfirm": MessageLookupByLibrary.simpleMessage(
            "座席を選択済みです。注文をキャンセルして選択済みの座席を解放しますか？"),
        "confirmOrder_cancelOrderFailed":
            MessageLookupByLibrary.simpleMessage("注文のキャンセルに失敗しました。再試行してください"),
        "confirmOrder_cinemaInfo":
            MessageLookupByLibrary.simpleMessage("映画館情報"),
        "confirmOrder_confirmCancel":
            MessageLookupByLibrary.simpleMessage("キャンセル確認"),
        "confirmOrder_continuePay":
            MessageLookupByLibrary.simpleMessage("支払いを続ける"),
        "confirmOrder_countdown": MessageLookupByLibrary.simpleMessage("残り時間"),
        "confirmOrder_orderCanceled":
            MessageLookupByLibrary.simpleMessage("注文がキャンセルされました"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("支払いへ"),
        "confirmOrder_seatCount": m6,
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage("支払い方法を選択してください"),
        "confirmOrder_selectedSeats":
            MessageLookupByLibrary.simpleMessage("選択済み座席"),
        "confirmOrder_timeInfo": MessageLookupByLibrary.simpleMessage("時間情報"),
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
        "movieDetail_comment_replyTo": m7,
        "movieDetail_comment_translate": m8,
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
        "movieDetail_detail_totalReplyMessage": m9,
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
        "movieTicketType_actualPrice":
            MessageLookupByLibrary.simpleMessage("実際の支払い"),
        "movieTicketType_cinema": MessageLookupByLibrary.simpleMessage("映画館"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("注文確認"),
        "movieTicketType_movieInfo":
            MessageLookupByLibrary.simpleMessage("映画情報"),
        "movieTicketType_price": MessageLookupByLibrary.simpleMessage("価格"),
        "movieTicketType_seatInfo":
            MessageLookupByLibrary.simpleMessage("座席情報"),
        "movieTicketType_seatNumber":
            MessageLookupByLibrary.simpleMessage("座席番号"),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage("映画チケットの種類を選んでください"),
        "movieTicketType_selectTicketType":
            MessageLookupByLibrary.simpleMessage("チケット種類を選択"),
        "movieTicketType_selectTicketTypeForSeats":
            MessageLookupByLibrary.simpleMessage("各座席に適切なチケット種類を選択してください"),
        "movieTicketType_showTime":
            MessageLookupByLibrary.simpleMessage("上映時間"),
        "movieTicketType_ticketType":
            MessageLookupByLibrary.simpleMessage("チケット種類"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("映画チケットの種類を選択してください"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("合計"),
        "movieTicketType_totalPrice":
            MessageLookupByLibrary.simpleMessage("合計金額"),
        "orderDetail_countdown_hoursMinutes": m10,
        "orderDetail_countdown_minutesSeconds": m11,
        "orderDetail_countdown_seconds": m12,
        "orderDetail_countdown_started":
            MessageLookupByLibrary.simpleMessage("上映開始済み"),
        "orderDetail_countdown_title":
            MessageLookupByLibrary.simpleMessage("まもなく上映開始"),
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
        "orderDetail_ticketCount": m13,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage("注文詳細"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("コメント"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage("注文番号"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("注文一覧"),
        "payResult_qrCodeTip": MessageLookupByLibrary.simpleMessage(
            "このQRコードまたはチケットコードで劇場でチケットを受け取ってください"),
        "payResult_success": MessageLookupByLibrary.simpleMessage("支払い成功"),
        "payResult_ticketCode": MessageLookupByLibrary.simpleMessage("チケットコード"),
        "payResult_title": MessageLookupByLibrary.simpleMessage("支払い完了"),
        "payResult_viewMyTickets":
            MessageLookupByLibrary.simpleMessage("マイチケットを見る"),
        "payment_addCreditCard_cardConfirmed":
            MessageLookupByLibrary.simpleMessage("クレジットカード情報が確認されました"),
        "payment_addCreditCard_cardHolderName":
            MessageLookupByLibrary.simpleMessage("カード名義"),
        "payment_addCreditCard_cardHolderNameError":
            MessageLookupByLibrary.simpleMessage("カード名義を入力してください"),
        "payment_addCreditCard_cardHolderNameHint":
            MessageLookupByLibrary.simpleMessage("カード名義を入力してください"),
        "payment_addCreditCard_cardNumber":
            MessageLookupByLibrary.simpleMessage("カード番号"),
        "payment_addCreditCard_cardNumberError":
            MessageLookupByLibrary.simpleMessage("有効なカード番号を入力してください"),
        "payment_addCreditCard_cardNumberHint":
            MessageLookupByLibrary.simpleMessage("カード番号を入力してください"),
        "payment_addCreditCard_cardNumberLength":
            MessageLookupByLibrary.simpleMessage("カード番号の長さが正しくありません"),
        "payment_addCreditCard_cardSaved":
            MessageLookupByLibrary.simpleMessage("クレジットカードが保存されました"),
        "payment_addCreditCard_confirmAdd":
            MessageLookupByLibrary.simpleMessage("追加確認"),
        "payment_addCreditCard_cvv":
            MessageLookupByLibrary.simpleMessage("セキュリティコード"),
        "payment_addCreditCard_cvvError":
            MessageLookupByLibrary.simpleMessage("セキュリティコードを入力してください"),
        "payment_addCreditCard_cvvHint":
            MessageLookupByLibrary.simpleMessage("•••"),
        "payment_addCreditCard_cvvLength":
            MessageLookupByLibrary.simpleMessage("長さが正しくありません"),
        "payment_addCreditCard_expiryDate":
            MessageLookupByLibrary.simpleMessage("有効期限"),
        "payment_addCreditCard_expiryDateError":
            MessageLookupByLibrary.simpleMessage("有効期限を入力してください"),
        "payment_addCreditCard_expiryDateExpired":
            MessageLookupByLibrary.simpleMessage("カードの有効期限が切れています"),
        "payment_addCreditCard_expiryDateHint":
            MessageLookupByLibrary.simpleMessage("MM/YY"),
        "payment_addCreditCard_expiryDateInvalid":
            MessageLookupByLibrary.simpleMessage("有効期限の形式が正しくありません"),
        "payment_addCreditCard_operationFailed":
            MessageLookupByLibrary.simpleMessage("操作に失敗しました。再試行してください"),
        "payment_addCreditCard_saveCard":
            MessageLookupByLibrary.simpleMessage("このクレジットカードを保存"),
        "payment_addCreditCard_saveToAccount":
            MessageLookupByLibrary.simpleMessage("アカウントに保存され、次回使用時に便利です"),
        "payment_addCreditCard_title":
            MessageLookupByLibrary.simpleMessage("クレジットカードを追加"),
        "payment_addCreditCard_useOnce":
            MessageLookupByLibrary.simpleMessage("今回のみ使用、保存されません"),
        "payment_selectCreditCard_addNewCard":
            MessageLookupByLibrary.simpleMessage("新しいクレジットカードを追加"),
        "payment_selectCreditCard_confirmPayment":
            MessageLookupByLibrary.simpleMessage("支払い確認"),
        "payment_selectCreditCard_expiryDate": m14,
        "payment_selectCreditCard_loadFailed":
            MessageLookupByLibrary.simpleMessage("クレジットカード一覧の読み込みに失敗しました"),
        "payment_selectCreditCard_noCreditCard":
            MessageLookupByLibrary.simpleMessage("クレジットカードがありません"),
        "payment_selectCreditCard_paymentFailed":
            MessageLookupByLibrary.simpleMessage("支払いに失敗しました。再試行してください"),
        "payment_selectCreditCard_paymentSuccess":
            MessageLookupByLibrary.simpleMessage("支払い成功"),
        "payment_selectCreditCard_pleaseAddCard":
            MessageLookupByLibrary.simpleMessage("クレジットカードを追加してください"),
        "payment_selectCreditCard_pleaseSelectCard":
            MessageLookupByLibrary.simpleMessage("クレジットカードを選択してください"),
        "payment_selectCreditCard_removeTempCard":
            MessageLookupByLibrary.simpleMessage("一時カードを削除"),
        "payment_selectCreditCard_tempCard":
            MessageLookupByLibrary.simpleMessage("一時カード（今回のみ）"),
        "payment_selectCreditCard_tempCardRemoved":
            MessageLookupByLibrary.simpleMessage("一時カードが削除されました"),
        "payment_selectCreditCard_tempCardSelected":
            MessageLookupByLibrary.simpleMessage("一時クレジットカードが選択されました"),
        "payment_selectCreditCard_title":
            MessageLookupByLibrary.simpleMessage("クレジットカードを選択"),
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
        "seatCancel_cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "seatCancel_confirm": MessageLookupByLibrary.simpleMessage("確定"),
        "seatCancel_confirmMessage":
            MessageLookupByLibrary.simpleMessage("座席を選択済みです。選択した座席をキャンセルしますか？"),
        "seatCancel_confirmTitle":
            MessageLookupByLibrary.simpleMessage("座席選択をキャンセル"),
        "seatCancel_errorMessage":
            MessageLookupByLibrary.simpleMessage("座席選択のキャンセルに失敗しました。再試行してください"),
        "seatCancel_successMessage":
            MessageLookupByLibrary.simpleMessage("座席選択がキャンセルされました"),
        "seatSelection_cancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "seatSelection_cancelSeatConfirm": MessageLookupByLibrary.simpleMessage(
            "座席を選択済みです。選択済みの座席をキャンセルしますか？"),
        "seatSelection_cancelSeatFailed":
            MessageLookupByLibrary.simpleMessage("座席選択のキャンセルに失敗しました。再試行してください"),
        "seatSelection_cancelSeatTitle":
            MessageLookupByLibrary.simpleMessage("座席選択をキャンセル"),
        "seatSelection_confirm": MessageLookupByLibrary.simpleMessage("確定"),
        "seatSelection_seatCanceled":
            MessageLookupByLibrary.simpleMessage("座席選択がキャンセルされました"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("座席を確定する"),
        "selectSeat_maxSelectSeatWarn": m15,
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
        "ticket_shareTicket": m16,
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
        "ticket_time_remaining_days": m17,
        "ticket_time_remaining_hours": m18,
        "ticket_time_remaining_minutes": m19,
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
