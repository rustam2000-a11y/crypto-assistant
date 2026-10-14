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

  static String m3(value) => "растяжение ×${value}";

  static String m4(percent) => "фандинг ${percent}%";

  static String m5(percent) => "OI ${percent}%";

  static String m6(count) => "Перегрузка ${count}/7";

  static String m7(value) => "RSI 1ч ${value}";

  static String m8(value) => "RSI 4ч ${value}";

  static String m9(percent) =>
      "⚠ плечи ${percent}% за сутки — на истории рост чаще продолжался";

  static String m10(value) => "топ-трейдеры L/S ${value}";

  static String m11(value) => "объём ×${value}";

  static String m12(percent) =>
      "подходит, осталось ${percent}% (доходила за 2 ч ~75%)";

  static String m13(percent, times) =>
      "+${percent}% за 24 ч (×${times} обычного хода)";

  static String m14(count, percent) =>
      "сильных отскоков: ${count} (в ср. ${percent}%)";

  static String m15(count) => "Сделок: ${count}";

  static String m16(times) => "объём на отскоках ×${times}";

  static String m17(percent) => "объём ${percent}%";

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
    "approachingLevel": MessageLookupByLibrary.simpleMessage("подходит"),
    "atLevel": MessageLookupByLibrary.simpleMessage("на уровне"),
    "averageResult": MessageLookupByLibrary.simpleMessage("Среднее"),
    "btcTrend30d": MessageLookupByLibrary.simpleMessage("BTC за 30 дн."),
    "buyersShare": m0,
    "capitalFlow": MessageLookupByLibrary.simpleMessage(
      "Приток и отток капитала",
    ),
    "capitalFlowDescription": MessageLookupByLibrary.simpleMessage(
      "Монеты, капитализация которых за 24 часа выросла больше чем на 5% (приток денег) или упала больше чем на 5% (отток). Рост капитализации может быть связан и с разлоком монет, а не только с ростом цены.",
    ),
    "capitalFlowShort": MessageLookupByLibrary.simpleMessage(
      "Капитализация ±5% и больше за 24 часа",
    ),
    "capitalInflow": MessageLookupByLibrary.simpleMessage("Приток капитала"),
    "capitalization": MessageLookupByLibrary.simpleMessage("Капитализация"),
    "confirmedAnomaly": MessageLookupByLibrary.simpleMessage(
      "Подтверждённая аномалия",
    ),
    "confirmedAnomalyDescription": MessageLookupByLibrary.simpleMessage(
      "Сильное движение, подтверждённое объёмом: цена за 24 часа изменилась больше чем на 7% (вверх или вниз), а объём торгов за сутки больше 30% капитализации монеты. Например, при капитализации \$100 млн за сутки наторговали больше чем на \$30 млн.",
    ),
    "confirmedAnomalyShort": MessageLookupByLibrary.simpleMessage(
      "Цена ±7% на объёме больше 30% капитализации",
    ),
    "corridorLowerBound": MessageLookupByLibrary.simpleMessage("Низ коридора"),
    "corridorUpperBound": MessageLookupByLibrary.simpleMessage("Верх коридора"),
    "createAnAccount": MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
    "currentPricePositionInDailyRange0100":
        MessageLookupByLibrary.simpleMessage(
          "Текущая позиция цены в дневном диапазоне (0–100%):",
        ),
    "dailyExtremumDescription": MessageLookupByLibrary.simpleMessage(
      "Монеты, цена которых сейчас у края своего диапазона за 24 часа: в верхних 5% (у дневного максимума) или в нижних 5% (у дневного минимума). Например, если за сутки монета ходила от 1,00 до 1,20, она попадёт в список при цене от 1,19 или до 1,01. Направление дальнейшего движения формула не предсказывает.",
    ),
    "dailyExtremumShort": MessageLookupByLibrary.simpleMessage(
      "Цена в верхних или нижних 5% дневного диапазона",
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
      "Монеты, цена которых стоит на реально сильном уровне или подходит к нему. Уровни строятся по 4-часовым свечам за 90 дней: цена минимум 2 раза делала там крупный разворот (самая высокая или низкая цена за ±24 часа) и после каждого уходила минимум на 3 обычных 4-часовых хода за 48 часов, в среднем — на 8% и больше. С первого касания цена почти не пробивала уровень: 4-часовые свечи закрывались по другую сторону не больше двух раз (смена роли или ложный пробой с возвратом). Середина боковика, которую цена ходит туда-обратно, уровнем не считается. Только живые монеты: обычный 4-часовой ход от 1,5% и оборот фьючерса от \$10 млн в сутки. «На уровне» — ближе ~0,3%; «подходит» — ближе ~1%, и за последние 8 часов цена уровня не касалась. Если цена уже коснулась уровня и отскочила, монета не показывается. На истории после касания таких уровней цена в среднем уходила дальше, чем от прежних, более слабых (медиана 3,9% против 3,6% за 48 часов), но удерживался уровень не чаще, чем случайная цена: это ориентир для стопов и целей, а не гарантия отскока.",
    ),
    "keyLevelsShort": MessageLookupByLibrary.simpleMessage(
      "Цена у сильного уровня: 2+ отскока в среднем от 8%, живые монеты",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "levelRadar": MessageLookupByLibrary.simpleMessage(
      "Радар: подход к сильному уровню",
    ),
    "levelRadarDescription": MessageLookupByLibrary.simpleMessage(
      "Монеты, которые прямо сейчас на сильном уровне или до него меньше 1%. Уровень строится по 4-часовым свечам за 90 дней: минимум 2 крупных разворота с отскоками в среднем от 8%, уровень почти не пробивался (4-часовые закрытия по другую сторону — не больше двух раз), а на свечах этих отскоков оборот минимум в 1,5 раза больше обычного — там заходил крупный капитал. Только живые монеты: обычный 4-часовой ход от 1,5% и оборот фьючерса от \$10 млн в сутки. «На уровне» — ближе ~0,3%. «Подходит» — до уровня меньше 1%, последние 4 часа цена идёт к нему и за последние 8 часов его не касалась. Уровни строгие, поэтому монет немного: на истории в среднем около одной одновременно, список часто пустой. Подходящая цена доходила до такого уровня за 2 часа примерно в 75% случаев, за 4 часа — в 80% (около 140 случаев за год). Когда цена уже на уровне, в ближайшие 4 часа уровень чаще пробивался, чем давал сильный отскок: это важная цена, а не обещание отскока.",
    ),
    "levelRadarShort": MessageLookupByLibrary.simpleMessage(
      "На сильном уровне с крупным объёмом на отскоках или до него меньше 1%",
    ),
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
    "overheatedFading": MessageLookupByLibrary.simpleMessage(
      "Перегрев и затухание",
    ),
    "overheatedFadingDescription": MessageLookupByLibrary.simpleMessage(
      "Монета сильно разогналась: рост за 24 ч или 7 дн. не меньше 4% и минимум в 2 раза больше её обычного хода, при этом она ещё не упала сильнее обычного дневного хода. Из четырёх признаков остывания сработали минимум три: RSI за сутки был 85+ и опустился на 5+ пунктов; цена отошла от дневного максимума на 15–50% дневного диапазона; последний час и последние 6 часов в минусе; цена выше средней за 7 дней больше чем на 1,5 обычных дневных хода.",
    ),
    "overheatedFadingShort": MessageLookupByLibrary.simpleMessage(
      "Перегрев + 3 из 4 признаков остывания",
    ),
    "overloadExtension": m3,
    "overloadFunding": m4,
    "overloadIndex": MessageLookupByLibrary.simpleMessage("Индекс перегрузки"),
    "overloadIndexDescription": MessageLookupByLibrary.simpleMessage(
      "Монета разогнана выше своей средней (цена выше EMA20 часового графика и за 6 часов в плюсе), и у неё горят минимум 3 из 7 признаков перегрузки: 1) цена выше EMA20 больше чем на 2,5 обычных часовых хода; 2) RSI 1ч 72+; 3) RSI 4ч 67+; 4) открытый интерес за сутки вырос на 15%+ — набирают плечи; 5) фандинг 0,02%+, вдвое выше стандартного — лонги переплачивают; 6) у топ-трейдеров лонг/шорт по позициям 2+; 7) объём за последние 2 часа в 2+ раза выше, чем до этого. Пороги — верхние ~20% среди всех разогнанных монет на истории, поэтому попадают и крупные монеты. Это степень перегрузки, а не прогноз: на истории откат после перегрузки случался не чаще обычного, а когда открытый интерес за сутки удваивался, рост чаще продолжался — об этом есть отдельное предупреждение.",
    ),
    "overloadIndexShort": MessageLookupByLibrary.simpleMessage(
      "3+ из 7 признаков перегрева и плеч",
    ),
    "overloadOpenInterest": m5,
    "overloadPoints": m6,
    "overloadRsi1h": m7,
    "overloadRsi4h": m8,
    "overloadSqueeze": m9,
    "overloadTopTraders": m10,
    "overloadVolume": m11,
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
    "radarApproaching": m12,
    "removeFromFavorites": MessageLookupByLibrary.simpleMessage(
      "Удалить из избранного",
    ),
    "resistance": MessageLookupByLibrary.simpleMessage("Сопротивление"),
    "rise24h": m13,
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "signUp": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
    "signalJournal": MessageLookupByLibrary.simpleMessage("Журнал сигналов"),
    "signalsActive": MessageLookupByLibrary.simpleMessage("Сигналы активны"),
    "signalsPaused": MessageLookupByLibrary.simpleMessage("Сигналы на паузе"),
    "strongBounces": m14,
    "structureBreak": MessageLookupByLibrary.simpleMessage("Слом структуры"),
    "support": MessageLookupByLibrary.simpleMessage("Поддержка"),
    "thePasswordMustBeAtLeast6CharactersLong":
        MessageLookupByLibrary.simpleMessage(
          "Пароль должен содержать не менее 6 символов",
        ),
    "tradesCount": m15,
    "turnover": MessageLookupByLibrary.simpleMessage("Оборачиваемость"),
    "volume24Hours": MessageLookupByLibrary.simpleMessage("Объём за 24 часа"),
    "volumeAtLevel": m16,
    "volumeChange": m17,
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
