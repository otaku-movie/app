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

  /// `No data yet`
  String get search_noData {
    return Intl.message(
      'No data yet',
      name: 'search_noData',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get search_placeholder {
    return Intl.message(
      '',
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

  /// ``
  String get search_removeHistoryConfirm_title {
    return Intl.message(
      '',
      name: 'search_removeHistoryConfirm_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get search_removeHistoryConfirm_content {
    return Intl.message(
      '',
      name: 'search_removeHistoryConfirm_content',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get search_removeHistoryConfirm_confirm {
    return Intl.message(
      '',
      name: 'search_removeHistoryConfirm_confirm',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get search_removeHistoryConfirm_cancel {
    return Intl.message(
      '',
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

  /// ``
  String get showTimeDetail_buy {
    return Intl.message(
      '',
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

  /// ``
  String get cinemaDetail_specialSpecPrice {
    return Intl.message(
      '',
      name: 'cinemaDetail_specialSpecPrice',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cinemaDetail_ticketTypePrice {
    return Intl.message(
      '',
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

  /// ``
  String get cinemaDetail_theaterSpec {
    return Intl.message(
      '',
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

  /// `Send Verification Code`
  String get common_components_sendVerifyCode_send {
    return Intl.message(
      'Send Verification Code',
      name: 'common_components_sendVerifyCode_send',
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

  /// ``
  String get login_password_verify_notNull {
    return Intl.message(
      '',
      name: 'login_password_verify_notNull',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_password_verify_isValid {
    return Intl.message(
      '',
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

  /// ``
  String get login_verificationCode {
    return Intl.message(
      '',
      name: 'login_verificationCode',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get login_sendVerifyCodeButton {
    return Intl.message(
      '',
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

  /// `Email`
  String get register_email {
    return Intl.message(
      'Email',
      name: 'register_email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get register_password {
    return Intl.message(
      'Password',
      name: 'register_password',
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

  /// ``
  String get movieList_placeholder {
    return Intl.message(
      '',
      name: 'movieList_placeholder',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieList_buy {
    return Intl.message(
      '',
      name: 'movieList_buy',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get cinemaList_address {
    return Intl.message(
      '',
      name: 'cinemaList_address',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_button_want {
    return Intl.message(
      '',
      name: 'movieDetail_button_want',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_button_saw {
    return Intl.message(
      '',
      name: 'movieDetail_button_saw',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_button_buy {
    return Intl.message(
      '',
      name: 'movieDetail_button_buy',
      desc: '',
      args: [],
    );
  }

  /// `reply`
  String get movieDetail_comment_reply {
    return Intl.message(
      'reply',
      name: 'movieDetail_comment_reply',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_noDate {
    return Intl.message(
      '',
      name: 'movieDetail_detail_noDate',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_basicMessage {
    return Intl.message(
      '',
      name: 'movieDetail_detail_basicMessage',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_originalName {
    return Intl.message(
      '',
      name: 'movieDetail_detail_originalName',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_time {
    return Intl.message(
      '',
      name: 'movieDetail_detail_time',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_spec {
    return Intl.message(
      '',
      name: 'movieDetail_detail_spec',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_tags {
    return Intl.message(
      '',
      name: 'movieDetail_detail_tags',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_homepage {
    return Intl.message(
      '',
      name: 'movieDetail_detail_homepage',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_state {
    return Intl.message(
      '',
      name: 'movieDetail_detail_state',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_level {
    return Intl.message(
      '',
      name: 'movieDetail_detail_level',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_staff {
    return Intl.message(
      '',
      name: 'movieDetail_detail_staff',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_character {
    return Intl.message(
      '',
      name: 'movieDetail_detail_character',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieDetail_detail_comment {
    return Intl.message(
      '',
      name: 'movieDetail_detail_comment',
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

  /// ``
  String get movieTicketType_title {
    return Intl.message(
      '',
      name: 'movieTicketType_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieTicketType_seatNumber {
    return Intl.message(
      '',
      name: 'movieTicketType_seatNumber',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get movieTicketType_selectMovieTicketType {
    return Intl.message(
      '',
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

  /// ``
  String get confirmOrder_title {
    return Intl.message(
      '',
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

  /// ``
  String get confirmOrder_selectPayMethod {
    return Intl.message(
      '',
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

  /// ``
  String get user_title {
    return Intl.message(
      '',
      name: 'user_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_data_orderCount {
    return Intl.message(
      '',
      name: 'user_data_orderCount',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_data_wantCount {
    return Intl.message(
      '',
      name: 'user_data_wantCount',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_data_characterCount {
    return Intl.message(
      '',
      name: 'user_data_characterCount',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_data_staffCount {
    return Intl.message(
      '',
      name: 'user_data_staffCount',
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

  /// ``
  String get user_editProfile {
    return Intl.message(
      '',
      name: 'user_editProfile',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_privateAgreement {
    return Intl.message(
      '',
      name: 'user_privateAgreement',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_checkUpdate {
    return Intl.message(
      '',
      name: 'user_checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_about {
    return Intl.message(
      '',
      name: 'user_about',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get user_logout {
    return Intl.message(
      '',
      name: 'user_logout',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderList_title {
    return Intl.message(
      '',
      name: 'orderList_title',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderList_orderNumber {
    return Intl.message(
      '',
      name: 'orderList_orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `comment`
  String get orderList_comment {
    return Intl.message(
      'comment',
      name: 'orderList_comment',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_title {
    return Intl.message(
      '',
      name: 'orderDetail_title',
      desc: '',
      args: [],
    );
  }

  /// `Ticket collection code`
  String get orderDetail_ticketCode {
    return Intl.message(
      'Ticket collection code',
      name: 'orderDetail_ticketCode',
      desc: '',
      args: [],
    );
  }

  /// ``
  String orderDetail_ticketCount(int ticketCount) {
    return Intl.message(
      '',
      name: 'orderDetail_ticketCount',
      desc: '',
      args: [ticketCount],
    );
  }

  /// ``
  String get orderDetail_orderNumber {
    return Intl.message(
      '',
      name: 'orderDetail_orderNumber',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_orderState {
    return Intl.message(
      '',
      name: 'orderDetail_orderState',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_orderCreateTime {
    return Intl.message(
      '',
      name: 'orderDetail_orderCreateTime',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_payTime {
    return Intl.message(
      '',
      name: 'orderDetail_payTime',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_payMethod {
    return Intl.message(
      '',
      name: 'orderDetail_payMethod',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_seatMessage {
    return Intl.message(
      '',
      name: 'orderDetail_seatMessage',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get orderDetail_orderMessage {
    return Intl.message(
      '',
      name: 'orderDetail_orderMessage',
      desc: '',
      args: [],
    );
  }

  /// `Pay Succeed`
  String get payResult_title {
    return Intl.message(
      'Pay Succeed',
      name: 'payResult_title',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been paid. Please arrive at the following location before the following time. Enjoy your movie.`
  String get payResult_success {
    return Intl.message(
      'Your order has been paid. Please arrive at the following location before the following time. Enjoy your movie.',
      name: 'payResult_success',
      desc: '',
      args: [],
    );
  }

  /// `Ticket collection code`
  String get payResult_ticketCode {
    return Intl.message(
      'Ticket collection code',
      name: 'payResult_ticketCode',
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
