// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get writeComment_title => '写评论';

  @override
  String get writeComment_hint => '写下你的评论...';

  @override
  String get writeComment_rateTitle => '为这部电影评分';

  @override
  String get writeComment_contentTitle => '写下你的观影感受';

  @override
  String get writeComment_shareExperience => '分享你的观影体验，帮助其他人做出选择';

  @override
  String get writeComment_publishFailed => '评论发布失败，请重试';

  @override
  String get writeComment_verify_notNull => '评论不能为空';

  @override
  String get writeComment_verify_notRate => '请给电影评分';

  @override
  String get writeComment_verify_movieIdEmpty => '电影ID不能为空';

  @override
  String get writeComment_release => '发布';

  @override
  String get search_noData => '暂无数据';

  @override
  String get search_placeholder => '搜索全部电影';

  @override
  String get search_history => '搜索历史';

  @override
  String get search_removeHistoryConfirm_title => '删除历史记录';

  @override
  String get search_removeHistoryConfirm_content => '是否确定要删除历史记录?';

  @override
  String get search_removeHistoryConfirm_confirm => '确定';

  @override
  String get search_removeHistoryConfirm_cancel => '取消';

  @override
  String get search_level => '分级';

  @override
  String get showTimeDetail_address => '地址';

  @override
  String get showTimeDetail_buy => '选座';

  @override
  String get showTimeDetail_time => '分';

  @override
  String get showTimeDetail_seatStatus_available => '座位充足';

  @override
  String get showTimeDetail_seatStatus_tight => '座位紧张';

  @override
  String get showTimeDetail_seatStatus_soldOut => '已售罄';

  @override
  String get cinemaDetail_tel => '联系方式';

  @override
  String get cinemaDetail_address => '地址';

  @override
  String get cinemaDetail_homepage => '官网';

  @override
  String get cinemaDetail_showing => '正在上映';

  @override
  String get cinemaDetail_specialSpecPrice => '特殊上映价格';

  @override
  String get cinemaDetail_ticketTypePrice => '普通影票价格';

  @override
  String get cinemaDetail_maxSelectSeat => '最大可选座位数';

  @override
  String get cinemaDetail_theaterSpec => '影厅信息';

  @override
  String cinemaDetail_seatCount(int seatCount) {
    return '$seatCount个座位';
  }

  @override
  String selectSeat_maxSelectSeatWarn(int maxSeat) {
    return '最大选座数量不能超过$maxSeat个';
  }

  @override
  String get selectSeat_confirmSelectSeat => '确认选座';

  @override
  String get selectSeat_notSelectSeatWarn => '请选择座位';

  @override
  String get home_home => '首页';

  @override
  String get home_ticket => '我的票';

  @override
  String get home_cinema => '电影院';

  @override
  String get home_me => '我的';

  @override
  String get ticket_showTime => '放映时间';

  @override
  String get ticket_endTime => '预计结束';

  @override
  String get ticket_seatCount => '座位数';

  @override
  String get ticket_noData => '暂无电影票';

  @override
  String get ticket_noDataTip => '快去购买电影票吧！';

  @override
  String get ticket_status_valid => '有效';

  @override
  String get ticket_status_used => '已使用';

  @override
  String get ticket_status_expired => '已过期';

  @override
  String get ticket_status_cancelled => '已取消';

  @override
  String get ticket_time_unknown => '时间未知';

  @override
  String get ticket_time_formatError => '时间格式错误';

  @override
  String ticket_time_remaining_days(Object days) {
    return '还有$days天';
  }

  @override
  String ticket_time_remaining_hours(Object hours) {
    return '还有$hours小时';
  }

  @override
  String ticket_time_remaining_minutes(Object minutes) {
    return '还有$minutes分钟';
  }

  @override
  String get ticket_time_remaining_soon => '即将开始';

  @override
  String get ticket_time_weekdays_monday => '周一';

  @override
  String get ticket_time_weekdays_tuesday => '周二';

  @override
  String get ticket_time_weekdays_wednesday => '周三';

  @override
  String get ticket_time_weekdays_thursday => '周四';

  @override
  String get ticket_time_weekdays_friday => '周五';

  @override
  String get ticket_time_weekdays_saturday => '周六';

  @override
  String get ticket_time_weekdays_sunday => '周日';

  @override
  String get ticket_ticketCount => '票数';

  @override
  String get ticket_totalPurchased => '共购买';

  @override
  String get ticket_tickets => '张票';

  @override
  String get ticket_tapToView => '点击查看详情';

  @override
  String get ticket_buyTickets => '去购票';

  @override
  String ticket_shareTicket(Object movieName) {
    return '分享电影票: $movieName';
  }

  @override
  String get ticket_benefit_feedback_lead => '帮其他小伙伴确认下特典库存吧';

  @override
  String get ticket_benefit_feedback_btn => '去反馈';

  @override
  String get ticket_benefit_feedback_select_ticket => '选择要反馈的场次';

  @override
  String get showTime_benefit_feedback_soldOut => '网友反馈：今日已领完';

  @override
  String get common_loading => '加载中...';

  @override
  String get common_error_title => '出错了';

  @override
  String get common_error_message => '数据加载失败，请稍后重试';

  @override
  String get common_retry => '重新加载';

  @override
  String get common_network_error_connectionRefused => '服务器拒绝连接，请稍后重试';

  @override
  String get common_network_error_noRouteToHost => '无法连接到服务器，请检查网络连接';

  @override
  String get common_network_error_connectionTimeout => '连接超时，请检查网络或稍后重试';

  @override
  String get common_network_error_networkUnreachable => '网络不可达，请检查网络设置';

  @override
  String get common_network_error_hostLookupFailed => '无法解析服务器地址，请检查网络设置';

  @override
  String get common_network_error_sendTimeout => '发送请求超时，请稍后重试';

  @override
  String get common_network_error_receiveTimeout => '接收响应超时，请稍后重试';

  @override
  String get common_network_error_connectionError => '网络连接错误，请检查网络设置';

  @override
  String get common_network_error_default => '网络请求失败，请稍后重试';

  @override
  String get common_unit_jpy => '日元';

  @override
  String get common_unit_meter => '米';

  @override
  String get common_unit_kilometer => '公里';

  @override
  String get common_unit_point => '分';

  @override
  String get common_components_cropper_title => '裁剪';

  @override
  String get common_components_cropper_actions_rotateLeft => '向左旋转';

  @override
  String get common_components_cropper_actions_rotateRight => '向右旋转';

  @override
  String get common_components_cropper_actions_flip => '翻转';

  @override
  String get common_components_cropper_actions_undo => '撤销';

  @override
  String get common_components_cropper_actions_redo => '重做';

  @override
  String get common_components_cropper_actions_reset => '重置';

  @override
  String get common_components_easyRefresh_refresh_dragText => '下拉刷新';

  @override
  String get common_components_easyRefresh_refresh_armedText => '松开刷新';

  @override
  String get common_components_easyRefresh_refresh_readyText => '正在刷新...';

  @override
  String get common_components_easyRefresh_refresh_processingText => '刷新中...';

  @override
  String get common_components_easyRefresh_refresh_processedText => '刷新完成';

  @override
  String get common_components_easyRefresh_refresh_failedText => '刷新失败';

  @override
  String get common_components_easyRefresh_refresh_noMoreText => '没有更多数据了';

  @override
  String get common_components_easyRefresh_loadMore_dragText => '上拉加载更多';

  @override
  String get common_components_easyRefresh_loadMore_armedText => '松开加载更多';

  @override
  String get common_components_easyRefresh_loadMore_readyText => '正在加载...';

  @override
  String get common_components_easyRefresh_loadMore_processingText => '加载中...';

  @override
  String get common_components_easyRefresh_loadMore_processedText => '加载完成';

  @override
  String get common_components_easyRefresh_loadMore_failedText => '加载失败';

  @override
  String get common_components_easyRefresh_loadMore_noMoreText => '没有更多数据了';

  @override
  String get common_components_sendVerifyCode_success => '验证码发送成功';

  @override
  String get common_components_filterBar_pleaseSelect => '请选择';

  @override
  String get common_components_filterBar_reset => '重置';

  @override
  String get common_components_filterBar_confirm => '确定';

  @override
  String get common_components_filterBar_allDay => '全天';

  @override
  String get common_components_filterBar_noData => '暂无数据';

  @override
  String get common_week_monday => '周一';

  @override
  String get common_week_tuesday => '周二';

  @override
  String get common_week_wednesday => '周三';

  @override
  String get common_week_thursday => '周四';

  @override
  String get common_week_friday => '周五';

  @override
  String get common_week_saturday => '周六';

  @override
  String get common_week_sunday => '周日';

  @override
  String get common_enum_seatType_wheelChair => '轮椅座';

  @override
  String get common_enum_seatType_coupleSeat => '情侣座';

  @override
  String get common_enum_seatType_locked => '锁定';

  @override
  String get common_enum_seatType_sold => '已售';

  @override
  String get about_title => '关于';

  @override
  String get about_version => '版本号';

  @override
  String get about_description => '致力于为电影爱好者提供便捷的购票体验。';

  @override
  String get about_privacy_policy => '查看隐私协议';

  @override
  String get about_copyright => '© 2025 Otaku Movie 版权所有';

  @override
  String get about_components_sendVerifyCode_success => '验证码发送成功';

  @override
  String get about_components_filterBar_pleaseSelect => '请选择';

  @override
  String get about_components_filterBar_reset => '重置';

  @override
  String get about_components_filterBar_confirm => '确认';

  @override
  String get about_components_showTimeList_all => '全部';

  @override
  String get about_components_showTimeList_unnamed => '未命名';

  @override
  String get about_components_showTimeList_noData => '暂无数据';

  @override
  String get about_components_showTimeList_noShowTimeInfo => '暂无场次信息';

  @override
  String about_components_showTimeList_moreShowTimes(Object count) {
    return '还有 $count 个场次...';
  }

  @override
  String get about_components_showTimeList_timeRange => '开场时间';

  @override
  String get about_components_showTimeList_dubbingVersion => '配音版';

  @override
  String get about_components_showTimeList_seatStatus_soldOut => '售罄';

  @override
  String get about_components_showTimeList_seatStatus_limited => '紧张';

  @override
  String get about_components_showTimeList_seatStatus_available => '充足';

  @override
  String get about_components_showTimeList_benefitBadge => '特典';

  @override
  String get about_login_verificationCode => '验证码';

  @override
  String get about_login_email_verify_notNull => '邮箱不能为空';

  @override
  String get about_login_email_verify_isValid => '请输入有效的邮箱地址';

  @override
  String get about_login_email_text => '邮箱';

  @override
  String get about_login_password_verify_notNull => '密码不能为空';

  @override
  String get about_login_password_verify_isValid => '密码长度至少6位';

  @override
  String get about_login_password_text => '密码';

  @override
  String get about_login_loginButton => '登录';

  @override
  String get about_login_welcomeText => '欢迎回来';

  @override
  String get about_login_forgotPassword => '忘记密码？';

  @override
  String get about_login_or => '或';

  @override
  String get about_login_googleLogin => 'Google登录';

  @override
  String get about_login_noAccount => '还没有账号？';

  @override
  String get about_register_registerButton => '注册';

  @override
  String get about_register_username_verify_notNull => '用户名不能为空';

  @override
  String get about_register_username_text => '用户名';

  @override
  String get about_register_repeatPassword_text => '确认密码';

  @override
  String get about_register_passwordNotMatchRepeatPassword => '两次密码输入不一致';

  @override
  String get about_register_verifyCode_verify_isValid => '验证码格式不正确';

  @override
  String get about_register_send => '发送';

  @override
  String get about_register_haveAccount => '已有账号？';

  @override
  String get about_register_loginHere => '立即登录';

  @override
  String get about_movieShowList_dropdown_area => '地区';

  @override
  String get about_movieShowList_dropdown_dimensionType => '放映类型';

  @override
  String get about_movieShowList_dropdown_screenSpec => '规格';

  @override
  String get about_movieShowList_dropdown_subtitle => '字幕';

  @override
  String get about_movieShowList_dropdown_tag => '标签';

  @override
  String get about_movieShowList_dropdown_version => '版本';

  @override
  String get enum_seatType_coupleSeat => '情侣座';

  @override
  String get enum_seatType_wheelChair => '轮椅座';

  @override
  String get enum_seatType_disabled => '已禁用';

  @override
  String get enum_seatType_selected => '已选择';

  @override
  String get enum_seatType_locked => '已锁定';

  @override
  String get enum_seatType_sold => '已售出';

  @override
  String get unit_point => '分';

  @override
  String get unit_jpy => '日元';

  @override
  String get login_email_text => '邮箱';

  @override
  String get login_email_verify_notNull => '邮箱不能为空';

  @override
  String get login_email_verify_isValid => '邮箱不合法';

  @override
  String get login_password_text => '密码';

  @override
  String get login_password_verify_notNull => '密码不能为空';

  @override
  String get login_password_verify_isValid => '密码必须为8-16位，包含数字、字母和下划线';

  @override
  String get login_loginButton => '登录';

  @override
  String get login_welcomeText => '欢迎回来，请登录您的账户';

  @override
  String get login_or => '或';

  @override
  String get login_googleLogin => '使用 Google 登录';

  @override
  String get login_forgotPassword => '忘记密码？';

  @override
  String get login_forgotPasswordTitle => '忘记密码';

  @override
  String get login_forgotPasswordDescription => '输入您的邮箱地址，我们将发送验证码给您';

  @override
  String get login_emailAddress => '邮箱地址';

  @override
  String get login_newPassword => '新密码';

  @override
  String get login_sendVerificationCode => '发送验证码';

  @override
  String get login_resetPassword => '重置密码';

  @override
  String get login_rememberPassword => '想起密码了？';

  @override
  String get login_backToLogin => '返回登录';

  @override
  String get login_emailRequired => '请输入邮箱';

  @override
  String get login_emailInvalid => '请输入有效的邮箱地址';

  @override
  String get login_verificationCodeRequired => '请输入验证码';

  @override
  String get login_newPasswordRequired => '请输入新密码';

  @override
  String get login_passwordTooShort => '密码至少需要6位';

  @override
  String get login_verificationCodeSent => '验证码已发送至您的邮箱';

  @override
  String get login_passwordResetSuccess => '密码重置成功';

  @override
  String get login_verificationCode => '验证码';

  @override
  String get login_sendVerifyCodeButton => '发送验证码';

  @override
  String get login_noAccount => '还没有注册账号？';

  @override
  String get register_repeatPassword_text => '重复密码';

  @override
  String get register_repeatPassword_verify_notNull => '重复密码不能为空';

  @override
  String get register_repeatPassword_verify_isValid =>
      '重复密码必须为8-16位，包含数字、字母和下划线';

  @override
  String get register_username_text => '用户名称';

  @override
  String get register_username_verify_notNull => '用户名不能为空';

  @override
  String get register_passwordNotMatchRepeatPassword => '两次输入的密码不一致';

  @override
  String get register_verifyCode_verify_notNull => '验证码不能为空';

  @override
  String get register_verifyCode_verify_isValid => '验证码必须是6位纯数字';

  @override
  String get register_registerButton => '注册并登录';

  @override
  String get register_send => '发送';

  @override
  String get register_haveAccount => '已经有账号了？';

  @override
  String get register_loginHere => '点击登录';

  @override
  String get movieList_tabBar_currentlyShowing => '上映中';

  @override
  String get movieList_tabBar_comingSoon => '即将上映';

  @override
  String get movieList_currentlyShowing_level => '分级';

  @override
  String get movieList_comingSoon_noDate => '日期待定';

  @override
  String get movieList_placeholder => '搜索全部电影';

  @override
  String get movieList_buy => '购票';

  @override
  String get movieDetail_button_want => '想看';

  @override
  String get movieDetail_button_saw => '看过';

  @override
  String get movieDetail_button_buy => '购票';

  @override
  String get movieDetail_viewPresaleTicket => '预售票';

  @override
  String get movieDetail_presaleHasBonus => '含特典';

  @override
  String get movieDetail_comment_reply => '回复';

  @override
  String movieDetail_comment_replyTo(String reply) {
    return '回复@$reply';
  }

  @override
  String movieDetail_comment_translate(String language) {
    return '翻译为$language';
  }

  @override
  String get movieDetail_comment_delete => '删除';

  @override
  String get movieDetail_writeComment => '写评论';

  @override
  String get movieDetail_detail_noDate => '上映日期待定';

  @override
  String get movieDetail_detail_basicMessage => '基本信息';

  @override
  String get movieDetail_detail_originalName => '原名';

  @override
  String get movieDetail_detail_time => '时长';

  @override
  String get movieDetail_detail_spec => '上映规格';

  @override
  String get movieDetail_detail_tags => '标签';

  @override
  String get movieDetail_detail_homepage => '官网';

  @override
  String get movieDetail_detail_state => '上映状态';

  @override
  String get movieDetail_detail_level => '分级';

  @override
  String get movieDetail_detail_staff => '工作人员';

  @override
  String get movieDetail_detail_character => '角色';

  @override
  String get movieDetail_detail_comment => '评论';

  @override
  String get movieDetail_detail_duration_unknown => '未知';

  @override
  String get movieDetail_detail_duration_minutes => '分钟';

  @override
  String get movieDetail_detail_duration_hours => '小时';

  @override
  String movieDetail_detail_duration_hoursMinutes(int hours, int minutes) {
    return '$hours小时$minutes分钟';
  }

  @override
  String movieDetail_detail_totalReplyMessage(int total) {
    return '共$total条回复';
  }

  @override
  String get commentDetail_title => '评论详情';

  @override
  String get commentDetail_replyComment => '评论回复';

  @override
  String commentDetail_totalReplyMessage(int total) {
    return '共$total条回复';
  }

  @override
  String commentDetail_comment_placeholder(String reply) {
    return '给 $reply 回复';
  }

  @override
  String get commentDetail_comment_hint => '写下你的回复...';

  @override
  String get commentDetail_comment_button => '回复';

  @override
  String get movieTicketType_total => '合计';

  @override
  String get movieTicketType_title => '选择电影票类型';

  @override
  String get movieTicketType_seatNumber => '座位号';

  @override
  String get movieTicketType_selectMovieTicketType => '请选择电影票类型';

  @override
  String get movieTicketType_confirmOrder => '确认订单';

  @override
  String get movieTicketType_selectTicketTypeForSeats => '请为每个座位选择合适的票种';

  @override
  String get movieTicketType_movieInfo => '电影信息';

  @override
  String get movieTicketType_showTime => '放映时间';

  @override
  String get movieTicketType_cinema => '影院';

  @override
  String get movieTicketType_seatInfo => '座位信息';

  @override
  String get movieTicketType_ticketType => '票种';

  @override
  String get movieTicketType_price => '价格';

  @override
  String get movieTicketType_selectTicketType => '选择票种';

  @override
  String get movieTicketType_totalPrice => '总价';

  @override
  String get movieTicketType_singleSeatPrice => '单人票价';

  @override
  String get movieTicketType_seatCountLabel => '座';

  @override
  String get movieTicketType_priceRuleTitle => '价格计算规则';

  @override
  String get movieTicketType_priceRuleFormula =>
      '单人票价 = 区域价 + 票种价格 + 特效规格加价（3D/IMAX 等，普通 2D 无）';

  @override
  String get movieTicketType_actualPrice => '实付';

  @override
  String get movieTicketType_mubitikeTitle => 'ムビチケ前売り券';

  @override
  String get movieTicketType_mubitikeDescription =>
      '使用后可抵消票面价格，3D、IMAX 等加价需另付。';

  @override
  String get movieTicketType_mubitikeCode => '购票号码（10位）';

  @override
  String get movieTicketType_mubitikeCodeHint => '请输入10位购票号码';

  @override
  String get movieTicketType_mubitikePassword => '密码（4位）';

  @override
  String get movieTicketType_mubitikePasswordHint => '请输入4位密码';

  @override
  String get movieTicketType_mubitikeUseCount => '使用张数';

  @override
  String get movieTicketType_mubitikeTapToInput => '点击输入';

  @override
  String get movieTicketType_mubitikeUsageLimit => '每张预售券仅限1人1次观影使用';

  @override
  String get movieTicketType_mubitikeDetailsTitle => '使用明细';

  @override
  String get movieTicketType_mubitikeDetails =>
      '• 使用后可抵消票面价格\n• 3D、IMAX 等加价需另付\n• 每张券仅限1人1次观影使用';

  @override
  String get movieTicketType_fixedPrice => '固定票价';

  @override
  String get movieTicketType_noSeatInfoRetry => '未获取到当前选座信息，请重新选择座位';

  @override
  String get movieTicketType_sessionSurchargeTitle => '本场次加价：';

  @override
  String movieTicketType_unavailableSeatsWithNames(String names) {
    return '部分座位不可用，请重新选择：$names';
  }

  @override
  String get movieTicketType_createOrderNoOrderNumber => '创建订单失败，未返回订单号';

  @override
  String get movieTicketType_unknownTicketType => '未知票种';

  @override
  String get movieTicketType_priceRuleFormula_fixed =>
      '单人票价 = 固定票价 + 区域加价 + 规格加价 + 放映类型加价（2D/3D）';

  @override
  String get movieTicketType_priceDetailTitle => '价格明细';

  @override
  String get movieTicketType_priceDetail_mubitikeOffset => '券抵';

  @override
  String get movieTicketType_priceDetail_fullPrice => '全价';

  @override
  String get seatCancel_confirmTitle => '取消座位选择';

  @override
  String get seatCancel_confirmMessage => '您已选择了座位，确定要取消已选择的座位吗？';

  @override
  String get seatCancel_cancel => '取消';

  @override
  String get seatCancel_confirm => '确定';

  @override
  String get seatCancel_successMessage => '座位选择已取消';

  @override
  String get seatCancel_errorMessage => '取消座位选择失败，请重试';

  @override
  String get confirmOrder_noSpec => '无规格信息';

  @override
  String get confirmOrder_payFailed => '支付失败，请重试';

  @override
  String get confirmOrder_title => '确认订单';

  @override
  String get confirmOrder_total => '合计';

  @override
  String get confirmOrder_selectPayMethod => '选择支付方式';

  @override
  String get confirmOrder_pay => '支付';

  @override
  String get confirmOrder_selectedSeats => '已选座位';

  @override
  String confirmOrder_seatCount(int count) {
    return '$count个座位';
  }

  @override
  String get confirmOrder_timeInfo => '时间信息';

  @override
  String get confirmOrder_cinemaInfo => '影院信息';

  @override
  String get confirmOrder_countdown => '剩余时间';

  @override
  String get confirmOrder_cancelOrder => '取消订单';

  @override
  String get confirmOrder_cancelOrderConfirm => '您已选择了座位，确定要取消订单并释放已选择的座位吗？';

  @override
  String get confirmOrder_continuePay => '继续支付';

  @override
  String get confirmOrder_confirmCancel => '确认取消';

  @override
  String get confirmOrder_orderCanceled => '订单已取消';

  @override
  String get confirmOrder_cancelOrderFailed => '取消订单失败，请重试';

  @override
  String get confirmOrder_orderTimeout => '订单超时处理中...';

  @override
  String get confirmOrder_orderTimeoutMessage => '订单已超时，已自动取消';

  @override
  String get confirmOrder_timeoutFailed => '订单超时处理失败，请重试';

  @override
  String get seatSelection_cancelSeatTitle => '取消座位选择';

  @override
  String get seatSelection_cancelSeatConfirm => '您已选择了座位，确定要取消已选择的座位吗？';

  @override
  String get seatSelection_cancel => '取消';

  @override
  String get seatSelection_confirm => '确定';

  @override
  String get seatSelection_seatCanceled => '选择的座位已取消';

  @override
  String get seatSelection_cancelSeatFailed => '取消座位选择失败，请重试';

  @override
  String get seatSelection_hasLockedOrderTitle => '未完成订单';

  @override
  String get seatSelection_hasLockedOrderMessage =>
      '您有未完成的订单，座位已被锁定。请前往支付或取消订单';

  @override
  String get seatSelection_later => '稍后';

  @override
  String get seatSelection_goToPay => '去支付';

  @override
  String get seatSelection_screen => '屏幕';

  @override
  String get user_title => '我的';

  @override
  String get user_data_orderCount => '订单数';

  @override
  String get user_data_watchHistory => '观影记录';

  @override
  String get user_data_wantCount => '想看数';

  @override
  String get user_data_characterCount => '演员数';

  @override
  String get user_data_staffCount => '工作人员数';

  @override
  String get user_registerTime => '注册时间';

  @override
  String get user_language => '语言';

  @override
  String get user_editProfile => '编辑个人信息';

  @override
  String get user_privateAgreement => '隐私协议';

  @override
  String get user_checkUpdate => '检查更新';

  @override
  String get user_about => '关于';

  @override
  String get user_logout => '退出登录';

  @override
  String get user_currentVersion => '当前版本';

  @override
  String get user_latestVersion => '最新版本';

  @override
  String get user_updateAvailable => '发现新版本，是否立即更新？';

  @override
  String get user_cancel => '取消';

  @override
  String get user_update => '更新';

  @override
  String get user_updating => '正在更新';

  @override
  String get user_updateProgress => '正在下载更新，请稍候...';

  @override
  String get user_updateSuccess => '更新成功';

  @override
  String get user_updateSuccessMessage => '应用已成功更新到最新版本！';

  @override
  String get user_updateError => '更新失败';

  @override
  String get user_updateErrorMessage => '更新过程中出现错误，请稍后重试。';

  @override
  String get user_ok => '确定';

  @override
  String get orderList_title => '订单列表';

  @override
  String get orderList_orderNumber => '订单号';

  @override
  String get orderList_comment => '评论';

  @override
  String get orderDetail_title => '订单详情';

  @override
  String get orderDetail_countdown_title => '即将开场提醒';

  @override
  String get orderDetail_countdown_started => '已开场';

  @override
  String orderDetail_countdown_hoursMinutes(Object hours, Object minutes) {
    return '距离开场还有 $hours 小时 $minutes 分钟';
  }

  @override
  String orderDetail_countdown_minutesSeconds(Object minutes, Object seconds) {
    return '距离开场还有 $minutes 分钟 $seconds 秒';
  }

  @override
  String orderDetail_countdown_seconds(Object seconds) {
    return '距离开场还有 $seconds 秒';
  }

  @override
  String get orderDetail_ticketCode => '取票码';

  @override
  String orderDetail_ticketCount(int ticketCount) {
    return '$ticketCount张电影票';
  }

  @override
  String get orderDetail_orderNumber => '订单号';

  @override
  String get orderDetail_orderState => '订单状态';

  @override
  String get orderDetail_orderCreateTime => '订单创建时间';

  @override
  String get orderDetail_payTime => '支付时间';

  @override
  String get orderDetail_payMethod => '支付方式';

  @override
  String get orderDetail_seatMessage => '座位信息';

  @override
  String get orderDetail_orderMessage => '订单信息';

  @override
  String get orderDetail_failureReason => '失败原因';

  @override
  String get orderDetail_benefit_feedback_title => '特典反馈';

  @override
  String get orderDetail_benefit_feedback_hint =>
      '若您在该影院观影时发现下方特典已领完，点击提交后我们会更新库存提示，方便其他观众。';

  @override
  String get orderDetail_benefit_feedback_cinema_label => '反馈影院';

  @override
  String get orderDetail_benefit_feedback_benefit_label => '特典';

  @override
  String get orderDetail_benefit_feedback_submit => '确认：该影院已领完';

  @override
  String get payResult_title => '支付完成';

  @override
  String get payResult_success => '支付成功';

  @override
  String get payResult_ticketCode => '取票码';

  @override
  String get payResult_qrCodeTip => '请凭此二维码或取票码前往影院取票';

  @override
  String get payResult_viewMyTickets => '查看我的电影票';

  @override
  String get userProfile_title => '个人信息';

  @override
  String get userProfile_avatar => '头像';

  @override
  String get userProfile_username => '用户名';

  @override
  String get userProfile_email => '邮箱';

  @override
  String get userProfile_registerTime => '注册时间';

  @override
  String get userProfile_save => '保存';

  @override
  String get userProfile_edit_tip => '点击保存按钮保存更改';

  @override
  String get userProfile_edit_username_placeholder => '请输入用户名';

  @override
  String get userProfile_edit_username_verify_notNull => '用户名不能为空';

  @override
  String get movieShowList_dropdown_area => '地区';

  @override
  String get movieShowList_dropdown_dimensionType => '放映类型';

  @override
  String get movieShowList_dropdown_screenSpec => '放映规格';

  @override
  String get movieShowList_dropdown_subtitle => '字幕';

  @override
  String get movieShowList_dropdown_tag => '标签';

  @override
  String get movieShowList_dropdown_version => '版本';

  @override
  String get payment_addCreditCard_title => '添加信用卡';

  @override
  String get payment_addCreditCard_cardNumber => '卡号';

  @override
  String get payment_addCreditCard_cardNumberHint => '请输入卡号';

  @override
  String get payment_addCreditCard_cardNumberError => '请输入有效的卡号';

  @override
  String get payment_addCreditCard_cardNumberLength => '卡号长度不正确';

  @override
  String get payment_addCreditCard_cardHolderName => '持卡人姓名';

  @override
  String get payment_addCreditCard_cardHolderNameHint => '请输入持卡人姓名';

  @override
  String get payment_addCreditCard_cardHolderNameError => '请输入持卡人姓名';

  @override
  String get payment_addCreditCard_expiryDate => '有效期';

  @override
  String get payment_addCreditCard_expiryDateHint => 'MM/YY';

  @override
  String get payment_addCreditCard_expiryDateError => '请输入有效期';

  @override
  String get payment_addCreditCard_expiryDateInvalid => '有效期格式不正确';

  @override
  String get payment_addCreditCard_expiryDateExpired => '卡片已过期';

  @override
  String get payment_addCreditCard_cvv => 'CVV';

  @override
  String get payment_addCreditCard_cvvHint => '•••';

  @override
  String get payment_addCreditCard_cvvError => '請输入CVV';

  @override
  String get payment_addCreditCard_cvvLength => '长度不正确';

  @override
  String get payment_addCreditCard_saveCard => '保存此信用卡';

  @override
  String get payment_addCreditCard_saveToAccount => '将保存到您的账户，方便下次使用';

  @override
  String get payment_addCreditCard_useOnce => '仅本次使用，不会保存';

  @override
  String get payment_addCreditCard_confirmAdd => '确认添加';

  @override
  String get payment_addCreditCard_cardSaved => '信用卡已保存';

  @override
  String get payment_addCreditCard_cardConfirmed => '信用卡信息已确认';

  @override
  String get payment_addCreditCard_operationFailed => '操作失败，请重试';

  @override
  String get payment_selectCreditCard_title => '选择信用卡';

  @override
  String get payment_selectCreditCard_noCreditCard => '暂无信用卡';

  @override
  String get payment_selectCreditCard_pleaseAddCard => '请添加一张信用卡';

  @override
  String get payment_selectCreditCard_tempCard => '临时卡片（仅本次使用）';

  @override
  String payment_selectCreditCard_expiryDate(Object date) {
    return '有效期: $date';
  }

  @override
  String get payment_selectCreditCard_removeTempCard => '移除临时卡片';

  @override
  String get payment_selectCreditCard_tempCardRemoved => '已移除临时卡片';

  @override
  String get payment_selectCreditCard_addNewCard => '添加新信用卡';

  @override
  String get payment_selectCreditCard_confirmPayment => '确认支付';

  @override
  String get payment_selectCreditCard_pleaseSelectCard => '请选择一张信用卡';

  @override
  String get payment_selectCreditCard_paymentSuccess => '支付成功';

  @override
  String get payment_selectCreditCard_paymentFailed => '支付失败，请重试';

  @override
  String get payment_selectCreditCard_loadFailed => '加载信用卡列表失败';

  @override
  String get payment_selectCreditCard_tempCardSelected => '已选择临时信用卡';

  @override
  String get payError_title => '支付失败';

  @override
  String get payError_message => '您的订单似乎遇到了一些问题，请稍后重试。';

  @override
  String get payError_back => '返回';

  @override
  String get cinemaList_allArea => '全部地区';

  @override
  String get cinemaList_title => '附近影院';

  @override
  String get cinemaList_allCinemas => '全部影院';

  @override
  String get cinemaList_address => '正在获取当前位置';

  @override
  String get cinemaList_currentLocation => '当前所在地';

  @override
  String get cinemaList_search_hint => '搜索影院名称或地址';

  @override
  String get cinemaList_search_clear => '清除';

  @override
  String cinemaList_search_results_found(Object count) {
    return '找到 $count 个相关影院';
  }

  @override
  String get cinemaList_search_results_notFound => '未找到相关影院，请尝试其他关键词';

  @override
  String get cinemaList_filter_title => '按区域筛选';

  @override
  String get cinemaList_filter_brand => '品牌';

  @override
  String get cinemaList_filter_loading => '正在加载区域数据...';

  @override
  String get cinemaList_loading => '加载失败，请重试';

  @override
  String get cinemaList_empty_noData => '暂无影院数据';

  @override
  String get cinemaList_empty_noDataTip => '请稍后再试';

  @override
  String get cinemaList_empty_noSearchResults => '没有找到相关影院';

  @override
  String get cinemaList_empty_noSearchResultsTip => '请尝试其他关键词';

  @override
  String get cinemaList_movies_nowShowing => '正在上映';

  @override
  String get cinemaList_movies_empty => '暂无上映电影';

  @override
  String get cinemaList_selectSeat_selectedSeats => '已选座位';

  @override
  String get cinemaList_selectSeat_pleaseSelectSeats => '请选择座位';

  @override
  String cinemaList_selectSeat_confirmSelection(Object count) {
    return '确认选择 $count 个座位';
  }

  @override
  String cinemaList_selectSeat_seatsSelected(Object count) {
    return '已选择 $count 个座位';
  }

  @override
  String get cinemaList_selectSeat_dateFormat => 'yyyy年MM月dd日';

  @override
  String get forgotPassword_title => '忘记密码';

  @override
  String get forgotPassword_description => '输入您的邮箱地址，我们将发送验证码给您';

  @override
  String get forgotPassword_emailAddress => '邮箱地址';

  @override
  String get forgotPassword_verificationCode => '验证码';

  @override
  String get forgotPassword_newPassword => '新密码';

  @override
  String get forgotPassword_sendVerificationCode => '发送验证码';

  @override
  String get forgotPassword_resetPassword => '重置密码';

  @override
  String get forgotPassword_rememberPassword => '想起密码了？';

  @override
  String get forgotPassword_backToLogin => '返回登录';

  @override
  String get forgotPassword_emailRequired => '请输入邮箱';

  @override
  String get forgotPassword_emailInvalid => '请输入有效的邮箱地址';

  @override
  String get forgotPassword_verificationCodeRequired => '请输入验证码';

  @override
  String get forgotPassword_newPasswordRequired => '请输入新密码';

  @override
  String get forgotPassword_passwordTooShort => '密码至少需要6位';

  @override
  String get forgotPassword_verificationCodeSent => '验证码已发送至您的邮箱';

  @override
  String get forgotPassword_passwordResetSuccess => '密码重置成功';

  @override
  String get presaleDetail_title => '预售券';

  @override
  String get presaleDetail_specs => '规格';

  @override
  String get presaleDetail_salePeriodNote => '※ 销售期间与使用期间可能因影院而异，请以各影院公告为准';

  @override
  String get presaleDetail_applyMovie => '适用电影';

  @override
  String get presaleDetail_salePeriod => '销售期间';

  @override
  String get presaleDetail_usagePeriod => '使用期间';

  @override
  String get presaleDetail_perUserLimit => '每人限购';

  @override
  String get presaleDetail_noLimit => '不限';

  @override
  String get presaleDetail_pickupNotes => '取票说明';

  @override
  String get presaleDetail_gallery => '图集';

  @override
  String get presaleDetail_price => '价格';

  @override
  String get presaleDetail_bonus => '特典';

  @override
  String get presaleDetail_bonusDescription => '特典说明';

  @override
  String presaleDetail_bonusCount(int count) {
    return '共$count张';
  }

  @override
  String get benefit_hasBenefitsLabel => '有入场者特典';

  @override
  String get benefit_pageTitle => '入场者特典';

  @override
  String get benefit_empty => '该电影暂无特典信息';

  @override
  String get benefit_phase => '阶段';

  @override
  String get benefit_period => '期间';

  @override
  String get benefit_items => '物料';

  @override
  String get benefit_total => '总数';

  @override
  String get benefit_remaining => '剩余';

  @override
  String get benefit_status_sufficient => '充足';

  @override
  String get benefit_status_few => '少量';

  @override
  String get benefit_status_veryFew => '极少';

  @override
  String get benefit_status_soldOut => '已领完';

  @override
  String get benefit_status_unknown => '未知';

  @override
  String get benefit_phaseStatus_before => '之前';

  @override
  String get benefit_phaseStatus_ongoing => '进行中';

  @override
  String get benefit_phaseStatus_ended => '已结束';

  @override
  String get benefit_unit_thousand => '千';

  @override
  String get benefit_unit_tenThousand => '万';

  @override
  String get benefit_limit => '限定';

  @override
  String get benefit_limit_cinema => '仅限指定影院';

  @override
  String get benefit_limit_dimension_2d => '2D';

  @override
  String get benefit_limit_dimension_3d => '3D';

  @override
  String get benefit_feedback_hint =>
      '如果你在某家影院观影时发现下方这份特典已经领完，请选择影院并提交反馈，我们会更新库存提示，方便其他观众。';

  @override
  String get benefit_feedback_select_cinema => '选择影院';

  @override
  String get benefit_feedback_submit => '反馈：该影院已领完';

  @override
  String get benefit_feedback_success => '感谢您的反馈';

  @override
  String get benefit_feedback_please_select_cinema => '请先选择影院';

  @override
  String get benefit_feedback_button => '反馈';

  @override
  String get benefit_feedback_select_phase => '选择阶段';

  @override
  String get benefit_feedback_please_select_phase => '请先选择阶段';

  @override
  String get comingSoon_presale => '预售';

  @override
  String get comingSoon_presaleTicketBadge => '预售票';

  @override
  String get comingSoon_releaseDate => '上映';

  @override
  String get comingSoon_noMovies => '暂无正在上映的电影';

  @override
  String get comingSoon_tryLaterOrRefresh => '请稍后再试或下拉刷新';

  @override
  String get comingSoon_pullToRefresh => '下拉刷新';
}
