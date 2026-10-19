import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/ui/device_layout.dart';
import '../core/ui/ui_provider.dart';
import '../generated/l10n.dart';
import '../home/data/models/chart_period.dart';
import '../home/data/models/price_point.dart';
import '../presentation/app_colors.dart';

class CoinPriceChart extends StatelessWidget {
  const CoinPriceChart({
    super.key,
    required this.points,
    required this.isLoading,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final List<PricePoint> points;
  final bool isLoading;
  final ChartPeriod selectedPeriod;
  final ValueChanged<ChartPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _PeriodSelector(
          selectedPeriod: selectedPeriod,
          onPeriodChanged: onPeriodChanged,
        ),
        const SizedBox(height: 8),
        _buildChart(context),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 200,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  S.of(context).noDataForGraph,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
        ),
      );
    }

    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].price),
    ];
    final prices = points.map((p) => p.price);
    final minY = prices.reduce((a, b) => a < b ? a : b);
    final maxY = prices.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;
    final isPositive = points.last.price >= points.first.price;
    final lineColor = isPositive ? AppColors.positive : AppColors.negative;

    return SizedBox(
      width: double.infinity,
      height: 200,
      child: LineChart(
        LineChartData(
          minY: minY - padding,
          maxY: maxY + padding,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((_) {
                return TouchedSpotIndicatorData(
                  FlLine(color: lineColor, strokeWidth: 1),
                  FlDotData(
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(radius: 4, color: lineColor),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.cardBackground,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '\$${spot.y.toStringAsFixed(2)}',
                    const TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: lineColor,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: lineColor.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final ChartPeriod selectedPeriod;
  final ValueChanged<ChartPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        for (final period in ChartPeriod.values) ...[
          _PeriodChip(
            label: period.label(context),
            isSelected: period == selectedPeriod,
            onTap: () => onPeriodChanged(period),
          ),
        ],
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.watch<UiProvider>().deviceLayout.isTabletMode;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.jacarta,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.whiteColor : AppColors.textSecondary,
            fontSize: isTablet ? 17 : 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
