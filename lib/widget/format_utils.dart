String formatVolume(int volume) {
  if (volume >= 1000000000000) return '${(volume / 1000000000000).toStringAsFixed(1)}T';
  if (volume >= 1000000000) return '${(volume / 1000000000).toStringAsFixed(1)}B';
  if (volume >= 1000000) return '${(volume / 1000000).toStringAsFixed(1)}M';
  if (volume >= 1000) return '${(volume / 1000).toStringAsFixed(1)}K';
  return volume.toString();
}

String formatPriceRangePosition(double currentPrice, double? low24h, double? high24h) {
  if (low24h == null || high24h == null || high24h == low24h) return '—';
  final position = ((currentPrice - low24h) / (high24h - low24h) * 100).clamp(0, 100);
  return '${position.toStringAsFixed(0)}%';
}

// Цена с разумной точностью: 64250.12, 1.2345, 0.00001234.
String formatPrice(double price) {
  if (price >= 1) return price.toStringAsFixed(price >= 1000 ? 2 : 4);
  return price.toStringAsPrecision(4);
}
