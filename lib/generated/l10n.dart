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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `No coins in portfolio`
  String get noItemsAddedYet {
    return Intl.message(
      'No coins in portfolio',
      name: 'noItemsAddedYet',
      desc:
          'Shown on the briefcase screen when the user has not added any coins yet',
      args: [],
    );
  }

  /// `Volume 24 hours`
  String get volume24Hours {
    return Intl.message(
      'Volume 24 hours',
      name: 'volume24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Max 24 hours`
  String get max24Hours {
    return Intl.message('Max 24 hours', name: 'max24Hours', desc: '', args: []);
  }

  /// `Current price position in daily range (0–100%):`
  String get currentPricePositionInDailyRange0100 {
    return Intl.message(
      'Current price position in daily range (0–100%):',
      name: 'currentPricePositionInDailyRange0100',
      desc: '',
      args: [],
    );
  }

  /// `Capitalization`
  String get capitalization {
    return Intl.message(
      'Capitalization',
      name: 'capitalization',
      desc: '',
      args: [],
    );
  }

  /// `Historical maximum`
  String get historicalMaximum {
    return Intl.message(
      'Historical maximum',
      name: 'historicalMaximum',
      desc: '',
      args: [],
    );
  }

  /// `Historical minimum`
  String get historicalMinimum {
    return Intl.message(
      'Historical minimum',
      name: 'historicalMinimum',
      desc: '',
      args: [],
    );
  }

  /// `Remove from favorites`
  String get removeFromFavorites {
    return Intl.message(
      'Remove from favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorites`
  String get addToFavorites {
    return Intl.message(
      'Add to favorites',
      name: 'addToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `My briefcase`
  String get myBriefcase {
    return Intl.message(
      'My briefcase',
      name: 'myBriefcase',
      desc: '',
      args: [],
    );
  }

  /// `Analytics`
  String get analytics {
    return Intl.message('Analytics', name: 'analytics', desc: '', args: []);
  }

  /// `Price is currently at the upper or lower boundary of the daily range`
  String get priceIsCurrentlyAtTheUpperOrLowerBoundaryOf {
    return Intl.message(
      'Price is currently at the upper or lower boundary of the daily range',
      name: 'priceIsCurrentlyAtTheUpperOrLowerBoundaryOf',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed anomaly`
  String get confirmedAnomaly {
    return Intl.message(
      'Confirmed anomaly',
      name: 'confirmedAnomaly',
      desc: '',
      args: [],
    );
  }

  /// `Abnormally high trading activity relative to coin size`
  String get abnormallyHighTradingActivityRelativeToCoinSize {
    return Intl.message(
      'Abnormally high trading activity relative to coin size',
      name: 'abnormallyHighTradingActivityRelativeToCoinSize',
      desc: '',
      args: [],
    );
  }

  /// `Near daily peak/bottom`
  String get nearDailyPeakbottom {
    return Intl.message(
      'Near daily peak/bottom',
      name: 'nearDailyPeakbottom',
      desc: '',
      args: [],
    );
  }

  /// `Market cap increase/outflow of more than 5% over 24 hours`
  String get marketCapIncreaseoutflowOfMoreThan5Over24Hours {
    return Intl.message(
      'Market cap increase/outflow of more than 5% over 24 hours',
      name: 'marketCapIncreaseoutflowOfMoreThan5Over24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Turnover`
  String get turnover {
    return Intl.message('Turnover', name: 'turnover', desc: '', args: []);
  }

  /// `Approaching its historical maximum/minimum`
  String get approachingItsHistoricalMaximumminimum {
    return Intl.message(
      'Approaching its historical maximum/minimum',
      name: 'approachingItsHistoricalMaximumminimum',
      desc: '',
      args: [],
    );
  }

  /// `Historical maximum/minimum`
  String get historicalMaximumminimum {
    return Intl.message(
      'Historical maximum/minimum',
      name: 'historicalMaximumminimum',
      desc: '',
      args: [],
    );
  }

  /// `Price fluctuation range over the last 24 hours`
  String get priceFluctuationRangeOverTheLast24Hours {
    return Intl.message(
      'Price fluctuation range over the last 24 hours',
      name: 'priceFluctuationRangeOverTheLast24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Price increase/decrease by more than 5%`
  String get priceIncreasedecreaseByMoreThan5 {
    return Intl.message(
      'Price increase/decrease by more than 5%',
      name: 'priceIncreasedecreaseByMoreThan5',
      desc: '',
      args: [],
    );
  }

  /// `High volatility`
  String get highVolatility {
    return Intl.message(
      'High volatility',
      name: 'highVolatility',
      desc: '',
      args: [],
    );
  }

  /// `Price movement over the last 24 hours`
  String get priceMovementOverTheLast24Hours {
    return Intl.message(
      'Price movement over the last 24 hours',
      name: 'priceMovementOverTheLast24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Price increase/decrease by more than 10%`
  String get priceIncreasedecreaseByMoreThan10 {
    return Intl.message(
      'Price increase/decrease by more than 10%',
      name: 'priceIncreasedecreaseByMoreThan10',
      desc: '',
      args: [],
    );
  }

  /// `Abnormal price movement over the last 24 hours`
  String get abnormalPriceMovementOverTheLast24Hours {
    return Intl.message(
      'Abnormal price movement over the last 24 hours',
      name: 'abnormalPriceMovementOverTheLast24Hours',
      desc: '',
      args: [],
    );
  }

  /// `Capital inflow`
  String get capitalInflow {
    return Intl.message(
      'Capital inflow',
      name: 'capitalInflow',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Log in to keep following the market`
  String get logInToKeepFollowingTheMarket {
    return Intl.message(
      'Log in to keep following the market',
      name: 'logInToKeepFollowingTheMarket',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Log in`
  String get logIn {
    return Intl.message('Log in', name: 'logIn', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Create an account`
  String get createAnAccount {
    return Intl.message(
      'Create an account',
      name: 'createAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `It takes less than a minute`
  String get itTakesLessThanAMinute {
    return Intl.message(
      'It takes less than a minute',
      name: 'itTakesLessThanAMinute',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `24 h`
  String get Hour {
    return Intl.message('24 h', name: 'Hour', desc: '', args: []);
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Year`
  String get year {
    return Intl.message('Year', name: 'year', desc: '', args: []);
  }

  /// `No data for graph`
  String get noDataForGraph {
    return Intl.message(
      'No data for graph',
      name: 'noDataForGraph',
      desc: '',
      args: [],
    );
  }

  /// `Detailing`
  String get detailing {
    return Intl.message('Detailing', name: 'detailing', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `The password must be at least 6 characters long.`
  String get thePasswordMustBeAtLeast6CharactersLong {
    return Intl.message(
      'The password must be at least 6 characters long.',
      name: 'thePasswordMustBeAtLeast6CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Failed to log in, please try again later`
  String get failedToLogIn {
    return Intl.message(
      'Failed to log in, please try again later',
      name: 'failedToLogIn',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak`
  String get weakPassword {
    return Intl.message(
      'Password is too weak',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `This email is already in use`
  String get emailAlreadyInUse {
    return Intl.message(
      'This email is already in use',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Failed to sign up, please try again later`
  String get failedToSignUp {
    return Intl.message(
      'Failed to sign up, please try again later',
      name: 'failedToSignUp',
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
      Locale.fromSubtags(languageCode: 'ru'),
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
