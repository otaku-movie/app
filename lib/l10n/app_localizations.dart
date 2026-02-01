import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh')
  ];

  /// No description provided for @writeComment_title.
  ///
  /// In en, this message translates to:
  /// **'Write comment'**
  String get writeComment_title;

  /// No description provided for @writeComment_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your comment...'**
  String get writeComment_hint;

  /// No description provided for @writeComment_rateTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate this movie'**
  String get writeComment_rateTitle;

  /// No description provided for @writeComment_contentTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your movie experience'**
  String get writeComment_contentTitle;

  /// No description provided for @writeComment_shareExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help others'**
  String get writeComment_shareExperience;

  /// No description provided for @writeComment_publishFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to publish comment, please try again'**
  String get writeComment_publishFailed;

  /// No description provided for @writeComment_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Comment cannot be empty'**
  String get writeComment_verify_notNull;

  /// No description provided for @writeComment_verify_notRate.
  ///
  /// In en, this message translates to:
  /// **'Please rate the movie'**
  String get writeComment_verify_notRate;

  /// No description provided for @writeComment_verify_movieIdEmpty.
  ///
  /// In en, this message translates to:
  /// **'Movie ID cannot be empty'**
  String get writeComment_verify_movieIdEmpty;

  /// No description provided for @writeComment_release.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get writeComment_release;

  /// No description provided for @search_noData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get search_noData;

  /// No description provided for @search_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search all movies'**
  String get search_placeholder;

  /// No description provided for @search_history.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get search_history;

  /// No description provided for @search_removeHistoryConfirm_title.
  ///
  /// In en, this message translates to:
  /// **'Delete History'**
  String get search_removeHistoryConfirm_title;

  /// No description provided for @search_removeHistoryConfirm_content.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your search history?'**
  String get search_removeHistoryConfirm_content;

  /// No description provided for @search_removeHistoryConfirm_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get search_removeHistoryConfirm_confirm;

  /// No description provided for @search_removeHistoryConfirm_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get search_removeHistoryConfirm_cancel;

  /// No description provided for @search_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get search_level;

  /// No description provided for @showTimeDetail_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get showTimeDetail_address;

  /// No description provided for @showTimeDetail_buy.
  ///
  /// In en, this message translates to:
  /// **'Select Seat'**
  String get showTimeDetail_buy;

  /// No description provided for @showTimeDetail_time.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get showTimeDetail_time;

  /// No description provided for @showTimeDetail_seatStatus_available.
  ///
  /// In en, this message translates to:
  /// **'Seats Available'**
  String get showTimeDetail_seatStatus_available;

  /// No description provided for @showTimeDetail_seatStatus_tight.
  ///
  /// In en, this message translates to:
  /// **'Seats Limited'**
  String get showTimeDetail_seatStatus_tight;

  /// No description provided for @showTimeDetail_seatStatus_soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get showTimeDetail_seatStatus_soldOut;

  /// No description provided for @cinemaDetail_tel.
  ///
  /// In en, this message translates to:
  /// **'TEL'**
  String get cinemaDetail_tel;

  /// No description provided for @cinemaDetail_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get cinemaDetail_address;

  /// No description provided for @cinemaDetail_homepage.
  ///
  /// In en, this message translates to:
  /// **'WebSite'**
  String get cinemaDetail_homepage;

  /// No description provided for @cinemaDetail_showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get cinemaDetail_showing;

  /// No description provided for @cinemaDetail_specialSpecPrice.
  ///
  /// In en, this message translates to:
  /// **'Special Screening Price'**
  String get cinemaDetail_specialSpecPrice;

  /// No description provided for @cinemaDetail_ticketTypePrice.
  ///
  /// In en, this message translates to:
  /// **'Standard Ticket Price'**
  String get cinemaDetail_ticketTypePrice;

  /// No description provided for @cinemaDetail_maxSelectSeat.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of available seats'**
  String get cinemaDetail_maxSelectSeat;

  /// No description provided for @cinemaDetail_theaterSpec.
  ///
  /// In en, this message translates to:
  /// **'Theater Info'**
  String get cinemaDetail_theaterSpec;

  /// No description provided for @cinemaDetail_seatCount.
  ///
  /// In en, this message translates to:
  /// **'{seatCount} seats'**
  String cinemaDetail_seatCount(int seatCount);

  /// No description provided for @selectSeat_maxSelectSeatWarn.
  ///
  /// In en, this message translates to:
  /// **'A maximum of {maxSeat} seats can be selected'**
  String selectSeat_maxSelectSeatWarn(int maxSeat);

  /// No description provided for @selectSeat_confirmSelectSeat.
  ///
  /// In en, this message translates to:
  /// **'Confirm Seat Selection'**
  String get selectSeat_confirmSelectSeat;

  /// No description provided for @selectSeat_notSelectSeatWarn.
  ///
  /// In en, this message translates to:
  /// **'Please select a seat'**
  String get selectSeat_notSelectSeatWarn;

  /// No description provided for @home_home.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home_home;

  /// No description provided for @home_ticket.
  ///
  /// In en, this message translates to:
  /// **'My Ticket'**
  String get home_ticket;

  /// No description provided for @home_cinema.
  ///
  /// In en, this message translates to:
  /// **'cinema'**
  String get home_cinema;

  /// No description provided for @home_me.
  ///
  /// In en, this message translates to:
  /// **'my page'**
  String get home_me;

  /// No description provided for @ticket_showTime.
  ///
  /// In en, this message translates to:
  /// **'Show Time'**
  String get ticket_showTime;

  /// No description provided for @ticket_endTime.
  ///
  /// In en, this message translates to:
  /// **'Expected End Time'**
  String get ticket_endTime;

  /// No description provided for @ticket_seatCount.
  ///
  /// In en, this message translates to:
  /// **'Seat Count'**
  String get ticket_seatCount;

  /// No description provided for @ticket_noData.
  ///
  /// In en, this message translates to:
  /// **'No ticket yet'**
  String get ticket_noData;

  /// No description provided for @ticket_noDataTip.
  ///
  /// In en, this message translates to:
  /// **'Buy tickets now!'**
  String get ticket_noDataTip;

  /// No description provided for @ticket_status_valid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get ticket_status_valid;

  /// No description provided for @ticket_status_used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get ticket_status_used;

  /// No description provided for @ticket_status_expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get ticket_status_expired;

  /// No description provided for @ticket_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get ticket_status_cancelled;

  /// No description provided for @ticket_time_unknown.
  ///
  /// In en, this message translates to:
  /// **'Time unknown'**
  String get ticket_time_unknown;

  /// No description provided for @ticket_time_formatError.
  ///
  /// In en, this message translates to:
  /// **'Time format error'**
  String get ticket_time_formatError;

  /// No description provided for @ticket_time_remaining_days.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String ticket_time_remaining_days(Object days);

  /// No description provided for @ticket_time_remaining_hours.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours left'**
  String ticket_time_remaining_hours(Object hours);

  /// No description provided for @ticket_time_remaining_minutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes left'**
  String ticket_time_remaining_minutes(Object minutes);

  /// No description provided for @ticket_time_remaining_soon.
  ///
  /// In en, this message translates to:
  /// **'Starting soon'**
  String get ticket_time_remaining_soon;

  /// No description provided for @ticket_time_weekdays_monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get ticket_time_weekdays_monday;

  /// No description provided for @ticket_time_weekdays_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get ticket_time_weekdays_tuesday;

  /// No description provided for @ticket_time_weekdays_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get ticket_time_weekdays_wednesday;

  /// No description provided for @ticket_time_weekdays_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get ticket_time_weekdays_thursday;

  /// No description provided for @ticket_time_weekdays_friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get ticket_time_weekdays_friday;

  /// No description provided for @ticket_time_weekdays_saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get ticket_time_weekdays_saturday;

  /// No description provided for @ticket_time_weekdays_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get ticket_time_weekdays_sunday;

  /// No description provided for @ticket_ticketCount.
  ///
  /// In en, this message translates to:
  /// **'Ticket Count'**
  String get ticket_ticketCount;

  /// No description provided for @ticket_totalPurchased.
  ///
  /// In en, this message translates to:
  /// **'Total Purchased'**
  String get ticket_totalPurchased;

  /// No description provided for @ticket_tickets.
  ///
  /// In en, this message translates to:
  /// **' tickets'**
  String get ticket_tickets;

  /// No description provided for @ticket_tapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get ticket_tapToView;

  /// No description provided for @ticket_buyTickets.
  ///
  /// In en, this message translates to:
  /// **'Buy Tickets'**
  String get ticket_buyTickets;

  /// No description provided for @ticket_shareTicket.
  ///
  /// In en, this message translates to:
  /// **'Share movie ticket: {movieName}'**
  String ticket_shareTicket(Object movieName);

  /// No description provided for @common_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_loading;

  /// No description provided for @common_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get common_error_title;

  /// No description provided for @common_error_message.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data, please try again later'**
  String get common_error_message;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_network_error_connectionRefused.
  ///
  /// In en, this message translates to:
  /// **'Server connection refused, please try again later'**
  String get common_network_error_connectionRefused;

  /// No description provided for @common_network_error_noRouteToHost.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to server, please check network connection'**
  String get common_network_error_noRouteToHost;

  /// No description provided for @common_network_error_connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout, please check network or try again later'**
  String get common_network_error_connectionTimeout;

  /// No description provided for @common_network_error_networkUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Network unreachable, please check network settings'**
  String get common_network_error_networkUnreachable;

  /// No description provided for @common_network_error_hostLookupFailed.
  ///
  /// In en, this message translates to:
  /// **'Cannot resolve server address, please check network settings'**
  String get common_network_error_hostLookupFailed;

  /// No description provided for @common_network_error_sendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout, please try again later'**
  String get common_network_error_sendTimeout;

  /// No description provided for @common_network_error_receiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Response timeout, please try again later'**
  String get common_network_error_receiveTimeout;

  /// No description provided for @common_network_error_connectionError.
  ///
  /// In en, this message translates to:
  /// **'Network connection error, please check network settings'**
  String get common_network_error_connectionError;

  /// No description provided for @common_network_error_default.
  ///
  /// In en, this message translates to:
  /// **'Network request failed, please try again later'**
  String get common_network_error_default;

  /// No description provided for @common_unit_jpy.
  ///
  /// In en, this message translates to:
  /// **'JPY'**
  String get common_unit_jpy;

  /// No description provided for @common_unit_meter.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get common_unit_meter;

  /// No description provided for @common_unit_kilometer.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get common_unit_kilometer;

  /// No description provided for @common_unit_point.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get common_unit_point;

  /// No description provided for @common_components_cropper_title.
  ///
  /// In en, this message translates to:
  /// **'Crop the picture'**
  String get common_components_cropper_title;

  /// No description provided for @common_components_cropper_actions_rotateLeft.
  ///
  /// In en, this message translates to:
  /// **'Rotate Left'**
  String get common_components_cropper_actions_rotateLeft;

  /// No description provided for @common_components_cropper_actions_rotateRight.
  ///
  /// In en, this message translates to:
  /// **'Rotate Right'**
  String get common_components_cropper_actions_rotateRight;

  /// No description provided for @common_components_cropper_actions_flip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get common_components_cropper_actions_flip;

  /// No description provided for @common_components_cropper_actions_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get common_components_cropper_actions_undo;

  /// No description provided for @common_components_cropper_actions_redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get common_components_cropper_actions_redo;

  /// No description provided for @common_components_cropper_actions_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get common_components_cropper_actions_reset;

  /// No description provided for @common_components_easyRefresh_refresh_dragText.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get common_components_easyRefresh_refresh_dragText;

  /// No description provided for @common_components_easyRefresh_refresh_armedText.
  ///
  /// In en, this message translates to:
  /// **'Release to refresh'**
  String get common_components_easyRefresh_refresh_armedText;

  /// No description provided for @common_components_easyRefresh_refresh_readyText.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get common_components_easyRefresh_refresh_readyText;

  /// No description provided for @common_components_easyRefresh_refresh_processingText.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get common_components_easyRefresh_refresh_processingText;

  /// No description provided for @common_components_easyRefresh_refresh_processedText.
  ///
  /// In en, this message translates to:
  /// **'Refresh complete'**
  String get common_components_easyRefresh_refresh_processedText;

  /// No description provided for @common_components_easyRefresh_refresh_failedText.
  ///
  /// In en, this message translates to:
  /// **'Refresh failed'**
  String get common_components_easyRefresh_refresh_failedText;

  /// No description provided for @common_components_easyRefresh_refresh_noMoreText.
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get common_components_easyRefresh_refresh_noMoreText;

  /// No description provided for @common_components_easyRefresh_loadMore_dragText.
  ///
  /// In en, this message translates to:
  /// **'Pull to load more'**
  String get common_components_easyRefresh_loadMore_dragText;

  /// No description provided for @common_components_easyRefresh_loadMore_armedText.
  ///
  /// In en, this message translates to:
  /// **'Release to load more'**
  String get common_components_easyRefresh_loadMore_armedText;

  /// No description provided for @common_components_easyRefresh_loadMore_readyText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_components_easyRefresh_loadMore_readyText;

  /// No description provided for @common_components_easyRefresh_loadMore_processingText.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get common_components_easyRefresh_loadMore_processingText;

  /// No description provided for @common_components_easyRefresh_loadMore_processedText.
  ///
  /// In en, this message translates to:
  /// **'Load complete'**
  String get common_components_easyRefresh_loadMore_processedText;

  /// No description provided for @common_components_easyRefresh_loadMore_failedText.
  ///
  /// In en, this message translates to:
  /// **'Load failed'**
  String get common_components_easyRefresh_loadMore_failedText;

  /// No description provided for @common_components_easyRefresh_loadMore_noMoreText.
  ///
  /// In en, this message translates to:
  /// **'No more data'**
  String get common_components_easyRefresh_loadMore_noMoreText;

  /// No description provided for @common_components_sendVerifyCode_success.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get common_components_sendVerifyCode_success;

  /// No description provided for @common_components_filterBar_pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get common_components_filterBar_pleaseSelect;

  /// No description provided for @common_components_filterBar_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get common_components_filterBar_reset;

  /// No description provided for @common_components_filterBar_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get common_components_filterBar_confirm;

  /// No description provided for @common_components_filterBar_allDay.
  ///
  /// In en, this message translates to:
  /// **'All Day'**
  String get common_components_filterBar_allDay;

  /// No description provided for @common_components_filterBar_noData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get common_components_filterBar_noData;

  /// No description provided for @common_week_monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get common_week_monday;

  /// No description provided for @common_week_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get common_week_tuesday;

  /// No description provided for @common_week_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get common_week_wednesday;

  /// No description provided for @common_week_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get common_week_thursday;

  /// No description provided for @common_week_friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get common_week_friday;

  /// No description provided for @common_week_saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get common_week_saturday;

  /// No description provided for @common_week_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get common_week_sunday;

  /// No description provided for @common_enum_seatType_wheelChair.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair'**
  String get common_enum_seatType_wheelChair;

  /// No description provided for @common_enum_seatType_coupleSeat.
  ///
  /// In en, this message translates to:
  /// **'Couple Seat'**
  String get common_enum_seatType_coupleSeat;

  /// No description provided for @common_enum_seatType_locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get common_enum_seatType_locked;

  /// No description provided for @common_enum_seatType_sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get common_enum_seatType_sold;

  /// No description provided for @about_title.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about_title;

  /// No description provided for @about_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get about_version;

  /// No description provided for @about_description.
  ///
  /// In en, this message translates to:
  /// **'Committed to providing convenient ticket purchasing experience for movie enthusiasts.'**
  String get about_description;

  /// No description provided for @about_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'View Privacy Policy'**
  String get about_privacy_policy;

  /// No description provided for @about_copyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Otaku Movie All Rights Reserved'**
  String get about_copyright;

  /// No description provided for @about_components_sendVerifyCode_success.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get about_components_sendVerifyCode_success;

  /// No description provided for @about_components_filterBar_pleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get about_components_filterBar_pleaseSelect;

  /// No description provided for @about_components_filterBar_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get about_components_filterBar_reset;

  /// No description provided for @about_components_filterBar_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get about_components_filterBar_confirm;

  /// No description provided for @about_components_showTimeList_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get about_components_showTimeList_all;

  /// No description provided for @about_components_showTimeList_unnamed.
  ///
  /// In en, this message translates to:
  /// **'Unnamed'**
  String get about_components_showTimeList_unnamed;

  /// No description provided for @about_components_showTimeList_noData.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get about_components_showTimeList_noData;

  /// No description provided for @about_components_showTimeList_noShowTimeInfo.
  ///
  /// In en, this message translates to:
  /// **'No showtime information'**
  String get about_components_showTimeList_noShowTimeInfo;

  /// No description provided for @about_components_showTimeList_moreShowTimes.
  ///
  /// In en, this message translates to:
  /// **'There are {count} more showtimes...'**
  String about_components_showTimeList_moreShowTimes(Object count);

  /// No description provided for @about_components_showTimeList_timeRange.
  ///
  /// In en, this message translates to:
  /// **'Show Time'**
  String get about_components_showTimeList_timeRange;

  /// No description provided for @about_components_showTimeList_dubbingVersion.
  ///
  /// In en, this message translates to:
  /// **'Dubbed Version'**
  String get about_components_showTimeList_dubbingVersion;

  /// No description provided for @about_components_showTimeList_seatStatus_soldOut.
  ///
  /// In en, this message translates to:
  /// **'Sold Out'**
  String get about_components_showTimeList_seatStatus_soldOut;

  /// No description provided for @about_components_showTimeList_seatStatus_limited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get about_components_showTimeList_seatStatus_limited;

  /// No description provided for @about_components_showTimeList_seatStatus_available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get about_components_showTimeList_seatStatus_available;

  /// No description provided for @about_login_verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get about_login_verificationCode;

  /// No description provided for @about_login_email_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get about_login_email_verify_notNull;

  /// No description provided for @about_login_email_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get about_login_email_verify_isValid;

  /// No description provided for @about_login_email_text.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get about_login_email_text;

  /// No description provided for @about_login_password_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get about_login_password_verify_notNull;

  /// No description provided for @about_login_password_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get about_login_password_verify_isValid;

  /// No description provided for @about_login_password_text.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get about_login_password_text;

  /// No description provided for @about_login_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get about_login_loginButton;

  /// No description provided for @about_login_welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get about_login_welcomeText;

  /// No description provided for @about_login_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get about_login_forgotPassword;

  /// No description provided for @about_login_or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get about_login_or;

  /// No description provided for @about_login_googleLogin.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get about_login_googleLogin;

  /// No description provided for @about_login_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get about_login_noAccount;

  /// No description provided for @about_register_registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get about_register_registerButton;

  /// No description provided for @about_register_username_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get about_register_username_verify_notNull;

  /// No description provided for @about_register_username_text.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get about_register_username_text;

  /// No description provided for @about_register_repeatPassword_text.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get about_register_repeatPassword_text;

  /// No description provided for @about_register_passwordNotMatchRepeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get about_register_passwordNotMatchRepeatPassword;

  /// No description provided for @about_register_verifyCode_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code format'**
  String get about_register_verifyCode_verify_isValid;

  /// No description provided for @about_register_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get about_register_send;

  /// No description provided for @about_register_haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get about_register_haveAccount;

  /// No description provided for @about_register_loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get about_register_loginHere;

  /// No description provided for @about_movieShowList_dropdown_area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get about_movieShowList_dropdown_area;

  /// No description provided for @about_movieShowList_dropdown_screenSpec.
  ///
  /// In en, this message translates to:
  /// **'Screen Spec'**
  String get about_movieShowList_dropdown_screenSpec;

  /// No description provided for @about_movieShowList_dropdown_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get about_movieShowList_dropdown_subtitle;

  /// No description provided for @about_movieShowList_dropdown_tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get about_movieShowList_dropdown_tag;

  /// No description provided for @about_movieShowList_dropdown_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get about_movieShowList_dropdown_version;

  /// No description provided for @about_movieShowList_dropdown_dimensionType.
  ///
  /// In en, this message translates to:
  /// **'2D/3D'**
  String get about_movieShowList_dropdown_dimensionType;

  /// No description provided for @enum_seatType_coupleSeat.
  ///
  /// In en, this message translates to:
  /// **'Couple Seat'**
  String get enum_seatType_coupleSeat;

  /// No description provided for @enum_seatType_wheelChair.
  ///
  /// In en, this message translates to:
  /// **'Wheelchair Seat'**
  String get enum_seatType_wheelChair;

  /// No description provided for @enum_seatType_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get enum_seatType_disabled;

  /// No description provided for @enum_seatType_selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get enum_seatType_selected;

  /// No description provided for @enum_seatType_locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get enum_seatType_locked;

  /// No description provided for @enum_seatType_sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get enum_seatType_sold;

  /// No description provided for @unit_point.
  ///
  /// In en, this message translates to:
  /// **'point'**
  String get unit_point;

  /// No description provided for @unit_jpy.
  ///
  /// In en, this message translates to:
  /// **'JPY'**
  String get unit_jpy;

  /// No description provided for @login_email_text.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get login_email_text;

  /// No description provided for @login_email_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get login_email_verify_notNull;

  /// No description provided for @login_email_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get login_email_verify_isValid;

  /// No description provided for @login_password_text.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password_text;

  /// No description provided for @login_password_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get login_password_verify_notNull;

  /// No description provided for @login_password_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8-16 characters with letters, numbers, and underscores'**
  String get login_password_verify_isValid;

  /// No description provided for @login_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_loginButton;

  /// No description provided for @login_welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, please log in to your account'**
  String get login_welcomeText;

  /// No description provided for @login_or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get login_or;

  /// No description provided for @login_googleLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get login_googleLogin;

  /// No description provided for @login_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get login_forgotPassword;

  /// No description provided for @login_forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get login_forgotPasswordTitle;

  /// No description provided for @login_forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a verification code'**
  String get login_forgotPasswordDescription;

  /// No description provided for @login_emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get login_emailAddress;

  /// No description provided for @login_newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get login_newPassword;

  /// No description provided for @login_sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get login_sendVerificationCode;

  /// No description provided for @login_resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get login_resetPassword;

  /// No description provided for @login_rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get login_rememberPassword;

  /// No description provided for @login_backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get login_backToLogin;

  /// No description provided for @login_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get login_emailRequired;

  /// No description provided for @login_emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get login_emailInvalid;

  /// No description provided for @login_verificationCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get login_verificationCodeRequired;

  /// No description provided for @login_newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get login_newPasswordRequired;

  /// No description provided for @login_passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get login_passwordTooShort;

  /// No description provided for @login_verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code has been sent to your email'**
  String get login_verificationCodeSent;

  /// No description provided for @login_passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get login_passwordResetSuccess;

  /// No description provided for @login_verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get login_verificationCode;

  /// No description provided for @login_sendVerifyCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get login_sendVerifyCodeButton;

  /// No description provided for @login_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_noAccount;

  /// No description provided for @register_repeatPassword_text.
  ///
  /// In en, this message translates to:
  /// **'Repeat Password'**
  String get register_repeatPassword_text;

  /// No description provided for @register_repeatPassword_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Repeat password cannot be empty'**
  String get register_repeatPassword_verify_notNull;

  /// No description provided for @register_repeatPassword_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Repeat password must be 8-16 characters with letters, numbers, and underscores'**
  String get register_repeatPassword_verify_isValid;

  /// No description provided for @register_username_text.
  ///
  /// In en, this message translates to:
  /// **'UserName'**
  String get register_username_text;

  /// No description provided for @register_username_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get register_username_verify_notNull;

  /// No description provided for @register_passwordNotMatchRepeatPassword.
  ///
  /// In en, this message translates to:
  /// **'The passwords you entered twice do not match'**
  String get register_passwordNotMatchRepeatPassword;

  /// No description provided for @register_verifyCode_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Verification code cannot be empty'**
  String get register_verifyCode_verify_notNull;

  /// No description provided for @register_verifyCode_verify_isValid.
  ///
  /// In en, this message translates to:
  /// **'Verification code must be 6 digits'**
  String get register_verifyCode_verify_isValid;

  /// No description provided for @register_registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_registerButton;

  /// No description provided for @register_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get register_send;

  /// No description provided for @register_haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get register_haveAccount;

  /// No description provided for @register_loginHere.
  ///
  /// In en, this message translates to:
  /// **'Click Here'**
  String get register_loginHere;

  /// No description provided for @movieList_tabBar_currentlyShowing.
  ///
  /// In en, this message translates to:
  /// **'Currently Showing'**
  String get movieList_tabBar_currentlyShowing;

  /// No description provided for @movieList_tabBar_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get movieList_tabBar_comingSoon;

  /// No description provided for @movieList_currentlyShowing_level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get movieList_currentlyShowing_level;

  /// No description provided for @movieList_comingSoon_noDate.
  ///
  /// In en, this message translates to:
  /// **'Date TBD'**
  String get movieList_comingSoon_noDate;

  /// No description provided for @movieList_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search all movies'**
  String get movieList_placeholder;

  /// No description provided for @movieList_buy.
  ///
  /// In en, this message translates to:
  /// **'Buy Ticket'**
  String get movieList_buy;

  /// No description provided for @movieDetail_button_want.
  ///
  /// In en, this message translates to:
  /// **'Want to Watch'**
  String get movieDetail_button_want;

  /// No description provided for @movieDetail_button_saw.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get movieDetail_button_saw;

  /// No description provided for @movieDetail_button_buy.
  ///
  /// In en, this message translates to:
  /// **'Buy Ticket'**
  String get movieDetail_button_buy;

  /// No description provided for @movieDetail_comment_reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get movieDetail_comment_reply;

  /// No description provided for @movieDetail_comment_replyTo.
  ///
  /// In en, this message translates to:
  /// **'Reply to {reply}'**
  String movieDetail_comment_replyTo(String reply);

  /// No description provided for @movieDetail_comment_translate.
  ///
  /// In en, this message translates to:
  /// **'Translate to {language}'**
  String movieDetail_comment_translate(String language);

  /// No description provided for @movieDetail_comment_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get movieDetail_comment_delete;

  /// No description provided for @movieDetail_writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write Comment'**
  String get movieDetail_writeComment;

  /// No description provided for @movieDetail_detail_noDate.
  ///
  /// In en, this message translates to:
  /// **'Release date TBD'**
  String get movieDetail_detail_noDate;

  /// No description provided for @movieDetail_detail_basicMessage.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get movieDetail_detail_basicMessage;

  /// No description provided for @movieDetail_detail_originalName.
  ///
  /// In en, this message translates to:
  /// **'Original Title'**
  String get movieDetail_detail_originalName;

  /// No description provided for @movieDetail_detail_time.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get movieDetail_detail_time;

  /// No description provided for @movieDetail_detail_spec.
  ///
  /// In en, this message translates to:
  /// **'Screening Spec'**
  String get movieDetail_detail_spec;

  /// No description provided for @movieDetail_detail_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get movieDetail_detail_tags;

  /// No description provided for @movieDetail_detail_homepage.
  ///
  /// In en, this message translates to:
  /// **'Official Website'**
  String get movieDetail_detail_homepage;

  /// No description provided for @movieDetail_detail_state.
  ///
  /// In en, this message translates to:
  /// **'Screening Status'**
  String get movieDetail_detail_state;

  /// No description provided for @movieDetail_detail_level.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get movieDetail_detail_level;

  /// No description provided for @movieDetail_detail_staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get movieDetail_detail_staff;

  /// No description provided for @movieDetail_detail_character.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get movieDetail_detail_character;

  /// No description provided for @movieDetail_detail_comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get movieDetail_detail_comment;

  /// No description provided for @movieDetail_detail_duration_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get movieDetail_detail_duration_unknown;

  /// No description provided for @movieDetail_detail_duration_minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get movieDetail_detail_duration_minutes;

  /// No description provided for @movieDetail_detail_duration_hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get movieDetail_detail_duration_hours;

  /// No description provided for @movieDetail_detail_duration_hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String movieDetail_detail_duration_hoursMinutes(int hours, int minutes);

  /// No description provided for @movieDetail_detail_totalReplyMessage.
  ///
  /// In en, this message translates to:
  /// **'Total {total} replies'**
  String movieDetail_detail_totalReplyMessage(int total);

  /// No description provided for @commentDetail_title.
  ///
  /// In en, this message translates to:
  /// **'Comment Detail'**
  String get commentDetail_title;

  /// No description provided for @commentDetail_replyComment.
  ///
  /// In en, this message translates to:
  /// **'Comment Reply'**
  String get commentDetail_replyComment;

  /// No description provided for @commentDetail_totalReplyMessage.
  ///
  /// In en, this message translates to:
  /// **'Total {total} replies'**
  String commentDetail_totalReplyMessage(int total);

  /// No description provided for @commentDetail_comment_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Reply to {reply}'**
  String commentDetail_comment_placeholder(String reply);

  /// No description provided for @commentDetail_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your reply...'**
  String get commentDetail_comment_hint;

  /// No description provided for @commentDetail_comment_button.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get commentDetail_comment_button;

  /// No description provided for @movieTicketType_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get movieTicketType_total;

  /// No description provided for @movieTicketType_title.
  ///
  /// In en, this message translates to:
  /// **'Select Movie Ticket Type'**
  String get movieTicketType_title;

  /// No description provided for @movieTicketType_seatNumber.
  ///
  /// In en, this message translates to:
  /// **'Seat Number'**
  String get movieTicketType_seatNumber;

  /// No description provided for @movieTicketType_selectMovieTicketType.
  ///
  /// In en, this message translates to:
  /// **'Please select a movie ticket type'**
  String get movieTicketType_selectMovieTicketType;

  /// No description provided for @movieTicketType_confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get movieTicketType_confirmOrder;

  /// No description provided for @movieTicketType_selectTicketTypeForSeats.
  ///
  /// In en, this message translates to:
  /// **'Please select appropriate ticket type for each seat'**
  String get movieTicketType_selectTicketTypeForSeats;

  /// No description provided for @movieTicketType_movieInfo.
  ///
  /// In en, this message translates to:
  /// **'Movie Info'**
  String get movieTicketType_movieInfo;

  /// No description provided for @movieTicketType_showTime.
  ///
  /// In en, this message translates to:
  /// **'Show Time'**
  String get movieTicketType_showTime;

  /// No description provided for @movieTicketType_cinema.
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get movieTicketType_cinema;

  /// No description provided for @movieTicketType_seatInfo.
  ///
  /// In en, this message translates to:
  /// **'Seat Information'**
  String get movieTicketType_seatInfo;

  /// No description provided for @movieTicketType_ticketType.
  ///
  /// In en, this message translates to:
  /// **'Ticket Type'**
  String get movieTicketType_ticketType;

  /// No description provided for @movieTicketType_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get movieTicketType_price;

  /// No description provided for @movieTicketType_selectTicketType.
  ///
  /// In en, this message translates to:
  /// **'Select Ticket Type'**
  String get movieTicketType_selectTicketType;

  /// No description provided for @movieTicketType_totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get movieTicketType_totalPrice;

  /// No description provided for @movieTicketType_singleSeatPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per seat'**
  String get movieTicketType_singleSeatPrice;

  /// No description provided for @movieTicketType_seatCountLabel.
  ///
  /// In en, this message translates to:
  /// **' seats'**
  String get movieTicketType_seatCountLabel;

  /// No description provided for @movieTicketType_priceRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Calculation'**
  String get movieTicketType_priceRuleTitle;

  /// No description provided for @movieTicketType_priceRuleFormula.
  ///
  /// In en, this message translates to:
  /// **'Price per seat = Area price + Ticket type price + Spec surcharge (e.g. 3D, IMAX; 2D has none)'**
  String get movieTicketType_priceRuleFormula;

  /// No description provided for @movieTicketType_actualPrice.
  ///
  /// In en, this message translates to:
  /// **'Actual Payment'**
  String get movieTicketType_actualPrice;

  /// No description provided for @seatCancel_confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Seat Selection'**
  String get seatCancel_confirmTitle;

  /// No description provided for @seatCancel_confirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You have selected seats. Are you sure you want to cancel the selected seats?'**
  String get seatCancel_confirmMessage;

  /// No description provided for @seatCancel_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get seatCancel_cancel;

  /// No description provided for @seatCancel_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get seatCancel_confirm;

  /// No description provided for @seatCancel_successMessage.
  ///
  /// In en, this message translates to:
  /// **'Seat selection has been cancelled'**
  String get seatCancel_successMessage;

  /// No description provided for @seatCancel_errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel seat selection, please try again'**
  String get seatCancel_errorMessage;

  /// No description provided for @confirmOrder_noSpec.
  ///
  /// In en, this message translates to:
  /// **'No spec info'**
  String get confirmOrder_noSpec;

  /// No description provided for @confirmOrder_payFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed, please try again'**
  String get confirmOrder_payFailed;

  /// No description provided for @confirmOrder_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder_title;

  /// No description provided for @confirmOrder_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get confirmOrder_total;

  /// No description provided for @confirmOrder_selectPayMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get confirmOrder_selectPayMethod;

  /// No description provided for @confirmOrder_pay.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get confirmOrder_pay;

  /// No description provided for @confirmOrder_selectedSeats.
  ///
  /// In en, this message translates to:
  /// **'Selected Seats'**
  String get confirmOrder_selectedSeats;

  /// No description provided for @confirmOrder_seatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} seats'**
  String confirmOrder_seatCount(int count);

  /// No description provided for @confirmOrder_timeInfo.
  ///
  /// In en, this message translates to:
  /// **'Time Information'**
  String get confirmOrder_timeInfo;

  /// No description provided for @confirmOrder_cinemaInfo.
  ///
  /// In en, this message translates to:
  /// **'Cinema Information'**
  String get confirmOrder_cinemaInfo;

  /// No description provided for @confirmOrder_countdown.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get confirmOrder_countdown;

  /// No description provided for @confirmOrder_cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get confirmOrder_cancelOrder;

  /// No description provided for @confirmOrder_cancelOrderConfirm.
  ///
  /// In en, this message translates to:
  /// **'You have selected seats. Are you sure you want to cancel the order and release the selected seats?'**
  String get confirmOrder_cancelOrderConfirm;

  /// No description provided for @confirmOrder_continuePay.
  ///
  /// In en, this message translates to:
  /// **'Continue Payment'**
  String get confirmOrder_continuePay;

  /// No description provided for @confirmOrder_confirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancel'**
  String get confirmOrder_confirmCancel;

  /// No description provided for @confirmOrder_orderCanceled.
  ///
  /// In en, this message translates to:
  /// **'Order Canceled'**
  String get confirmOrder_orderCanceled;

  /// No description provided for @confirmOrder_cancelOrderFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order, please try again'**
  String get confirmOrder_cancelOrderFailed;

  /// No description provided for @confirmOrder_orderTimeout.
  ///
  /// In en, this message translates to:
  /// **'Processing order timeout...'**
  String get confirmOrder_orderTimeout;

  /// No description provided for @confirmOrder_orderTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Order has timed out and been automatically canceled'**
  String get confirmOrder_orderTimeoutMessage;

  /// No description provided for @confirmOrder_timeoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to process order timeout, please try again'**
  String get confirmOrder_timeoutFailed;

  /// No description provided for @seatSelection_cancelSeatTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Seat Selection'**
  String get seatSelection_cancelSeatTitle;

  /// No description provided for @seatSelection_cancelSeatConfirm.
  ///
  /// In en, this message translates to:
  /// **'You have selected seats. Are you sure you want to cancel the selected seats?'**
  String get seatSelection_cancelSeatConfirm;

  /// No description provided for @seatSelection_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get seatSelection_cancel;

  /// No description provided for @seatSelection_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get seatSelection_confirm;

  /// No description provided for @seatSelection_seatCanceled.
  ///
  /// In en, this message translates to:
  /// **'Selected seats have been canceled'**
  String get seatSelection_seatCanceled;

  /// No description provided for @seatSelection_cancelSeatFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel seat selection, please try again'**
  String get seatSelection_cancelSeatFailed;

  /// No description provided for @seatSelection_hasLockedOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Unpaid Order'**
  String get seatSelection_hasLockedOrderTitle;

  /// No description provided for @seatSelection_hasLockedOrderMessage.
  ///
  /// In en, this message translates to:
  /// **'You have an unpaid order. Please complete payment first.'**
  String get seatSelection_hasLockedOrderMessage;

  /// No description provided for @seatSelection_goToPay.
  ///
  /// In en, this message translates to:
  /// **'Go to Pay'**
  String get seatSelection_goToPay;

  /// No description provided for @seatSelection_later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get seatSelection_later;

  /// No description provided for @user_title.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get user_title;

  /// No description provided for @user_data_orderCount.
  ///
  /// In en, this message translates to:
  /// **'Order Count'**
  String get user_data_orderCount;

  /// No description provided for @user_data_watchHistory.
  ///
  /// In en, this message translates to:
  /// **'Watch History'**
  String get user_data_watchHistory;

  /// No description provided for @user_data_wantCount.
  ///
  /// In en, this message translates to:
  /// **'Want to Watch Count'**
  String get user_data_wantCount;

  /// No description provided for @user_data_characterCount.
  ///
  /// In en, this message translates to:
  /// **'Character Count'**
  String get user_data_characterCount;

  /// No description provided for @user_data_staffCount.
  ///
  /// In en, this message translates to:
  /// **'Staff Count'**
  String get user_data_staffCount;

  /// No description provided for @user_registerTime.
  ///
  /// In en, this message translates to:
  /// **'Registration Time'**
  String get user_registerTime;

  /// No description provided for @user_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get user_language;

  /// No description provided for @user_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get user_editProfile;

  /// No description provided for @user_privateAgreement.
  ///
  /// In en, this message translates to:
  /// **'Privacy Agreement'**
  String get user_privateAgreement;

  /// No description provided for @user_checkUpdate.
  ///
  /// In en, this message translates to:
  /// **'Check Update'**
  String get user_checkUpdate;

  /// No description provided for @user_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get user_about;

  /// No description provided for @user_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get user_logout;

  /// No description provided for @user_currentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get user_currentVersion;

  /// No description provided for @user_latestVersion.
  ///
  /// In en, this message translates to:
  /// **'Latest Version'**
  String get user_latestVersion;

  /// No description provided for @user_updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version found. Update now?'**
  String get user_updateAvailable;

  /// No description provided for @user_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get user_cancel;

  /// No description provided for @user_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get user_update;

  /// No description provided for @user_updating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get user_updating;

  /// No description provided for @user_updateProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading update, please wait...'**
  String get user_updateProgress;

  /// No description provided for @user_updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update Successful'**
  String get user_updateSuccess;

  /// No description provided for @user_updateSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'App has been successfully updated to the latest version!'**
  String get user_updateSuccessMessage;

  /// No description provided for @user_updateError.
  ///
  /// In en, this message translates to:
  /// **'Update Failed'**
  String get user_updateError;

  /// No description provided for @user_updateErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during update. Please try again later.'**
  String get user_updateErrorMessage;

  /// No description provided for @user_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get user_ok;

  /// No description provided for @orderList_title.
  ///
  /// In en, this message translates to:
  /// **'Order List'**
  String get orderList_title;

  /// No description provided for @orderList_orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderList_orderNumber;

  /// No description provided for @orderList_comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get orderList_comment;

  /// No description provided for @orderDetail_title.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get orderDetail_title;

  /// No description provided for @orderDetail_countdown_title.
  ///
  /// In en, this message translates to:
  /// **'Showtime Reminder'**
  String get orderDetail_countdown_title;

  /// No description provided for @orderDetail_countdown_started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get orderDetail_countdown_started;

  /// No description provided for @orderDetail_countdown_hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} hours {minutes} minutes until showtime'**
  String orderDetail_countdown_hoursMinutes(Object hours, Object minutes);

  /// No description provided for @orderDetail_countdown_minutesSeconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes {seconds} seconds until showtime'**
  String orderDetail_countdown_minutesSeconds(Object minutes, Object seconds);

  /// No description provided for @orderDetail_countdown_seconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds until showtime'**
  String orderDetail_countdown_seconds(Object seconds);

  /// No description provided for @orderDetail_ticketCode.
  ///
  /// In en, this message translates to:
  /// **'Ticket Collection Code'**
  String get orderDetail_ticketCode;

  /// No description provided for @orderDetail_ticketCount.
  ///
  /// In en, this message translates to:
  /// **'{ticketCount} Movie Tickets'**
  String orderDetail_ticketCount(int ticketCount);

  /// No description provided for @orderDetail_orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderDetail_orderNumber;

  /// No description provided for @orderDetail_orderState.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderDetail_orderState;

  /// No description provided for @orderDetail_orderCreateTime.
  ///
  /// In en, this message translates to:
  /// **'Order Creation Time'**
  String get orderDetail_orderCreateTime;

  /// No description provided for @orderDetail_payTime.
  ///
  /// In en, this message translates to:
  /// **'Payment Time'**
  String get orderDetail_payTime;

  /// No description provided for @orderDetail_payMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get orderDetail_payMethod;

  /// No description provided for @orderDetail_seatMessage.
  ///
  /// In en, this message translates to:
  /// **'Seat Information'**
  String get orderDetail_seatMessage;

  /// No description provided for @orderDetail_orderMessage.
  ///
  /// In en, this message translates to:
  /// **'Order Information'**
  String get orderDetail_orderMessage;

  /// No description provided for @orderDetail_failureReason.
  ///
  /// In en, this message translates to:
  /// **'Failure Reason'**
  String get orderDetail_failureReason;

  /// No description provided for @payResult_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get payResult_title;

  /// No description provided for @payResult_success.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get payResult_success;

  /// No description provided for @payResult_ticketCode.
  ///
  /// In en, this message translates to:
  /// **'Ticket Collection Code'**
  String get payResult_ticketCode;

  /// No description provided for @payResult_qrCodeTip.
  ///
  /// In en, this message translates to:
  /// **'Please use this QR code or ticket code to collect your tickets at the cinema'**
  String get payResult_qrCodeTip;

  /// No description provided for @payResult_viewMyTickets.
  ///
  /// In en, this message translates to:
  /// **'View My Tickets'**
  String get payResult_viewMyTickets;

  /// No description provided for @userProfile_title.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile_title;

  /// No description provided for @userProfile_avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get userProfile_avatar;

  /// No description provided for @userProfile_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userProfile_username;

  /// No description provided for @userProfile_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userProfile_email;

  /// No description provided for @userProfile_registerTime.
  ///
  /// In en, this message translates to:
  /// **'Register Time'**
  String get userProfile_registerTime;

  /// No description provided for @userProfile_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get userProfile_save;

  /// No description provided for @userProfile_edit_tip.
  ///
  /// In en, this message translates to:
  /// **'Click save button to save changes'**
  String get userProfile_edit_tip;

  /// No description provided for @userProfile_edit_username_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get userProfile_edit_username_placeholder;

  /// No description provided for @userProfile_edit_username_verify_notNull.
  ///
  /// In en, this message translates to:
  /// **'Username cannot be empty'**
  String get userProfile_edit_username_verify_notNull;

  /// No description provided for @movieShowList_dropdown_area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get movieShowList_dropdown_area;

  /// No description provided for @movieShowList_dropdown_screenSpec.
  ///
  /// In en, this message translates to:
  /// **'Screen Spec'**
  String get movieShowList_dropdown_screenSpec;

  /// No description provided for @movieShowList_dropdown_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get movieShowList_dropdown_subtitle;

  /// No description provided for @movieShowList_dropdown_tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get movieShowList_dropdown_tag;

  /// No description provided for @movieShowList_dropdown_version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get movieShowList_dropdown_version;

  /// No description provided for @payment_addCreditCard_title.
  ///
  /// In en, this message translates to:
  /// **'Add Credit Card'**
  String get payment_addCreditCard_title;

  /// No description provided for @payment_addCreditCard_cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get payment_addCreditCard_cardNumber;

  /// No description provided for @payment_addCreditCard_cardNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter card number'**
  String get payment_addCreditCard_cardNumberHint;

  /// No description provided for @payment_addCreditCard_cardNumberError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid card number'**
  String get payment_addCreditCard_cardNumberError;

  /// No description provided for @payment_addCreditCard_cardNumberLength.
  ///
  /// In en, this message translates to:
  /// **'Invalid card number length'**
  String get payment_addCreditCard_cardNumberLength;

  /// No description provided for @payment_addCreditCard_cardHolderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get payment_addCreditCard_cardHolderName;

  /// No description provided for @payment_addCreditCard_cardHolderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter cardholder name'**
  String get payment_addCreditCard_cardHolderNameHint;

  /// No description provided for @payment_addCreditCard_cardHolderNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter cardholder name'**
  String get payment_addCreditCard_cardHolderNameError;

  /// No description provided for @payment_addCreditCard_expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get payment_addCreditCard_expiryDate;

  /// No description provided for @payment_addCreditCard_expiryDateHint.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get payment_addCreditCard_expiryDateHint;

  /// No description provided for @payment_addCreditCard_expiryDateError.
  ///
  /// In en, this message translates to:
  /// **'Please enter expiry date'**
  String get payment_addCreditCard_expiryDateError;

  /// No description provided for @payment_addCreditCard_expiryDateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid expiry date format'**
  String get payment_addCreditCard_expiryDateInvalid;

  /// No description provided for @payment_addCreditCard_expiryDateExpired.
  ///
  /// In en, this message translates to:
  /// **'Card has expired'**
  String get payment_addCreditCard_expiryDateExpired;

  /// No description provided for @payment_addCreditCard_cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get payment_addCreditCard_cvv;

  /// No description provided for @payment_addCreditCard_cvvHint.
  ///
  /// In en, this message translates to:
  /// **'•••'**
  String get payment_addCreditCard_cvvHint;

  /// No description provided for @payment_addCreditCard_cvvError.
  ///
  /// In en, this message translates to:
  /// **'Please enter CVV'**
  String get payment_addCreditCard_cvvError;

  /// No description provided for @payment_addCreditCard_cvvLength.
  ///
  /// In en, this message translates to:
  /// **'Invalid length'**
  String get payment_addCreditCard_cvvLength;

  /// No description provided for @payment_addCreditCard_saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save this credit card'**
  String get payment_addCreditCard_saveCard;

  /// No description provided for @payment_addCreditCard_saveToAccount.
  ///
  /// In en, this message translates to:
  /// **'Will be saved to your account for future use'**
  String get payment_addCreditCard_saveToAccount;

  /// No description provided for @payment_addCreditCard_useOnce.
  ///
  /// In en, this message translates to:
  /// **'Use once only, will not be saved'**
  String get payment_addCreditCard_useOnce;

  /// No description provided for @payment_addCreditCard_confirmAdd.
  ///
  /// In en, this message translates to:
  /// **'Confirm Add'**
  String get payment_addCreditCard_confirmAdd;

  /// No description provided for @payment_addCreditCard_cardSaved.
  ///
  /// In en, this message translates to:
  /// **'Credit card saved'**
  String get payment_addCreditCard_cardSaved;

  /// No description provided for @payment_addCreditCard_cardConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Credit card confirmed'**
  String get payment_addCreditCard_cardConfirmed;

  /// No description provided for @payment_addCreditCard_operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed, please try again'**
  String get payment_addCreditCard_operationFailed;

  /// No description provided for @payment_selectCreditCard_title.
  ///
  /// In en, this message translates to:
  /// **'Select Credit Card'**
  String get payment_selectCreditCard_title;

  /// No description provided for @payment_selectCreditCard_noCreditCard.
  ///
  /// In en, this message translates to:
  /// **'No credit cards'**
  String get payment_selectCreditCard_noCreditCard;

  /// No description provided for @payment_selectCreditCard_pleaseAddCard.
  ///
  /// In en, this message translates to:
  /// **'Please add a credit card'**
  String get payment_selectCreditCard_pleaseAddCard;

  /// No description provided for @payment_selectCreditCard_tempCard.
  ///
  /// In en, this message translates to:
  /// **'Temporary card (one-time use)'**
  String get payment_selectCreditCard_tempCard;

  /// No description provided for @payment_selectCreditCard_expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Exp: {date}'**
  String payment_selectCreditCard_expiryDate(Object date);

  /// No description provided for @payment_selectCreditCard_removeTempCard.
  ///
  /// In en, this message translates to:
  /// **'Remove temporary card'**
  String get payment_selectCreditCard_removeTempCard;

  /// No description provided for @payment_selectCreditCard_tempCardRemoved.
  ///
  /// In en, this message translates to:
  /// **'Temporary card removed'**
  String get payment_selectCreditCard_tempCardRemoved;

  /// No description provided for @payment_selectCreditCard_addNewCard.
  ///
  /// In en, this message translates to:
  /// **'Add New Credit Card'**
  String get payment_selectCreditCard_addNewCard;

  /// No description provided for @payment_selectCreditCard_confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment'**
  String get payment_selectCreditCard_confirmPayment;

  /// No description provided for @payment_selectCreditCard_pleaseSelectCard.
  ///
  /// In en, this message translates to:
  /// **'Please select a credit card'**
  String get payment_selectCreditCard_pleaseSelectCard;

  /// No description provided for @payment_selectCreditCard_paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment successful'**
  String get payment_selectCreditCard_paymentSuccess;

  /// No description provided for @payment_selectCreditCard_paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed, please try again'**
  String get payment_selectCreditCard_paymentFailed;

  /// No description provided for @payment_selectCreditCard_loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load credit card list'**
  String get payment_selectCreditCard_loadFailed;

  /// No description provided for @payment_selectCreditCard_tempCardSelected.
  ///
  /// In en, this message translates to:
  /// **'Temporary credit card selected'**
  String get payment_selectCreditCard_tempCardSelected;

  /// No description provided for @payError_title.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get payError_title;

  /// No description provided for @payError_message.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with your order. Please try again later.'**
  String get payError_message;

  /// No description provided for @payError_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get payError_back;

  /// No description provided for @cinemaList_allArea.
  ///
  /// In en, this message translates to:
  /// **'All Areas'**
  String get cinemaList_allArea;

  /// No description provided for @cinemaList_title.
  ///
  /// In en, this message translates to:
  /// **'Nearby Cinemas'**
  String get cinemaList_title;

  /// No description provided for @cinemaList_allCinemas.
  ///
  /// In en, this message translates to:
  /// **'All Cinemas'**
  String get cinemaList_allCinemas;

  /// No description provided for @cinemaList_address.
  ///
  /// In en, this message translates to:
  /// **'Getting current location'**
  String get cinemaList_address;

  /// No description provided for @cinemaList_currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get cinemaList_currentLocation;

  /// No description provided for @cinemaList_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search cinema name or address'**
  String get cinemaList_search_hint;

  /// No description provided for @cinemaList_search_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get cinemaList_search_clear;

  /// No description provided for @cinemaList_search_results_found.
  ///
  /// In en, this message translates to:
  /// **'Found {count} related cinemas'**
  String cinemaList_search_results_found(Object count);

  /// No description provided for @cinemaList_search_results_notFound.
  ///
  /// In en, this message translates to:
  /// **'No related cinemas found, please try other keywords'**
  String get cinemaList_search_results_notFound;

  /// No description provided for @cinemaList_filter_title.
  ///
  /// In en, this message translates to:
  /// **'Filter by Area'**
  String get cinemaList_filter_title;

  /// No description provided for @cinemaList_filter_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get cinemaList_filter_brand;

  /// No description provided for @cinemaList_filter_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading area data...'**
  String get cinemaList_filter_loading;

  /// No description provided for @cinemaList_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading failed, please retry'**
  String get cinemaList_loading;

  /// No description provided for @cinemaList_empty_noData.
  ///
  /// In en, this message translates to:
  /// **'No cinema data'**
  String get cinemaList_empty_noData;

  /// No description provided for @cinemaList_empty_noDataTip.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get cinemaList_empty_noDataTip;

  /// No description provided for @cinemaList_empty_noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No related cinemas found'**
  String get cinemaList_empty_noSearchResults;

  /// No description provided for @cinemaList_empty_noSearchResultsTip.
  ///
  /// In en, this message translates to:
  /// **'Please try other keywords'**
  String get cinemaList_empty_noSearchResultsTip;

  /// No description provided for @cinemaList_movies_nowShowing.
  ///
  /// In en, this message translates to:
  /// **'Now Showing'**
  String get cinemaList_movies_nowShowing;

  /// No description provided for @cinemaList_movies_empty.
  ///
  /// In en, this message translates to:
  /// **'No movies showing'**
  String get cinemaList_movies_empty;

  /// No description provided for @cinemaList_selectSeat_selectedSeats.
  ///
  /// In en, this message translates to:
  /// **'Selected Seats'**
  String get cinemaList_selectSeat_selectedSeats;

  /// No description provided for @cinemaList_selectSeat_pleaseSelectSeats.
  ///
  /// In en, this message translates to:
  /// **'Please select seats'**
  String get cinemaList_selectSeat_pleaseSelectSeats;

  /// No description provided for @cinemaList_selectSeat_confirmSelection.
  ///
  /// In en, this message translates to:
  /// **'Confirm selection of {count} seats'**
  String cinemaList_selectSeat_confirmSelection(Object count);

  /// No description provided for @cinemaList_selectSeat_seatsSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected {count} seats'**
  String cinemaList_selectSeat_seatsSelected(Object count);

  /// No description provided for @cinemaList_selectSeat_dateFormat.
  ///
  /// In en, this message translates to:
  /// **'MMM dd, yyyy'**
  String get cinemaList_selectSeat_dateFormat;

  /// No description provided for @forgotPassword_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword_title;

  /// No description provided for @forgotPassword_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a verification code'**
  String get forgotPassword_description;

  /// No description provided for @forgotPassword_emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get forgotPassword_emailAddress;

  /// No description provided for @forgotPassword_verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get forgotPassword_verificationCode;

  /// No description provided for @forgotPassword_newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get forgotPassword_newPassword;

  /// No description provided for @forgotPassword_sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get forgotPassword_sendVerificationCode;

  /// No description provided for @forgotPassword_resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPassword_resetPassword;

  /// No description provided for @forgotPassword_rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password?'**
  String get forgotPassword_rememberPassword;

  /// No description provided for @forgotPassword_backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get forgotPassword_backToLogin;

  /// No description provided for @forgotPassword_emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get forgotPassword_emailRequired;

  /// No description provided for @forgotPassword_emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get forgotPassword_emailInvalid;

  /// No description provided for @forgotPassword_verificationCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter verification code'**
  String get forgotPassword_verificationCodeRequired;

  /// No description provided for @forgotPassword_newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password'**
  String get forgotPassword_newPasswordRequired;

  /// No description provided for @forgotPassword_passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get forgotPassword_passwordTooShort;

  /// No description provided for @forgotPassword_verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code has been sent to your email'**
  String get forgotPassword_verificationCodeSent;

  /// No description provided for @forgotPassword_passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get forgotPassword_passwordResetSuccess;

  /// No description provided for @comingSoon_presale.
  ///
  /// In en, this message translates to:
  /// **'Presale'**
  String get comingSoon_presale;

  /// No description provided for @comingSoon_releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get comingSoon_releaseDate;

  /// No description provided for @comingSoon_noMovies.
  ///
  /// In en, this message translates to:
  /// **'No movies currently showing'**
  String get comingSoon_noMovies;

  /// No description provided for @comingSoon_tryLaterOrRefresh.
  ///
  /// In en, this message translates to:
  /// **'Please try again later or pull down to refresh'**
  String get comingSoon_tryLaterOrRefresh;

  /// No description provided for @comingSoon_pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get comingSoon_pullToRefresh;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
