// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(seatCount) => "${seatCount} seats";

  static String m1(reply) => "Reply to ${reply}";

  static String m2(total) => "Total ${total} replies";

  static String m3(reply) => "Reply to ${reply}";

  static String m4(language) => "Translate to ${language}";

  static String m5(total) => "Total ${total} replies";

  static String m6(ticketCount) => "";

  static String m7(maxSeat) => "A maximum of ${maxSeat} seats can be selected";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cinemaDetail_address": MessageLookupByLibrary.simpleMessage("Address"),
        "cinemaDetail_homepage":
            MessageLookupByLibrary.simpleMessage("WebSite"),
        "cinemaDetail_maxSelectSeat": MessageLookupByLibrary.simpleMessage(
            "Maximum number of available seats"),
        "cinemaDetail_seatCount": m0,
        "cinemaDetail_showing": MessageLookupByLibrary.simpleMessage("Showing"),
        "cinemaDetail_specialSpecPrice":
            MessageLookupByLibrary.simpleMessage(""),
        "cinemaDetail_tel": MessageLookupByLibrary.simpleMessage("TEL"),
        "cinemaDetail_theaterSpec": MessageLookupByLibrary.simpleMessage(""),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage(""),
        "cinemaList_address": MessageLookupByLibrary.simpleMessage(""),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("Reply"),
        "commentDetail_comment_placeholder": m1,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("Comment Reply"),
        "commentDetail_title":
            MessageLookupByLibrary.simpleMessage("Comment Detail"),
        "commentDetail_totalReplyMessage": m2,
        "common_components_cropper_actions_flip":
            MessageLookupByLibrary.simpleMessage("Flip"),
        "common_components_cropper_actions_redo":
            MessageLookupByLibrary.simpleMessage("Restore Undo"),
        "common_components_cropper_actions_reset":
            MessageLookupByLibrary.simpleMessage("Reset"),
        "common_components_cropper_actions_rotateLeft":
            MessageLookupByLibrary.simpleMessage("Rotate Left"),
        "common_components_cropper_actions_rotateRight":
            MessageLookupByLibrary.simpleMessage("Rotate Right"),
        "common_components_cropper_actions_undo":
            MessageLookupByLibrary.simpleMessage("Revocation"),
        "common_components_cropper_title":
            MessageLookupByLibrary.simpleMessage("Crop the picture"),
        "common_components_easyRefresh_loadMore_armedText":
            MessageLookupByLibrary.simpleMessage("Release to load more"),
        "common_components_easyRefresh_loadMore_dragText":
            MessageLookupByLibrary.simpleMessage("Pull to load more"),
        "common_components_easyRefresh_loadMore_failedText":
            MessageLookupByLibrary.simpleMessage("Load failed"),
        "common_components_easyRefresh_loadMore_noMoreText":
            MessageLookupByLibrary.simpleMessage("No more data"),
        "common_components_easyRefresh_loadMore_processedText":
            MessageLookupByLibrary.simpleMessage("Load complete"),
        "common_components_easyRefresh_loadMore_processingText":
            MessageLookupByLibrary.simpleMessage("Loading..."),
        "common_components_easyRefresh_loadMore_readyText":
            MessageLookupByLibrary.simpleMessage("Ready to load more"),
        "common_components_easyRefresh_refresh_armedText":
            MessageLookupByLibrary.simpleMessage("Release to refresh"),
        "common_components_easyRefresh_refresh_dragText":
            MessageLookupByLibrary.simpleMessage("Pull to refresh"),
        "common_components_easyRefresh_refresh_failedText":
            MessageLookupByLibrary.simpleMessage("Refresh failed"),
        "common_components_easyRefresh_refresh_noMoreText":
            MessageLookupByLibrary.simpleMessage("No more data"),
        "common_components_easyRefresh_refresh_processedText":
            MessageLookupByLibrary.simpleMessage("Refresh complete"),
        "common_components_easyRefresh_refresh_processingText":
            MessageLookupByLibrary.simpleMessage("Refreshing..."),
        "common_components_easyRefresh_refresh_readyText":
            MessageLookupByLibrary.simpleMessage("Refreshing..."),
        "common_components_sendVerifyCode_send":
            MessageLookupByLibrary.simpleMessage("Send Verification Code"),
        "common_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage(""),
        "common_enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("Couple Seat"),
        "common_enum_seatType_disabled":
            MessageLookupByLibrary.simpleMessage("Disabled"),
        "common_enum_seatType_locked":
            MessageLookupByLibrary.simpleMessage("Locked"),
        "common_enum_seatType_selected":
            MessageLookupByLibrary.simpleMessage("Selected"),
        "common_enum_seatType_sold":
            MessageLookupByLibrary.simpleMessage("Sold"),
        "common_enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("Wheelchair Seat"),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("JPY"),
        "common_unit_point": MessageLookupByLibrary.simpleMessage(" point"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("Fri"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("Mon"),
        "common_week_saturday": MessageLookupByLibrary.simpleMessage("Sat"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("Sun"),
        "common_week_thursday": MessageLookupByLibrary.simpleMessage("Thu"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("Tue"),
        "common_week_wednesday": MessageLookupByLibrary.simpleMessage("Wed"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("Buy"),
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage(""),
        "confirmOrder_title": MessageLookupByLibrary.simpleMessage(""),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("Total"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("cinema"),
        "home_home": MessageLookupByLibrary.simpleMessage("home"),
        "home_me": MessageLookupByLibrary.simpleMessage("my page"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("Email"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("Invalid email address"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Email cannot be empty"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "login_noAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "login_password_text": MessageLookupByLibrary.simpleMessage("Password"),
        "login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage(""),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "login_sendVerifyCodeButton": MessageLookupByLibrary.simpleMessage(""),
        "login_verificationCode": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_button_buy": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_button_saw": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_button_want": MessageLookupByLibrary.simpleMessage(""),
        "movieDetail_comment_delete":
            MessageLookupByLibrary.simpleMessage("Delete"),
        "movieDetail_comment_reply":
            MessageLookupByLibrary.simpleMessage("reply"),
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
        "movieDetail_writeComment":
            MessageLookupByLibrary.simpleMessage("Write comment"),
        "movieList_buy": MessageLookupByLibrary.simpleMessage(""),
        "movieList_comingSoon_noDate": MessageLookupByLibrary.simpleMessage(""),
        "movieList_currentlyShowing_level":
            MessageLookupByLibrary.simpleMessage("Level"),
        "movieList_placeholder": MessageLookupByLibrary.simpleMessage(""),
        "movieList_tabBar_comingSoon":
            MessageLookupByLibrary.simpleMessage("Coming Soon"),
        "movieList_tabBar_currentlyShowing":
            MessageLookupByLibrary.simpleMessage("Currently Showing"),
        "movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("Area"),
        "movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("Screen Spec"),
        "movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("Subtitle"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("Confirm Order"),
        "movieTicketType_seatNumber": MessageLookupByLibrary.simpleMessage(""),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage(""),
        "movieTicketType_title": MessageLookupByLibrary.simpleMessage(""),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("Total"),
        "orderDetail_orderCreateTime": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_orderMessage": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_orderNumber": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_orderState": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_payMethod": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_payTime": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_seatMessage": MessageLookupByLibrary.simpleMessage(""),
        "orderDetail_ticketCode":
            MessageLookupByLibrary.simpleMessage("Ticket collection code"),
        "orderDetail_ticketCount": m6,
        "orderDetail_title": MessageLookupByLibrary.simpleMessage(""),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("comment"),
        "orderList_orderNumber": MessageLookupByLibrary.simpleMessage(""),
        "orderList_title": MessageLookupByLibrary.simpleMessage(""),
        "payResult_success": MessageLookupByLibrary.simpleMessage(
            "Your order has been paid. Please arrive at the following location before the following time. Enjoy your movie."),
        "payResult_ticketCode":
            MessageLookupByLibrary.simpleMessage("Ticket collection code"),
        "payResult_title": MessageLookupByLibrary.simpleMessage("Pay Succeed"),
        "register_haveAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "register_loginHere":
            MessageLookupByLibrary.simpleMessage("Click Here"),
        "register_passwordNotMatchRepeatPassword":
            MessageLookupByLibrary.simpleMessage(
                "The passwords you entered twice do not match"),
        "register_registerButton":
            MessageLookupByLibrary.simpleMessage("Register"),
        "register_repeatPassword_text":
            MessageLookupByLibrary.simpleMessage("Repeat Password"),
        "register_repeatPassword_verify_isValid":
            MessageLookupByLibrary.simpleMessage(""),
        "register_repeatPassword_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "register_send": MessageLookupByLibrary.simpleMessage("send"),
        "register_username_text":
            MessageLookupByLibrary.simpleMessage("UserName"),
        "register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage(""),
        "register_verifyCode_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "search_history":
            MessageLookupByLibrary.simpleMessage("Search History"),
        "search_level": MessageLookupByLibrary.simpleMessage("Level"),
        "search_noData": MessageLookupByLibrary.simpleMessage("No data yet"),
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
            MessageLookupByLibrary.simpleMessage("Confirm Seat Selection"),
        "selectSeat_maxSelectSeatWarn": m7,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("Please select a seat"),
        "showTimeDetail_address":
            MessageLookupByLibrary.simpleMessage("Address"),
        "showTimeDetail_buy": MessageLookupByLibrary.simpleMessage(""),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("minutes"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_edit_username_placeholder":
            MessageLookupByLibrary.simpleMessage("Please enter your username"),
        "userProfile_edit_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage(""),
        "userProfile_email": MessageLookupByLibrary.simpleMessage("Email"),
        "userProfile_registerTime":
            MessageLookupByLibrary.simpleMessage("Register Time"),
        "userProfile_save": MessageLookupByLibrary.simpleMessage("Save"),
        "userProfile_title": MessageLookupByLibrary.simpleMessage(""),
        "userProfile_username": MessageLookupByLibrary.simpleMessage(""),
        "user_about": MessageLookupByLibrary.simpleMessage(""),
        "user_checkUpdate": MessageLookupByLibrary.simpleMessage(""),
        "user_data_characterCount": MessageLookupByLibrary.simpleMessage(""),
        "user_data_orderCount": MessageLookupByLibrary.simpleMessage(""),
        "user_data_staffCount": MessageLookupByLibrary.simpleMessage(""),
        "user_data_wantCount": MessageLookupByLibrary.simpleMessage(""),
        "user_editProfile": MessageLookupByLibrary.simpleMessage(""),
        "user_language": MessageLookupByLibrary.simpleMessage("Language"),
        "user_logout": MessageLookupByLibrary.simpleMessage(""),
        "user_privateAgreement": MessageLookupByLibrary.simpleMessage(""),
        "user_registerTime": MessageLookupByLibrary.simpleMessage(""),
        "user_title": MessageLookupByLibrary.simpleMessage(""),
        "writeComment_hint":
            MessageLookupByLibrary.simpleMessage("Write your comment..."),
        "writeComment_release": MessageLookupByLibrary.simpleMessage("Release"),
        "writeComment_title":
            MessageLookupByLibrary.simpleMessage("Write comment"),
        "writeComment_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Comment cannot be empty"),
        "writeComment_verify_notRate": MessageLookupByLibrary.simpleMessage("")
      };
}
