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

  static String m0(count) => "There are ${count} more showtimes...";

  static String m1(seatCount) => "${seatCount} seats";

  static String m2(count) => "Found ${count} related cinemas";

  static String m3(count) => "Confirm selection of ${count} seats";

  static String m4(count) => "Selected ${count} seats";

  static String m5(reply) => "Reply to ${reply}";

  static String m6(total) => "Total ${total} replies";

  static String m7(count) => "${count} seats";

  static String m8(reply) => "Reply to ${reply}";

  static String m9(language) => "Translate to ${language}";

  static String m10(hours, minutes) => "${hours}h ${minutes}m";

  static String m11(total) => "Total ${total} replies";

  static String m12(hours, minutes) =>
      "${hours} hours ${minutes} minutes until showtime";

  static String m13(minutes, seconds) =>
      "${minutes} minutes ${seconds} seconds until showtime";

  static String m14(seconds) => "${seconds} seconds until showtime";

  static String m15(ticketCount) => "${ticketCount} Movie Tickets";

  static String m16(date) => "Exp: ${date}";

  static String m17(maxSeat) => "A maximum of ${maxSeat} seats can be selected";

  static String m18(movieName) => "Share movie ticket: ${movieName}";

  static String m19(days) => "${days} days left";

  static String m20(hours) => "${hours} hours left";

  static String m21(minutes) => "${minutes} minutes left";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "about_components_filterBar_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "about_components_filterBar_pleaseSelect":
            MessageLookupByLibrary.simpleMessage("Please select"),
        "about_components_filterBar_reset":
            MessageLookupByLibrary.simpleMessage("Reset"),
        "about_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage(
                "Verification code sent successfully"),
        "about_components_showTimeList_all":
            MessageLookupByLibrary.simpleMessage("All"),
        "about_components_showTimeList_moreShowTimes": m0,
        "about_components_showTimeList_noData":
            MessageLookupByLibrary.simpleMessage("No data yet"),
        "about_components_showTimeList_noShowTimeInfo":
            MessageLookupByLibrary.simpleMessage("No showtime information"),
        "about_components_showTimeList_seatStatus_available":
            MessageLookupByLibrary.simpleMessage("Available"),
        "about_components_showTimeList_seatStatus_limited":
            MessageLookupByLibrary.simpleMessage("Limited"),
        "about_components_showTimeList_seatStatus_soldOut":
            MessageLookupByLibrary.simpleMessage("Sold Out"),
        "about_components_showTimeList_unnamed":
            MessageLookupByLibrary.simpleMessage("Unnamed"),
        "about_copyright": MessageLookupByLibrary.simpleMessage(
            "© 2025 Otaku Movie All Rights Reserved"),
        "about_description": MessageLookupByLibrary.simpleMessage(
            "Committed to providing convenient ticket purchasing experience for movie enthusiasts."),
        "about_login_email_text": MessageLookupByLibrary.simpleMessage("Email"),
        "about_login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a valid email address"),
        "about_login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Email cannot be empty"),
        "about_login_forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "about_login_googleLogin":
            MessageLookupByLibrary.simpleMessage("Login with Google"),
        "about_login_loginButton":
            MessageLookupByLibrary.simpleMessage("Login"),
        "about_login_noAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "about_login_or": MessageLookupByLibrary.simpleMessage("or"),
        "about_login_password_text":
            MessageLookupByLibrary.simpleMessage("Password"),
        "about_login_password_verify_isValid":
            MessageLookupByLibrary.simpleMessage(
                "Password must be at least 6 characters"),
        "about_login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty"),
        "about_login_verificationCode":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "about_login_welcomeText":
            MessageLookupByLibrary.simpleMessage("Welcome Back"),
        "about_movieShowList_dropdown_area":
            MessageLookupByLibrary.simpleMessage("Area"),
        "about_movieShowList_dropdown_screenSpec":
            MessageLookupByLibrary.simpleMessage("Screen Spec"),
        "about_movieShowList_dropdown_subtitle":
            MessageLookupByLibrary.simpleMessage("Subtitle"),
        "about_privacy_policy":
            MessageLookupByLibrary.simpleMessage("View Privacy Policy"),
        "about_register_haveAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "about_register_loginHere":
            MessageLookupByLibrary.simpleMessage("Login here"),
        "about_register_passwordNotMatchRepeatPassword":
            MessageLookupByLibrary.simpleMessage("Passwords do not match"),
        "about_register_registerButton":
            MessageLookupByLibrary.simpleMessage("Register"),
        "about_register_repeatPassword_text":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "about_register_send": MessageLookupByLibrary.simpleMessage("Send"),
        "about_register_username_text":
            MessageLookupByLibrary.simpleMessage("Username"),
        "about_register_username_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Username cannot be empty"),
        "about_register_verifyCode_verify_isValid":
            MessageLookupByLibrary.simpleMessage(
                "Invalid verification code format"),
        "about_title": MessageLookupByLibrary.simpleMessage("About"),
        "about_version": MessageLookupByLibrary.simpleMessage("Version"),
        "cinemaDetail_address": MessageLookupByLibrary.simpleMessage("Address"),
        "cinemaDetail_homepage":
            MessageLookupByLibrary.simpleMessage("WebSite"),
        "cinemaDetail_maxSelectSeat": MessageLookupByLibrary.simpleMessage(
            "Maximum number of available seats"),
        "cinemaDetail_seatCount": m1,
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
        "cinemaList_movies_empty":
            MessageLookupByLibrary.simpleMessage("No movies showing"),
        "cinemaList_movies_nowShowing":
            MessageLookupByLibrary.simpleMessage("Now Showing"),
        "cinemaList_search_clear":
            MessageLookupByLibrary.simpleMessage("Clear"),
        "cinemaList_search_hint": MessageLookupByLibrary.simpleMessage(
            "Search cinema name or address"),
        "cinemaList_search_results_found": m2,
        "cinemaList_search_results_notFound":
            MessageLookupByLibrary.simpleMessage(
                "No related cinemas found, please try other keywords"),
        "cinemaList_selectSeat_confirmSelection": m3,
        "cinemaList_selectSeat_dateFormat":
            MessageLookupByLibrary.simpleMessage("MMM dd, yyyy"),
        "cinemaList_selectSeat_pleaseSelectSeats":
            MessageLookupByLibrary.simpleMessage("Please select seats"),
        "cinemaList_selectSeat_seatsSelected": m4,
        "cinemaList_selectSeat_selectedSeats":
            MessageLookupByLibrary.simpleMessage("Selected Seats"),
        "cinemaList_title":
            MessageLookupByLibrary.simpleMessage("Nearby Cinemas"),
        "comingSoon_noMovies":
            MessageLookupByLibrary.simpleMessage("No movies currently showing"),
        "comingSoon_presale": MessageLookupByLibrary.simpleMessage("Presale"),
        "comingSoon_pullToRefresh":
            MessageLookupByLibrary.simpleMessage("Pull to refresh"),
        "comingSoon_releaseDate":
            MessageLookupByLibrary.simpleMessage("Release"),
        "comingSoon_tryLaterOrRefresh": MessageLookupByLibrary.simpleMessage(
            "Please try again later or pull down to refresh"),
        "commentDetail_comment_button":
            MessageLookupByLibrary.simpleMessage("Reply"),
        "commentDetail_comment_hint":
            MessageLookupByLibrary.simpleMessage("Write your reply..."),
        "commentDetail_comment_placeholder": m5,
        "commentDetail_replyComment":
            MessageLookupByLibrary.simpleMessage("Comment Reply"),
        "commentDetail_title":
            MessageLookupByLibrary.simpleMessage("Comment Detail"),
        "commentDetail_totalReplyMessage": m6,
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
            MessageLookupByLibrary.simpleMessage("Loading..."),
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
        "common_components_filterBar_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "common_components_filterBar_pleaseSelect":
            MessageLookupByLibrary.simpleMessage("Please select"),
        "common_components_filterBar_reset":
            MessageLookupByLibrary.simpleMessage("Reset"),
        "common_components_sendVerifyCode_success":
            MessageLookupByLibrary.simpleMessage(
                "Verification code sent successfully"),
        "common_enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("Couple Seat"),
        "common_enum_seatType_locked":
            MessageLookupByLibrary.simpleMessage("Locked"),
        "common_enum_seatType_sold":
            MessageLookupByLibrary.simpleMessage("Sold"),
        "common_enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("Wheelchair"),
        "common_error_message": MessageLookupByLibrary.simpleMessage(
            "Failed to load data, please try again later"),
        "common_error_title": MessageLookupByLibrary.simpleMessage("Error"),
        "common_loading": MessageLookupByLibrary.simpleMessage("Loading..."),
        "common_retry": MessageLookupByLibrary.simpleMessage("Retry"),
        "common_unit_jpy": MessageLookupByLibrary.simpleMessage("JPY"),
        "common_unit_point": MessageLookupByLibrary.simpleMessage("pts"),
        "common_week_friday": MessageLookupByLibrary.simpleMessage("Friday"),
        "common_week_monday": MessageLookupByLibrary.simpleMessage("Monday"),
        "common_week_saturday":
            MessageLookupByLibrary.simpleMessage("Saturday"),
        "common_week_sunday": MessageLookupByLibrary.simpleMessage("Sunday"),
        "common_week_thursday":
            MessageLookupByLibrary.simpleMessage("Thursday"),
        "common_week_tuesday": MessageLookupByLibrary.simpleMessage("Tuesday"),
        "common_week_wednesday":
            MessageLookupByLibrary.simpleMessage("Wednesday"),
        "confirmOrder_cancelOrder":
            MessageLookupByLibrary.simpleMessage("Cancel Order"),
        "confirmOrder_cancelOrderConfirm": MessageLookupByLibrary.simpleMessage(
            "You have selected seats. Are you sure you want to cancel the order and release the selected seats?"),
        "confirmOrder_cancelOrderFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to cancel order, please try again"),
        "confirmOrder_cinemaInfo":
            MessageLookupByLibrary.simpleMessage("Cinema Information"),
        "confirmOrder_confirmCancel":
            MessageLookupByLibrary.simpleMessage("Confirm Cancel"),
        "confirmOrder_continuePay":
            MessageLookupByLibrary.simpleMessage("Continue Payment"),
        "confirmOrder_countdown":
            MessageLookupByLibrary.simpleMessage("Time Remaining"),
        "confirmOrder_noSpec":
            MessageLookupByLibrary.simpleMessage("No spec info"),
        "confirmOrder_orderCanceled":
            MessageLookupByLibrary.simpleMessage("Order Canceled"),
        "confirmOrder_orderTimeout":
            MessageLookupByLibrary.simpleMessage("Processing order timeout..."),
        "confirmOrder_orderTimeoutMessage":
            MessageLookupByLibrary.simpleMessage(
                "Order has timed out and been automatically canceled"),
        "confirmOrder_pay": MessageLookupByLibrary.simpleMessage("Buy"),
        "confirmOrder_payFailed": MessageLookupByLibrary.simpleMessage(
            "Payment failed, please try again"),
        "confirmOrder_seatCount": m7,
        "confirmOrder_selectPayMethod":
            MessageLookupByLibrary.simpleMessage("Select Payment Method"),
        "confirmOrder_selectedSeats":
            MessageLookupByLibrary.simpleMessage("Selected Seats"),
        "confirmOrder_timeInfo":
            MessageLookupByLibrary.simpleMessage("Time Information"),
        "confirmOrder_timeoutFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to process order timeout, please try again"),
        "confirmOrder_title":
            MessageLookupByLibrary.simpleMessage("Confirm Order"),
        "confirmOrder_total": MessageLookupByLibrary.simpleMessage("Total"),
        "enum_seatType_coupleSeat":
            MessageLookupByLibrary.simpleMessage("Couple Seat"),
        "enum_seatType_disabled":
            MessageLookupByLibrary.simpleMessage("Disabled"),
        "enum_seatType_locked": MessageLookupByLibrary.simpleMessage("Locked"),
        "enum_seatType_selected":
            MessageLookupByLibrary.simpleMessage("Selected"),
        "enum_seatType_sold": MessageLookupByLibrary.simpleMessage("Sold"),
        "enum_seatType_wheelChair":
            MessageLookupByLibrary.simpleMessage("Wheelchair Seat"),
        "forgotPassword_backToLogin":
            MessageLookupByLibrary.simpleMessage("Back to Login"),
        "forgotPassword_description": MessageLookupByLibrary.simpleMessage(
            "Enter your email address and we will send you a verification code"),
        "forgotPassword_emailAddress":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "forgotPassword_emailInvalid": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address"),
        "forgotPassword_emailRequired":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "forgotPassword_newPassword":
            MessageLookupByLibrary.simpleMessage("New Password"),
        "forgotPassword_newPasswordRequired":
            MessageLookupByLibrary.simpleMessage(
                "Please enter your new password"),
        "forgotPassword_passwordResetSuccess":
            MessageLookupByLibrary.simpleMessage("Password reset successful"),
        "forgotPassword_passwordTooShort": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "forgotPassword_rememberPassword":
            MessageLookupByLibrary.simpleMessage("Remember your password?"),
        "forgotPassword_resetPassword":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "forgotPassword_sendVerificationCode":
            MessageLookupByLibrary.simpleMessage("Send Verification Code"),
        "forgotPassword_title":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "forgotPassword_verificationCode":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "forgotPassword_verificationCodeRequired":
            MessageLookupByLibrary.simpleMessage(
                "Please enter verification code"),
        "forgotPassword_verificationCodeSent":
            MessageLookupByLibrary.simpleMessage(
                "Verification code has been sent to your email"),
        "home_cinema": MessageLookupByLibrary.simpleMessage("cinema"),
        "home_home": MessageLookupByLibrary.simpleMessage("home"),
        "home_me": MessageLookupByLibrary.simpleMessage("my page"),
        "home_ticket": MessageLookupByLibrary.simpleMessage("My Ticket"),
        "login_backToLogin":
            MessageLookupByLibrary.simpleMessage("Back to Login"),
        "login_emailAddress":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "login_emailInvalid": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid email address"),
        "login_emailRequired":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "login_email_text": MessageLookupByLibrary.simpleMessage("Email"),
        "login_email_verify_isValid":
            MessageLookupByLibrary.simpleMessage("Invalid email address"),
        "login_email_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Email cannot be empty"),
        "login_forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot password?"),
        "login_forgotPasswordDescription": MessageLookupByLibrary.simpleMessage(
            "Enter your email address and we\'ll send you a verification code"),
        "login_forgotPasswordTitle":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "login_googleLogin":
            MessageLookupByLibrary.simpleMessage("Sign in with Google"),
        "login_loginButton": MessageLookupByLibrary.simpleMessage("Login"),
        "login_newPassword":
            MessageLookupByLibrary.simpleMessage("New Password"),
        "login_newPasswordRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter your new password"),
        "login_noAccount":
            MessageLookupByLibrary.simpleMessage("Don\'t have an account?"),
        "login_or": MessageLookupByLibrary.simpleMessage("or"),
        "login_passwordResetSuccess":
            MessageLookupByLibrary.simpleMessage("Password reset successful"),
        "login_passwordTooShort": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "login_password_text": MessageLookupByLibrary.simpleMessage("Password"),
        "login_password_verify_isValid": MessageLookupByLibrary.simpleMessage(
            "Password must be 8-16 characters with letters, numbers, and underscores"),
        "login_password_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Password cannot be empty"),
        "login_rememberPassword":
            MessageLookupByLibrary.simpleMessage("Remember your password?"),
        "login_resetPassword":
            MessageLookupByLibrary.simpleMessage("Reset Password"),
        "login_sendVerificationCode":
            MessageLookupByLibrary.simpleMessage("Send Verification Code"),
        "login_sendVerifyCodeButton":
            MessageLookupByLibrary.simpleMessage("Send Verification Code"),
        "login_verificationCode":
            MessageLookupByLibrary.simpleMessage("Verification Code"),
        "login_verificationCodeRequired": MessageLookupByLibrary.simpleMessage(
            "Please enter the verification code"),
        "login_verificationCodeSent": MessageLookupByLibrary.simpleMessage(
            "Verification code has been sent to your email"),
        "login_welcomeText": MessageLookupByLibrary.simpleMessage(
            "Welcome back, please log in to your account"),
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
        "movieDetail_comment_replyTo": m8,
        "movieDetail_comment_translate": m9,
        "movieDetail_detail_basicMessage":
            MessageLookupByLibrary.simpleMessage("Basic Info"),
        "movieDetail_detail_character":
            MessageLookupByLibrary.simpleMessage("Character"),
        "movieDetail_detail_comment":
            MessageLookupByLibrary.simpleMessage("Comment"),
        "movieDetail_detail_duration_hours":
            MessageLookupByLibrary.simpleMessage("hours"),
        "movieDetail_detail_duration_hoursMinutes": m10,
        "movieDetail_detail_duration_minutes":
            MessageLookupByLibrary.simpleMessage("minutes"),
        "movieDetail_detail_duration_unknown":
            MessageLookupByLibrary.simpleMessage("Unknown"),
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
        "movieDetail_detail_totalReplyMessage": m11,
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
        "movieTicketType_actualPrice":
            MessageLookupByLibrary.simpleMessage("Actual Payment"),
        "movieTicketType_cinema":
            MessageLookupByLibrary.simpleMessage("Cinema"),
        "movieTicketType_confirmOrder":
            MessageLookupByLibrary.simpleMessage("Confirm Order"),
        "movieTicketType_movieInfo":
            MessageLookupByLibrary.simpleMessage("Movie Info"),
        "movieTicketType_price": MessageLookupByLibrary.simpleMessage("Price"),
        "movieTicketType_seatInfo":
            MessageLookupByLibrary.simpleMessage("Seat Information"),
        "movieTicketType_seatNumber":
            MessageLookupByLibrary.simpleMessage("Seat Number"),
        "movieTicketType_selectMovieTicketType":
            MessageLookupByLibrary.simpleMessage(
                "Please select a movie ticket type"),
        "movieTicketType_selectTicketType":
            MessageLookupByLibrary.simpleMessage("Select Ticket Type"),
        "movieTicketType_selectTicketTypeForSeats":
            MessageLookupByLibrary.simpleMessage(
                "Please select appropriate ticket type for each seat"),
        "movieTicketType_showTime":
            MessageLookupByLibrary.simpleMessage("Show Time"),
        "movieTicketType_ticketType":
            MessageLookupByLibrary.simpleMessage("Ticket Type"),
        "movieTicketType_title":
            MessageLookupByLibrary.simpleMessage("Select Movie Ticket Type"),
        "movieTicketType_total": MessageLookupByLibrary.simpleMessage("Total"),
        "movieTicketType_totalPrice":
            MessageLookupByLibrary.simpleMessage("Total Price"),
        "orderDetail_countdown_hoursMinutes": m12,
        "orderDetail_countdown_minutesSeconds": m13,
        "orderDetail_countdown_seconds": m14,
        "orderDetail_countdown_started":
            MessageLookupByLibrary.simpleMessage("Started"),
        "orderDetail_countdown_title":
            MessageLookupByLibrary.simpleMessage("Showtime Reminder"),
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
        "orderDetail_ticketCount": m15,
        "orderDetail_title":
            MessageLookupByLibrary.simpleMessage("Order Detail"),
        "orderList_comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "orderList_orderNumber":
            MessageLookupByLibrary.simpleMessage("Order Number"),
        "orderList_title": MessageLookupByLibrary.simpleMessage("Order List"),
        "payResult_qrCodeTip": MessageLookupByLibrary.simpleMessage(
            "Please use this QR code or ticket code to collect your tickets at the cinema"),
        "payResult_success":
            MessageLookupByLibrary.simpleMessage("Payment Successful"),
        "payResult_ticketCode":
            MessageLookupByLibrary.simpleMessage("Ticket Collection Code"),
        "payResult_title":
            MessageLookupByLibrary.simpleMessage("Payment Successful"),
        "payResult_viewMyTickets":
            MessageLookupByLibrary.simpleMessage("View My Tickets"),
        "payment_addCreditCard_cardConfirmed":
            MessageLookupByLibrary.simpleMessage("Credit card confirmed"),
        "payment_addCreditCard_cardHolderName":
            MessageLookupByLibrary.simpleMessage("Cardholder Name"),
        "payment_addCreditCard_cardHolderNameError":
            MessageLookupByLibrary.simpleMessage(
                "Please enter cardholder name"),
        "payment_addCreditCard_cardHolderNameHint":
            MessageLookupByLibrary.simpleMessage("Enter cardholder name"),
        "payment_addCreditCard_cardNumber":
            MessageLookupByLibrary.simpleMessage("Card Number"),
        "payment_addCreditCard_cardNumberError":
            MessageLookupByLibrary.simpleMessage(
                "Please enter a valid card number"),
        "payment_addCreditCard_cardNumberHint":
            MessageLookupByLibrary.simpleMessage("Enter card number"),
        "payment_addCreditCard_cardNumberLength":
            MessageLookupByLibrary.simpleMessage("Invalid card number length"),
        "payment_addCreditCard_cardSaved":
            MessageLookupByLibrary.simpleMessage("Credit card saved"),
        "payment_addCreditCard_confirmAdd":
            MessageLookupByLibrary.simpleMessage("Confirm Add"),
        "payment_addCreditCard_cvv":
            MessageLookupByLibrary.simpleMessage("CVV"),
        "payment_addCreditCard_cvvError":
            MessageLookupByLibrary.simpleMessage("Please enter CVV"),
        "payment_addCreditCard_cvvHint":
            MessageLookupByLibrary.simpleMessage("•••"),
        "payment_addCreditCard_cvvLength":
            MessageLookupByLibrary.simpleMessage("Invalid length"),
        "payment_addCreditCard_expiryDate":
            MessageLookupByLibrary.simpleMessage("Expiry Date"),
        "payment_addCreditCard_expiryDateError":
            MessageLookupByLibrary.simpleMessage("Please enter expiry date"),
        "payment_addCreditCard_expiryDateExpired":
            MessageLookupByLibrary.simpleMessage("Card has expired"),
        "payment_addCreditCard_expiryDateHint":
            MessageLookupByLibrary.simpleMessage("MM/YY"),
        "payment_addCreditCard_expiryDateInvalid":
            MessageLookupByLibrary.simpleMessage("Invalid expiry date format"),
        "payment_addCreditCard_operationFailed":
            MessageLookupByLibrary.simpleMessage(
                "Operation failed, please try again"),
        "payment_addCreditCard_saveCard":
            MessageLookupByLibrary.simpleMessage("Save this credit card"),
        "payment_addCreditCard_saveToAccount":
            MessageLookupByLibrary.simpleMessage(
                "Will be saved to your account for future use"),
        "payment_addCreditCard_title":
            MessageLookupByLibrary.simpleMessage("Add Credit Card"),
        "payment_addCreditCard_useOnce": MessageLookupByLibrary.simpleMessage(
            "Use once only, will not be saved"),
        "payment_selectCreditCard_addNewCard":
            MessageLookupByLibrary.simpleMessage("Add New Credit Card"),
        "payment_selectCreditCard_confirmPayment":
            MessageLookupByLibrary.simpleMessage("Confirm Payment"),
        "payment_selectCreditCard_expiryDate": m16,
        "payment_selectCreditCard_loadFailed":
            MessageLookupByLibrary.simpleMessage(
                "Failed to load credit card list"),
        "payment_selectCreditCard_noCreditCard":
            MessageLookupByLibrary.simpleMessage("No credit cards"),
        "payment_selectCreditCard_paymentFailed":
            MessageLookupByLibrary.simpleMessage(
                "Payment failed, please try again"),
        "payment_selectCreditCard_paymentSuccess":
            MessageLookupByLibrary.simpleMessage("Payment successful"),
        "payment_selectCreditCard_pleaseAddCard":
            MessageLookupByLibrary.simpleMessage("Please add a credit card"),
        "payment_selectCreditCard_pleaseSelectCard":
            MessageLookupByLibrary.simpleMessage("Please select a credit card"),
        "payment_selectCreditCard_removeTempCard":
            MessageLookupByLibrary.simpleMessage("Remove temporary card"),
        "payment_selectCreditCard_tempCard":
            MessageLookupByLibrary.simpleMessage(
                "Temporary card (one-time use)"),
        "payment_selectCreditCard_tempCardRemoved":
            MessageLookupByLibrary.simpleMessage("Temporary card removed"),
        "payment_selectCreditCard_tempCardSelected":
            MessageLookupByLibrary.simpleMessage(
                "Temporary credit card selected"),
        "payment_selectCreditCard_title":
            MessageLookupByLibrary.simpleMessage("Select Credit Card"),
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
        "seatCancel_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "seatCancel_confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "seatCancel_confirmMessage": MessageLookupByLibrary.simpleMessage(
            "You have selected seats. Are you sure you want to cancel the selected seats?"),
        "seatCancel_confirmTitle":
            MessageLookupByLibrary.simpleMessage("Cancel Seat Selection"),
        "seatCancel_errorMessage": MessageLookupByLibrary.simpleMessage(
            "Failed to cancel seat selection, please try again"),
        "seatCancel_successMessage": MessageLookupByLibrary.simpleMessage(
            "Seat selection has been cancelled"),
        "seatSelection_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "seatSelection_cancelSeatConfirm": MessageLookupByLibrary.simpleMessage(
            "You have selected seats. Are you sure you want to cancel the selected seats?"),
        "seatSelection_cancelSeatFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to cancel seat selection, please try again"),
        "seatSelection_cancelSeatTitle":
            MessageLookupByLibrary.simpleMessage("Cancel Seat Selection"),
        "seatSelection_confirm":
            MessageLookupByLibrary.simpleMessage("Confirm"),
        "seatSelection_seatCanceled": MessageLookupByLibrary.simpleMessage(
            "Selected seats have been canceled"),
        "selectSeat_confirmSelectSeat":
            MessageLookupByLibrary.simpleMessage("Confirm Seat Selection"),
        "selectSeat_maxSelectSeatWarn": m17,
        "selectSeat_notSelectSeatWarn":
            MessageLookupByLibrary.simpleMessage("Please select a seat"),
        "showTimeDetail_address":
            MessageLookupByLibrary.simpleMessage("Address"),
        "showTimeDetail_buy":
            MessageLookupByLibrary.simpleMessage("Select Seat"),
        "showTimeDetail_seatStatus_available":
            MessageLookupByLibrary.simpleMessage("Seats Available"),
        "showTimeDetail_seatStatus_soldOut":
            MessageLookupByLibrary.simpleMessage("Sold Out"),
        "showTimeDetail_seatStatus_tight":
            MessageLookupByLibrary.simpleMessage("Seats Limited"),
        "showTimeDetail_time": MessageLookupByLibrary.simpleMessage("minutes"),
        "ticket_buyTickets":
            MessageLookupByLibrary.simpleMessage("Buy Tickets"),
        "ticket_endTime":
            MessageLookupByLibrary.simpleMessage("Expected End Time"),
        "ticket_noData": MessageLookupByLibrary.simpleMessage("No ticket yet"),
        "ticket_noDataTip":
            MessageLookupByLibrary.simpleMessage("Buy tickets now!"),
        "ticket_seatCount": MessageLookupByLibrary.simpleMessage("Seat Count"),
        "ticket_shareTicket": m18,
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
        "ticket_time_remaining_days": m19,
        "ticket_time_remaining_hours": m20,
        "ticket_time_remaining_minutes": m21,
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
        "unit_jpy": MessageLookupByLibrary.simpleMessage("JPY"),
        "unit_point": MessageLookupByLibrary.simpleMessage("point"),
        "userProfile_avatar": MessageLookupByLibrary.simpleMessage("Avatar"),
        "userProfile_edit_tip": MessageLookupByLibrary.simpleMessage(
            "Click save button to save changes"),
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
        "user_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "user_checkUpdate":
            MessageLookupByLibrary.simpleMessage("Check Update"),
        "user_currentVersion":
            MessageLookupByLibrary.simpleMessage("Current Version"),
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
        "user_latestVersion":
            MessageLookupByLibrary.simpleMessage("Latest Version"),
        "user_logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "user_ok": MessageLookupByLibrary.simpleMessage("OK"),
        "user_privateAgreement":
            MessageLookupByLibrary.simpleMessage("Privacy Agreement"),
        "user_registerTime":
            MessageLookupByLibrary.simpleMessage("Registration Time"),
        "user_title": MessageLookupByLibrary.simpleMessage("My Profile"),
        "user_update": MessageLookupByLibrary.simpleMessage("Update"),
        "user_updateAvailable": MessageLookupByLibrary.simpleMessage(
            "New version found. Update now?"),
        "user_updateError":
            MessageLookupByLibrary.simpleMessage("Update Failed"),
        "user_updateErrorMessage": MessageLookupByLibrary.simpleMessage(
            "An error occurred during update. Please try again later."),
        "user_updateProgress": MessageLookupByLibrary.simpleMessage(
            "Downloading update, please wait..."),
        "user_updateSuccess":
            MessageLookupByLibrary.simpleMessage("Update Successful"),
        "user_updateSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "App has been successfully updated to the latest version!"),
        "user_updating": MessageLookupByLibrary.simpleMessage("Updating"),
        "writeComment_contentTitle":
            MessageLookupByLibrary.simpleMessage("Share your movie experience"),
        "writeComment_hint":
            MessageLookupByLibrary.simpleMessage("Write your comment..."),
        "writeComment_publishFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to publish comment, please try again"),
        "writeComment_rateTitle":
            MessageLookupByLibrary.simpleMessage("Rate this movie"),
        "writeComment_release": MessageLookupByLibrary.simpleMessage("Release"),
        "writeComment_shareExperience": MessageLookupByLibrary.simpleMessage(
            "Share your experience to help others"),
        "writeComment_title":
            MessageLookupByLibrary.simpleMessage("Write comment"),
        "writeComment_verify_movieIdEmpty":
            MessageLookupByLibrary.simpleMessage("Movie ID cannot be empty"),
        "writeComment_verify_notNull":
            MessageLookupByLibrary.simpleMessage("Comment cannot be empty"),
        "writeComment_verify_notRate":
            MessageLookupByLibrary.simpleMessage("Please rate the movie")
      };
}
