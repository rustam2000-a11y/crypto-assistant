// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(now, before) => "buyers ${now}% (was ${before}%)";

  static String m1(percent) => "${percent}% away";

  static String m2(count) => "${count} h";

  static String m3(percent, times) =>
      "+${percent}% in 24h (×${times} usual move)";

  static String m4(count) => "touches: ${count}";

  static String m5(count) => "Trades: ${count}";

  static String m6(percent) => "volume ${percent}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Hour": MessageLookupByLibrary.simpleMessage("24 h"),
    "abnormalPriceMovementOverTheLast24Hours":
        MessageLookupByLibrary.simpleMessage(
          "Abnormal price movement over the last 24 hours",
        ),
    "abnormallyHighTradingActivityRelativeToCoinSize":
        MessageLookupByLibrary.simpleMessage(
          "Abnormally high trading activity relative to coin size",
        ),
    "addToFavorites": MessageLookupByLibrary.simpleMessage("Add to favorites"),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "analytics": MessageLookupByLibrary.simpleMessage("Analytics"),
    "apply": MessageLookupByLibrary.simpleMessage("Apply"),
    "approachingItsHistoricalMaximumminimum":
        MessageLookupByLibrary.simpleMessage(
          "Approaching its historical maximum/minimum",
        ),
    "averageResult": MessageLookupByLibrary.simpleMessage("Average"),
    "btcTrend30d": MessageLookupByLibrary.simpleMessage("BTC 30d"),
    "buyersShare": m0,
    "capitalInflow": MessageLookupByLibrary.simpleMessage("Capital inflow"),
    "capitalization": MessageLookupByLibrary.simpleMessage("Capitalization"),
    "confirmedAnomaly": MessageLookupByLibrary.simpleMessage(
      "Confirmed anomaly",
    ),
    "corridorLowerBound": MessageLookupByLibrary.simpleMessage(
      "Corridor bottom",
    ),
    "corridorUpperBound": MessageLookupByLibrary.simpleMessage("Corridor top"),
    "createAnAccount": MessageLookupByLibrary.simpleMessage(
      "Create an account",
    ),
    "currentPricePositionInDailyRange0100":
        MessageLookupByLibrary.simpleMessage(
          "Current price position in daily range (0–100%):",
        ),
    "detailing": MessageLookupByLibrary.simpleMessage("Detailing"),
    "distanceToLevel": m1,
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "earlyFade": MessageLookupByLibrary.simpleMessage("Pump starting to fade"),
    "earlyFadeDescription": MessageLookupByLibrary.simpleMessage(
      "The coin rose unusually strongly for its volatility: the 24h or 7d rise is at least 2× its usual move and at least 4%. The peak was no more than 3 hours ago, RSI was 80+ within the day and has now dropped by 3–12 points, the price has pulled back 3–20% of the daily range from the high, and the live price is below the last hourly point while still up over 6 hours.",
    ),
    "earlyFadeShort": MessageLookupByLibrary.simpleMessage(
      "Fresh peak, RSI was 80+ and is turning down",
    ),
    "emailAlreadyInUse": MessageLookupByLibrary.simpleMessage(
      "This email is already in use",
    ),
    "failedToLogIn": MessageLookupByLibrary.simpleMessage(
      "Failed to log in, please try again later",
    ),
    "failedToSignUp": MessageLookupByLibrary.simpleMessage(
      "Failed to sign up, please try again later",
    ),
    "filtersNotPassed": MessageLookupByLibrary.simpleMessage("filtered out"),
    "filtersPassed": MessageLookupByLibrary.simpleMessage("filters passed"),
    "formulaWithFilters": MessageLookupByLibrary.simpleMessage(
      "Formula (all filters)",
    ),
    "highVolatility": MessageLookupByLibrary.simpleMessage("High volatility"),
    "historicalMaximum": MessageLookupByLibrary.simpleMessage(
      "Historical maximum",
    ),
    "historicalMaximumminimum": MessageLookupByLibrary.simpleMessage(
      "Historical maximum/minimum",
    ),
    "historicalMinimum": MessageLookupByLibrary.simpleMessage(
      "Historical minimum",
    ),
    "hoursShort": m2,
    "invalidEmail": MessageLookupByLibrary.simpleMessage("Invalid email"),
    "itTakesLessThanAMinute": MessageLookupByLibrary.simpleMessage(
      "It takes less than a minute",
    ),
    "journalEmpty": MessageLookupByLibrary.simpleMessage(
      "No signals yet. They are recorded while the reversal screen is open.",
    ),
    "journalNote": MessageLookupByLibrary.simpleMessage(
      "Short from the next 15-minute candle, emergency stop 4% above the 24h high, fees 0.2% included. The result appears 4 hours after the signal.",
    ),
    "keyLevels": MessageLookupByLibrary.simpleMessage(
      "Approaching a very strong level",
    ),
    "keyLevelsDescription": MessageLookupByLibrary.simpleMessage(
      "Coins whose price has come very close to a very strong level: over the last 20 days the price reversed from it at least 5 times with a strong move. A level above the price is resistance, below is support. If the price moves between confirmed levels, it is a corridor. A level is a reference for stops and targets, not a guarantee of a bounce.",
    ),
    "keyLevelsShort": MessageLookupByLibrary.simpleMessage(
      "Price near a level with 5+ strong reversals",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "logIn": MessageLookupByLibrary.simpleMessage("Log in"),
    "logInToKeepFollowingTheMarket": MessageLookupByLibrary.simpleMessage(
      "Log in to keep following the market",
    ),
    "market1h": MessageLookupByLibrary.simpleMessage("Market 1h"),
    "marketCapIncreaseoutflowOfMoreThan5Over24Hours":
        MessageLookupByLibrary.simpleMessage(
          "Market cap increase/outflow of more than 5% over 24 hours",
        ),
    "max24Hours": MessageLookupByLibrary.simpleMessage("Max 24 hours"),
    "myBriefcase": MessageLookupByLibrary.simpleMessage("My briefcase"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nearDailyPeakbottom": MessageLookupByLibrary.simpleMessage(
      "Near daily peak/bottom",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noDataForGraph": MessageLookupByLibrary.simpleMessage("No data for graph"),
    "noItemsAddedYet": MessageLookupByLibrary.simpleMessage(
      "No coins in portfolio",
    ),
    "overbought": MessageLookupByLibrary.simpleMessage(
      "Overheated, liquidity leaving",
    ),
    "overboughtDescription": MessageLookupByLibrary.simpleMessage(
      "The coin is strongly overheated: hourly RSI is 80 or higher, the 24h rise is at least 2× its usual daily move and the price is far above its 7-day average. Meanwhile liquidity is leaving: volume over the last 3 hours is 30%+ lower than at the height of the rally, and the share of aggressive buying is falling. This is a state of the coin, not a short signal: historically the price was lower 1–4 hours later in about half of the cases.",
    ),
    "overboughtShort": MessageLookupByLibrary.simpleMessage(
      "RSI 80+, volume and buyers fading",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "patternOnly": MessageLookupByLibrary.simpleMessage(
      "Pattern only, no filters",
    ),
    "pausedBullRegime": MessageLookupByLibrary.simpleMessage(
      "BTC is up over 30 days. In this regime pumps tend to continue, so reversal signals are off.",
    ),
    "pausedMarketRising": MessageLookupByLibrary.simpleMessage(
      "The market is rising this hour. Waiting for it to turn down.",
    ),
    "priceFluctuationRangeOverTheLast24Hours":
        MessageLookupByLibrary.simpleMessage(
          "Price fluctuation range over the last 24 hours",
        ),
    "priceIncreasedecreaseByMoreThan10": MessageLookupByLibrary.simpleMessage(
      "Price increase/decrease by more than 10%",
    ),
    "priceIncreasedecreaseByMoreThan5": MessageLookupByLibrary.simpleMessage(
      "Price increase/decrease by more than 5%",
    ),
    "priceIsCurrentlyAtTheUpperOrLowerBoundaryOf":
        MessageLookupByLibrary.simpleMessage(
          "Price is currently at the upper or lower boundary of the daily range",
        ),
    "priceMovementOverTheLast24Hours": MessageLookupByLibrary.simpleMessage(
      "Price movement over the last 24 hours",
    ),
    "profitable": MessageLookupByLibrary.simpleMessage("Profitable"),
    "pumpReversal": MessageLookupByLibrary.simpleMessage("Pump reversal"),
    "pumpReversalDescription": MessageLookupByLibrary.simpleMessage(
      "The pump was rejected at the top: a long upper wick on high volume, or a break below the last hour\'s low after the peak. Short from the next 15-minute candle and hold 3–4 hours. Works only while BTC is down over 30 days and the market is falling this hour.",
    ),
    "pumpReversalShort": MessageLookupByLibrary.simpleMessage(
      "Short for 3–4 hours after a rejected pump",
    ),
    "removeFromFavorites": MessageLookupByLibrary.simpleMessage(
      "Remove from favorites",
    ),
    "resistance": MessageLookupByLibrary.simpleMessage("Resistance"),
    "rise24h": m3,
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign up"),
    "signalJournal": MessageLookupByLibrary.simpleMessage("Signal journal"),
    "signalsActive": MessageLookupByLibrary.simpleMessage("Signals active"),
    "signalsPaused": MessageLookupByLibrary.simpleMessage("Signals paused"),
    "structureBreak": MessageLookupByLibrary.simpleMessage("Structure break"),
    "support": MessageLookupByLibrary.simpleMessage("Support"),
    "thePasswordMustBeAtLeast6CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "The password must be at least 6 characters long.",
        ),
    "touchesCount": m4,
    "tradesCount": m5,
    "turnover": MessageLookupByLibrary.simpleMessage("Turnover"),
    "volume24Hours": MessageLookupByLibrary.simpleMessage("Volume 24 hours"),
    "volumeChange": m6,
    "waitingForResult": MessageLookupByLibrary.simpleMessage(
      "waiting for result",
    ),
    "weakPassword": MessageLookupByLibrary.simpleMessage(
      "Password is too weak",
    ),
    "week": MessageLookupByLibrary.simpleMessage("Week"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome back"),
    "wickRejection": MessageLookupByLibrary.simpleMessage("Rejection wick"),
    "year": MessageLookupByLibrary.simpleMessage("Year"),
  };
}
