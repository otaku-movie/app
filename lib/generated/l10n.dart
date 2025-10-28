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

  /// `Rate this movie`
  String get writeComment_rateTitle {
    return Intl.message(
      'Rate this movie',
      name: 'writeComment_rateTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share your movie experience`
  String get writeComment_contentTitle {
    return Intl.message(
      'Share your movie experience',
      name: 'writeComment_contentTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share your experience to help others`
  String get writeComment_shareExperience {
    return Intl.message(
      'Share your experience to help others',
      name: 'writeComment_shareExperience',
      desc: '',
      args: [],
    );
  }

  /// `Failed to publish comment, please try again`
  String get writeComment_publishFailed {
    return Intl.message(
      'Failed to publish comment, please try again',
      name: 'writeComment_publishFailed',
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

  /// `Movie ID cannot be empty`
  String get writeComment_verify_movieIdEmpty {
    return Intl.message(
      'Movie ID cannot be empty',
      name: 'writeComment_verify_movieIdEmpty',
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

  /// `Select Seat`
  String get showTimeDetail_buy {
    return Intl.message(
      'Select Seat',
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

  /// `Seats Available`
  String get showTimeDetail_seatStatus_available {
    return Intl.message(
      'Seats Available',
      name: 'showTimeDetail_seatStatus_available',
      desc: '',
      args: [],
    );
  }

  /// `Seats Limited`
  String get showTimeDetail_seatStatus_tight {
    return Intl.message(
      'Seats Limited',
      name: 'showTimeDetail_seatStatus_tight',
      desc: '',
      args: [],
    );
  }

  /// `Sold Out`
  String get showTimeDetail_seatStatus_soldOut {
    return Intl.message(
      'Sold Out',
      name: 'showTimeDetail_seatStatus_soldOut',
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

  /// `Loading...`
  String get common_loading {
    return Intl.message(
      'Loading...',
      name: 'common_loading',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get common_error_title {
    return Intl.message(
      'Error',
      name: 'common_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load data, please try again later`
  String get common_error_message {
    return Intl.message(
      'Failed to load data, please try again later',
      name: 'common_error_message',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get common_retry {
    return Intl.message(
      'Retry',
      name: 'common_retry',
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

  /// `pts`
  String get common_unit_point {
    return Intl.message(
      'pts',
      name: 'common_unit_point',
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

  /// `Loading...`
  String get common_components_easyRefresh_loadMore_readyText {
    return Intl.message(
      'Loading...',
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

  /// `Verification code sent successfully`
  String get common_components_sendVerifyCode_success {
    return Intl.message(
      'Verification code sent successfully',
      name: 'common_components_sendVerifyCode_success',
      desc: '',
      args: [],
    );
  }

  /// `Please select`
  String get common_components_filterBar_pleaseSelect {
    return Intl.message(
      'Please select',
      name: 'common_components_filterBar_pleaseSelect',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get common_components_filterBar_reset {
    return Intl.message(
      'Reset',
      name: 'common_components_filterBar_reset',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get common_components_filterBar_confirm {
    return Intl.message(
      'Confirm',
      name: 'common_components_filterBar_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get common_week_monday {
    return Intl.message(
      'Monday',
      name: 'common_week_monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get common_week_tuesday {
    return Intl.message(
      'Tuesday',
      name: 'common_week_tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get common_week_wednesday {
    return Intl.message(
      'Wednesday',
      name: 'common_week_wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get common_week_thursday {
    return Intl.message(
      'Thursday',
      name: 'common_week_thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get common_week_friday {
    return Intl.message(
      'Friday',
      name: 'common_week_friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get common_week_saturday {
    return Intl.message(
      'Saturday',
      name: 'common_week_saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get common_week_sunday {
    return Intl.message(
      'Sunday',
      name: 'common_week_sunday',
      desc: '',
      args: [],
    );
  }

  /// `Wheelchair`
  String get common_enum_seatType_wheelChair {
    return Intl.message(
      'Wheelchair',
      name: 'common_enum_seatType_wheelChair',
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

  /// `About`
  String get about_title {
    return Intl.message(
      'About',
      name: 'about_title',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get about_version {
    return Intl.message(
      'Version',
      name: 'about_version',
      desc: '',
      args: [],
    );
  }

  /// `Committed to providing convenient ticket purchasing experience for movie enthusiasts.`
  String get about_description {
    return Intl.message(
      'Committed to providing convenient ticket purchasing experience for movie enthusiasts.',
      name: 'about_description',
      desc: '',
      args: [],
    );
  }

  /// `View Privacy Policy`
  String get about_privacy_policy {
    return Intl.message(
      'View Privacy Policy',
      name: 'about_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `© 2025 Otaku Movie All Rights Reserved`
  String get about_copyright {
    return Intl.message(
      '© 2025 Otaku Movie All Rights Reserved',
      name: 'about_copyright',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent successfully`
  String get about_components_sendVerifyCode_success {
    return Intl.message(
      'Verification code sent successfully',
      name: 'about_components_sendVerifyCode_success',
      desc: '',
      args: [],
    );
  }

  /// `Please select`
  String get about_components_filterBar_pleaseSelect {
    return Intl.message(
      'Please select',
      name: 'about_components_filterBar_pleaseSelect',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get about_components_filterBar_reset {
    return Intl.message(
      'Reset',
      name: 'about_components_filterBar_reset',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get about_components_filterBar_confirm {
    return Intl.message(
      'Confirm',
      name: 'about_components_filterBar_confirm',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get about_components_showTimeList_all {
    return Intl.message(
      'All',
      name: 'about_components_showTimeList_all',
      desc: '',
      args: [],
    );
  }

  /// `Unnamed`
  String get about_components_showTimeList_unnamed {
    return Intl.message(
      'Unnamed',
      name: 'about_components_showTimeList_unnamed',
      desc: '',
      args: [],
    );
  }

  /// `No data yet`
  String get about_components_showTimeList_noData {
    return Intl.message(
      'No data yet',
      name: 'about_components_showTimeList_noData',
      desc: '',
      args: [],
    );
  }

  /// `No showtime information`
  String get about_components_showTimeList_noShowTimeInfo {
    return Intl.message(
      'No showtime information',
      name: 'about_components_showTimeList_noShowTimeInfo',
      desc: '',
      args: [],
    );
  }

  /// `There are {count} more showtimes...`
  String about_components_showTimeList_moreShowTimes(Object count) {
    return Intl.message(
      'There are $count more showtimes...',
      name: 'about_components_showTimeList_moreShowTimes',
      desc: '',
      args: [count],
    );
  }

  /// `Sold Out`
  String get about_components_showTimeList_seatStatus_soldOut {
    return Intl.message(
      'Sold Out',
      name: 'about_components_showTimeList_seatStatus_soldOut',
      desc: '',
      args: [],
    );
  }

  /// `Limited`
  String get about_components_showTimeList_seatStatus_limited {
    return Intl.message(
      'Limited',
      name: 'about_components_showTimeList_seatStatus_limited',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get about_components_showTimeList_seatStatus_available {
    return Intl.message(
      'Available',
      name: 'about_components_showTimeList_seatStatus_available',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get about_login_verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'about_login_verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get about_login_email_verify_notNull {
    return Intl.message(
      'Email cannot be empty',
      name: 'about_login_email_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get about_login_email_verify_isValid {
    return Intl.message(
      'Please enter a valid email address',
      name: 'about_login_email_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get about_login_email_text {
    return Intl.message(
      'Email',
      name: 'about_login_email_text',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get about_login_password_verify_notNull {
    return Intl.message(
      'Password cannot be empty',
      name: 'about_login_password_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get about_login_password_verify_isValid {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'about_login_password_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get about_login_password_text {
    return Intl.message(
      'Password',
      name: 'about_login_password_text',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get about_login_loginButton {
    return Intl.message(
      'Login',
      name: 'about_login_loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get about_login_welcomeText {
    return Intl.message(
      'Welcome Back',
      name: 'about_login_welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get about_login_forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'about_login_forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get about_login_or {
    return Intl.message(
      'or',
      name: 'about_login_or',
      desc: '',
      args: [],
    );
  }

  /// `Login with Google`
  String get about_login_googleLogin {
    return Intl.message(
      'Login with Google',
      name: 'about_login_googleLogin',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get about_login_noAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'about_login_noAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get about_register_registerButton {
    return Intl.message(
      'Register',
      name: 'about_register_registerButton',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get about_register_username_verify_notNull {
    return Intl.message(
      'Username cannot be empty',
      name: 'about_register_username_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get about_register_username_text {
    return Intl.message(
      'Username',
      name: 'about_register_username_text',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get about_register_repeatPassword_text {
    return Intl.message(
      'Confirm Password',
      name: 'about_register_repeatPassword_text',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get about_register_passwordNotMatchRepeatPassword {
    return Intl.message(
      'Passwords do not match',
      name: 'about_register_passwordNotMatchRepeatPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid verification code format`
  String get about_register_verifyCode_verify_isValid {
    return Intl.message(
      'Invalid verification code format',
      name: 'about_register_verifyCode_verify_isValid',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get about_register_send {
    return Intl.message(
      'Send',
      name: 'about_register_send',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get about_register_haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'about_register_haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login here`
  String get about_register_loginHere {
    return Intl.message(
      'Login here',
      name: 'about_register_loginHere',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get about_movieShowList_dropdown_area {
    return Intl.message(
      'Area',
      name: 'about_movieShowList_dropdown_area',
      desc: '',
      args: [],
    );
  }

  /// `Screen Spec`
  String get about_movieShowList_dropdown_screenSpec {
    return Intl.message(
      'Screen Spec',
      name: 'about_movieShowList_dropdown_screenSpec',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle`
  String get about_movieShowList_dropdown_subtitle {
    return Intl.message(
      'Subtitle',
      name: 'about_movieShowList_dropdown_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Couple Seat`
  String get enum_seatType_coupleSeat {
    return Intl.message(
      'Couple Seat',
      name: 'enum_seatType_coupleSeat',
      desc: '',
      args: [],
    );
  }

  /// `Wheelchair Seat`
  String get enum_seatType_wheelChair {
    return Intl.message(
      'Wheelchair Seat',
      name: 'enum_seatType_wheelChair',
      desc: '',
      args: [],
    );
  }

  /// `Disabled`
  String get enum_seatType_disabled {
    return Intl.message(
      'Disabled',
      name: 'enum_seatType_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get enum_seatType_selected {
    return Intl.message(
      'Selected',
      name: 'enum_seatType_selected',
      desc: '',
      args: [],
    );
  }

  /// `Locked`
  String get enum_seatType_locked {
    return Intl.message(
      'Locked',
      name: 'enum_seatType_locked',
      desc: '',
      args: [],
    );
  }

  /// `Sold`
  String get enum_seatType_sold {
    return Intl.message(
      'Sold',
      name: 'enum_seatType_sold',
      desc: '',
      args: [],
    );
  }

  /// `point`
  String get unit_point {
    return Intl.message(
      'point',
      name: 'unit_point',
      desc: '',
      args: [],
    );
  }

  /// `JPY`
  String get unit_jpy {
    return Intl.message(
      'JPY',
      name: 'unit_jpy',
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

  /// `Welcome back, please log in to your account`
  String get login_welcomeText {
    return Intl.message(
      'Welcome back, please log in to your account',
      name: 'login_welcomeText',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get login_or {
    return Intl.message(
      'or',
      name: 'login_or',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get login_googleLogin {
    return Intl.message(
      'Sign in with Google',
      name: 'login_googleLogin',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get login_forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'login_forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get login_forgotPasswordTitle {
    return Intl.message(
      'Forgot Password',
      name: 'login_forgotPasswordTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we'll send you a verification code`
  String get login_forgotPasswordDescription {
    return Intl.message(
      'Enter your email address and we\'ll send you a verification code',
      name: 'login_forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get login_emailAddress {
    return Intl.message(
      'Email Address',
      name: 'login_emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get login_newPassword {
    return Intl.message(
      'New Password',
      name: 'login_newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get login_sendVerificationCode {
    return Intl.message(
      'Send Verification Code',
      name: 'login_sendVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get login_resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'login_resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember your password?`
  String get login_rememberPassword {
    return Intl.message(
      'Remember your password?',
      name: 'login_rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get login_backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'login_backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get login_emailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'login_emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get login_emailInvalid {
    return Intl.message(
      'Please enter a valid email address',
      name: 'login_emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get login_verificationCodeRequired {
    return Intl.message(
      'Please enter the verification code',
      name: 'login_verificationCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your new password`
  String get login_newPasswordRequired {
    return Intl.message(
      'Please enter your new password',
      name: 'login_newPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get login_passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'login_passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Verification code has been sent to your email`
  String get login_verificationCodeSent {
    return Intl.message(
      'Verification code has been sent to your email',
      name: 'login_verificationCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful`
  String get login_passwordResetSuccess {
    return Intl.message(
      'Password reset successful',
      name: 'login_passwordResetSuccess',
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

  /// `Unknown`
  String get movieDetail_detail_duration_unknown {
    return Intl.message(
      'Unknown',
      name: 'movieDetail_detail_duration_unknown',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get movieDetail_detail_duration_minutes {
    return Intl.message(
      'minutes',
      name: 'movieDetail_detail_duration_minutes',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get movieDetail_detail_duration_hours {
    return Intl.message(
      'hours',
      name: 'movieDetail_detail_duration_hours',
      desc: '',
      args: [],
    );
  }

  /// `{hours}h {minutes}m`
  String movieDetail_detail_duration_hoursMinutes(int hours, int minutes) {
    return Intl.message(
      '${hours}h ${minutes}m',
      name: 'movieDetail_detail_duration_hoursMinutes',
      desc: '',
      args: [hours, minutes],
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

  /// `Write your reply...`
  String get commentDetail_comment_hint {
    return Intl.message(
      'Write your reply...',
      name: 'commentDetail_comment_hint',
      desc: '',
      args: [],
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

  /// `Please select appropriate ticket type for each seat`
  String get movieTicketType_selectTicketTypeForSeats {
    return Intl.message(
      'Please select appropriate ticket type for each seat',
      name: 'movieTicketType_selectTicketTypeForSeats',
      desc: '',
      args: [],
    );
  }

  /// `Movie Info`
  String get movieTicketType_movieInfo {
    return Intl.message(
      'Movie Info',
      name: 'movieTicketType_movieInfo',
      desc: '',
      args: [],
    );
  }

  /// `Show Time`
  String get movieTicketType_showTime {
    return Intl.message(
      'Show Time',
      name: 'movieTicketType_showTime',
      desc: '',
      args: [],
    );
  }

  /// `Cinema`
  String get movieTicketType_cinema {
    return Intl.message(
      'Cinema',
      name: 'movieTicketType_cinema',
      desc: '',
      args: [],
    );
  }

  /// `Seat Information`
  String get movieTicketType_seatInfo {
    return Intl.message(
      'Seat Information',
      name: 'movieTicketType_seatInfo',
      desc: '',
      args: [],
    );
  }

  /// `Ticket Type`
  String get movieTicketType_ticketType {
    return Intl.message(
      'Ticket Type',
      name: 'movieTicketType_ticketType',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get movieTicketType_price {
    return Intl.message(
      'Price',
      name: 'movieTicketType_price',
      desc: '',
      args: [],
    );
  }

  /// `Select Ticket Type`
  String get movieTicketType_selectTicketType {
    return Intl.message(
      'Select Ticket Type',
      name: 'movieTicketType_selectTicketType',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get movieTicketType_totalPrice {
    return Intl.message(
      'Total Price',
      name: 'movieTicketType_totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Actual Payment`
  String get movieTicketType_actualPrice {
    return Intl.message(
      'Actual Payment',
      name: 'movieTicketType_actualPrice',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Seat Selection`
  String get seatCancel_confirmTitle {
    return Intl.message(
      'Cancel Seat Selection',
      name: 'seatCancel_confirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have selected seats. Are you sure you want to cancel the selected seats?`
  String get seatCancel_confirmMessage {
    return Intl.message(
      'You have selected seats. Are you sure you want to cancel the selected seats?',
      name: 'seatCancel_confirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get seatCancel_cancel {
    return Intl.message(
      'Cancel',
      name: 'seatCancel_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get seatCancel_confirm {
    return Intl.message(
      'Confirm',
      name: 'seatCancel_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Seat selection has been cancelled`
  String get seatCancel_successMessage {
    return Intl.message(
      'Seat selection has been cancelled',
      name: 'seatCancel_successMessage',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel seat selection, please try again`
  String get seatCancel_errorMessage {
    return Intl.message(
      'Failed to cancel seat selection, please try again',
      name: 'seatCancel_errorMessage',
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

  /// `Selected Seats`
  String get confirmOrder_selectedSeats {
    return Intl.message(
      'Selected Seats',
      name: 'confirmOrder_selectedSeats',
      desc: '',
      args: [],
    );
  }

  /// `{count} seats`
  String confirmOrder_seatCount(int count) {
    return Intl.message(
      '$count seats',
      name: 'confirmOrder_seatCount',
      desc: '',
      args: [count],
    );
  }

  /// `Time Information`
  String get confirmOrder_timeInfo {
    return Intl.message(
      'Time Information',
      name: 'confirmOrder_timeInfo',
      desc: '',
      args: [],
    );
  }

  /// `Cinema Information`
  String get confirmOrder_cinemaInfo {
    return Intl.message(
      'Cinema Information',
      name: 'confirmOrder_cinemaInfo',
      desc: '',
      args: [],
    );
  }

  /// `Time Remaining`
  String get confirmOrder_countdown {
    return Intl.message(
      'Time Remaining',
      name: 'confirmOrder_countdown',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Order`
  String get confirmOrder_cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'confirmOrder_cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `You have selected seats. Are you sure you want to cancel the order and release the selected seats?`
  String get confirmOrder_cancelOrderConfirm {
    return Intl.message(
      'You have selected seats. Are you sure you want to cancel the order and release the selected seats?',
      name: 'confirmOrder_cancelOrderConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Continue Payment`
  String get confirmOrder_continuePay {
    return Intl.message(
      'Continue Payment',
      name: 'confirmOrder_continuePay',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Cancel`
  String get confirmOrder_confirmCancel {
    return Intl.message(
      'Confirm Cancel',
      name: 'confirmOrder_confirmCancel',
      desc: '',
      args: [],
    );
  }

  /// `Order Canceled`
  String get confirmOrder_orderCanceled {
    return Intl.message(
      'Order Canceled',
      name: 'confirmOrder_orderCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel order, please try again`
  String get confirmOrder_cancelOrderFailed {
    return Intl.message(
      'Failed to cancel order, please try again',
      name: 'confirmOrder_cancelOrderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Seat Selection`
  String get seatSelection_cancelSeatTitle {
    return Intl.message(
      'Cancel Seat Selection',
      name: 'seatSelection_cancelSeatTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have selected seats. Are you sure you want to cancel the selected seats?`
  String get seatSelection_cancelSeatConfirm {
    return Intl.message(
      'You have selected seats. Are you sure you want to cancel the selected seats?',
      name: 'seatSelection_cancelSeatConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get seatSelection_cancel {
    return Intl.message(
      'Cancel',
      name: 'seatSelection_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get seatSelection_confirm {
    return Intl.message(
      'Confirm',
      name: 'seatSelection_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Seat selection canceled`
  String get seatSelection_seatCanceled {
    return Intl.message(
      'Seat selection canceled',
      name: 'seatSelection_seatCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel seat selection, please try again`
  String get seatSelection_cancelSeatFailed {
    return Intl.message(
      'Failed to cancel seat selection, please try again',
      name: 'seatSelection_cancelSeatFailed',
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

  /// `Current Version`
  String get user_currentVersion {
    return Intl.message(
      'Current Version',
      name: 'user_currentVersion',
      desc: '',
      args: [],
    );
  }

  /// `Latest Version`
  String get user_latestVersion {
    return Intl.message(
      'Latest Version',
      name: 'user_latestVersion',
      desc: '',
      args: [],
    );
  }

  /// `New version found. Update now?`
  String get user_updateAvailable {
    return Intl.message(
      'New version found. Update now?',
      name: 'user_updateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get user_cancel {
    return Intl.message(
      'Cancel',
      name: 'user_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get user_update {
    return Intl.message(
      'Update',
      name: 'user_update',
      desc: '',
      args: [],
    );
  }

  /// `Updating`
  String get user_updating {
    return Intl.message(
      'Updating',
      name: 'user_updating',
      desc: '',
      args: [],
    );
  }

  /// `Downloading update, please wait...`
  String get user_updateProgress {
    return Intl.message(
      'Downloading update, please wait...',
      name: 'user_updateProgress',
      desc: '',
      args: [],
    );
  }

  /// `Update Successful`
  String get user_updateSuccess {
    return Intl.message(
      'Update Successful',
      name: 'user_updateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `App has been successfully updated to the latest version!`
  String get user_updateSuccessMessage {
    return Intl.message(
      'App has been successfully updated to the latest version!',
      name: 'user_updateSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Update Failed`
  String get user_updateError {
    return Intl.message(
      'Update Failed',
      name: 'user_updateError',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred during update. Please try again later.`
  String get user_updateErrorMessage {
    return Intl.message(
      'An error occurred during update. Please try again later.',
      name: 'user_updateErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get user_ok {
    return Intl.message(
      'OK',
      name: 'user_ok',
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

  /// `Showtime Reminder`
  String get orderDetail_countdown_title {
    return Intl.message(
      'Showtime Reminder',
      name: 'orderDetail_countdown_title',
      desc: '',
      args: [],
    );
  }

  /// `Started`
  String get orderDetail_countdown_started {
    return Intl.message(
      'Started',
      name: 'orderDetail_countdown_started',
      desc: '',
      args: [],
    );
  }

  /// `{hours} hours {minutes} minutes until showtime`
  String orderDetail_countdown_hoursMinutes(Object hours, Object minutes) {
    return Intl.message(
      '$hours hours $minutes minutes until showtime',
      name: 'orderDetail_countdown_hoursMinutes',
      desc: '',
      args: [hours, minutes],
    );
  }

  /// `{minutes} minutes {seconds} seconds until showtime`
  String orderDetail_countdown_minutesSeconds(Object minutes, Object seconds) {
    return Intl.message(
      '$minutes minutes $seconds seconds until showtime',
      name: 'orderDetail_countdown_minutesSeconds',
      desc: '',
      args: [minutes, seconds],
    );
  }

  /// `{seconds} seconds until showtime`
  String orderDetail_countdown_seconds(Object seconds) {
    return Intl.message(
      '$seconds seconds until showtime',
      name: 'orderDetail_countdown_seconds',
      desc: '',
      args: [seconds],
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

  /// `Payment Successful`
  String get payResult_success {
    return Intl.message(
      'Payment Successful',
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

  /// `Please use this QR code or ticket code to collect your tickets at the cinema`
  String get payResult_qrCodeTip {
    return Intl.message(
      'Please use this QR code or ticket code to collect your tickets at the cinema',
      name: 'payResult_qrCodeTip',
      desc: '',
      args: [],
    );
  }

  /// `View My Tickets`
  String get payResult_viewMyTickets {
    return Intl.message(
      'View My Tickets',
      name: 'payResult_viewMyTickets',
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

  /// `Click save button to save changes`
  String get userProfile_edit_tip {
    return Intl.message(
      'Click save button to save changes',
      name: 'userProfile_edit_tip',
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

  /// `Add Credit Card`
  String get payment_addCreditCard_title {
    return Intl.message(
      'Add Credit Card',
      name: 'payment_addCreditCard_title',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get payment_addCreditCard_cardNumber {
    return Intl.message(
      'Card Number',
      name: 'payment_addCreditCard_cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter card number`
  String get payment_addCreditCard_cardNumberHint {
    return Intl.message(
      'Enter card number',
      name: 'payment_addCreditCard_cardNumberHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid card number`
  String get payment_addCreditCard_cardNumberError {
    return Intl.message(
      'Please enter a valid card number',
      name: 'payment_addCreditCard_cardNumberError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid card number length`
  String get payment_addCreditCard_cardNumberLength {
    return Intl.message(
      'Invalid card number length',
      name: 'payment_addCreditCard_cardNumberLength',
      desc: '',
      args: [],
    );
  }

  /// `Cardholder Name`
  String get payment_addCreditCard_cardHolderName {
    return Intl.message(
      'Cardholder Name',
      name: 'payment_addCreditCard_cardHolderName',
      desc: '',
      args: [],
    );
  }

  /// `Enter cardholder name`
  String get payment_addCreditCard_cardHolderNameHint {
    return Intl.message(
      'Enter cardholder name',
      name: 'payment_addCreditCard_cardHolderNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter cardholder name`
  String get payment_addCreditCard_cardHolderNameError {
    return Intl.message(
      'Please enter cardholder name',
      name: 'payment_addCreditCard_cardHolderNameError',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get payment_addCreditCard_expiryDate {
    return Intl.message(
      'Expiry Date',
      name: 'payment_addCreditCard_expiryDate',
      desc: '',
      args: [],
    );
  }

  /// `MM/YY`
  String get payment_addCreditCard_expiryDateHint {
    return Intl.message(
      'MM/YY',
      name: 'payment_addCreditCard_expiryDateHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter expiry date`
  String get payment_addCreditCard_expiryDateError {
    return Intl.message(
      'Please enter expiry date',
      name: 'payment_addCreditCard_expiryDateError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid expiry date format`
  String get payment_addCreditCard_expiryDateInvalid {
    return Intl.message(
      'Invalid expiry date format',
      name: 'payment_addCreditCard_expiryDateInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Card has expired`
  String get payment_addCreditCard_expiryDateExpired {
    return Intl.message(
      'Card has expired',
      name: 'payment_addCreditCard_expiryDateExpired',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get payment_addCreditCard_cvv {
    return Intl.message(
      'CVV',
      name: 'payment_addCreditCard_cvv',
      desc: '',
      args: [],
    );
  }

  /// `•••`
  String get payment_addCreditCard_cvvHint {
    return Intl.message(
      '•••',
      name: 'payment_addCreditCard_cvvHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter CVV`
  String get payment_addCreditCard_cvvError {
    return Intl.message(
      'Please enter CVV',
      name: 'payment_addCreditCard_cvvError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid length`
  String get payment_addCreditCard_cvvLength {
    return Intl.message(
      'Invalid length',
      name: 'payment_addCreditCard_cvvLength',
      desc: '',
      args: [],
    );
  }

  /// `Save this credit card`
  String get payment_addCreditCard_saveCard {
    return Intl.message(
      'Save this credit card',
      name: 'payment_addCreditCard_saveCard',
      desc: '',
      args: [],
    );
  }

  /// `Will be saved to your account for future use`
  String get payment_addCreditCard_saveToAccount {
    return Intl.message(
      'Will be saved to your account for future use',
      name: 'payment_addCreditCard_saveToAccount',
      desc: '',
      args: [],
    );
  }

  /// `Use once only, will not be saved`
  String get payment_addCreditCard_useOnce {
    return Intl.message(
      'Use once only, will not be saved',
      name: 'payment_addCreditCard_useOnce',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Add`
  String get payment_addCreditCard_confirmAdd {
    return Intl.message(
      'Confirm Add',
      name: 'payment_addCreditCard_confirmAdd',
      desc: '',
      args: [],
    );
  }

  /// `Credit card saved`
  String get payment_addCreditCard_cardSaved {
    return Intl.message(
      'Credit card saved',
      name: 'payment_addCreditCard_cardSaved',
      desc: '',
      args: [],
    );
  }

  /// `Credit card confirmed`
  String get payment_addCreditCard_cardConfirmed {
    return Intl.message(
      'Credit card confirmed',
      name: 'payment_addCreditCard_cardConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Operation failed, please try again`
  String get payment_addCreditCard_operationFailed {
    return Intl.message(
      'Operation failed, please try again',
      name: 'payment_addCreditCard_operationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Select Credit Card`
  String get payment_selectCreditCard_title {
    return Intl.message(
      'Select Credit Card',
      name: 'payment_selectCreditCard_title',
      desc: '',
      args: [],
    );
  }

  /// `No credit cards`
  String get payment_selectCreditCard_noCreditCard {
    return Intl.message(
      'No credit cards',
      name: 'payment_selectCreditCard_noCreditCard',
      desc: '',
      args: [],
    );
  }

  /// `Please add a credit card`
  String get payment_selectCreditCard_pleaseAddCard {
    return Intl.message(
      'Please add a credit card',
      name: 'payment_selectCreditCard_pleaseAddCard',
      desc: '',
      args: [],
    );
  }

  /// `Temporary card (one-time use)`
  String get payment_selectCreditCard_tempCard {
    return Intl.message(
      'Temporary card (one-time use)',
      name: 'payment_selectCreditCard_tempCard',
      desc: '',
      args: [],
    );
  }

  /// `Exp: {date}`
  String payment_selectCreditCard_expiryDate(Object date) {
    return Intl.message(
      'Exp: $date',
      name: 'payment_selectCreditCard_expiryDate',
      desc: '',
      args: [date],
    );
  }

  /// `Remove temporary card`
  String get payment_selectCreditCard_removeTempCard {
    return Intl.message(
      'Remove temporary card',
      name: 'payment_selectCreditCard_removeTempCard',
      desc: '',
      args: [],
    );
  }

  /// `Temporary card removed`
  String get payment_selectCreditCard_tempCardRemoved {
    return Intl.message(
      'Temporary card removed',
      name: 'payment_selectCreditCard_tempCardRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Add New Credit Card`
  String get payment_selectCreditCard_addNewCard {
    return Intl.message(
      'Add New Credit Card',
      name: 'payment_selectCreditCard_addNewCard',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get payment_selectCreditCard_confirmPayment {
    return Intl.message(
      'Confirm Payment',
      name: 'payment_selectCreditCard_confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Please select a credit card`
  String get payment_selectCreditCard_pleaseSelectCard {
    return Intl.message(
      'Please select a credit card',
      name: 'payment_selectCreditCard_pleaseSelectCard',
      desc: '',
      args: [],
    );
  }

  /// `Payment successful`
  String get payment_selectCreditCard_paymentSuccess {
    return Intl.message(
      'Payment successful',
      name: 'payment_selectCreditCard_paymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed, please try again`
  String get payment_selectCreditCard_paymentFailed {
    return Intl.message(
      'Payment failed, please try again',
      name: 'payment_selectCreditCard_paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load credit card list`
  String get payment_selectCreditCard_loadFailed {
    return Intl.message(
      'Failed to load credit card list',
      name: 'payment_selectCreditCard_loadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Temporary credit card selected`
  String get payment_selectCreditCard_tempCardSelected {
    return Intl.message(
      'Temporary credit card selected',
      name: 'payment_selectCreditCard_tempCardSelected',
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

  /// `No movies showing`
  String get cinemaList_movies_empty {
    return Intl.message(
      'No movies showing',
      name: 'cinemaList_movies_empty',
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

  /// `Forgot Password`
  String get forgotPassword_title {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we will send you a verification code`
  String get forgotPassword_description {
    return Intl.message(
      'Enter your email address and we will send you a verification code',
      name: 'forgotPassword_description',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get forgotPassword_emailAddress {
    return Intl.message(
      'Email Address',
      name: 'forgotPassword_emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get forgotPassword_verificationCode {
    return Intl.message(
      'Verification Code',
      name: 'forgotPassword_verificationCode',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get forgotPassword_newPassword {
    return Intl.message(
      'New Password',
      name: 'forgotPassword_newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Verification Code`
  String get forgotPassword_sendVerificationCode {
    return Intl.message(
      'Send Verification Code',
      name: 'forgotPassword_sendVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get forgotPassword_resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'forgotPassword_resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember your password?`
  String get forgotPassword_rememberPassword {
    return Intl.message(
      'Remember your password?',
      name: 'forgotPassword_rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get forgotPassword_backToLogin {
    return Intl.message(
      'Back to Login',
      name: 'forgotPassword_backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get forgotPassword_emailRequired {
    return Intl.message(
      'Please enter your email',
      name: 'forgotPassword_emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get forgotPassword_emailInvalid {
    return Intl.message(
      'Please enter a valid email address',
      name: 'forgotPassword_emailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter verification code`
  String get forgotPassword_verificationCodeRequired {
    return Intl.message(
      'Please enter verification code',
      name: 'forgotPassword_verificationCodeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your new password`
  String get forgotPassword_newPasswordRequired {
    return Intl.message(
      'Please enter your new password',
      name: 'forgotPassword_newPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get forgotPassword_passwordTooShort {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'forgotPassword_passwordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Verification code has been sent to your email`
  String get forgotPassword_verificationCodeSent {
    return Intl.message(
      'Verification code has been sent to your email',
      name: 'forgotPassword_verificationCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful`
  String get forgotPassword_passwordResetSuccess {
    return Intl.message(
      'Password reset successful',
      name: 'forgotPassword_passwordResetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Presale`
  String get comingSoon_presale {
    return Intl.message(
      'Presale',
      name: 'comingSoon_presale',
      desc: '',
      args: [],
    );
  }

  /// `Release`
  String get comingSoon_releaseDate {
    return Intl.message(
      'Release',
      name: 'comingSoon_releaseDate',
      desc: '',
      args: [],
    );
  }

  /// `No movies currently showing`
  String get comingSoon_noMovies {
    return Intl.message(
      'No movies currently showing',
      name: 'comingSoon_noMovies',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later or pull down to refresh`
  String get comingSoon_tryLaterOrRefresh {
    return Intl.message(
      'Please try again later or pull down to refresh',
      name: 'comingSoon_tryLaterOrRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get comingSoon_pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'comingSoon_pullToRefresh',
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
