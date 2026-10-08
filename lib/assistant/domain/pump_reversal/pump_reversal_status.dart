import 'package:equatable/equatable.dart';

/// Состояние рынка, при котором формула разворота включена или на паузе.
class PumpReversalStatus extends Equatable {
  const PumpReversalStatus({
    required this.btcChange30d,
    required this.marketChange1h,
  });

  /// Изменение BTC за 30 дней, %. Отрицательное — медвежий режим.
  final double btcChange30d;

  /// Медианное изменение монет списка за 1 час, %.
  final double marketChange1h;

  /// Разворот после пампа работал только на падающем рынке.
  bool get isBearRegime => btcChange30d < 0;

  bool get isMarketFalling => marketChange1h < 0;

  bool get isActive => isBearRegime && isMarketFalling;

  @override
  List<Object?> get props => [btcChange30d, marketChange1h];
}
