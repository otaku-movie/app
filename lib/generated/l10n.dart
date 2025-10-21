// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Write comment`
  String get writeComment_title {
    return Intl.message(
      'Write comment',
      name: 'writeComment_title',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment...`
  String get writeComment_hint {
    return Intl.message(
      'Write your comment...',
      name: 'writeComment_hint',
      desc: '',
      args: [],
    );
  }

  /// `Comment cannot be empty`
  String get writeComment_verify_notNull {
    return Intl.message(
      'Comment cannot be empty',
      name: 'writeComment_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Please rate the movie`
  String get writeComment_verify_notRate {
    return Intl.message(
      'Please rate the movie',
      name: 'writeComment_verify_notRate',
      desc: '',
      args: [],
    );
  }

  /// `Release`
  String get writeComment_release {
    return Intl.message(
      'Release',
      name: 'writeComment_release',
      desc: '',
      args: [],
    );
  }

  /// `No data yet`
  String get search_noData {
    return Intl.message(
      'No data yet',
      name: 'search_noData',
      desc: '',
      args: [],
    );
  }

  /// `Search all movies`
  String get search_placeholder {
    return Intl.message(
      'Search all movies',
      name: 'search_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Search History`
  String get search_history {
    return Intl.message(
      'Search History',
      name: 'search_history',
      desc: '',
      args: [],
    );
  }

  /// `Delete History`
  String get search_removeHistoryConfirm_title {
    return Intl.message(
      'Delete History',
      name: 'search_removeHistoryConfirm_title',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your search history?`
  String get search_removeHistoryConfirm_content {
    return Intl.message(
      'Are you sure you want to delete your search history?',
      name: 'search_removeHistoryConfirm_content',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get search_removeHistoryConfirm_confirm {
    return Intl.message(
      'Confirm',
      name: 'search_removeHistoryConfirm_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get search_removeHistoryConfirm_cancel {
    return Intl.message(
      'Cancel',
      name: 'search_removeHistoryConfirm_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get search_level {
    return Intl.message(
      'Level',
      name: 'search_level',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get showTimeDetail_address {
    return Intl.message(
      'Address',
      name: 'showTimeDetail_address',
      desc: '',
      args: [],
    );
  }

  /// `Buy Ticket`
  String get showTimeDetail_buy {
    return Intl.message(
      'Buy Ticket',
      name: 'showTimeDetail_buy',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get showTimeDetail_time {
    return Intl.message(
      'minutes',
      name: 'showTimeDetail_time',
      desc: '',
      args: [],
    );
  }

  /// `TEL`
  String get cinemaDetail_tel {
    return Intl.message(
      'TEL',
      name: 'cinemaDetail_tel',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get cinemaDetail_address {
    return Intl.message(
      'Address',
      name: 'cinemaDetail_address',
      desc: '',
      args: [],
    );
  }

  /// `WebSite`
  String get cinemaDetail_homepage {
    return Intl.message(
      'WebSite',
      name: 'cinemaDetail_homepage',
      desc: '',
      args: [],
    );
  }

  /// `Showing`
  String get cinemaDetail_showing {
    return Intl.message(
      'Showing',
      name: 'cinemaDetail_showing',
      desc: '',
      args: [],
    );
  }

  /// `Special Screening Price`
  String get cinemaDetail_specialSpecPrice {
    return Intl.message(
      'Special Screening Price',
      name: 'cinemaDetail_specialSpecPrice',
      desc: '',
      args: [],
    );
  }

  /// `Standard Ticket Price`
  String get cinemaDetail_ticketTypePrice {
    return Intl.message(
      'Standard Ticket Price',
      name: 'cinemaDetail_ticketTypePrice',
      desc: '',
      args: [],
    );
  }

  /// `Maximum number of available seats`
  String get cinemaDetail_maxSelectSeat {
    return Intl.message(
      'Maximum number of available seats',
      name: 'cinemaDetail_maxSelectSeat',
      desc: '',
      args: [],
    );
  }

  /// `Theater Info`
  String get cinemaDetail_theaterSpec {
    return Intl.message(
      'Theater Info',
      name: 'cinemaDetail_theaterSpec',
      desc: '',
      args: [],
    );
  }

  /// `{seatCount} seats`
  String cinemaDetail_seatCount(int seatCount) {
    return Intl.message(
      '$seatCount seats',
      name: 'cinemaDetail_seatCount',
      desc: '',
      args: [seatCount],
    );
  }

  /// `A maximum of {maxSeat} seats can be selected`
  String selectSeat_maxSelectSeatWarn(int maxSeat) {
    return Intl.message(
      'A maximum of $maxSeat seats can be selected',
      name: 'selectSeat_maxSelectSeatWarn',
      desc: '',
      args: [maxSeat],
    );
  }

  /// `Confirm Seat Selection`
  String get selectSeat_confirmSelectSeat {
    return Intl.message(
      'Confirm Seat Selection',
      name: 'selectSeat_confirmSelectSeat',
      desc: '',
      args: [],
    );
  }

  /// `Please select a seat`
  String get selectSeat_notSelectSeatWarn {
    return Intl.message(
      'Please select a seat',
      name: 'selectSeat_notSelectSeatWarn',
      desc: '',
      args: [],
    );
  }

  /// `home`
  String get home_home {
    return Intl.message(
      'home',
      name: 'home_home',
      desc: '',
      args: [],
    );
  }

  /// `My Ticket`
  String get home_ticket {
    return Intl.message(
      'My Ticket',
      name: 'home_ticket',
      desc: '',
      args: [],
    );
  }

  /// `cinema`
  String get home_cinema {
    return Intl.message(
      'cinema',
      name: 'home_cinema',
      desc: '',
      args: [],
    );
  }

  /// `my page`
  String get home_me {
    return Intl.message(
      'my page',
      name: 'home_me',
      desc: '',
      args: [],
    );
  }

  /// `Show Time`
  String get ticket_showTime {
    return Intl.message(
      'Show Time',
      name: 'ticket_showTime',
      desc: '',
      args: [],
    );
  }

  /// `Expected End Time`
  String get ticket_endTime {
    return Intl.message(
      'Expected End Time',
      name: 'ticket_endTime',
      desc: '',
      args: [],
    );
  }

  /// `Seat Count`
  String get ticket_seatCount {
    return Intl.message(
      'Seat Count',
      name: 'ticket_seatCount',
      desc: '',
      args: [],
    );
  }

  /// `No ticket yet`
  String get ticket_noData {
    return Intl.message(
      'No ticket yet',
      name: 'ticket_noData',
      desc: '',
      args: [],
    );
  }

  /// `Buy tickets now!`
  String get ticket_noDataTip {
    return Intl.message(
      'Buy tickets now!',
      name: 'ticket_noDataTip',
      desc: '',
      args: [],
    );
  }

  /// `Valid`
  String get ticket_status_valid {
    return Intl.message(
      'Valid',
      name: 'ticket_status_valid',
      desc: '',
      args: [],
    );
  }

  /// `Used`
  String get ticket_status_used {
    return Intl.message(
      'Used',
      name: 'ticket_status_used',
      desc: '',
      args: [],
    );
  }

  /// `Expired`
  String get ticket_status_expired {
    return Intl.message(
      'Expired',
      name: 'ticket_status_expired',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get ticket_status_cancelled {
    return Intl.message(
      'Cancelled',
      name: 'ticket_status_cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Time unknown`
  String get ticket_time_unknown {
    return Intl.message(
      'Time unknown',
      name: 'ticket_time_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Time format error`
  String get ticket_time_formatError {
    return Intl.message(
      'Time format error',
      name: 'ticket_time_formatError',
      desc: '',
      args: [],
    );
  }

  /// `{days} days left`
  String ticket_time_remaining_days(Object days) {
    return Intl.message(
      '$days days left',
      name: 'ticket_time_remaining_days',
      desc: '',
      args: [days],
    );
  }

  /// `{hours} hours left`
  String ticket_time_remaining_hours(Object hours) {
    return Intl.message(
      '$hours hours left',
      name: 'ticket_time_remaining_hours',
      desc: '',
      args: [hours],
    );
  }

  /// `{minutes} minutes left`
  String ticket_time_remaining_minutes(Object minutes) {
    return Intl.message(
      '$minutes minutes left',
      name: 'ticket_time_remaining_minutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `Starting soon`
  String get ticket_time_remaining_soon {
    return Intl.message(
      'Starting soon',
      name: 'ticket_time_remaining_soon',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get ticket_time_weekdays_monday {
    return Intl.message(
      'Mon',
      name: 'ticket_time_weekdays_monday',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get ticket_time_weekdays_tuesday {
    return Intl.message(
      'Tue',
      name: 'ticket_time_weekdays_tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get ticket_time_weekdays_wednesday {
    return Intl.message(
      'Wed',
      name: 'ticket_time_weekdays_wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get ticket_time_weekdays_thursday {
    return Intl.message(
      'Thu',
      name: 'ticket_time_weekdays_thursday',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get ticket_time_weekdays_friday {
    return Intl.message(
      'Fri',
      name: 'ticket_time_weekdays_friday',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get ticket_time_weekdays_saturday {
    return Intl.message(
      'Sat',
      name: 'ticket_time_weekdays_saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get ticket_time_weekdays_sunday {
    return Intl.message(
      'Sun',
      name: 'ticket_time_weekdays_sunday',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Count`
  String get ticket_ticketCount {
    return Intl.message(
      'Ticket Count',
      name: 'ticket_ticketCount',
      desc: '',
      args: [],
    );
  }

  /// `Total Purchased`
  String get ticket_totalPurchased {
    return Intl.message(
      'Total Purchased',
      name: 'ticket_totalPurchased',
      desc: '',
      args: [],
    );
  }

  /// ` tickets`
  String get ticket_tickets {
    return Intl.message(
      ' tickets',
      name: 'ticket_tickets',
      desc: '',
      args: [],
    );
  }

  /// `Tap to view details`
  String get ticket_tapToView {
    return Intl.message(
      'Tap to view details',
      name: 'ticket_tapToView',
      desc: '',
      args: [],
    );
  }

  /// `Buy Tickets`
  String get ticket_buyTickets {
    return Intl.message(
      'Buy Tickets',
      name: 'ticket_buyTickets',
      desc: '',
      args: [],
    );
  }

  /// `Share movie ticket: {movieName}`
  String ticket_shareTicket(Object movieName) {
    return Intl.message(
      'Share movie ticket: $movieName',
      name: 'ticket_shareTicket',
      desc: '',
      args: [movieName],
    );
  }

  /// `Pull to refresh`
  String get common_components_easyRefresh_refresh_dragText {
    return Intl.message(
      'Pull to refresh',
      name: 'common_components_easyRefresh_refresh_dragText',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get common_components_easyRefresh_refresh_armedText {
    return Intl.message(
      'Release to refresh',
      name: 'common_components_easyRefresh_refresh_armedText',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get common_components_easyRefresh_refresh_readyText {
    return Intl.message(
      'Refreshing...',
      name: 'common_components_easyRefresh_refresh_readyText',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get common_components_easyRefresh_refresh_processingText {
    return Intl.message(
      'Refreshing...',
      name: 'common_components_easyRefresh_refresh_processingText',
      desc: '',
      args: [],
    );
  }

  /// `Refresh complete`
  String get common_components_easyRefresh_refresh_processedText {
    return Intl.message(
      'Refresh complete',
      name: 'common_components_easyRefresh_refresh_processedText',
      desc: '',
      args: [],
    );
  }

  /// `Refresh failed`
  String get common_components_easyRefresh_refresh_failedText {
    return Intl.message(
      'Refresh failed',
      name: 'common_components_easyRefresh_refresh_failedText',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get common_components_easyRefresh_refresh_noMoreText {
    return Intl.message(
      'No more data',
      name: 'common_components_easyRefresh_refresh_noMoreText',
      desc: '',
      args: [],
    );
  }

  /// `Pull to load more`
  String get common_components_easyRefresh_loadMore_dragText {
    return Intl.message(
      'Pull to load more',
      name: 'common_components_easyRefresh_loadMore_dragText',
      desc: '',
      args: [],
    );
  }

  /// `Release to load more`
  String get common_components_easyRefresh_loadMore_armedText {
    return Intl.message(
      'Release to load more',
      name: 'common_components_easyRefresh_loadMore_armedText',
      desc: '',
      args: [],
    );
  }

  /// `Ready to load more`
  String get common_components_easyRefresh_loadMore_readyText {
    return Intl.message(
      'Ready to load more',
      name: 'common_components_easyRefresh_loadMore_readyText',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get common_components_easyRefresh_loadMore_processingText {
    return Intl.message(
      'Loading...',
      name: 'common_components_easyRefresh_loadMore_processingText',
      desc: '',
      args: [],
    );
  }

  /// `Load complete`
  String get common_components_easyRefresh_loadMore_processedText {
    return Intl.message(
      'Load complete',
      name: 'common_components_easyRefresh_loadMore_processedText',
      desc: '',
      args: [],
    );
  }

  /// `Load failed`
  String get common_components_easyRefresh_loadMore_failedText {
    return Intl.message(
      'Load failed',
      name: 'common_components_easyRefresh_loadMore_failedText',
      desc: '',
      args: [],
    );
  }

  /// `No more data`
  String get common_components_easyRefresh_loadMore_noMoreText {
    return Intl.message(
      'No more data',
      name: 'common_components_easyRefresh_loadMore_noMoreText',
      desc: '',
      args: [],
    );
  }

  /// `Crop the picture`
  String get common_components_cropper_title {
    return Intl.message(
      'Crop the picture',
      name: 'common_components_cropper_title',
      desc: '',
      args: [],
    );
  }

  /// `Rotate Left`
  String get common_components_cropper_actions_rotateLeft {
    return Intl.message(
      'Rotate Left',
      name: 'common_components_cropper_actions_rotateLeft',
      desc: '',
      args: [],
    );
  }

  /// `Rotate Right`
  String get common_components_cropper_actions_rotateRight {
    return Intl.message(
      'Rotate Right',
      name: 'common_components_cropper_actions_rotateRight',
      desc: '',
      args: [],
    );
  }

  /// `Flip`
  String get common_components_cropper_actions_flip {
    return Intl.message(
      'Flip',
      name: 'common_components_cropper_actions_flip',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get common_components_cropper_actions_undo {
    return Intl.message(
      'Undo',
      name: 'common_components_cropper_actions_undo',
      desc: '',
      args: [],
    );
  }

  /// `Redo`
  String get common_components_cropper_actions_redo {
    return Intl.message(
      'Redo',
      name: 'common_components_cropper_actions_redo',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get common_components_cropper_actions_reset {
    return Intl.message(
      'Reset',
      name: 'common_components_cropper_actions_reset',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get common_components_sendVerifyCode_send {
    return Intl.message(
      'Send Verification Code',
      name: 'common_components_sendVerifyCode_send',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent successfully`
  String get common_components_sendVerifyCode_success {
    return Intl.message(
      'Verification code sent successfully',
      name: 'common_components_sendVerifyCode_success',
      desc: '',
      args: [],
    );
  }

  /// `Couple Seat`
  String get common_enum_seatType_coupleSeat {
    return Intl.message(
      'Couple Seat',
      name: 'common_enum_seatType_coupleSeat',
      desc: '',
      args: [],
    );
  }

  /// `Wheelchair Seat`
  String get common_enum_seatType_wheelChair {
    return Intl.message(
      'Wheelchair Seat',
      name: 'common_enum_seatType_wheelChair',
      desc: '',
      args: [],
    );
  }

  /// `Disabled`
  String get common_enum_seatType_disabled {
    return Intl.message(
      'Disabled',
      name: 'common_enum_seatType_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get common_enum_seatType_selected {
    return Intl.message(
      'Selected',
      name: 'common_enum_seatType_selected',
      desc: '',
      args: [],
    );
  }

  /// `Locked`
  String get common_enum_seatType_locked {
    return Intl.message(
      'Locked',
      name: 'common_enum_seatType_locked',
      desc: '',
      args: [],
    );
  }

  /// `Sold`
  String get common_enum_seatType_sold {
    return Intl.message(
      'Sold',
      name: 'common_enum_seatType_sold',
      desc: '',
      args: [],
    );
  }

  /// `Mon`
  String get common_week_monday {
    return Intl.message(
      'Mon',
      name: 'common_week_monday',
      desc: '',
      args: [],
    );
  }

  /// `Tue`
  String get common_week_tuesday {
    return Intl.message(
      'Tue',
      name: 'common_week_tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wed`
  String get common_week_wednesday {
    return Intl.message(
      'Wed',
      name: 'common_week_wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thu`
  String get common_week_thursday {
    return Intl.message(
      'Thu',
      name: 'common_week_thursday',
      desc: '',
      args: [],
    );
  }

  /// `Fri`
  String get common_week_friday {
    return Intl.message(
      'Fri',
      name: 'common_week_friday',
      desc: '',
      args: [],
    );
  }

  /// `Sat`
  String get common_week_saturday {
    return Intl.message(
      'Sat',
      name: 'common_week_saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sun`
  String get common_week_sunday {
    return Intl.message(
      'Sun',
      name: 'common_week_sunday',
      desc: '',
      args: [],
    );
  }

  /// `point`
  String get common_unit_point {
    return Intl.message(
      'point',
      name: 'common_unit_point',
      desc: '',
      args: [],
    );
  }

  /// `JPY`
  String get common_unit_jpy {
    return Intl.message(
      'JPY',
      name: 'common_unit_jpy',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get login_email_text {
    return Intl.message(
      'Email',
      name: 'login_email_text',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get login_email_verify_notNull {
    return Intl.message(
      'Email cannot be empty',
      name: 'login_email_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address`
  String get login_email_verify_isValid {
    return Intl.message(
      'Invalid email address',
      name: 'login_email_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get login_password_text {
    return Intl.message(
      'Password',
      name: 'login_password_text',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get login_password_verify_notNull {
    return Intl.message(
      'Password cannot be empty',
      name: 'login_password_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Password must be 8-16 characters with letters, numbers, and underscores`
  String get login_password_verify_isValid {
    return Intl.message(
      'Password must be 8-16 characters with letters, numbers, and underscores',
      name: 'login_password_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_loginButton {
    return Intl.message(
      'Login',
      name: 'login_loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get login_verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'login_verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get login_sendVerifyCodeButton {
    return Intl.message(
      'Send Verification Code',
      name: 'login_sendVerifyCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get login_noAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'login_noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Password`
  String get register_repeatPassword_text {
    return Intl.message(
      'Repeat Password',
      name: 'register_repeatPassword_text',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password cannot be empty`
  String get register_repeatPassword_verify_notNull {
    return Intl.message(
      'Repeat password cannot be empty',
      name: 'register_repeatPassword_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Repeat password must be 8-16 characters with letters, numbers, and underscores`
  String get register_repeatPassword_verify_isValid {
    return Intl.message(
      'Repeat password must be 8-16 characters with letters, numbers, and underscores',
      name: 'register_repeatPassword_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `UserName`
  String get register_username_text {
    return Intl.message(
      'UserName',
      name: 'register_username_text',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get register_username_verify_notNull {
    return Intl.message(
      'Username cannot be empty',
      name: 'register_username_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `The passwords you entered twice do not match`
  String get register_passwordNotMatchRepeatPassword {
    return Intl.message(
      'The passwords you entered twice do not match',
      name: 'register_passwordNotMatchRepeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Verification code cannot be empty`
  String get register_verifyCode_verify_notNull {
    return Intl.message(
      'Verification code cannot be empty',
      name: 'register_verifyCode_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Verification code must be 6 digits`
  String get register_verifyCode_verify_isValid {
    return Intl.message(
      'Verification code must be 6 digits',
      name: 'register_verifyCode_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register_registerButton {
    return Intl.message(
      'Register',
      name: 'register_registerButton',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get register_send {
    return Intl.message(
      'Send',
      name: 'register_send',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get register_haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'register_haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Click Here`
  String get register_loginHere {
    return Intl.message(
      'Click Here',
      name: 'register_loginHere',
      desc: '',
      args: [],
    );
  }

  /// `Currently Showing`
  String get movieList_tabBar_currentlyShowing {
    return Intl.message(
      'Currently Showing',
      name: 'movieList_tabBar_currentlyShowing',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get movieList_tabBar_comingSoon {
    return Intl.message(
      'Coming Soon',
      name: 'movieList_tabBar_comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Level`
  String get movieList_currentlyShowing_level {
    return Intl.message(
      'Level',
      name: 'movieList_currentlyShowing_level',
      desc: '',
      args: [],
    );
  }

  /// `Date TBD`
  String get movieList_comingSoon_noDate {
    return Intl.message(
      'Date TBD',
      name: 'movieList_comingSoon_noDate',
      desc: '',
      args: [],
    );
  }

  /// `Search all movies`
  String get movieList_placeholder {
    return Intl.message(
      'Search all movies',
      name: 'movieList_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Buy Ticket`
  String get movieList_buy {
    return Intl.message(
      'Buy Ticket',
      name: 'movieList_buy',
      desc: '',
      args: [],
    );
  }

  /// `Want to Watch`
  String get movieDetail_button_want {
    return Intl.message(
      'Want to Watch',
      name: 'movieDetail_button_want',
      desc: '',
      args: [],
    );
  }

  /// `Watched`
  String get movieDetail_button_saw {
    return Intl.message(
      'Watched',
      name: 'movieDetail_button_saw',
      desc: '',
      args: [],
    );
  }

  /// `Buy Ticket`
  String get movieDetail_button_buy {
    return Intl.message(
      'Buy Ticket',
      name: 'movieDetail_button_buy',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get movieDetail_comment_reply {
    return Intl.message(
      'Reply',
      name: 'movieDetail_comment_reply',
      desc: '',
      args: [],
    );
  }

  /// `Reply to {reply}`
  String movieDetail_comment_replyTo(String reply) {
    return Intl.message(
      'Reply to $reply',
      name: 'movieDetail_comment_replyTo',
      desc: '',
      args: [reply],
    );
  }

  /// `Translate to {language}`
  String movieDetail_comment_translate(String language) {
    return Intl.message(
      'Translate to $language',
      name: 'movieDetail_comment_translate',
      desc: '',
      args: [language],
    );
  }

  /// `Delete`
  String get movieDetail_comment_delete {
    return Intl.message(
      'Delete',
      name: 'movieDetail_comment_delete',
      desc: '',
      args: [],
    );
  }

  /// `Write Comment`
  String get movieDetail_writeComment {
    return Intl.message(
      'Write Comment',
      name: 'movieDetail_writeComment',
      desc: '',
      args: [],
    );
  }

  /// `Release date TBD`
  String get movieDetail_detail_noDate {
    return Intl.message(
      'Release date TBD',
      name: 'movieDetail_detail_noDate',
      desc: '',
      args: [],
    );
  }

  /// `Basic Info`
  String get movieDetail_detail_basicMessage {
    return Intl.message(
      'Basic Info',
      name: 'movieDetail_detail_basicMessage',
      desc: '',
      args: [],
    );
  }

  /// `Original Title`
  String get movieDetail_detail_originalName {
    return Intl.message(
      'Original Title',
      name: 'movieDetail_detail_originalName',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get movieDetail_detail_time {
    return Intl.message(
      'Duration',
      name: 'movieDetail_detail_time',
      desc: '',
      args: [],
    );
  }

  /// `Screening Spec`
  String get movieDetail_detail_spec {
    return Intl.message(
      'Screening Spec',
      name: 'movieDetail_detail_spec',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get movieDetail_detail_tags {
    return Intl.message(
      'Tags',
      name: 'movieDetail_detail_tags',
      desc: '',
      args: [],
    );
  }

  /// `Official Website`
  String get movieDetail_detail_homepage {
    return Intl.message(
      'Official Website',
      name: 'movieDetail_detail_homepage',
      desc: '',
      args: [],
    );
  }

  /// `Screening Status`
  String get movieDetail_detail_state {
    return Intl.message(
      'Screening Status',
      name: 'movieDetail_detail_state',
      desc: '',
      args: [],
    );
  }

  /// `Rating`
  String get movieDetail_detail_level {
    return Intl.message(
      'Rating',
      name: 'movieDetail_detail_level',
      desc: '',
      args: [],
    );
  }

  /// `Staff`
  String get movieDetail_detail_staff {
    return Intl.message(
      'Staff',
      name: 'movieDetail_detail_staff',
      desc: '',
      args: [],
    );
  }

  /// `Character`
  String get movieDetail_detail_character {
    return Intl.message(
      'Character',
      name: 'movieDetail_detail_character',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get movieDetail_detail_comment {
    return Intl.message(
      'Comment',
      name: 'movieDetail_detail_comment',
      desc: '',
      args: [],
    );
  }

  /// `Total {total} replies`
  String movieDetail_detail_totalReplyMessage(int total) {
    return Intl.message(
      'Total $total replies',
      name: 'movieDetail_detail_totalReplyMessage',
      desc: '',
      args: [total],
    );
  }

  /// `Comment Detail`
  String get commentDetail_title {
    return Intl.message(
      'Comment Detail',
      name: 'commentDetail_title',
      desc: '',
      args: [],
    );
  }

  /// `Comment Reply`
  String get commentDetail_replyComment {
    return Intl.message(
      'Comment Reply',
      name: 'commentDetail_replyComment',
      desc: '',
      args: [],
    );
  }

  /// `Total {total} replies`
  String commentDetail_totalReplyMessage(int total) {
    return Intl.message(
      'Total $total replies',
      name: 'commentDetail_totalReplyMessage',
      desc: '',
      args: [total],
    );
  }

  /// `Reply to {reply}`
  String commentDetail_comment_placeholder(String reply) {
    return Intl.message(
      'Reply to $reply',
      name: 'commentDetail_comment_placeholder',
      desc: '',
      args: [reply],
    );
  }

  /// `Reply`
  String get commentDetail_comment_button {
    return Intl.message(
      'Reply',
      name: 'commentDetail_comment_button',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get movieTicketType_total {
    return Intl.message(
      'Total',
      name: 'movieTicketType_total',
      desc: '',
      args: [],
    );
  }

  /// `Select Movie Ticket Type`
  String get movieTicketType_title {
    return Intl.message(
      'Select Movie Ticket Type',
      name: 'movieTicketType_title',
      desc: '',
      args: [],
    );
  }

  /// `Seat Number`
  String get movieTicketType_seatNumber {
    return Intl.message(
      'Seat Number',
      name: 'movieTicketType_seatNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please select a movie ticket type`
  String get movieTicketType_selectMovieTicketType {
    return Intl.message(
      'Please select a movie ticket type',
      name: 'movieTicketType_selectMovieTicketType',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get movieTicketType_confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'movieTicketType_confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder_title {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder_title',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get confirmOrder_total {
    return Intl.message(
      'Total',
      name: 'confirmOrder_total',
      desc: '',
      args: [],
    );
  }

  /// `Select Payment Method`
  String get confirmOrder_selectPayMethod {
    return Intl.message(
      'Select Payment Method',
      name: 'confirmOrder_selectPayMethod',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get confirmOrder_pay {
    return Intl.message(
      'Buy',
      name: 'confirmOrder_pay',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get user_title {
    return Intl.message(
      'My Profile',
      name: 'user_title',
      desc: '',
      args: [],
    );
  }

  /// `Order Count`
  String get user_data_orderCount {
    return Intl.message(
      'Order Count',
      name: 'user_data_orderCount',
      desc: '',
      args: [],
    );
  }

  /// `Watch History`
  String get user_data_watchHistory {
    return Intl.message(
      'Watch History',
      name: 'user_data_watchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Want to Watch Count`
  String get user_data_wantCount {
    return Intl.message(
      'Want to Watch Count',
      name: 'user_data_wantCount',
      desc: '',
      args: [],
    );
  }

  /// `Character Count`
  String get user_data_characterCount {
    return Intl.message(
      'Character Count',
      name: 'user_data_characterCount',
      desc: '',
      args: [],
    );
  }

  /// `Staff Count`
  String get user_data_staffCount {
    return Intl.message(
      'Staff Count',
      name: 'user_data_staffCount',
      desc: '',
      args: [],
    );
  }

  /// `Registration Time`
  String get user_registerTime {
    return Intl.message(
      'Registration Time',
      name: 'user_registerTime',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get user_language {
    return Intl.message(
      'Language',
      name: 'user_language',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get user_editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'user_editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Agreement`
  String get user_privateAgreement {
    return Intl.message(
      'Privacy Agreement',
      name: 'user_privateAgreement',
      desc: '',
      args: [],
    );
  }

  /// `Check Update`
  String get user_checkUpdate {
    return Intl.message(
      'Check Update',
      name: 'user_checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get user_about {
    return Intl.message(
      'About',
      name: 'user_about',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get user_logout {
    return Intl.message(
      'Logout',
      name: 'user_logout',
      desc: '',
      args: [],
    );
  }

  /// `Order List`
  String get orderList_title {
    return Intl.message(
      'Order List',
      name: 'orderList_title',
      desc: '',
      args: [],
    );
  }

  /// `Order Number`
  String get orderList_orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderList_orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get orderList_comment {
    return Intl.message(
      'Comment',
      name: 'orderList_comment',
      desc: '',
      args: [],
    );
  }

  /// `Order Detail`
  String get orderDetail_title {
    return Intl.message(
      'Order Detail',
      name: 'orderDetail_title',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Collection Code`
  String get orderDetail_ticketCode {
    return Intl.message(
      'Ticket Collection Code',
      name: 'orderDetail_ticketCode',
      desc: '',
      args: [],
    );
  }

  /// `{ticketCount} Movie Tickets`
  String orderDetail_ticketCount(int ticketCount) {
    return Intl.message(
      '$ticketCount Movie Tickets',
      name: 'orderDetail_ticketCount',
      desc: '',
      args: [ticketCount],
    );
  }

  /// `Order Number`
  String get orderDetail_orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderDetail_orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get orderDetail_orderState {
    return Intl.message(
      'Order Status',
      name: 'orderDetail_orderState',
      desc: '',
      args: [],
    );
  }

  /// `Order Creation Time`
  String get orderDetail_orderCreateTime {
    return Intl.message(
      'Order Creation Time',
      name: 'orderDetail_orderCreateTime',
      desc: '',
      args: [],
    );
  }

  /// `Payment Time`
  String get orderDetail_payTime {
    return Intl.message(
      'Payment Time',
      name: 'orderDetail_payTime',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get orderDetail_payMethod {
    return Intl.message(
      'Payment Method',
      name: 'orderDetail_payMethod',
      desc: '',
      args: [],
    );
  }

  /// `Seat Information`
  String get orderDetail_seatMessage {
    return Intl.message(
      'Seat Information',
      name: 'orderDetail_seatMessage',
      desc: '',
      args: [],
    );
  }

  /// `Order Information`
  String get orderDetail_orderMessage {
    return Intl.message(
      'Order Information',
      name: 'orderDetail_orderMessage',
      desc: '',
      args: [],
    );
  }

  /// `Payment Successful`
  String get payResult_title {
    return Intl.message(
      'Payment Successful',
      name: 'payResult_title',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been paid. Please arrive at the following location before the specified time. Enjoy your movie.`
  String get payResult_success {
    return Intl.message(
      'Your order has been paid. Please arrive at the following location before the specified time. Enjoy your movie.',
      name: 'payResult_success',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Collection Code`
  String get payResult_ticketCode {
    return Intl.message(
      'Ticket Collection Code',
      name: 'payResult_ticketCode',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get userProfile_title {
    return Intl.message(
      'User Profile',
      name: 'userProfile_title',
      desc: '',
      args: [],
    );
  }

  /// `Avatar`
  String get userProfile_avatar {
    return Intl.message(
      'Avatar',
      name: 'userProfile_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userProfile_username {
    return Intl.message(
      'Username',
      name: 'userProfile_username',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get userProfile_email {
    return Intl.message(
      'Email',
      name: 'userProfile_email',
      desc: '',
      args: [],
    );
  }

  /// `Register Time`
  String get userProfile_registerTime {
    return Intl.message(
      'Register Time',
      name: 'userProfile_registerTime',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get userProfile_save {
    return Intl.message(
      'Save',
      name: 'userProfile_save',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your username`
  String get userProfile_edit_username_placeholder {
    return Intl.message(
      'Please enter your username',
      name: 'userProfile_edit_username_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get userProfile_edit_username_verify_notNull {
    return Intl.message(
      'Username cannot be empty',
      name: 'userProfile_edit_username_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get movieShowList_dropdown_area {
    return Intl.message(
      'Area',
      name: 'movieShowList_dropdown_area',
      desc: '',
      args: [],
    );
  }

  /// `Screen Spec`
  String get movieShowList_dropdown_screenSpec {
    return Intl.message(
      'Screen Spec',
      name: 'movieShowList_dropdown_screenSpec',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle`
  String get movieShowList_dropdown_subtitle {
    return Intl.message(
      'Subtitle',
      name: 'movieShowList_dropdown_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Nearby Cinemas`
  String get cinemaList_title {
    return Intl.message(
      'Nearby Cinemas',
      name: 'cinemaList_title',
      desc: '',
      args: [],
    );
  }

  /// `Getting current location`
  String get cinemaList_address {
    return Intl.message(
      'Getting current location',
      name: 'cinemaList_address',
      desc: '',
      args: [],
    );
  }

  /// `Search cinema name or address`
  String get cinemaList_search_hint {
    return Intl.message(
      'Search cinema name or address',
      name: 'cinemaList_search_hint',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get cinemaList_search_clear {
    return Intl.message(
      'Clear',
      name: 'cinemaList_search_clear',
      desc: '',
      args: [],
    );
  }

  /// `Found {count} related cinemas`
  String cinemaList_search_results_found(Object count) {
    return Intl.message(
      'Found $count related cinemas',
      name: 'cinemaList_search_results_found',
      desc: '',
      args: [count],
    );
  }

  /// `No related cinemas found, please try other keywords`
  String get cinemaList_search_results_notFound {
    return Intl.message(
      'No related cinemas found, please try other keywords',
      name: 'cinemaList_search_results_notFound',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Area`
  String get cinemaList_filter_title {
    return Intl.message(
      'Filter by Area',
      name: 'cinemaList_filter_title',
      desc: '',
      args: [],
    );
  }

  /// `Loading area data...`
  String get cinemaList_filter_loading {
    return Intl.message(
      'Loading area data...',
      name: 'cinemaList_filter_loading',
      desc: '',
      args: [],
    );
  }

  /// `Loading failed, please retry`
  String get cinemaList_loading {
    return Intl.message(
      'Loading failed, please retry',
      name: 'cinemaList_loading',
      desc: '',
      args: [],
    );
  }

  /// `No cinema data`
  String get cinemaList_empty_noData {
    return Intl.message(
      'No cinema data',
      name: 'cinemaList_empty_noData',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later`
  String get cinemaList_empty_noDataTip {
    return Intl.message(
      'Please try again later',
      name: 'cinemaList_empty_noDataTip',
      desc: '',
      args: [],
    );
  }

  /// `No related cinemas found`
  String get cinemaList_empty_noSearchResults {
    return Intl.message(
      'No related cinemas found',
      name: 'cinemaList_empty_noSearchResults',
      desc: '',
      args: [],
    );
  }

  /// `Please try other keywords`
  String get cinemaList_empty_noSearchResultsTip {
    return Intl.message(
      'Please try other keywords',
      name: 'cinemaList_empty_noSearchResultsTip',
      desc: '',
      args: [],
    );
  }

  /// `Now Showing`
  String get cinemaList_movies_nowShowing {
    return Intl.message(
      'Now Showing',
      name: 'cinemaList_movies_nowShowing',
      desc: '',
      args: [],
    );
  }

  /// `Selected Seats`
  String get cinemaList_selectSeat_selectedSeats {
    return Intl.message(
      'Selected Seats',
      name: 'cinemaList_selectSeat_selectedSeats',
      desc: '',
      args: [],
    );
  }

  /// `Please select seats`
  String get cinemaList_selectSeat_pleaseSelectSeats {
    return Intl.message(
      'Please select seats',
      name: 'cinemaList_selectSeat_pleaseSelectSeats',
      desc: '',
      args: [],
    );
  }

  /// `Confirm selection of {count} seats`
  String cinemaList_selectSeat_confirmSelection(Object count) {
    return Intl.message(
      'Confirm selection of $count seats',
      name: 'cinemaList_selectSeat_confirmSelection',
      desc: '',
      args: [count],
    );
  }

  /// `Selected {count} seats`
  String cinemaList_selectSeat_seatsSelected(Object count) {
    return Intl.message(
      'Selected $count seats',
      name: 'cinemaList_selectSeat_seatsSelected',
      desc: '',
      args: [count],
    );
  }

  /// `MMM dd, yyyy`
  String get cinemaList_selectSeat_dateFormat {
    return Intl.message(
      'MMM dd, yyyy',
      name: 'cinemaList_selectSeat_dateFormat',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
