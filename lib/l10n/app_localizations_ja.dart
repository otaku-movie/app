// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get writeComment_title => 'コメントを書く';

  @override
  String get writeComment_hint => 'コメントを入力してください...';

  @override
  String get writeComment_rateTitle => 'この映画を評価する';

  @override
  String get writeComment_contentTitle => '映画の感想を書いてください';

  @override
  String get writeComment_shareExperience => '映画体験をシェアして、他の人の選択をサポートしましょう';

  @override
  String get writeComment_publishFailed => 'コメントの投稿に失敗しました。もう一度お試しください';

  @override
  String get writeComment_verify_notNull => 'コメントを入力してください';

  @override
  String get writeComment_verify_notRate => '映画に評価を付けてください';

  @override
  String get writeComment_verify_movieIdEmpty => '映画IDが空です';

  @override
  String get writeComment_release => 'リリース';

  @override
  String get search_noData => 'まだデータがありません';

  @override
  String get search_placeholder => 'すべての映画を検索';

  @override
  String get search_history => '検索履歴';

  @override
  String get search_removeHistoryConfirm_title => '履歴を削除';

  @override
  String get search_removeHistoryConfirm_content => '検索履歴を削除してもよろしいですか？';

  @override
  String get search_removeHistoryConfirm_confirm => '確認';

  @override
  String get search_removeHistoryConfirm_cancel => 'キャンセル';

  @override
  String get search_level => '映倫';

  @override
  String get showTimeDetail_address => 'アドレス';

  @override
  String get showTimeDetail_buy => '座席選択';

  @override
  String get showTimeDetail_time => '分';

  @override
  String get showTimeDetail_seatStatus_available => '座席余裕あり';

  @override
  String get showTimeDetail_seatStatus_tight => '座席残りわずか';

  @override
  String get showTimeDetail_seatStatus_soldOut => '完売';

  @override
  String get cinemaDetail_tel => '連絡先';

  @override
  String get cinemaDetail_address => 'アドレス';

  @override
  String get cinemaDetail_homepage => 'ホームページ';

  @override
  String get cinemaDetail_showing => '上映中';

  @override
  String get cinemaDetail_specialSpecPrice => '特別上映料金';

  @override
  String get cinemaDetail_ticketTypePrice => '基本料金';

  @override
  String get cinemaDetail_maxSelectSeat => '利用可能な座席数';

  @override
  String get cinemaDetail_theaterSpec => 'シアター情報';

  @override
  String cinemaDetail_seatCount(int seatCount) {
    return '$seatCount席';
  }

  @override
  String selectSeat_maxSelectSeatWarn(int maxSeat) {
    return '最大$maxSeat席までお選びいただけます';
  }

  @override
  String get selectSeat_confirmSelectSeat => '座席を確定する';

  @override
  String get selectSeat_notSelectSeatWarn => '座席を選択してください';

  @override
  String get home_home => 'ホーム';

  @override
  String get home_ticket => 'チケット';

  @override
  String get home_cinema => '映画館';

  @override
  String get home_me => 'マイページ';

  @override
  String get ticket_showTime => '上映時間';

  @override
  String get ticket_endTime => '予想終了時間';

  @override
  String get ticket_seatCount => '座席数';

  @override
  String get ticket_noData => 'まだチケットがありません';

  @override
  String get ticket_noDataTip => 'チケットを購入してください！';

  @override
  String get ticket_status_valid => '有効';

  @override
  String get ticket_status_used => '使用済み';

  @override
  String get ticket_status_expired => '期限切れ';

  @override
  String get ticket_status_cancelled => 'キャンセル済み';

  @override
  String get ticket_time_unknown => '時間不明';

  @override
  String get ticket_time_formatError => '時間形式エラー';

  @override
  String ticket_time_remaining_days(Object days) {
    return 'あと$days日';
  }

  @override
  String ticket_time_remaining_hours(Object hours) {
    return 'あと$hours時間';
  }

  @override
  String ticket_time_remaining_minutes(Object minutes) {
    return 'あと$minutes分';
  }

  @override
  String get ticket_time_remaining_soon => 'まもなく開始';

  @override
  String get ticket_time_weekdays_monday => '月曜日';

  @override
  String get ticket_time_weekdays_tuesday => '火曜日';

  @override
  String get ticket_time_weekdays_wednesday => '水曜日';

  @override
  String get ticket_time_weekdays_thursday => '木曜日';

  @override
  String get ticket_time_weekdays_friday => '金曜日';

  @override
  String get ticket_time_weekdays_saturday => '土曜日';

  @override
  String get ticket_time_weekdays_sunday => '日曜日';

  @override
  String get ticket_ticketCount => 'チケット数';

  @override
  String get ticket_totalPurchased => '合計購入';

  @override
  String get ticket_tickets => '枚のチケット';

  @override
  String get ticket_tapToView => 'タップして詳細を表示';

  @override
  String get ticket_buyTickets => 'チケットを購入';

  @override
  String ticket_shareTicket(Object movieName) {
    return '映画チケットをシェア: $movieName';
  }

  @override
  String get ticket_benefit_feedback_lead => '他のお客様のため、特典在庫を教えてください';

  @override
  String get ticket_benefit_feedback_btn => 'フィードバック';

  @override
  String get ticket_benefit_feedback_select_ticket => 'フィードバックする回を選択';

  @override
  String get showTime_benefit_feedback_soldOut => '网友反馈：本日終了';

  @override
  String get common_loading => '読み込み中...';

  @override
  String get common_error_title => 'エラーが発生しました';

  @override
  String get common_error_message => 'データの読み込みに失敗しました。後でもう一度お試しください';

  @override
  String get common_retry => '再読み込み';

  @override
  String get common_network_error_connectionRefused =>
      'サーバー接続が拒否されました。後でもう一度お試しください';

  @override
  String get common_network_error_noRouteToHost =>
      'サーバーに接続できません。ネットワーク接続を確認してください';

  @override
  String get common_network_error_connectionTimeout =>
      '接続がタイムアウトしました。ネットワークを確認するか、後でもう一度お試しください';

  @override
  String get common_network_error_networkUnreachable =>
      'ネットワークに到達できません。ネットワーク設定を確認してください';

  @override
  String get common_network_error_hostLookupFailed =>
      'サーバーアドレスを解決できません。ネットワーク設定を確認してください';

  @override
  String get common_network_error_sendTimeout =>
      'リクエストがタイムアウトしました。後でもう一度お試しください';

  @override
  String get common_network_error_receiveTimeout =>
      'レスポンスがタイムアウトしました。後でもう一度お試しください';

  @override
  String get common_network_error_connectionError =>
      'ネットワーク接続エラーです。ネットワーク設定を確認してください';

  @override
  String get common_network_error_default => 'ネットワークリクエストが失敗しました。後でもう一度お試しください';

  @override
  String get common_unit_jpy => '円';

  @override
  String get common_unit_meter => 'm';

  @override
  String get common_unit_kilometer => 'km';

  @override
  String get common_unit_point => '点';

  @override
  String get common_components_cropper_title => '写真をトリミングする';

  @override
  String get common_components_cropper_actions_rotateLeft => '左へ回転';

  @override
  String get common_components_cropper_actions_rotateRight => '右へ回転';

  @override
  String get common_components_cropper_actions_flip => '反転';

  @override
  String get common_components_cropper_actions_undo => '元に戻す';

  @override
  String get common_components_cropper_actions_redo => 'やり直し';

  @override
  String get common_components_cropper_actions_reset => 'リセット';

  @override
  String get common_components_easyRefresh_refresh_dragText => '下に引っ張って更新';

  @override
  String get common_components_easyRefresh_refresh_armedText => '更新のために離してください';

  @override
  String get common_components_easyRefresh_refresh_readyText => '更新中...';

  @override
  String get common_components_easyRefresh_refresh_processingText =>
      '更新しています...';

  @override
  String get common_components_easyRefresh_refresh_processedText => '更新完了';

  @override
  String get common_components_easyRefresh_refresh_failedText => '更新失敗';

  @override
  String get common_components_easyRefresh_refresh_noMoreText => 'もうデータはありません';

  @override
  String get common_components_easyRefresh_loadMore_dragText =>
      '上に引っ張ってさらに読み込む';

  @override
  String get common_components_easyRefresh_loadMore_armedText =>
      'さらに読み込むために離してください';

  @override
  String get common_components_easyRefresh_loadMore_readyText => '読み込み中...';

  @override
  String get common_components_easyRefresh_loadMore_processingText =>
      '読み込んでいます...';

  @override
  String get common_components_easyRefresh_loadMore_processedText => '読み込み完了';

  @override
  String get common_components_easyRefresh_loadMore_failedText => '読み込み失敗';

  @override
  String get common_components_easyRefresh_loadMore_noMoreText =>
      'これ以上のデータはありません';

  @override
  String get common_components_sendVerifyCode_success => '認証コードが送信されました';

  @override
  String get common_components_filterBar_pleaseSelect => '選択してください';

  @override
  String get common_components_filterBar_reset => 'リセット';

  @override
  String get common_components_filterBar_confirm => '確定';

  @override
  String get common_components_filterBar_allDay => '終日';

  @override
  String get common_components_filterBar_noData => 'まだデータがありません';

  @override
  String get common_week_monday => '月曜日';

  @override
  String get common_week_tuesday => '火曜日';

  @override
  String get common_week_wednesday => '水曜日';

  @override
  String get common_week_thursday => '木曜日';

  @override
  String get common_week_friday => '金曜日';

  @override
  String get common_week_saturday => '土曜日';

  @override
  String get common_week_sunday => '日曜日';

  @override
  String get common_enum_seatType_wheelChair => '車椅子席';

  @override
  String get common_enum_seatType_coupleSeat => 'カップル席';

  @override
  String get common_enum_seatType_locked => 'ロック';

  @override
  String get common_enum_seatType_sold => '売り切れ';

  @override
  String get about_title => 'について';

  @override
  String get about_version => 'バージョン';

  @override
  String get about_description => '映画愛好家に便利なチケット購入体験を提供することに専念しています。';

  @override
  String get about_privacy_policy => 'プライバシーポリシーを表示';

  @override
  String get about_copyright => '© 2025 Otaku Movie 全著作権所有';

  @override
  String get about_components_sendVerifyCode_success => '認証コードが送信されました';

  @override
  String get about_components_filterBar_pleaseSelect => '選択してください';

  @override
  String get about_components_filterBar_reset => 'リセット';

  @override
  String get about_components_filterBar_confirm => '確認';

  @override
  String get about_components_showTimeList_all => 'すべて';

  @override
  String get about_components_showTimeList_unnamed => '名前なし';

  @override
  String get about_components_showTimeList_noData => 'まだデータがありません';

  @override
  String get about_components_showTimeList_noShowTimeInfo => '上映時間情報がありません';

  @override
  String about_components_showTimeList_moreShowTimes(Object count) {
    return 'あと $count 回の上映があります...';
  }

  @override
  String get about_components_showTimeList_timeRange => '上映開始時間';

  @override
  String get about_components_showTimeList_dubbingVersion => '吹き替え版';

  @override
  String get about_components_showTimeList_seatStatus_soldOut => '完売';

  @override
  String get about_components_showTimeList_seatStatus_limited => '残りわずか';

  @override
  String get about_components_showTimeList_seatStatus_available => '余裕あり';

  @override
  String get about_components_showTimeList_benefitBadge => '特典';

  @override
  String get about_login_verificationCode => '認証コード';

  @override
  String get about_login_email_verify_notNull => 'メールアドレスを入力してください';

  @override
  String get about_login_email_verify_isValid => '有効なメールアドレスを入力してください';

  @override
  String get about_login_email_text => 'メールアドレス';

  @override
  String get about_login_password_verify_notNull => 'パスワードを入力してください';

  @override
  String get about_login_password_verify_isValid => 'パスワードは6文字以上で入力してください';

  @override
  String get about_login_password_text => 'パスワード';

  @override
  String get about_login_loginButton => 'ログイン';

  @override
  String get about_login_welcomeText => 'おかえりなさい';

  @override
  String get about_login_forgotPassword => 'パスワードを忘れましたか？';

  @override
  String get about_login_or => 'または';

  @override
  String get about_login_googleLogin => 'Googleでログイン';

  @override
  String get about_login_noAccount => 'アカウントをお持ちでない方は？';

  @override
  String get about_register_registerButton => '登録';

  @override
  String get about_register_username_verify_notNull => 'ユーザー名を入力してください';

  @override
  String get about_register_username_text => 'ユーザー名';

  @override
  String get about_register_repeatPassword_text => 'パスワード確認';

  @override
  String get about_register_passwordNotMatchRepeatPassword => 'パスワードが一致しません';

  @override
  String get about_register_verifyCode_verify_isValid => '認証コードの形式が正しくありません';

  @override
  String get about_register_send => '送信';

  @override
  String get about_register_haveAccount => 'アカウントをお持ちの方は？';

  @override
  String get about_register_loginHere => '今すぐログイン';

  @override
  String get about_movieShowList_dropdown_area => '地域';

  @override
  String get about_movieShowList_dropdown_dimensionType => '上映タイプ';

  @override
  String get about_movieShowList_dropdown_screenSpec => '仕様';

  @override
  String get about_movieShowList_dropdown_subtitle => '字幕';

  @override
  String get about_movieShowList_dropdown_tag => 'タグ';

  @override
  String get about_movieShowList_dropdown_version => 'バージョン';

  @override
  String get enum_seatType_coupleSeat => 'カップルシート';

  @override
  String get enum_seatType_wheelChair => '車椅子席';

  @override
  String get enum_seatType_disabled => '選択不可';

  @override
  String get enum_seatType_selected => '選択済み';

  @override
  String get enum_seatType_locked => 'ロック済み';

  @override
  String get enum_seatType_sold => '販売済み';

  @override
  String get unit_point => '点';

  @override
  String get unit_jpy => '円';

  @override
  String get login_email_text => 'メール';

  @override
  String get login_email_verify_notNull => 'メールアドレスを入力してください';

  @override
  String get login_email_verify_isValid => 'メールアドレスが正しくありません';

  @override
  String get login_password_text => 'パスワード';

  @override
  String get login_password_verify_notNull => 'パスワードを入力してください';

  @override
  String get login_password_verify_isValid => '8〜16文字の英数字とアンダースコアを含めてください';

  @override
  String get login_loginButton => 'ログイン';

  @override
  String get login_welcomeText => 'おかえりなさい、アカウントにログインしてください';

  @override
  String get login_or => 'または';

  @override
  String get login_googleLogin => 'Googleでログイン';

  @override
  String get login_forgotPassword => 'パスワードを忘れましたか？';

  @override
  String get login_forgotPasswordTitle => 'パスワードを忘れた';

  @override
  String get login_forgotPasswordDescription => 'メールアドレスを入力してください。確認コードをお送りします';

  @override
  String get login_emailAddress => 'メールアドレス';

  @override
  String get login_newPassword => '新しいパスワード';

  @override
  String get login_sendVerificationCode => '認証コードを送信';

  @override
  String get login_resetPassword => 'パスワードをリセット';

  @override
  String get login_rememberPassword => 'パスワードを思い出しましたか？';

  @override
  String get login_backToLogin => 'ログインに戻る';

  @override
  String get login_emailRequired => 'メールアドレスを入力してください';

  @override
  String get login_emailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get login_verificationCodeRequired => '認証コードを入力してください';

  @override
  String get login_newPasswordRequired => '新しいパスワードを入力してください';

  @override
  String get login_passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get login_verificationCodeSent => '認証コードがメールに送信されました';

  @override
  String get login_passwordResetSuccess => 'パスワードリセットが成功しました';

  @override
  String get login_verificationCode => '認証コード';

  @override
  String get login_sendVerifyCodeButton => '認証コードを送信';

  @override
  String get login_noAccount => 'アカウントをお持ちでない方はこちら';

  @override
  String get register_repeatPassword_text => 'パスワード（確認）';

  @override
  String get register_repeatPassword_verify_notNull => '確認用パスワードを入力してください';

  @override
  String get register_repeatPassword_verify_isValid =>
      '8〜16文字の英数字とアンダースコアを含めてください';

  @override
  String get register_username_text => 'ユーザー名';

  @override
  String get register_username_verify_notNull => 'ユーザー名を入力してください';

  @override
  String get register_passwordNotMatchRepeatPassword => '2回入力したパスワードは一致しません';

  @override
  String get register_verifyCode_verify_notNull => '認証コードを入力してください';

  @override
  String get register_verifyCode_verify_isValid => '6桁の数字を入力してください';

  @override
  String get register_registerButton => '登録してログイン';

  @override
  String get register_send => '送信';

  @override
  String get register_haveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get register_loginHere => 'こちらからログイン';

  @override
  String get movieList_tabBar_currentlyShowing => '現在上映中';

  @override
  String get movieList_tabBar_comingSoon => '近日公開';

  @override
  String get movieList_currentlyShowing_level => '映倫';

  @override
  String get movieList_comingSoon_noDate => '日程未定';

  @override
  String get movieList_placeholder => 'すべての映画を検索';

  @override
  String get movieList_buy => 'チケット購入';

  @override
  String get movieList_tag_reRelease => '再上映';

  @override
  String get movieDetail_button_want => '見たい';

  @override
  String get movieDetail_button_saw => '見た';

  @override
  String get movieDetail_button_buy => 'チケット購入';

  @override
  String get movieDetail_viewPresaleTicket => '前売り券';

  @override
  String get movieDetail_presaleHasBonus => '特典付き';

  @override
  String get movieDetail_comment_reply => '返信';

  @override
  String movieDetail_comment_replyTo(String reply) {
    return '@$reply に返信';
  }

  @override
  String movieDetail_comment_translate(String language) {
    return '$languageへ翻訳';
  }

  @override
  String get movieDetail_comment_delete => '削除';

  @override
  String get movieDetail_writeComment => 'コメントを書く';

  @override
  String get movieDetail_detail_noDate => '上映日未定';

  @override
  String get movieDetail_detail_basicMessage => '基本情報';

  @override
  String get movieDetail_detail_originalName => '原題';

  @override
  String get movieDetail_detail_time => '上映時間';

  @override
  String get movieDetail_reReleaseHistory_title => '再上映履歴';

  @override
  String get movieDetail_reReleaseHistory_disabled => '無効';

  @override
  String get movieDetail_reReleaseHistory_start => '開始';

  @override
  String get movieDetail_reReleaseHistory_end => '終了';

  @override
  String get movieDetail_reReleaseHistory_duration => '上映時間';

  @override
  String get movieDetail_detail_spec => '上映仕様';

  @override
  String get movieDetail_detail_tags => 'タグ';

  @override
  String get movieDetail_detail_homepage => '公式サイト';

  @override
  String get movieDetail_detail_state => '上映状況';

  @override
  String get movieDetail_detail_level => 'レーティング';

  @override
  String get movieDetail_detail_staff => 'スタッフ';

  @override
  String get movieDetail_detail_character => 'キャラクター';

  @override
  String get movieDetail_detail_comment => 'コメント';

  @override
  String get movieDetail_detail_duration_unknown => '不明';

  @override
  String get movieDetail_detail_duration_minutes => '分';

  @override
  String get movieDetail_detail_duration_hours => '時間';

  @override
  String movieDetail_detail_duration_hoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String movieDetail_detail_totalReplyMessage(int total) {
    return '合計 $total 件の返信';
  }

  @override
  String get commentDetail_title => 'コメント詳細';

  @override
  String get commentDetail_replyComment => 'コメント返信';

  @override
  String commentDetail_totalReplyMessage(int total) {
    return '合計 $total 件の返信';
  }

  @override
  String commentDetail_comment_placeholder(String reply) {
    return '$reply に返信';
  }

  @override
  String get commentDetail_comment_hint => '返信を入力してください...';

  @override
  String get commentDetail_comment_button => '返信';

  @override
  String get movieTicketType_total => '合計';

  @override
  String get movieTicketType_title => '映画チケットの種類を選択してください';

  @override
  String get movieTicketType_seatNumber => '座席番号';

  @override
  String get movieTicketType_selectMovieTicketType => '映画チケットの種類を選んでください';

  @override
  String get movieTicketType_confirmOrder => '注文確認';

  @override
  String get movieTicketType_selectTicketTypeForSeats =>
      '各座席に適切なチケット種類を選択してください';

  @override
  String get movieTicketType_movieInfo => '映画情報';

  @override
  String get movieTicketType_showTime => '上映時間';

  @override
  String get movieTicketType_cinema => '映画館';

  @override
  String get movieTicketType_seatInfo => '座席情報';

  @override
  String get movieTicketType_ticketType => 'チケット種類';

  @override
  String get movieTicketType_price => '価格';

  @override
  String get movieTicketType_selectTicketType => 'チケット種類を選択';

  @override
  String get movieTicketType_totalPrice => '合計金額';

  @override
  String get movieTicketType_singleSeatPrice => '1座あたり料金';

  @override
  String get movieTicketType_seatCountLabel => '席';

  @override
  String get movieTicketType_priceRuleTitle => '料金計算ルール';

  @override
  String get movieTicketType_priceRuleFormula =>
      '1座あたり料金 = エリア料金 + チケット種類料金 + 特効仕様加算（3D・IMAX等、通常2Dはなし）';

  @override
  String get movieTicketType_actualPrice => '実際の支払い';

  @override
  String get movieTicketType_mubitikeTitle => 'ムビチケ前売り券';

  @override
  String get movieTicketType_mubitikeDescription =>
      '使用でチケット料金を相殺。3D・IMAX等の加算料金は別途お支払いください。';

  @override
  String get movieTicketType_mubitikeCode => '購票番号（10桁）';

  @override
  String get movieTicketType_mubitikeCodeHint => '10桁の購票番号を入力';

  @override
  String get movieTicketType_mubitikePassword => 'パスワード（4桁）';

  @override
  String get movieTicketType_mubitikePasswordHint => '4桁のパスワードを入力';

  @override
  String get movieTicketType_mubitikeUseCount => '使用枚数';

  @override
  String get movieTicketType_mubitikeTapToInput => 'タップして入力';

  @override
  String get movieTicketType_mubitikeUsageLimit => '1枚の前売り券は1人1回の鑑賞のみに使用可能です';

  @override
  String get movieTicketType_mubitikeDetailsTitle => '利用明細';

  @override
  String get movieTicketType_mubitikeDetails =>
      '• 使用でチケット料金を相殺\n• 3D・IMAX等の加算料金は別途\n• 1枚1人1回のみ使用可能';

  @override
  String get movieTicketType_fixedPrice => '固定料金';

  @override
  String get movieTicketType_noSeatInfoRetry => '座席情報を取得できませんでした。座席を再度選択してください';

  @override
  String get movieTicketType_sessionSurchargeTitle => '本上映の加算：';

  @override
  String movieTicketType_unavailableSeatsWithNames(String names) {
    return '一部の座席は利用できません。再度選択してください：$names';
  }

  @override
  String get movieTicketType_createOrderNoOrderNumber =>
      '注文作成に失敗しました。注文番号が返されませんでした';

  @override
  String get movieTicketType_unknownTicketType => '不明なチケット種類';

  @override
  String get movieTicketType_priceRuleFormula_fixed =>
      '1座あたり料金 = 固定料金 + エリア加算 + 仕様加算 + 上映类型加算（2D/3D）';

  @override
  String get movieTicketType_priceDetailTitle => '料金明細';

  @override
  String get movieTicketType_priceDetail_mubitikeOffset => '券抵';

  @override
  String get movieTicketType_priceDetail_fullPrice => '通常料金';

  @override
  String get seatCancel_confirmTitle => '座席選択をキャンセル';

  @override
  String get seatCancel_confirmMessage => '座席を選択済みです。選択した座席をキャンセルしますか？';

  @override
  String get seatCancel_cancel => 'キャンセル';

  @override
  String get seatCancel_confirm => '確定';

  @override
  String get seatCancel_successMessage => '座席選択がキャンセルされました';

  @override
  String get seatCancel_errorMessage => '座席選択のキャンセルに失敗しました。再試行してください';

  @override
  String get confirmOrder_noSpec => '仕様情報なし';

  @override
  String get confirmOrder_payFailed => '支払いに失敗しました。もう一度お試しください';

  @override
  String get confirmOrder_title => '注文確認';

  @override
  String get confirmOrder_total => '合計';

  @override
  String get confirmOrder_selectPayMethod => '支払い方法を選択してください';

  @override
  String get confirmOrder_pay => '支払いへ';

  @override
  String get confirmOrder_selectedSeats => '選択済み座席';

  @override
  String confirmOrder_seatCount(int count) {
    return '$count席';
  }

  @override
  String get confirmOrder_timeInfo => '時間情報';

  @override
  String get confirmOrder_cinemaInfo => '映画館情報';

  @override
  String get confirmOrder_countdown => '残り時間';

  @override
  String get confirmOrder_cancelOrder => '注文をキャンセル';

  @override
  String get confirmOrder_cancelOrderConfirm =>
      '座席を選択済みです。注文をキャンセルして選択済みの座席を解放しますか？';

  @override
  String get confirmOrder_continuePay => '支払いを続ける';

  @override
  String get confirmOrder_confirmCancel => 'キャンセル確認';

  @override
  String get confirmOrder_orderCanceled => '注文がキャンセルされました';

  @override
  String get confirmOrder_cancelOrderFailed => '注文のキャンセルに失敗しました。再試行してください';

  @override
  String get confirmOrder_orderTimeout => '注文タイムアウト処理中...';

  @override
  String get confirmOrder_orderTimeoutMessage => '注文がタイムアウトしました。自動的にキャンセルされました';

  @override
  String get confirmOrder_timeoutFailed => '注文タイムアウト処理に失敗しました。再試行してください';

  @override
  String get seatSelection_cancelSeatTitle => '座席選択をキャンセル';

  @override
  String get seatSelection_cancelSeatConfirm => '座席を選択済みです。選択済みの座席をキャンセルしますか？';

  @override
  String get seatSelection_cancel => 'キャンセル';

  @override
  String get seatSelection_confirm => '確定';

  @override
  String get seatSelection_seatCanceled => '座席選択がキャンセルされました';

  @override
  String get seatSelection_cancelSeatFailed => '座席選択のキャンセルに失敗しました。再試行してください';

  @override
  String get seatSelection_hasLockedOrderTitle => '未完了の注文';

  @override
  String get seatSelection_hasLockedOrderMessage =>
      '未完了の注文があります。座席がロックされています。お支払いまたは注文のキャンセルをお願いします';

  @override
  String get seatSelection_later => '後で';

  @override
  String get seatSelection_goToPay => '支払う';

  @override
  String get seatSelection_screen => 'スクリーン';

  @override
  String get user_title => 'マイページ';

  @override
  String get user_data_orderCount => '注文数';

  @override
  String get user_data_watchHistory => '鑑賞履歴';

  @override
  String get user_data_wantCount => '観たい数';

  @override
  String get user_data_characterCount => 'キャラクター数';

  @override
  String get user_data_staffCount => 'スタッフ数';

  @override
  String get user_registerTime => '登録日時';

  @override
  String get user_language => '言語';

  @override
  String get user_editProfile => 'プロフィール編集';

  @override
  String get user_privateAgreement => 'プライバシーポリシー';

  @override
  String get user_checkUpdate => 'アップデート確認';

  @override
  String get user_about => 'アプリについて';

  @override
  String get user_logout => 'ログアウト';

  @override
  String get user_currentVersion => '現在のバージョン';

  @override
  String get user_latestVersion => '最新バージョン';

  @override
  String get user_updateAvailable => '新しいバージョンが見つかりました。今すぐ更新しますか？';

  @override
  String get user_cancel => 'キャンセル';

  @override
  String get user_update => '更新';

  @override
  String get user_updating => '更新中';

  @override
  String get user_updateProgress => '更新をダウンロード中です。お待ちください...';

  @override
  String get user_updateSuccess => '更新成功';

  @override
  String get user_updateSuccessMessage => 'アプリが最新バージョンに正常に更新されました！';

  @override
  String get user_updateError => '更新失敗';

  @override
  String get user_updateErrorMessage => '更新中にエラーが発生しました。後でもう一度お試しください。';

  @override
  String get user_noUpdateAvailable => 'すでに最新バージョンです';

  @override
  String get user_forceUpdateHint => '現在のバージョンはサポート対象外です。更新後にご利用ください。';

  @override
  String get user_updateReleaseNotes => '更新内容';

  @override
  String get user_updateDialogTitle => 'アップデートのご案内';

  @override
  String get user_updateToLatestHint => '最新版にアップデート';

  @override
  String get user_updatePackageSizeLabel => 'サイズ';

  @override
  String user_updateWhatsNewInVersion(String version) {
    return 'v$version の新機能';
  }

  @override
  String get user_updateRemindLater => 'あとで通知';

  @override
  String get user_ok => 'OK';

  @override
  String get orderList_title => '注文一覧';

  @override
  String get orderList_orderNumber => '注文番号';

  @override
  String get orderList_comment => 'コメント';

  @override
  String get orderDetail_title => '注文詳細';

  @override
  String get orderDetail_countdown_title => 'まもなく上映開始';

  @override
  String get orderDetail_countdown_started => '上映開始済み';

  @override
  String orderDetail_countdown_hoursMinutes(Object hours, Object minutes) {
    return '上映開始まであと $hours 時間 $minutes 分';
  }

  @override
  String orderDetail_countdown_minutesSeconds(Object minutes, Object seconds) {
    return '上映開始まであと $minutes 分 $seconds 秒';
  }

  @override
  String orderDetail_countdown_seconds(Object seconds) {
    return '上映開始まであと $seconds 秒';
  }

  @override
  String get orderDetail_ticketCode => 'チケットコード';

  @override
  String orderDetail_ticketCount(int ticketCount) {
    return '映画チケット $ticketCount 枚';
  }

  @override
  String get orderDetail_orderNumber => '注文番号';

  @override
  String get orderDetail_orderState => '注文状態';

  @override
  String get orderDetail_orderCreateTime => '注文作成日時';

  @override
  String get orderDetail_payTime => '支払日時';

  @override
  String get orderDetail_payMethod => '支払い方法';

  @override
  String get orderDetail_seatMessage => '座席情報';

  @override
  String get orderDetail_orderMessage => '注文情報';

  @override
  String get orderDetail_failureReason => '失敗理由';

  @override
  String get orderDetail_benefit_feedback_title => '特典フィードバック';

  @override
  String get orderDetail_benefit_feedback_hint =>
      'この劇場で鑑賞時に、下記特典が終了していた場合は送信してください。在庫表示を更新し、他のお客様の参考にします。';

  @override
  String get orderDetail_benefit_feedback_cinema_label => '対象劇場';

  @override
  String get orderDetail_benefit_feedback_benefit_label => '特典';

  @override
  String get orderDetail_benefit_feedback_submit => '送信：この劇場で終了';

  @override
  String get payResult_title => '支払い完了';

  @override
  String get payResult_success => '支払い成功';

  @override
  String get payResult_ticketCode => 'チケットコード';

  @override
  String get payResult_qrCodeTip => 'このQRコードまたはチケットコードで劇場でチケットを受け取ってください';

  @override
  String get payResult_viewMyTickets => 'マイチケットを見る';

  @override
  String get userProfile_title => '個人情報';

  @override
  String get userProfile_avatar => 'アバター';

  @override
  String get userProfile_username => 'ユーザー名';

  @override
  String get userProfile_email => 'メール';

  @override
  String get userProfile_registerTime => '登録日時';

  @override
  String get userProfile_save => '保存';

  @override
  String get userProfile_edit_tip => '保存ボタンをクリックして変更を保存';

  @override
  String get userProfile_edit_username_placeholder => 'ユーザー名を入力してください';

  @override
  String get userProfile_edit_username_verify_notNull => 'ユーザー名は必須です';

  @override
  String get movieShowList_dropdown_area => '地域';

  @override
  String get movieShowList_dropdown_dimensionType => '上映タイプ';

  @override
  String get movieShowList_dropdown_screenSpec => '上映仕様';

  @override
  String get movieShowList_dropdown_subtitle => '字幕';

  @override
  String get movieShowList_dropdown_tag => 'タグ';

  @override
  String get movieShowList_dropdown_version => 'バージョン';

  @override
  String get payment_addCreditCard_title => 'クレジットカードを追加';

  @override
  String get payment_addCreditCard_cardNumber => 'カード番号';

  @override
  String get payment_addCreditCard_cardNumberHint => 'カード番号を入力してください';

  @override
  String get payment_addCreditCard_cardNumberError => '有効なカード番号を入力してください';

  @override
  String get payment_addCreditCard_cardNumberLength => 'カード番号の長さが正しくありません';

  @override
  String get payment_addCreditCard_cardHolderName => 'カード名義';

  @override
  String get payment_addCreditCard_cardHolderNameHint => 'カード名義を入力してください';

  @override
  String get payment_addCreditCard_cardHolderNameError => 'カード名義を入力してください';

  @override
  String get payment_addCreditCard_expiryDate => '有効期限';

  @override
  String get payment_addCreditCard_expiryDateHint => 'MM/YY';

  @override
  String get payment_addCreditCard_expiryDateError => '有効期限を入力してください';

  @override
  String get payment_addCreditCard_expiryDateInvalid => '有効期限の形式が正しくありません';

  @override
  String get payment_addCreditCard_expiryDateExpired => 'カードの有効期限が切れています';

  @override
  String get payment_addCreditCard_cvv => 'セキュリティコード';

  @override
  String get payment_addCreditCard_cvvHint => '•••';

  @override
  String get payment_addCreditCard_cvvError => 'セキュリティコードを入力してください';

  @override
  String get payment_addCreditCard_cvvLength => '長さが正しくありません';

  @override
  String get payment_addCreditCard_saveCard => 'このクレジットカードを保存';

  @override
  String get payment_addCreditCard_saveToAccount => 'アカウントに保存され、次回使用時に便利です';

  @override
  String get payment_addCreditCard_useOnce => '今回のみ使用、保存されません';

  @override
  String get payment_addCreditCard_confirmAdd => '追加確認';

  @override
  String get payment_addCreditCard_cardSaved => 'クレジットカードが保存されました';

  @override
  String get payment_addCreditCard_cardConfirmed => 'クレジットカード情報が確認されました';

  @override
  String get payment_addCreditCard_operationFailed => '操作に失敗しました。再試行してください';

  @override
  String get payment_selectCreditCard_title => 'クレジットカードを選択';

  @override
  String get payment_selectCreditCard_noCreditCard => 'クレジットカードがありません';

  @override
  String get payment_selectCreditCard_pleaseAddCard => 'クレジットカードを追加してください';

  @override
  String get payment_selectCreditCard_tempCard => '一時カード（今回のみ）';

  @override
  String payment_selectCreditCard_expiryDate(Object date) {
    return '有効期限: $date';
  }

  @override
  String get payment_selectCreditCard_removeTempCard => '一時カードを削除';

  @override
  String get payment_selectCreditCard_tempCardRemoved => '一時カードが削除されました';

  @override
  String get payment_selectCreditCard_addNewCard => '新しいクレジットカードを追加';

  @override
  String get payment_selectCreditCard_confirmPayment => '支払い確認';

  @override
  String get payment_selectCreditCard_pleaseSelectCard => 'クレジットカードを選択してください';

  @override
  String get payment_selectCreditCard_paymentSuccess => '支払い成功';

  @override
  String get payment_selectCreditCard_paymentFailed => '支払いに失敗しました。再試行してください';

  @override
  String get payment_selectCreditCard_loadFailed => 'クレジットカード一覧の読み込みに失敗しました';

  @override
  String get payment_selectCreditCard_tempCardSelected => '一時クレジットカードが選択されました';

  @override
  String get payError_title => '支払い失敗';

  @override
  String get payError_message => '注文に問題が発生しました。しばらくしてから再度お試しください。';

  @override
  String get payError_back => '戻る';

  @override
  String get cinemaList_allArea => '全地域';

  @override
  String get cinemaList_title => '近くの映画館';

  @override
  String get cinemaList_allCinemas => 'すべての映画館';

  @override
  String get cinemaList_address => '現在地を取得中';

  @override
  String get cinemaList_currentLocation => '現在地';

  @override
  String get cinemaList_search_hint => '映画館名または住所を検索';

  @override
  String get cinemaList_search_clear => 'クリア';

  @override
  String cinemaList_search_results_found(Object count) {
    return '$count 件の関連映画館が見つかりました';
  }

  @override
  String get cinemaList_search_results_notFound =>
      '関連する映画館が見つかりません。他のキーワードをお試しください';

  @override
  String get cinemaList_filter_title => '地域でフィルター';

  @override
  String get cinemaList_filter_brand => 'ブランド';

  @override
  String get cinemaList_filter_loading => '地域データを読み込み中...';

  @override
  String get cinemaList_loading => '読み込みに失敗しました。再試行してください';

  @override
  String get cinemaList_empty_noData => '映画館データがありません';

  @override
  String get cinemaList_empty_noDataTip => '後でもう一度お試しください';

  @override
  String get cinemaList_empty_noSearchResults => '関連する映画館が見つかりません';

  @override
  String get cinemaList_empty_noSearchResultsTip => '他のキーワードをお試しください';

  @override
  String get cinemaList_movies_nowShowing => '上映中';

  @override
  String get cinemaList_movies_empty => '上映中の映画はありません';

  @override
  String get cinemaList_selectSeat_selectedSeats => '選択済み座席';

  @override
  String get cinemaList_selectSeat_pleaseSelectSeats => '座席を選択してください';

  @override
  String cinemaList_selectSeat_confirmSelection(Object count) {
    return '$count 席の選択を確認';
  }

  @override
  String cinemaList_selectSeat_seatsSelected(Object count) {
    return '$count 席を選択しました';
  }

  @override
  String get cinemaList_selectSeat_dateFormat => 'yyyy年MM月dd日';

  @override
  String get forgotPassword_title => 'パスワードを忘れた';

  @override
  String get forgotPassword_description => 'メールアドレスを入力してください。認証コードをお送りします';

  @override
  String get forgotPassword_emailAddress => 'メールアドレス';

  @override
  String get forgotPassword_verificationCode => '認証コード';

  @override
  String get forgotPassword_newPassword => '新しいパスワード';

  @override
  String get forgotPassword_sendVerificationCode => '認証コードを送信';

  @override
  String get forgotPassword_resetPassword => 'パスワードをリセット';

  @override
  String get forgotPassword_rememberPassword => 'パスワードを思い出しましたか？';

  @override
  String get forgotPassword_backToLogin => 'ログインに戻る';

  @override
  String get forgotPassword_emailRequired => 'メールアドレスを入力してください';

  @override
  String get forgotPassword_emailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get forgotPassword_verificationCodeRequired => '認証コードを入力してください';

  @override
  String get forgotPassword_newPasswordRequired => '新しいパスワードを入力してください';

  @override
  String get forgotPassword_passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get forgotPassword_verificationCodeSent => '認証コードがメールに送信されました';

  @override
  String get forgotPassword_passwordResetSuccess => 'パスワードリセットが成功しました';

  @override
  String get presaleDetail_title => '前売り券';

  @override
  String get presaleDetail_specs => '仕様';

  @override
  String get presaleDetail_salePeriodNote =>
      '※ 販売期間・利用期間は劇場により異なる場合があります。各劇場の案内をご確認ください';

  @override
  String get presaleDetail_applyMovie => '対象作品';

  @override
  String get presaleDetail_salePeriod => '販売期間';

  @override
  String get presaleDetail_usagePeriod => '利用期間';

  @override
  String get presaleDetail_perUserLimit => 'お一人様';

  @override
  String get presaleDetail_noLimit => '制限なし';

  @override
  String get presaleDetail_pickupNotes => 'チケット受け取りについて';

  @override
  String get presaleDetail_gallery => 'ギャラリー';

  @override
  String get presaleDetail_price => '価格';

  @override
  String get presaleDetail_bonus => '特典';

  @override
  String get presaleDetail_bonusDescription => '特典の説明';

  @override
  String presaleDetail_bonusCount(int count) {
    return '$count枚';
  }

  @override
  String get benefit_hasBenefitsLabel => '入場者特典あり';

  @override
  String get benefit_hasBenefitsLabel_reRelease => '再上映特典';

  @override
  String get benefit_pageTitle => '入場者特典';

  @override
  String get benefit_empty => 'この作品に特典情報はありません';

  @override
  String get benefit_phase => 'フェーズ';

  @override
  String get benefit_period => '期間';

  @override
  String get benefit_items => '物料';

  @override
  String get benefit_total => '総数';

  @override
  String get benefit_remaining => '残り';

  @override
  String get benefit_status_sufficient => '十分';

  @override
  String get benefit_status_few => '残りわずか';

  @override
  String get benefit_status_veryFew => 'ほぼ無し';

  @override
  String get benefit_status_soldOut => '終了';

  @override
  String get benefit_status_unknown => '不明';

  @override
  String get benefit_phaseStatus_before => '開始前';

  @override
  String get benefit_phaseStatus_ongoing => '実施中';

  @override
  String get benefit_phaseStatus_ended => '終了';

  @override
  String get benefit_unit_thousand => '千';

  @override
  String get benefit_unit_tenThousand => '万';

  @override
  String get benefit_limit => '限定';

  @override
  String get benefit_limit_cinema => '指定劇場のみ';

  @override
  String get benefit_limit_dimension_2d => '2D';

  @override
  String get benefit_limit_dimension_3d => '3D';

  @override
  String get benefit_feedback_hint =>
      '某劇場でこのフェーズの特典が終了している場合は、劇場を選択してフィードバックしてください。チケット購入は不要です。';

  @override
  String get benefit_feedback_select_cinema => '劇場を選択';

  @override
  String get benefit_feedback_submit => 'フィードバック：この劇場で終了';

  @override
  String get benefit_feedback_success => 'フィードバックありがとうございます';

  @override
  String get benefit_feedback_please_select_cinema => '先に劇場を選択してください';

  @override
  String get benefit_feedback_button => 'フィードバック';

  @override
  String get benefit_feedback_select_phase => 'フェーズを選択';

  @override
  String get benefit_feedback_please_select_phase => '先にフェーズを選択してください';

  @override
  String get comingSoon_presale => '前売り';

  @override
  String get comingSoon_presaleTicketBadge => '前売り券';

  @override
  String get comingSoon_releaseDate => '公開';

  @override
  String get comingSoon_noMovies => '現在上映中の映画はありません';

  @override
  String get comingSoon_tryLaterOrRefresh =>
      'しばらくしてからもう一度お試しいただくか、下にスワイプして更新してください';

  @override
  String get comingSoon_pullToRefresh => '下にスワイプして更新';
}
