import 'dart:math';

import '../../home/data/models/candle.dart';

/// RSI Уайлдера по всей истории: экспоненциальное сглаживание 1/[period],
/// первое изменение считается нулевым.
double wilderRsi(List<Candle> candles, {int period = 14}) {
  final alpha = 1 / period;
  var gain = 0.0;
  var loss = 0.0;
  for (var k = 1; k < candles.length; k++) {
    final change = candles[k].close - candles[k - 1].close;
    gain = (1 - alpha) * gain + alpha * max(change, 0.0);
    loss = (1 - alpha) * loss + alpha * max(-change, 0.0);
  }
  return loss == 0 ? 100 : 100 - 100 / (1 + gain / loss);
}

/// Обычный дневной ход по [bars] часовым свечам: медиана |часовых
/// лог-доходностей| × 1.4826 × √24 (в долях). Медиана не раздувается
/// самим пампом.
double dailyVolatility(List<Candle> c, {int bars = 168}) {
  final t = c.length - 1;
  final moves = <double>[
    for (var k = t - bars + 1; k <= t; k++)
      log(c[k].close / c[k - 1].close).abs(),
  ]..sort();
  final mid = moves.length ~/ 2;
  final median = moves.length.isOdd
      ? moves[mid]
      : (moves[mid - 1] + moves[mid]) / 2;
  return median * 1.4826 * sqrt(24);
}
