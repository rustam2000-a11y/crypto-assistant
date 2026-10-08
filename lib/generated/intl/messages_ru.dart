// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(now, before) => "покупки ${now}% (было ${before}%)";

  static String m1(percent) => "${percent}% до уровня";

  static String m2(count) => "${count} ч";

  static String m3(percent, times) =>
      "+${percent}% за 24 ч (×${times} обычного хода)";

  static String m4(count) => "касаний: ${count}";

  static String m5(count) => "Сделок: ${count}";

  static String m6(percent) => "объём ${percent}%";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "Hour": MessageLookupByLibrary.simpleMessage("24ч"),
    "abnormalPriceMovementOverTheLast24Hours":
        MessageLookupByLibrary.simpleMessage(
          "Аномальное движение цены за последние 24 часа",
        ),
    "abnormallyHighTradingActivityRelativeToCoinSize":
        MessageLookupByLibrary.simpleMessage(
          "Аномально высокая активность торгов относительно размера монеты",
        ),
    "addToFavorites": MessageLookupByLibrary.simpleMessage(
      "Добавить в избранное",
    ),
    "alreadyHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Уже есть аккаунт?",
    ),
    "analytics": MessageLookupByLibrary.simpleMessage("Аналитика"),
    "apply": MessageLookupByLibrary.simpleMessage("Применять"),
    "approachingItsHistoricalMaximumminimum":
        MessageLookupByLibrary.simpleMessage(
          "Приближается к своему историческому максимуму/минимуму",
        ),
    "averageResult": MessageLookupByLibrary.simpleMessage("Среднее"),
    "btcTrend30d": MessageLookupByLibrary.simpleMessage("BTC за 30 дн."),
    "buyersShare": m0,
    "capitalInflow": MessageLookupByLibrary.simpleMessage("Приток капитала"),
    "capitalization": MessageLookupByLibrary.simpleMessage("Капитализация"),
    "confirmedAnomaly": MessageLookupByLibrary.simpleMessage(
      "Подтверждённая аномалия",
    ),
    "corridorLowerBound": MessageLookupByLibrary.simpleMessage("Низ коридора"),
    "corridorUpperBound": MessageLookupByLibrary.simpleMessage("Верх коридора"),
    "createAnAccount": MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
    "currentPricePositionInDailyRange0100":
        MessageLookupByLibrary.simpleMessage(
          "Текущая позиция цены в дневном диапазоне (0–100%):",
        ),
    "detailing": MessageLookupByLibrary.simpleMessage("Детализация"),
    "distanceToLevel": m1,
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage("Нет аккаунта?"),
    "earlyFade": MessageLookupByLibrary.simpleMessage(
      "Памп начинает выдыхаться",
    ),
    "earlyFadeDescription": MessageLookupByLibrary.simpleMessage(
      "Монета выросла необычно сильно для своей волатильности: рост за 24 ч или 7 дн. минимум в 2 раза больше её обычного хода и не меньше 4%. Пик был не больше 3 часов назад, RSI за сутки был 80+ и сейчас опустился на 3–12 пунктов, цена отошла от дневного максимума на 3–20% дневного диапазона, а живая цена ниже последней часовой точки, но за 6 часов ещё в плюсе.",
    ),
    "earlyFadeShort": MessageLookupByLibrary.simpleMessage(
      "Свежий пик, RSI был 80+ и пошёл вниз",
    ),
    "emailAlreadyInUse": MessageLookupByLibrary.simpleMessage(
      "Этот email уже используется",
    ),
    "failedToLogIn": MessageLookupByLibrary.simpleMessage(
      "Не удалось войти, попробуйте позже",
    ),
    "failedToSignUp": MessageLookupByLibrary.simpleMessage(
      "Не удалось зарегистрироваться, попробуйте позже",
    ),
    "filtersNotPassed": MessageLookupByLibrary.simpleMessage(
      "отсеян фильтрами",
    ),
    "filtersPassed": MessageLookupByLibrary.simpleMessage("фильтры пройдены"),
    "formulaWithFilters": MessageLookupByLibrary.simpleMessage(
      "Формула (все фильтры)",
    ),
    "highVolatility": MessageLookupByLibrary.simpleMessage(
      "Высокая волатильность",
    ),
    "historicalMaximum": MessageLookupByLibrary.simpleMessage(
      "Исторический максимум",
    ),
    "historicalMaximumminimum": MessageLookupByLibrary.simpleMessage(
      "Исторический максимум/минимум",
    ),
    "historicalMinimum": MessageLookupByLibrary.simpleMessage(
      "Исторический минимум",
    ),
    "hoursShort": m2,
    "invalidEmail": MessageLookupByLibrary.simpleMessage("Некорректный email"),
    "itTakesLessThanAMinute": MessageLookupByLibrary.simpleMessage(
      "Это займёт меньше минуты",
    ),
    "journalEmpty": MessageLookupByLibrary.simpleMessage(
      "Сигналов пока нет. Они записываются, пока открыт экран разворота.",
    ),
    "journalNote": MessageLookupByLibrary.simpleMessage(
      "Шорт со следующей 15-минутной свечи, аварийный стоп на 4% выше максимума за 24 ч, издержки 0,2% учтены. Результат появляется через 4 часа после сигнала.",
    ),
    "keyLevels": MessageLookupByLibrary.simpleMessage(
      "Подход к очень сильному уровню",
    ),
    "keyLevelsDescription": MessageLookupByLibrary.simpleMessage(
      "Монеты, цена которых вплотную подошла к очень сильному уровню: за последние 20 дней от него было минимум 5 сильных разворотов. Уровень над ценой — сопротивление, под ценой — поддержка. Если цена ходит между подтверждёнными уровнями — это коридор. Уровень — ориентир для стопов и целей, а не гарантия отскока.",
    ),
    "keyLevelsShort": MessageLookupByLibrary.simpleMessage(
      "Цена у уровня с 5+ сильными разворотами",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "logIn": MessageLookupByLibrary.simpleMessage("Войти"),
    "logInToKeepFollowingTheMarket": MessageLookupByLibrary.simpleMessage(
      "Войдите, чтобы продолжить следить за рынком",
    ),
    "market1h": MessageLookupByLibrary.simpleMessage("Рынок за 1 ч"),
    "marketCapIncreaseoutflowOfMoreThan5Over24Hours":
        MessageLookupByLibrary.simpleMessage(
          "Рост/отток капитализации более чем на 5% за 24 часа",
        ),
    "max24Hours": MessageLookupByLibrary.simpleMessage("Макс. за 24 часа"),
    "myBriefcase": MessageLookupByLibrary.simpleMessage("Мой портфель"),
    "name": MessageLookupByLibrary.simpleMessage("Имя"),
    "nearDailyPeakbottom": MessageLookupByLibrary.simpleMessage(
      "У дневного пика/дна",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
    "noDataForGraph": MessageLookupByLibrary.simpleMessage("No data for graph"),
    "noItemsAddedYet": MessageLookupByLibrary.simpleMessage(
      "Нет монет в портфеле",
    ),
    "overbought": MessageLookupByLibrary.simpleMessage(
      "Перегрев, ликвидность уходит",
    ),
    "overboughtDescription": MessageLookupByLibrary.simpleMessage(
      "Монета сильно перегрета: RSI на часовом графике 80 или выше, рост за 24 часа минимум в 2 раза больше её обычного дневного хода, цена далеко над средней за 7 дней. При этом ликвидность уходит: объём за последние 3 часа на 30%+ ниже, чем в разгар роста, а доля агрессивных покупок падает. Это состояние монеты, а не сигнал на шорт: на истории через 1–4 часа цена была ниже примерно в половине случаев.",
    ),
    "overboughtShort": MessageLookupByLibrary.simpleMessage(
      "RSI 80+, объём и покупатели выдыхаются",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "patternOnly": MessageLookupByLibrary.simpleMessage(
      "Только паттерн, без фильтров",
    ),
    "pausedBullRegime": MessageLookupByLibrary.simpleMessage(
      "BTC за 30 дней растёт. В таком режиме пампы чаще продолжаются, поэтому сигналы разворота выключены.",
    ),
    "pausedMarketRising": MessageLookupByLibrary.simpleMessage(
      "Рынок за последний час растёт. Ждём, пока он развернётся вниз.",
    ),
    "priceFluctuationRangeOverTheLast24Hours":
        MessageLookupByLibrary.simpleMessage(
          "Размах колебаний цены за последние 24 часа",
        ),
    "priceIncreasedecreaseByMoreThan10": MessageLookupByLibrary.simpleMessage(
      "Рост/падение цены более чем на 10%",
    ),
    "priceIncreasedecreaseByMoreThan5": MessageLookupByLibrary.simpleMessage(
      "Рост/падение цены более чем на 5%",
    ),
    "priceIsCurrentlyAtTheUpperOrLowerBoundaryOf":
        MessageLookupByLibrary.simpleMessage(
          "Цена сейчас находится у верхней или нижней границы дневного диапазона",
        ),
    "priceMovementOverTheLast24Hours": MessageLookupByLibrary.simpleMessage(
      "Движение цены за последние 24 часа",
    ),
    "profitable": MessageLookupByLibrary.simpleMessage("В плюсе"),
    "pumpReversal": MessageLookupByLibrary.simpleMessage(
      "Разворот после пампа",
    ),
    "pumpReversalDescription": MessageLookupByLibrary.simpleMessage(
      "Памп отбит у вершины: длинная верхняя тень на большом объёме или пробой минимума последнего часа после пика. Шорт со следующей 15-минутной свечи, держать 3–4 часа. Работает, только когда BTC за 30 дней падает, а рынок за последний час снижается.",
    ),
    "pumpReversalShort": MessageLookupByLibrary.simpleMessage(
      "Шорт на 3–4 часа после отбоя пампа",
    ),
    "removeFromFavorites": MessageLookupByLibrary.simpleMessage(
      "Удалить из избранного",
    ),
    "resistance": MessageLookupByLibrary.simpleMessage("Сопротивление"),
    "rise24h": m3,
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "signUp": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
    "signalJournal": MessageLookupByLibrary.simpleMessage("Журнал сигналов"),
    "signalsActive": MessageLookupByLibrary.simpleMessage("Сигналы активны"),
    "signalsPaused": MessageLookupByLibrary.simpleMessage("Сигналы на паузе"),
    "structureBreak": MessageLookupByLibrary.simpleMessage("Слом структуры"),
    "support": MessageLookupByLibrary.simpleMessage("Поддержка"),
    "thePasswordMustBeAtLeast6CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Пароль должен содержать не менее 6 символов",
        ),
    "touchesCount": m4,
    "tradesCount": m5,
    "turnover": MessageLookupByLibrary.simpleMessage("Оборачиваемость"),
    "volume24Hours": MessageLookupByLibrary.simpleMessage("Объём за 24 часа"),
    "volumeChange": m6,
    "waitingForResult": MessageLookupByLibrary.simpleMessage("ждём результат"),
    "weakPassword": MessageLookupByLibrary.simpleMessage(
      "Пароль слишком простой",
    ),
    "week": MessageLookupByLibrary.simpleMessage("Неделя"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("С возвращением"),
    "wickRejection": MessageLookupByLibrary.simpleMessage("Отбой тенью"),
    "year": MessageLookupByLibrary.simpleMessage("Год"),
  };
}
