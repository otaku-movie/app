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

  static String m1(count) => "Found ${count} related cinemas";

  static String m2(count) => "Confirm selection of ${count} seats";

  static String m3(count) => "Selected ${count} seats";

  static String m4(reply) => "Reply to ${reply}";

  static String m5(total) => "Total ${total} replies";

  static String m6(reply) => "Reply to ${reply}";

  static String m7(language) => "Translate to ${language}";

  static String m8(total) => "Total ${total} replies";

  static String m9(ticketCount) => "${ticketCount} Movie Tickets";

  static String m10(maxSeat) => "A maximum of ${maxSeat} seats can be selected";

  static String m11(movieName) => "Share movie ticket: ${movieName}";

  static String m12(days) => "${days} days left";

  static String m13(hours) => "${hours} hours left";

  static String m14(minutes) => "${minutes} minutes left";

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
            MessageLookupByLibrary.simpleMessage("Special Screening Price"),
        "cinemaDetail_tel": MessageLookupByLibrary.simpleMessage("TEL"),
        "cinemaDetail_theaterSpec":
            MessageLookupByLibrary.simpleMessage("Theater Info"),
        "cinemaDetail_ticketTypePrice":
            MessageLookupByLibrary.simpleMessage("Standard Ticket Price"),
        "cinemaList_address":
            MessageLookupByLibrary.simpleMessage("Getting current location"),
        "cinemaList_empty_noData":
            MessageLookupByLibrary.simpleMessage("No cinema data"),
        "cinemaList_empty_noDataTip":
            MessageLookupByLibrary.simpleMessage("Please try again later"),
        "cinemaList_empty_noSearchResults":
            MessageLookupByLibrary.simpleMessage("No related cinemas found"),
        "cinemaList_empty_noSearchResultsTip":
            MessageLookupByLibrary.simpleMessage("Please try other keywords"),
        "cinemaList_filter_loading":
            MessageLookupByLibrary.simpleMessage("Loading area data..."),
        "cinemaList_filter_title":
            MessageLookupByLibrary.simpleMessage("Filter by Area"),
        "cinemaList_loading": MessageLookupByLibrary.simpleMessage(
            "Loading failed, please retry"),
        "cinemaList_movies_nowShowing":
            MessageLookupByLibrary.simpleMessage("Now Showing"),
        "cinemaList_search_clear":
            MessageLookupByLibrary.simpleMessage("Clear"),
        "cinemaList_search_hint": MessageLookupByLibrary.simpleMessage(
            "Search cinema name or address"),
        "cinemaList_search_results_found": m1,
        "cinemaList_search_results_notFound":
            MessageLookupByLibrary.simpleMessage(
                "No related cinemas found, please try other keywords"),
        "cinemaList_selectSeat_confirmSelection": m2,
        "cinemaList_selectSeat_dateFormat":
            MessageLookupByLibrary.simpleMessage("MMM dd, yyyy"),
        "cinemaList_selectSeat_pleaseSelectSeats":
            MessageLookupByLibrary.simpleMessage("Please select seats"),
        "cinemaList_selectSeat_seatsSelected": m3,
        "cinemaList_selectSeat_selectedSeats":
            MessageLookupByLibrary.simpleMessage("Selected Seats"),
        "cinemaList_title":
            MessageLookupByLibrary.simpleMessage("Nearby Cinemas"),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("Reply"),
        "commentDetail_comment_placeholder": m4,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("Comment Reply"),
        "commentDetail_title":
            MessageLookupByLibrary.simpleMessage("Comment Detail"),
        "commentDetail_totalReplyMessage": m5,
        "common_components_cropper_actions_flip":
            MessageLookupByLibrary.simpleMessage("Flip"),
        "common_components_cropper_actions_redo":
            MessageLookupByLibrary.simpleMessage("Redo"),
        "common_components_cropper_actions_reset":
            MessageLookupByLibrary.simpleMessage("Reset"),
        "common_components_cropper_actions_rotateLeft":
            MessageLookupByLibrary.simpleMessage("Rotate Left"),
        "common_components_cropper_actions_rotateRight":
            MessageLookupByLibrary.simpleMessage("Rotate Right"),
        "common_components_cropper_actions_undo":
            MessageLookupByLibrary.simpleMessage("Undo"),
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
            MessageLookupByLibrary.simpleMessage(
                "Verification code sent successfully"),
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
        "common_unit_point": MessageLookupByLibrary.simpleMessage("point"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("Fri"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("Mon"),
        "common_week_saturday": MessageLookupByLibrary.simpleMessage("Sat"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("Sun"),
        "common_week_thursday": MessageLookupByLibrary.simpleMessage("Thu"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("Tue"),
        "common_week_wednesday": MessageLookupByLibrary.simpleMessage("Wed"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("Buy"),
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage("Select Payment Method"),
        "confirmOrder_title":
            MessageLookupByLibrary.simpleMessage("Confirm Order"),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("Total"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("cinema"),
        "home_home": MessageLookupByLibrary.simpleMessage("home"),
        "home_me": MessageLookupByLibrary.simpleMessage("my page"),
        "home_ticket": MessageLookupByLibrary.simpleMessage("My Ticket"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("Email"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("Invalid email address"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Email cannot be empty"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "login_noAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "login_password_text": MessageLookupByLibrary.simpleMessage("Password"),
        "login_password_verify_isValid": MessageLookupByLibrary.simpleMessage(
            "Password must be 8-16 characters with letters, numbers, and underscores"),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty"),
        "login_sendVerifyCodeButton":
            MessageLookupByLibrary.simpleMessage("Send Verification Code"),
        "login_verificationCode":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "movieDetail_button_buy":
            MessageLookupByLibrary.simpleMessage("Buy Ticket"),
        "movieDetail_button_saw":
            MessageLookupByLibrary.simpleMessage("Watched"),
        "movieDetail_button_want":
            MessageLookupByLibrary.simpleMessage("Want to Watch"),
        "movieDetail_comment_delete":
            MessageLookupByLibrary.simpleMessage("Delete"),
        "movieDetail_comment_reply":
            MessageLookupByLibrary.simpleMessage("Reply"),
        "movieDetail_comment_replyTo": m6,
        "movieDetail_comment_translate": m7,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage("Basic Info"),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage("Character"),
        "movieDetail_detail_comment":
            MessageLookupByLibrary.simpleMessage("Comment"),
        "movieDetail_detail_homepage":
            MessageLookupByLibrary.simpleMessage("Official Website"),
        "movieDetail_detail_level":
            MessageLookupByLibrary.simpleMessage("Rating"),
        "movieDetail_detail_noDate":
            MessageLookupByLibrary.simpleMessage("Release date TBD"),
        "movieDetail_detail_originalName":
            MessageLookupByLibrary.simpleMessage("Original Title"),
        "movieDetail_detail_spec":
            MessageLookupByLibrary.simpleMessage("Screening Spec"),
        "movieDetail_detail_staff":
            MessageLookupByLibrary.simpleMessage("Staff"),
        "movieDetail_detail_state":
            MessageLookupByLibrary.simpleMessage("Screening Status"),
        "movieDetail_detail_tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "movieDetail_detail_time":
            MessageLookupByLibrary.simpleMessage("Duration"),
        "movieDetail_detail_totalReplyMessage": m8,
        "movieDetail_writeComment":
            MessageLookupByLibrary.simpleMessage("Write Comment"),
        "movieList_buy": MessageLookupByLibrary.simpleMessage("Buy Ticket"),
        "movieList_comingSoon_noDate":
            MessageLookupByLibrary.simpleMessage("Date TBD"),
        "movieList_currentlyShowing_level":
            MessageLookupByLibrary.simpleMessage("Level"),
        "movieList_placeholder":
            MessageLookupByLibrary.simpleMessage("Search all movies"),
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
        "movieTicketType_seatNumber":
            MessageLookupByLibrary.simpleMessage("Seat Number"),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage(
                "Please select a movie ticket type"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("Select Movie Ticket Type"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("Total"),
        "orderDetail_orderCreateTime":
            MessageLookupByLibrary.simpleMessage("Order Creation Time"),
        "orderDetail_orderMessage":
            MessageLookupByLibrary.simpleMessage("Order Information"),
        "orderDetail_orderNumber":
            MessageLookupByLibrary.simpleMessage("Order Number"),
        "orderDetail_orderState":
            MessageLookupByLibrary.simpleMessage("Order Status"),
        "orderDetail_payMethod":
            MessageLookupByLibrary.simpleMessage("Payment Method"),
        "orderDetail_payTime":
            MessageLookupByLibrary.simpleMessage("Payment Time"),
        "orderDetail_seatMessage":
            MessageLookupByLibrary.simpleMessage("Seat Information"),
        "orderDetail_ticketCode":
            MessageLookupByLibrary.simpleMessage("Ticket Collection Code"),
        "orderDetail_ticketCount": m9,
        "orderDetail_title":
            MessageLookupByLibrary.simpleMessage("Order Detail"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "orderList_orderNumber":
            MessageLookupByLibrary.simpleMessage("Order Number"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("Order List"),
        "payResult_success": MessageLookupByLibrary.simpleMessage(
            "Your order has been paid. Please arrive at the following location before the specified time. Enjoy your movie."),
        "payResult_ticketCode":
            MessageLookupByLibrary.simpleMessage("Ticket Collection Code"),
        "payResult_title":
            MessageLookupByLibrary.simpleMessage("Payment Successful"),
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
            MessageLookupByLibrary.simpleMessage(
                "Repeat password must be 8-16 characters with letters, numbers, and underscores"),
        "register_repeatPassword_verify_notNull":
            MessageLookupByLibrary.simpleMessage(
                "Repeat password cannot be empty"),
        "register_send": MessageLookupByLibrary.simpleMessage("Send"),
        "register_username_text":
            MessageLookupByLibrary.simpleMessage("UserName"),
        "register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Username cannot be empty"),
        "register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage(
                "Verification code must be 6 digits"),
        "register_verifyCode_verify_notNull":
            MessageLookupByLibrary.simpleMessage(
                "Verification code cannot be empty"),
        "search_history":
            MessageLookupByLibrary.simpleMessage("Search History"),
        "search_level": MessageLookupByLibrary.simpleMessage("Level"),
        "search_noData": MessageLookupByLibrary.simpleMessage("No data yet"),
        "search_placeholder":
            MessageLookupByLibrary.simpleMessage("Search all movies"),
        "search_removeHistoryConfirm_cancel":
            MessageLookupByLibrary.simpleMessage("Cancel"),
        "search_removeHistoryConfirm_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "search_removeHistoryConfirm_content":
            MessageLookupByLibrary.simpleMessage(
                "Are you sure you want to delete your search history?"),
        "search_removeHistoryConfirm_title":
            MessageLookupByLibrary.simpleMessage("Delete History"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("Confirm Seat Selection"),
        "selectSeat_maxSelectSeatWarn": m10,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("Please select a seat"),
        "showTimeDetail_address":
            MessageLookupByLibrary.simpleMessage("Address"),
        "showTimeDetail_buy":
            MessageLookupByLibrary.simpleMessage("Buy Ticket"),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("minutes"),
        "ticket_buyTickets":
            MessageLookupByLibrary.simpleMessage("Buy Tickets"),
        "ticket_endTime":
            MessageLookupByLibrary.simpleMessage("Expected End Time"),
        "ticket_noData": MessageLookupByLibrary.simpleMessage("No ticket yet"),
        "ticket_noDataTip":
            MessageLookupByLibrary.simpleMessage("Buy tickets now!"),
        "ticket_seatCount": MessageLookupByLibrary.simpleMessage("Seat Count"),
        "ticket_shareTicket": m11,
        "ticket_showTime": MessageLookupByLibrary.simpleMessage("Show Time"),
        "ticket_status_cancelled":
            MessageLookupByLibrary.simpleMessage("Cancelled"),
        "ticket_status_expired":
            MessageLookupByLibrary.simpleMessage("Expired"),
        "ticket_status_used": MessageLookupByLibrary.simpleMessage("Used"),
        "ticket_status_valid": MessageLookupByLibrary.simpleMessage("Valid"),
        "ticket_tapToView":
            MessageLookupByLibrary.simpleMessage("Tap to view details"),
        "ticket_ticketCount":
            MessageLookupByLibrary.simpleMessage("Ticket Count"),
        "ticket_tickets": MessageLookupByLibrary.simpleMessage(" tickets"),
        "ticket_time_formatError":
            MessageLookupByLibrary.simpleMessage("Time format error"),
        "ticket_time_remaining_days": m12,
        "ticket_time_remaining_hours": m13,
        "ticket_time_remaining_minutes": m14,
        "ticket_time_remaining_soon":
            MessageLookupByLibrary.simpleMessage("Starting soon"),
        "ticket_time_unknown":
            MessageLookupByLibrary.simpleMessage("Time unknown"),
        "ticket_time_weekdays_friday":
            MessageLookupByLibrary.simpleMessage("Fri"),
        "ticket_time_weekdays_monday":
            MessageLookupByLibrary.simpleMessage("Mon"),
        "ticket_time_weekdays_saturday":
            MessageLookupByLibrary.simpleMessage("Sat"),
        "ticket_time_weekdays_sunday":
            MessageLookupByLibrary.simpleMessage("Sun"),
        "ticket_time_weekdays_thursday":
            MessageLookupByLibrary.simpleMessage("Thu"),
        "ticket_time_weekdays_tuesday":
            MessageLookupByLibrary.simpleMessage("Tue"),
        "ticket_time_weekdays_wednesday":
            MessageLookupByLibrary.simpleMessage("Wed"),
        "ticket_totalPurchased":
            MessageLookupByLibrary.simpleMessage("Total Purchased"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
        "userProfile_edit_username_placeholder":
            MessageLookupByLibrary.simpleMessage("Please enter your username"),
        "userProfile_edit_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Username cannot be empty"),
        "userProfile_email": MessageLookupByLibrary.simpleMessage("Email"),
        "userProfile_registerTime":
            MessageLookupByLibrary.simpleMessage("Register Time"),
        "userProfile_save": MessageLookupByLibrary.simpleMessage("Save"),
        "userProfile_title":
            MessageLookupByLibrary.simpleMessage("User Profile"),
        "userProfile_username":
            MessageLookupByLibrary.simpleMessage("Username"),
        "user_about": MessageLookupByLibrary.simpleMessage("About"),
        "user_checkUpdate":
            MessageLookupByLibrary.simpleMessage("Check Update"),
        "user_data_characterCount":
            MessageLookupByLibrary.simpleMessage("Character Count"),
        "user_data_orderCount":
            MessageLookupByLibrary.simpleMessage("Order Count"),
        "user_data_staffCount":
            MessageLookupByLibrary.simpleMessage("Staff Count"),
        "user_data_wantCount":
            MessageLookupByLibrary.simpleMessage("Want to Watch Count"),
        "user_data_watchHistory":
            MessageLookupByLibrary.simpleMessage("Watch History"),
        "user_editProfile":
            MessageLookupByLibrary.simpleMessage("Edit Profile"),
        "user_language": MessageLookupByLibrary.simpleMessage("Language"),
        "user_logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "user_privateAgreement":
            MessageLookupByLibrary.simpleMessage("Privacy Agreement"),
        "user_registerTime":
            MessageLookupByLibrary.simpleMessage("Registration Time"),
        "user_title": MessageLookupByLibrary.simpleMessage("My Profile"),
        "writeComment_hint":
            MessageLookupByLibrary.simpleMessage("Write your comment..."),
        "writeComment_release": MessageLookupByLibrary.simpleMessage("Release"),
        "writeComment_title":
            MessageLookupByLibrary.simpleMessage("Write comment"),
        "writeComment_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Comment cannot be empty"),
        "writeComment_verify_notRate":
            MessageLookupByLibrary.simpleMessage("Please rate the movie")
      };
}
