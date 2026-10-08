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

  /// `Pump reversal`
  String get pumpReversal {
    return Intl.message(
      'Pump reversal',
      name: 'pumpReversal',
      desc: '',
      args: [],
    );
  }

  /// `Short for 3–4 hours after a rejected pump`
  String get pumpReversalShort {
    return Intl.message(
      'Short for 3–4 hours after a rejected pump',
      name: 'pumpReversalShort',
      desc: '',
      args: [],
    );
  }

  /// `The pump was rejected at the top: a long upper wick on high volume, or a break below the last hour's low after the peak. Short from the next 15-minute candle and hold 3–4 hours. Works only while BTC is down over 30 days and the market is falling this hour.`
  String get pumpReversalDescription {
    return Intl.message(
      'The pump was rejected at the top: a long upper wick on high volume, or a break below the last hour\'s low after the peak. Short from the next 15-minute candle and hold 3–4 hours. Works only while BTC is down over 30 days and the market is falling this hour.',
      name: 'pumpReversalDescription',
      desc: '',
      args: [],
    );
  }

  /// `Signals active`
  String get signalsActive {
    return Intl.message(
      'Signals active',
      name: 'signalsActive',
      desc: '',
      args: [],
    );
  }

  /// `Signals paused`
  String get signalsPaused {
    return Intl.message(
      'Signals paused',
      name: 'signalsPaused',
      desc: '',
      args: [],
    );
  }

  /// `BTC 30d`
  String get btcTrend30d {
    return Intl.message('BTC 30d', name: 'btcTrend30d', desc: '', args: []);
  }

  /// `Market 1h`
  String get market1h {
    return Intl.message('Market 1h', name: 'market1h', desc: '', args: []);
  }

  /// `BTC is up over 30 days. In this regime pumps tend to continue, so reversal signals are off.`
  String get pausedBullRegime {
    return Intl.message(
      'BTC is up over 30 days. In this regime pumps tend to continue, so reversal signals are off.',
      name: 'pausedBullRegime',
      desc: '',
      args: [],
    );
  }

  /// `The market is rising this hour. Waiting for it to turn down.`
  String get pausedMarketRising {
    return Intl.message(
      'The market is rising this hour. Waiting for it to turn down.',
      name: 'pausedMarketRising',
      desc: '',
      args: [],
    );
  }

  /// `Signal journal`
  String get signalJournal {
    return Intl.message(
      'Signal journal',
      name: 'signalJournal',
      desc: '',
      args: [],
    );
  }

  /// `No signals yet. They are recorded while the reversal screen is open.`
  String get journalEmpty {
    return Intl.message(
      'No signals yet. They are recorded while the reversal screen is open.',
      name: 'journalEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Short from the next 15-minute candle, emergency stop 4% above the 24h high, fees 0.2% included. The result appears 4 hours after the signal.`
  String get journalNote {
    return Intl.message(
      'Short from the next 15-minute candle, emergency stop 4% above the 24h high, fees 0.2% included. The result appears 4 hours after the signal.',
      name: 'journalNote',
      desc: '',
      args: [],
    );
  }

  /// `Formula (all filters)`
  String get formulaWithFilters {
    return Intl.message(
      'Formula (all filters)',
      name: 'formulaWithFilters',
      desc: '',
      args: [],
    );
  }

  /// `Pattern only, no filters`
  String get patternOnly {
    return Intl.message(
      'Pattern only, no filters',
      name: 'patternOnly',
      desc: '',
      args: [],
    );
  }

  /// `Profitable`
  String get profitable {
    return Intl.message('Profitable', name: 'profitable', desc: '', args: []);
  }

  /// `Average`
  String get averageResult {
    return Intl.message('Average', name: 'averageResult', desc: '', args: []);
  }

  /// `waiting for result`
  String get waitingForResult {
    return Intl.message(
      'waiting for result',
      name: 'waitingForResult',
      desc: '',
      args: [],
    );
  }

  /// `Rejection wick`
  String get wickRejection {
    return Intl.message(
      'Rejection wick',
      name: 'wickRejection',
      desc: '',
      args: [],
    );
  }

  /// `Structure break`
  String get structureBreak {
    return Intl.message(
      'Structure break',
      name: 'structureBreak',
      desc: '',
      args: [],
    );
  }

  /// `filters passed`
  String get filtersPassed {
    return Intl.message(
      'filters passed',
      name: 'filtersPassed',
      desc: '',
      args: [],
    );
  }

  /// `filtered out`
  String get filtersNotPassed {
    return Intl.message(
      'filtered out',
      name: 'filtersNotPassed',
      desc: '',
      args: [],
    );
  }

  /// `Trades: {count}`
  String tradesCount(int count) {
    return Intl.message(
      'Trades: $count',
      name: 'tradesCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count} h`
  String hoursShort(int count) {
    return Intl.message(
      '$count h',
      name: 'hoursShort',
      desc: '',
      args: [count],
    );
  }

  /// `Approaching a very strong level`
  String get keyLevels {
    return Intl.message(
      'Approaching a very strong level',
      name: 'keyLevels',
      desc: '',
      args: [],
    );
  }

  /// `Price near a level with 5+ strong reversals`
  String get keyLevelsShort {
    return Intl.message(
      'Price near a level with 5+ strong reversals',
      name: 'keyLevelsShort',
      desc: '',
      args: [],
    );
  }

  /// `Coins whose price has come very close to a very strong level: over the last 20 days the price reversed from it at least 5 times with a strong move. A level above the price is resistance, below is support. If the price moves between confirmed levels, it is a corridor. A level is a reference for stops and targets, not a guarantee of a bounce.`
  String get keyLevelsDescription {
    return Intl.message(
      'Coins whose price has come very close to a very strong level: over the last 20 days the price reversed from it at least 5 times with a strong move. A level above the price is resistance, below is support. If the price moves between confirmed levels, it is a corridor. A level is a reference for stops and targets, not a guarantee of a bounce.',
      name: 'keyLevelsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Resistance`
  String get resistance {
    return Intl.message('Resistance', name: 'resistance', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Corridor top`
  String get corridorUpperBound {
    return Intl.message(
      'Corridor top',
      name: 'corridorUpperBound',
      desc: '',
      args: [],
    );
  }

  /// `Corridor bottom`
  String get corridorLowerBound {
    return Intl.message(
      'Corridor bottom',
      name: 'corridorLowerBound',
      desc: '',
      args: [],
    );
  }

  /// `touches: {count}`
  String touchesCount(int count) {
    return Intl.message(
      'touches: $count',
      name: 'touchesCount',
      desc: '',
      args: [count],
    );
  }

  /// `{percent}% away`
  String distanceToLevel(String percent) {
    return Intl.message(
      '$percent% away',
      name: 'distanceToLevel',
      desc: '',
      args: [percent],
    );
  }

  /// `Overheated, liquidity leaving`
  String get overbought {
    return Intl.message(
      'Overheated, liquidity leaving',
      name: 'overbought',
      desc: '',
      args: [],
    );
  }

  /// `RSI 80+, volume and buyers fading`
  String get overboughtShort {
    return Intl.message(
      'RSI 80+, volume and buyers fading',
      name: 'overboughtShort',
      desc: '',
      args: [],
    );
  }

  /// `The coin is strongly overheated: hourly RSI is 80 or higher, the 24h rise is at least 2× its usual daily move and the price is far above its 7-day average. Meanwhile liquidity is leaving: volume over the last 3 hours is 30%+ lower than at the height of the rally, and the share of aggressive buying is falling. This is a state of the coin, not a short signal: historically the price was lower 1–4 hours later in about half of the cases.`
  String get overboughtDescription {
    return Intl.message(
      'The coin is strongly overheated: hourly RSI is 80 or higher, the 24h rise is at least 2× its usual daily move and the price is far above its 7-day average. Meanwhile liquidity is leaving: volume over the last 3 hours is 30%+ lower than at the height of the rally, and the share of aggressive buying is falling. This is a state of the coin, not a short signal: historically the price was lower 1–4 hours later in about half of the cases.',
      name: 'overboughtDescription',
      desc: '',
      args: [],
    );
  }

  /// `+{percent}% in 24h (×{times} usual move)`
  String rise24h(String percent, String times) {
    return Intl.message(
      '+$percent% in 24h (×$times usual move)',
      name: 'rise24h',
      desc: '',
      args: [percent, times],
    );
  }

  /// `volume {percent}%`
  String volumeChange(String percent) {
    return Intl.message(
      'volume $percent%',
      name: 'volumeChange',
      desc: '',
      args: [percent],
    );
  }

  /// `buyers {now}% (was {before}%)`
  String buyersShare(String now, String before) {
    return Intl.message(
      'buyers $now% (was $before%)',
      name: 'buyersShare',
      desc: '',
      args: [now, before],
    );
  }

  /// `Pump starting to fade`
  String get earlyFade {
    return Intl.message(
      'Pump starting to fade',
      name: 'earlyFade',
      desc: '',
      args: [],
    );
  }

  /// `Fresh peak, RSI was 80+ and is turning down`
  String get earlyFadeShort {
    return Intl.message(
      'Fresh peak, RSI was 80+ and is turning down',
      name: 'earlyFadeShort',
      desc: '',
      args: [],
    );
  }

  /// `The coin rose unusually strongly for its volatility: the 24h or 7d rise is at least 2× its usual move and at least 4%. The peak was no more than 3 hours ago, RSI was 80+ within the day and has now dropped by 3–12 points, the price has pulled back 3–20% of the daily range from the high, and the live price is below the last hourly point while still up over 6 hours.`
  String get earlyFadeDescription {
    return Intl.message(
      'The coin rose unusually strongly for its volatility: the 24h or 7d rise is at least 2× its usual move and at least 4%. The peak was no more than 3 hours ago, RSI was 80+ within the day and has now dropped by 3–12 points, the price has pulled back 3–20% of the daily range from the high, and the live price is below the last hourly point while still up over 6 hours.',
      name: 'earlyFadeDescription',
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
