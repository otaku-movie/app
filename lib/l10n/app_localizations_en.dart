// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get writeComment_title => 'Write comment';

  @override
  String get writeComment_hint => 'Write your comment...';

  @override
  String get writeComment_rateTitle => 'Rate this movie';

  @override
  String get writeComment_contentTitle => 'Share your movie experience';

  @override
  String get writeComment_shareExperience =>
      'Share your experience to help others';

  @override
  String get writeComment_publishFailed =>
      'Failed to publish comment, please try again';

  @override
  String get writeComment_verify_notNull => 'Comment cannot be empty';

  @override
  String get writeComment_verify_notRate => 'Please rate the movie';

  @override
  String get writeComment_verify_movieIdEmpty => 'Movie ID cannot be empty';

  @override
  String get writeComment_release => 'Release';

  @override
  String get search_noData => 'No data yet';

  @override
  String get search_placeholder => 'Search all movies';

  @override
  String get search_history => 'Search History';

  @override
  String get search_removeHistoryConfirm_title => 'Delete History';

  @override
  String get search_removeHistoryConfirm_content =>
      'Are you sure you want to delete your search history?';

  @override
  String get search_removeHistoryConfirm_confirm => 'Confirm';

  @override
  String get search_removeHistoryConfirm_cancel => 'Cancel';

  @override
  String get search_level => 'Level';

  @override
  String get showTimeDetail_address => 'Address';

  @override
  String get showTimeDetail_buy => 'Select Seat';

  @override
  String get showTimeDetail_time => 'minutes';

  @override
  String get showTimeDetail_seatStatus_available => 'Seats Available';

  @override
  String get showTimeDetail_seatStatus_tight => 'Seats Limited';

  @override
  String get showTimeDetail_seatStatus_soldOut => 'Sold Out';

  @override
  String get cinemaDetail_tel => 'TEL';

  @override
  String get cinemaDetail_address => 'Address';

  @override
  String get cinemaDetail_homepage => 'WebSite';

  @override
  String get cinemaDetail_showing => 'Showing';

  @override
  String get cinemaDetail_specialSpecPrice => 'Special Screening Price';

  @override
  String get cinemaDetail_ticketTypePrice => 'Standard Ticket Price';

  @override
  String get cinemaDetail_maxSelectSeat => 'Maximum number of available seats';

  @override
  String get cinemaDetail_theaterSpec => 'Theater Info';

  @override
  String cinemaDetail_seatCount(int seatCount) {
    return '$seatCount seats';
  }

  @override
  String selectSeat_maxSelectSeatWarn(int maxSeat) {
    return 'A maximum of $maxSeat seats can be selected';
  }

  @override
  String get selectSeat_confirmSelectSeat => 'Confirm Seat Selection';

  @override
  String get selectSeat_notSelectSeatWarn => 'Please select a seat';

  @override
  String get home_home => 'home';

  @override
  String get home_ticket => 'My Ticket';

  @override
  String get home_cinema => 'cinema';

  @override
  String get home_me => 'my page';

  @override
  String get ticket_showTime => 'Show Time';

  @override
  String get ticket_endTime => 'Expected End Time';

  @override
  String get ticket_seatCount => 'Seat Count';

  @override
  String get ticket_noData => 'No ticket yet';

  @override
  String get ticket_noDataTip => 'Buy tickets now!';

  @override
  String get ticket_status_valid => 'Valid';

  @override
  String get ticket_status_used => 'Used';

  @override
  String get ticket_status_expired => 'Expired';

  @override
  String get ticket_status_cancelled => 'Cancelled';

  @override
  String get ticket_time_unknown => 'Time unknown';

  @override
  String get ticket_time_formatError => 'Time format error';

  @override
  String ticket_time_remaining_days(Object days) {
    return '$days days left';
  }

  @override
  String ticket_time_remaining_hours(Object hours) {
    return '$hours hours left';
  }

  @override
  String ticket_time_remaining_minutes(Object minutes) {
    return '$minutes minutes left';
  }

  @override
  String get ticket_time_remaining_soon => 'Starting soon';

  @override
  String get ticket_time_weekdays_monday => 'Mon';

  @override
  String get ticket_time_weekdays_tuesday => 'Tue';

  @override
  String get ticket_time_weekdays_wednesday => 'Wed';

  @override
  String get ticket_time_weekdays_thursday => 'Thu';

  @override
  String get ticket_time_weekdays_friday => 'Fri';

  @override
  String get ticket_time_weekdays_saturday => 'Sat';

  @override
  String get ticket_time_weekdays_sunday => 'Sun';

  @override
  String get ticket_ticketCount => 'Ticket Count';

  @override
  String get ticket_totalPurchased => 'Total Purchased';

  @override
  String get ticket_tickets => ' tickets';

  @override
  String get ticket_tapToView => 'Tap to view details';

  @override
  String get ticket_buyTickets => 'Buy Tickets';

  @override
  String ticket_shareTicket(Object movieName) {
    return 'Share movie ticket: $movieName';
  }

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_error_title => 'Error';

  @override
  String get common_error_message =>
      'Failed to load data, please try again later';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_network_error_connectionRefused =>
      'Server connection refused, please try again later';

  @override
  String get common_network_error_noRouteToHost =>
      'Cannot connect to server, please check network connection';

  @override
  String get common_network_error_connectionTimeout =>
      'Connection timeout, please check network or try again later';

  @override
  String get common_network_error_networkUnreachable =>
      'Network unreachable, please check network settings';

  @override
  String get common_network_error_hostLookupFailed =>
      'Cannot resolve server address, please check network settings';

  @override
  String get common_network_error_sendTimeout =>
      'Request timeout, please try again later';

  @override
  String get common_network_error_receiveTimeout =>
      'Response timeout, please try again later';

  @override
  String get common_network_error_connectionError =>
      'Network connection error, please check network settings';

  @override
  String get common_network_error_default =>
      'Network request failed, please try again later';

  @override
  String get common_unit_jpy => 'JPY';

  @override
  String get common_unit_meter => 'm';

  @override
  String get common_unit_kilometer => 'km';

  @override
  String get common_unit_point => 'pts';

  @override
  String get common_components_cropper_title => 'Crop the picture';

  @override
  String get common_components_cropper_actions_rotateLeft => 'Rotate Left';

  @override
  String get common_components_cropper_actions_rotateRight => 'Rotate Right';

  @override
  String get common_components_cropper_actions_flip => 'Flip';

  @override
  String get common_components_cropper_actions_undo => 'Undo';

  @override
  String get common_components_cropper_actions_redo => 'Redo';

  @override
  String get common_components_cropper_actions_reset => 'Reset';

  @override
  String get common_components_easyRefresh_refresh_dragText =>
      'Pull to refresh';

  @override
  String get common_components_easyRefresh_refresh_armedText =>
      'Release to refresh';

  @override
  String get common_components_easyRefresh_refresh_readyText => 'Refreshing...';

  @override
  String get common_components_easyRefresh_refresh_processingText =>
      'Refreshing...';

  @override
  String get common_components_easyRefresh_refresh_processedText =>
      'Refresh complete';

  @override
  String get common_components_easyRefresh_refresh_failedText =>
      'Refresh failed';

  @override
  String get common_components_easyRefresh_refresh_noMoreText => 'No more data';

  @override
  String get common_components_easyRefresh_loadMore_dragText =>
      'Pull to load more';

  @override
  String get common_components_easyRefresh_loadMore_armedText =>
      'Release to load more';

  @override
  String get common_components_easyRefresh_loadMore_readyText => 'Loading...';

  @override
  String get common_components_easyRefresh_loadMore_processingText =>
      'Loading...';

  @override
  String get common_components_easyRefresh_loadMore_processedText =>
      'Load complete';

  @override
  String get common_components_easyRefresh_loadMore_failedText => 'Load failed';

  @override
  String get common_components_easyRefresh_loadMore_noMoreText =>
      'No more data';

  @override
  String get common_components_sendVerifyCode_success =>
      'Verification code sent successfully';

  @override
  String get common_components_filterBar_pleaseSelect => 'Please select';

  @override
  String get common_components_filterBar_reset => 'Reset';

  @override
  String get common_components_filterBar_confirm => 'Confirm';

  @override
  String get common_components_filterBar_allDay => 'All Day';

  @override
  String get common_components_filterBar_noData => 'No data yet';

  @override
  String get common_week_monday => 'Monday';

  @override
  String get common_week_tuesday => 'Tuesday';

  @override
  String get common_week_wednesday => 'Wednesday';

  @override
  String get common_week_thursday => 'Thursday';

  @override
  String get common_week_friday => 'Friday';

  @override
  String get common_week_saturday => 'Saturday';

  @override
  String get common_week_sunday => 'Sunday';

  @override
  String get common_enum_seatType_wheelChair => 'Wheelchair';

  @override
  String get common_enum_seatType_coupleSeat => 'Couple Seat';

  @override
  String get common_enum_seatType_locked => 'Locked';

  @override
  String get common_enum_seatType_sold => 'Sold';

  @override
  String get about_title => 'About';

  @override
  String get about_version => 'Version';

  @override
  String get about_description =>
      'Committed to providing convenient ticket purchasing experience for movie enthusiasts.';

  @override
  String get about_privacy_policy => 'View Privacy Policy';

  @override
  String get about_copyright => '© 2025 Otaku Movie All Rights Reserved';

  @override
  String get about_components_sendVerifyCode_success =>
      'Verification code sent successfully';

  @override
  String get about_components_filterBar_pleaseSelect => 'Please select';

  @override
  String get about_components_filterBar_reset => 'Reset';

  @override
  String get about_components_filterBar_confirm => 'Confirm';

  @override
  String get about_components_showTimeList_all => 'All';

  @override
  String get about_components_showTimeList_unnamed => 'Unnamed';

  @override
  String get about_components_showTimeList_noData => 'No data yet';

  @override
  String get about_components_showTimeList_noShowTimeInfo =>
      'No showtime information';

  @override
  String about_components_showTimeList_moreShowTimes(Object count) {
    return 'There are $count more showtimes...';
  }

  @override
  String get about_components_showTimeList_timeRange => 'Show Time';

  @override
  String get about_components_showTimeList_dubbingVersion => 'Dubbed Version';

  @override
  String get about_components_showTimeList_seatStatus_soldOut => 'Sold Out';

  @override
  String get about_components_showTimeList_seatStatus_limited => 'Limited';

  @override
  String get about_components_showTimeList_seatStatus_available => 'Available';

  @override
  String get about_login_verificationCode => 'Verification Code';

  @override
  String get about_login_email_verify_notNull => 'Email cannot be empty';

  @override
  String get about_login_email_verify_isValid =>
      'Please enter a valid email address';

  @override
  String get about_login_email_text => 'Email';

  @override
  String get about_login_password_verify_notNull => 'Password cannot be empty';

  @override
  String get about_login_password_verify_isValid =>
      'Password must be at least 6 characters';

  @override
  String get about_login_password_text => 'Password';

  @override
  String get about_login_loginButton => 'Login';

  @override
  String get about_login_welcomeText => 'Welcome Back';

  @override
  String get about_login_forgotPassword => 'Forgot Password?';

  @override
  String get about_login_or => 'or';

  @override
  String get about_login_googleLogin => 'Login with Google';

  @override
  String get about_login_noAccount => 'Don\'t have an account?';

  @override
  String get about_register_registerButton => 'Register';

  @override
  String get about_register_username_verify_notNull =>
      'Username cannot be empty';

  @override
  String get about_register_username_text => 'Username';

  @override
  String get about_register_repeatPassword_text => 'Confirm Password';

  @override
  String get about_register_passwordNotMatchRepeatPassword =>
      'Passwords do not match';

  @override
  String get about_register_verifyCode_verify_isValid =>
      'Invalid verification code format';

  @override
  String get about_register_send => 'Send';

  @override
  String get about_register_haveAccount => 'Already have an account?';

  @override
  String get about_register_loginHere => 'Login here';

  @override
  String get about_movieShowList_dropdown_area => 'Area';

  @override
  String get about_movieShowList_dropdown_dimensionType => 'Dimension';

  @override
  String get about_movieShowList_dropdown_screenSpec => 'Screen Spec';

  @override
  String get about_movieShowList_dropdown_subtitle => 'Subtitle';

  @override
  String get about_movieShowList_dropdown_tag => 'Tag';

  @override
  String get about_movieShowList_dropdown_version => 'Version';

  @override
  String get enum_seatType_coupleSeat => 'Couple Seat';

  @override
  String get enum_seatType_wheelChair => 'Wheelchair Seat';

  @override
  String get enum_seatType_disabled => 'Disabled';

  @override
  String get enum_seatType_selected => 'Selected';

  @override
  String get enum_seatType_locked => 'Locked';

  @override
  String get enum_seatType_sold => 'Sold';

  @override
  String get unit_point => 'point';

  @override
  String get unit_jpy => 'JPY';

  @override
  String get login_email_text => 'Email';

  @override
  String get login_email_verify_notNull => 'Email cannot be empty';

  @override
  String get login_email_verify_isValid => 'Invalid email address';

  @override
  String get login_password_text => 'Password';

  @override
  String get login_password_verify_notNull => 'Password cannot be empty';

  @override
  String get login_password_verify_isValid =>
      'Password must be 8-16 characters with letters, numbers, and underscores';

  @override
  String get login_loginButton => 'Login';

  @override
  String get login_welcomeText => 'Welcome back, please log in to your account';

  @override
  String get login_or => 'or';

  @override
  String get login_googleLogin => 'Sign in with Google';

  @override
  String get login_forgotPassword => 'Forgot password?';

  @override
  String get login_forgotPasswordTitle => 'Forgot Password';

  @override
  String get login_forgotPasswordDescription =>
      'Enter your email address and we\'ll send you a verification code';

  @override
  String get login_emailAddress => 'Email Address';

  @override
  String get login_newPassword => 'New Password';

  @override
  String get login_sendVerificationCode => 'Send Verification Code';

  @override
  String get login_resetPassword => 'Reset Password';

  @override
  String get login_rememberPassword => 'Remember your password?';

  @override
  String get login_backToLogin => 'Back to Login';

  @override
  String get login_emailRequired => 'Please enter your email';

  @override
  String get login_emailInvalid => 'Please enter a valid email address';

  @override
  String get login_verificationCodeRequired =>
      'Please enter the verification code';

  @override
  String get login_newPasswordRequired => 'Please enter your new password';

  @override
  String get login_passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get login_verificationCodeSent =>
      'Verification code has been sent to your email';

  @override
  String get login_passwordResetSuccess => 'Password reset successful';

  @override
  String get login_verificationCode => 'Verification Code';

  @override
  String get login_sendVerifyCodeButton => 'Send Verification Code';

  @override
  String get login_noAccount => 'Don\'t have an account?';

  @override
  String get register_repeatPassword_text => 'Repeat Password';

  @override
  String get register_repeatPassword_verify_notNull =>
      'Repeat password cannot be empty';

  @override
  String get register_repeatPassword_verify_isValid =>
      'Repeat password must be 8-16 characters with letters, numbers, and underscores';

  @override
  String get register_username_text => 'UserName';

  @override
  String get register_username_verify_notNull => 'Username cannot be empty';

  @override
  String get register_passwordNotMatchRepeatPassword =>
      'The passwords you entered twice do not match';

  @override
  String get register_verifyCode_verify_notNull =>
      'Verification code cannot be empty';

  @override
  String get register_verifyCode_verify_isValid =>
      'Verification code must be 6 digits';

  @override
  String get register_registerButton => 'Register';

  @override
  String get register_send => 'Send';

  @override
  String get register_haveAccount => 'Already have an account?';

  @override
  String get register_loginHere => 'Click Here';

  @override
  String get movieList_tabBar_currentlyShowing => 'Currently Showing';

  @override
  String get movieList_tabBar_comingSoon => 'Coming Soon';

  @override
  String get movieList_currentlyShowing_level => 'Level';

  @override
  String get movieList_comingSoon_noDate => 'Date TBD';

  @override
  String get movieList_placeholder => 'Search all movies';

  @override
  String get movieList_buy => 'Buy Ticket';

  @override
  String get movieDetail_button_want => 'Want to Watch';

  @override
  String get movieDetail_button_saw => 'Watched';

  @override
  String get movieDetail_button_buy => 'Buy Ticket';

  @override
  String get movieDetail_viewPresaleTicket => 'Presale Ticket';

  @override
  String get movieDetail_presaleHasBonus => 'With Bonus';

  @override
  String get movieDetail_comment_reply => 'Reply';

  @override
  String movieDetail_comment_replyTo(String reply) {
    return 'Reply to $reply';
  }

  @override
  String movieDetail_comment_translate(String language) {
    return 'Translate to $language';
  }

  @override
  String get movieDetail_comment_delete => 'Delete';

  @override
  String get movieDetail_writeComment => 'Write Comment';

  @override
  String get movieDetail_detail_noDate => 'Release date TBD';

  @override
  String get movieDetail_detail_basicMessage => 'Basic Info';

  @override
  String get movieDetail_detail_originalName => 'Original Title';

  @override
  String get movieDetail_detail_time => 'Duration';

  @override
  String get movieDetail_detail_spec => 'Screening Spec';

  @override
  String get movieDetail_detail_tags => 'Tags';

  @override
  String get movieDetail_detail_homepage => 'Official Website';

  @override
  String get movieDetail_detail_state => 'Screening Status';

  @override
  String get movieDetail_detail_level => 'Rating';

  @override
  String get movieDetail_detail_staff => 'Staff';

  @override
  String get movieDetail_detail_character => 'Character';

  @override
  String get movieDetail_detail_comment => 'Comment';

  @override
  String get movieDetail_detail_duration_unknown => 'Unknown';

  @override
  String get movieDetail_detail_duration_minutes => 'minutes';

  @override
  String get movieDetail_detail_duration_hours => 'hours';

  @override
  String movieDetail_detail_duration_hoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String movieDetail_detail_totalReplyMessage(int total) {
    return 'Total $total replies';
  }

  @override
  String get commentDetail_title => 'Comment Detail';

  @override
  String get commentDetail_replyComment => 'Comment Reply';

  @override
  String commentDetail_totalReplyMessage(int total) {
    return 'Total $total replies';
  }

  @override
  String commentDetail_comment_placeholder(String reply) {
    return 'Reply to $reply';
  }

  @override
  String get commentDetail_comment_hint => 'Write your reply...';

  @override
  String get commentDetail_comment_button => 'Reply';

  @override
  String get movieTicketType_total => 'Total';

  @override
  String get movieTicketType_title => 'Select Movie Ticket Type';

  @override
  String get movieTicketType_seatNumber => 'Seat Number';

  @override
  String get movieTicketType_selectMovieTicketType =>
      'Please select a movie ticket type';

  @override
  String get movieTicketType_confirmOrder => 'Confirm Order';

  @override
  String get movieTicketType_selectTicketTypeForSeats =>
      'Please select appropriate ticket type for each seat';

  @override
  String get movieTicketType_movieInfo => 'Movie Info';

  @override
  String get movieTicketType_showTime => 'Show Time';

  @override
  String get movieTicketType_cinema => 'Cinema';

  @override
  String get movieTicketType_seatInfo => 'Seat Information';

  @override
  String get movieTicketType_ticketType => 'Ticket Type';

  @override
  String get movieTicketType_price => 'Price';

  @override
  String get movieTicketType_selectTicketType => 'Select Ticket Type';

  @override
  String get movieTicketType_totalPrice => 'Total Price';

  @override
  String get movieTicketType_singleSeatPrice => 'Price per seat';

  @override
  String get movieTicketType_seatCountLabel => ' seats';

  @override
  String get movieTicketType_priceRuleTitle => 'Price Calculation';

  @override
  String get movieTicketType_priceRuleFormula =>
      'Price per seat = Area price + Ticket type price + Spec surcharge (e.g. 3D, IMAX; 2D has none)';

  @override
  String get movieTicketType_actualPrice => 'Actual Payment';

  @override
  String get movieTicketType_mubitikeTitle => 'Movie Ticket Presale (Mubitike)';

  @override
  String get movieTicketType_mubitikeDescription =>
      'Offsets the ticket price; 3D, IMAX and other surcharges still apply.';

  @override
  String get movieTicketType_mubitikeCode => 'Ticket code (10 digits)';

  @override
  String get movieTicketType_mubitikeCodeHint => 'Enter 10-digit code';

  @override
  String get movieTicketType_mubitikePassword => 'Password (4 digits)';

  @override
  String get movieTicketType_mubitikePasswordHint => 'Enter 4-digit password';

  @override
  String get movieTicketType_mubitikeUseCount => 'Number to use';

  @override
  String get movieTicketType_mubitikeTapToInput => 'Tap to input';

  @override
  String get movieTicketType_mubitikeUsageLimit =>
      'Each presale ticket is limited to 1 person for 1 viewing only';

  @override
  String get movieTicketType_mubitikeDetailsTitle => 'Usage Details';

  @override
  String get movieTicketType_mubitikeDetails =>
      '• Offsets ticket price\n• 3D, IMAX surcharges apply separately\n• 1 ticket per person per viewing';

  @override
  String get movieTicketType_fixedPrice => 'Fixed price';

  @override
  String get seatCancel_confirmTitle => 'Cancel Seat Selection';

  @override
  String get seatCancel_confirmMessage =>
      'You have selected seats. Are you sure you want to cancel the selected seats?';

  @override
  String get seatCancel_cancel => 'Cancel';

  @override
  String get seatCancel_confirm => 'Confirm';

  @override
  String get seatCancel_successMessage => 'Seat selection has been cancelled';

  @override
  String get seatCancel_errorMessage =>
      'Failed to cancel seat selection, please try again';

  @override
  String get confirmOrder_noSpec => 'No spec info';

  @override
  String get confirmOrder_payFailed => 'Payment failed, please try again';

  @override
  String get confirmOrder_title => 'Confirm Order';

  @override
  String get confirmOrder_total => 'Total';

  @override
  String get confirmOrder_selectPayMethod => 'Select Payment Method';

  @override
  String get confirmOrder_pay => 'Buy';

  @override
  String get confirmOrder_selectedSeats => 'Selected Seats';

  @override
  String confirmOrder_seatCount(int count) {
    return '$count seats';
  }

  @override
  String get confirmOrder_timeInfo => 'Time Information';

  @override
  String get confirmOrder_cinemaInfo => 'Cinema Information';

  @override
  String get confirmOrder_countdown => 'Time Remaining';

  @override
  String get confirmOrder_cancelOrder => 'Cancel Order';

  @override
  String get confirmOrder_cancelOrderConfirm =>
      'You have selected seats. Are you sure you want to cancel the order and release the selected seats?';

  @override
  String get confirmOrder_continuePay => 'Continue Payment';

  @override
  String get confirmOrder_confirmCancel => 'Confirm Cancel';

  @override
  String get confirmOrder_orderCanceled => 'Order Canceled';

  @override
  String get confirmOrder_cancelOrderFailed =>
      'Failed to cancel order, please try again';

  @override
  String get confirmOrder_orderTimeout => 'Processing order timeout...';

  @override
  String get confirmOrder_orderTimeoutMessage =>
      'Order has timed out and been automatically canceled';

  @override
  String get confirmOrder_timeoutFailed =>
      'Failed to process order timeout, please try again';

  @override
  String get seatSelection_cancelSeatTitle => 'Cancel Seat Selection';

  @override
  String get seatSelection_cancelSeatConfirm =>
      'You have selected seats. Are you sure you want to cancel the selected seats?';

  @override
  String get seatSelection_cancel => 'Cancel';

  @override
  String get seatSelection_confirm => 'Confirm';

  @override
  String get seatSelection_seatCanceled => 'Selected seats have been canceled';

  @override
  String get seatSelection_cancelSeatFailed =>
      'Failed to cancel seat selection, please try again';

  @override
  String get seatSelection_hasLockedOrderTitle => 'Unfinished Order';

  @override
  String get seatSelection_hasLockedOrderMessage =>
      'You have an unfinished order and seats are locked. Please complete payment or cancel the order';

  @override
  String get seatSelection_later => 'Later';

  @override
  String get seatSelection_goToPay => 'Pay Now';

  @override
  String get seatSelection_screen => 'Screen';

  @override
  String get user_title => 'My Profile';

  @override
  String get user_data_orderCount => 'Order Count';

  @override
  String get user_data_watchHistory => 'Watch History';

  @override
  String get user_data_wantCount => 'Want to Watch Count';

  @override
  String get user_data_characterCount => 'Character Count';

  @override
  String get user_data_staffCount => 'Staff Count';

  @override
  String get user_registerTime => 'Registration Time';

  @override
  String get user_language => 'Language';

  @override
  String get user_editProfile => 'Edit Profile';

  @override
  String get user_privateAgreement => 'Privacy Agreement';

  @override
  String get user_checkUpdate => 'Check Update';

  @override
  String get user_about => 'About';

  @override
  String get user_logout => 'Logout';

  @override
  String get user_currentVersion => 'Current Version';

  @override
  String get user_latestVersion => 'Latest Version';

  @override
  String get user_updateAvailable => 'New version found. Update now?';

  @override
  String get user_cancel => 'Cancel';

  @override
  String get user_update => 'Update';

  @override
  String get user_updating => 'Updating';

  @override
  String get user_updateProgress => 'Downloading update, please wait...';

  @override
  String get user_updateSuccess => 'Update Successful';

  @override
  String get user_updateSuccessMessage =>
      'App has been successfully updated to the latest version!';

  @override
  String get user_updateError => 'Update Failed';

  @override
  String get user_updateErrorMessage =>
      'An error occurred during update. Please try again later.';

  @override
  String get user_ok => 'OK';

  @override
  String get orderList_title => 'Order List';

  @override
  String get orderList_orderNumber => 'Order Number';

  @override
  String get orderList_comment => 'Comment';

  @override
  String get orderDetail_title => 'Order Detail';

  @override
  String get orderDetail_countdown_title => 'Showtime Reminder';

  @override
  String get orderDetail_countdown_started => 'Started';

  @override
  String orderDetail_countdown_hoursMinutes(Object hours, Object minutes) {
    return '$hours hours $minutes minutes until showtime';
  }

  @override
  String orderDetail_countdown_minutesSeconds(Object minutes, Object seconds) {
    return '$minutes minutes $seconds seconds until showtime';
  }

  @override
  String orderDetail_countdown_seconds(Object seconds) {
    return '$seconds seconds until showtime';
  }

  @override
  String get orderDetail_ticketCode => 'Ticket Collection Code';

  @override
  String orderDetail_ticketCount(int ticketCount) {
    return '$ticketCount Movie Tickets';
  }

  @override
  String get orderDetail_orderNumber => 'Order Number';

  @override
  String get orderDetail_orderState => 'Order Status';

  @override
  String get orderDetail_orderCreateTime => 'Order Creation Time';

  @override
  String get orderDetail_payTime => 'Payment Time';

  @override
  String get orderDetail_payMethod => 'Payment Method';

  @override
  String get orderDetail_seatMessage => 'Seat Information';

  @override
  String get orderDetail_orderMessage => 'Order Information';

  @override
  String get orderDetail_failureReason => 'Failure Reason';

  @override
  String get payResult_title => 'Payment Successful';

  @override
  String get payResult_success => 'Payment Successful';

  @override
  String get payResult_ticketCode => 'Ticket Collection Code';

  @override
  String get payResult_qrCodeTip =>
      'Please use this QR code or ticket code to collect your tickets at the cinema';

  @override
  String get payResult_viewMyTickets => 'View My Tickets';

  @override
  String get userProfile_title => 'User Profile';

  @override
  String get userProfile_avatar => 'Avatar';

  @override
  String get userProfile_username => 'Username';

  @override
  String get userProfile_email => 'Email';

  @override
  String get userProfile_registerTime => 'Register Time';

  @override
  String get userProfile_save => 'Save';

  @override
  String get userProfile_edit_tip => 'Click save button to save changes';

  @override
  String get userProfile_edit_username_placeholder =>
      'Please enter your username';

  @override
  String get userProfile_edit_username_verify_notNull =>
      'Username cannot be empty';

  @override
  String get movieShowList_dropdown_area => 'Area';

  @override
  String get movieShowList_dropdown_dimensionType => 'Dimension';

  @override
  String get movieShowList_dropdown_screenSpec => 'Screen Spec';

  @override
  String get movieShowList_dropdown_subtitle => 'Subtitle';

  @override
  String get movieShowList_dropdown_tag => 'Tag';

  @override
  String get movieShowList_dropdown_version => 'Version';

  @override
  String get payment_addCreditCard_title => 'Add Credit Card';

  @override
  String get payment_addCreditCard_cardNumber => 'Card Number';

  @override
  String get payment_addCreditCard_cardNumberHint => 'Enter card number';

  @override
  String get payment_addCreditCard_cardNumberError =>
      'Please enter a valid card number';

  @override
  String get payment_addCreditCard_cardNumberLength =>
      'Invalid card number length';

  @override
  String get payment_addCreditCard_cardHolderName => 'Cardholder Name';

  @override
  String get payment_addCreditCard_cardHolderNameHint =>
      'Enter cardholder name';

  @override
  String get payment_addCreditCard_cardHolderNameError =>
      'Please enter cardholder name';

  @override
  String get payment_addCreditCard_expiryDate => 'Expiry Date';

  @override
  String get payment_addCreditCard_expiryDateHint => 'MM/YY';

  @override
  String get payment_addCreditCard_expiryDateError =>
      'Please enter expiry date';

  @override
  String get payment_addCreditCard_expiryDateInvalid =>
      'Invalid expiry date format';

  @override
  String get payment_addCreditCard_expiryDateExpired => 'Card has expired';

  @override
  String get payment_addCreditCard_cvv => 'CVV';

  @override
  String get payment_addCreditCard_cvvHint => '•••';

  @override
  String get payment_addCreditCard_cvvError => 'Please enter CVV';

  @override
  String get payment_addCreditCard_cvvLength => 'Invalid length';

  @override
  String get payment_addCreditCard_saveCard => 'Save this credit card';

  @override
  String get payment_addCreditCard_saveToAccount =>
      'Will be saved to your account for future use';

  @override
  String get payment_addCreditCard_useOnce =>
      'Use once only, will not be saved';

  @override
  String get payment_addCreditCard_confirmAdd => 'Confirm Add';

  @override
  String get payment_addCreditCard_cardSaved => 'Credit card saved';

  @override
  String get payment_addCreditCard_cardConfirmed => 'Credit card confirmed';

  @override
  String get payment_addCreditCard_operationFailed =>
      'Operation failed, please try again';

  @override
  String get payment_selectCreditCard_title => 'Select Credit Card';

  @override
  String get payment_selectCreditCard_noCreditCard => 'No credit cards';

  @override
  String get payment_selectCreditCard_pleaseAddCard =>
      'Please add a credit card';

  @override
  String get payment_selectCreditCard_tempCard =>
      'Temporary card (one-time use)';

  @override
  String payment_selectCreditCard_expiryDate(Object date) {
    return 'Exp: $date';
  }

  @override
  String get payment_selectCreditCard_removeTempCard => 'Remove temporary card';

  @override
  String get payment_selectCreditCard_tempCardRemoved =>
      'Temporary card removed';

  @override
  String get payment_selectCreditCard_addNewCard => 'Add New Credit Card';

  @override
  String get payment_selectCreditCard_confirmPayment => 'Confirm Payment';

  @override
  String get payment_selectCreditCard_pleaseSelectCard =>
      'Please select a credit card';

  @override
  String get payment_selectCreditCard_paymentSuccess => 'Payment successful';

  @override
  String get payment_selectCreditCard_paymentFailed =>
      'Payment failed, please try again';

  @override
  String get payment_selectCreditCard_loadFailed =>
      'Failed to load credit card list';

  @override
  String get payment_selectCreditCard_tempCardSelected =>
      'Temporary credit card selected';

  @override
  String get payError_title => 'Payment Failed';

  @override
  String get payError_message =>
      'Something went wrong with your order. Please try again later.';

  @override
  String get payError_back => 'Back';

  @override
  String get cinemaList_allArea => 'All Areas';

  @override
  String get cinemaList_title => 'Nearby Cinemas';

  @override
  String get cinemaList_allCinemas => 'All Cinemas';

  @override
  String get cinemaList_address => 'Getting current location';

  @override
  String get cinemaList_currentLocation => 'Current location';

  @override
  String get cinemaList_search_hint => 'Search cinema name or address';

  @override
  String get cinemaList_search_clear => 'Clear';

  @override
  String cinemaList_search_results_found(Object count) {
    return 'Found $count related cinemas';
  }

  @override
  String get cinemaList_search_results_notFound =>
      'No related cinemas found, please try other keywords';

  @override
  String get cinemaList_filter_title => 'Filter by Area';

  @override
  String get cinemaList_filter_brand => 'Brand';

  @override
  String get cinemaList_filter_loading => 'Loading area data...';

  @override
  String get cinemaList_loading => 'Loading failed, please retry';

  @override
  String get cinemaList_empty_noData => 'No cinema data';

  @override
  String get cinemaList_empty_noDataTip => 'Please try again later';

  @override
  String get cinemaList_empty_noSearchResults => 'No related cinemas found';

  @override
  String get cinemaList_empty_noSearchResultsTip => 'Please try other keywords';

  @override
  String get cinemaList_movies_nowShowing => 'Now Showing';

  @override
  String get cinemaList_movies_empty => 'No movies showing';

  @override
  String get cinemaList_selectSeat_selectedSeats => 'Selected Seats';

  @override
  String get cinemaList_selectSeat_pleaseSelectSeats => 'Please select seats';

  @override
  String cinemaList_selectSeat_confirmSelection(Object count) {
    return 'Confirm selection of $count seats';
  }

  @override
  String cinemaList_selectSeat_seatsSelected(Object count) {
    return 'Selected $count seats';
  }

  @override
  String get cinemaList_selectSeat_dateFormat => 'MMM dd, yyyy';

  @override
  String get forgotPassword_title => 'Forgot Password';

  @override
  String get forgotPassword_description =>
      'Enter your email address and we will send you a verification code';

  @override
  String get forgotPassword_emailAddress => 'Email Address';

  @override
  String get forgotPassword_verificationCode => 'Verification Code';

  @override
  String get forgotPassword_newPassword => 'New Password';

  @override
  String get forgotPassword_sendVerificationCode => 'Send Verification Code';

  @override
  String get forgotPassword_resetPassword => 'Reset Password';

  @override
  String get forgotPassword_rememberPassword => 'Remember your password?';

  @override
  String get forgotPassword_backToLogin => 'Back to Login';

  @override
  String get forgotPassword_emailRequired => 'Please enter your email';

  @override
  String get forgotPassword_emailInvalid =>
      'Please enter a valid email address';

  @override
  String get forgotPassword_verificationCodeRequired =>
      'Please enter verification code';

  @override
  String get forgotPassword_newPasswordRequired =>
      'Please enter your new password';

  @override
  String get forgotPassword_passwordTooShort =>
      'Password must be at least 6 characters';

  @override
  String get forgotPassword_verificationCodeSent =>
      'Verification code has been sent to your email';

  @override
  String get forgotPassword_passwordResetSuccess => 'Password reset successful';

  @override
  String get presaleDetail_title => 'Presale Ticket';

  @override
  String get presaleDetail_specs => 'Spec';

  @override
  String get presaleDetail_salePeriodNote =>
      '※ Sale and usage periods may vary by theater. Please check each theater\'s notice';

  @override
  String get presaleDetail_applyMovie => 'Applicable Movie';

  @override
  String get presaleDetail_salePeriod => 'Sale Period';

  @override
  String get presaleDetail_usagePeriod => 'Usage Period';

  @override
  String get presaleDetail_perUserLimit => 'Per Person Limit';

  @override
  String get presaleDetail_noLimit => 'No limit';

  @override
  String get presaleDetail_pickupNotes => 'Pickup Notes';

  @override
  String get presaleDetail_gallery => 'Gallery';

  @override
  String get presaleDetail_price => 'Price';

  @override
  String get presaleDetail_bonus => 'Bonus';

  @override
  String get presaleDetail_bonusDescription => 'Bonus details';

  @override
  String presaleDetail_bonusCount(int count) {
    return '$count images';
  }

  @override
  String get comingSoon_presale => 'Presale';

  @override
  String get comingSoon_presaleTicketBadge => 'Presale Ticket';

  @override
  String get comingSoon_releaseDate => 'Release';

  @override
  String get comingSoon_noMovies => 'No movies currently showing';

  @override
  String get comingSoon_tryLaterOrRefresh =>
      'Please try again later or pull down to refresh';

  @override
  String get comingSoon_pullToRefresh => 'Pull to refresh';
}
