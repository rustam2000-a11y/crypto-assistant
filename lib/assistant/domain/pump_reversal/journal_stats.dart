import 'signal_record.dart';

/// Итоги журнала по горизонтам удержания: доля прибыльных и средний результат.
class JournalStats {
  factory JournalStats.from(Iterable<SignalRecord> records) {
    final resolved = records.where((r) => r.isResolved).toList();
    return JournalStats._(
      trades: resolved.length,
      byHours: {
        for (final hours in const [1, 2, 3, 4])
          if (resolved.isNotEmpty) hours: _horizon(resolved, hours),
      },
    );
  }

  const JournalStats._({required this.trades, required this.byHours});

  final int trades;
  final Map<int, ({double winRate, double average})> byHours;

  static ({double winRate, double average}) _horizon(
    List<SignalRecord> records,
    int hours,
  ) {
    final results = records.map((r) => r.results[hours] ?? 0).toList();
    final wins = results.where((r) => r > 0).length;
    return (
      winRate: wins / results.length * 100,
      average: results.reduce((a, b) => a + b) / results.length,
    );
  }
}
