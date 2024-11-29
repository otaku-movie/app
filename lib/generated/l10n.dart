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

  /// ``
  String get common_week_monday {
    return Intl.message(
      '',
      name: 'common_week_monday',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get common_week_tuesday {
    return Intl.message(
      '',
      name: 'common_week_tuesday',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get common_week_wednesday {
    return Intl.message(
      '',
      name: 'common_week_wednesday',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get common_week_thursday {
    return Intl.message(
      '',
      name: 'common_week_thursday',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get common_week_friday {
    return Intl.message(
      '',
      name: 'common_week_friday',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get common_week_saturday {
    return Intl.message(
      '',
      name: 'common_week_saturday',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get common_week_sunday {
    return Intl.message(
      '',
      name: 'common_week_sunday',
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
  String get movieList_button_buy {
    return Intl.message(
      '',
      name: 'movieList_button_buy',
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
