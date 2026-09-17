import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../home/home_widget/custom_app_bar.dart';
import '../presentation/app_colors.dart';
import '../presentation/app_images.dart';
import 'assistant_widgets/assistant_card_information.dart';
import 'domain/filter_type.dart';
import 'filter_detailing_screen.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  void _openDetails(BuildContext context, FilterType type, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FilterDetailingScreen(type: type, description: description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.haiti,
      appBar: CustomAppBar(text: S.of(context).analytics, leadingIcon: false),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 13,
            children: [
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.siren,
                      text: S
                          .of(context)
                          .abnormalPriceMovementOverTheLast24Hours,
                      description: S
                          .of(context)
                          .priceIncreasedecreaseByMoreThan10,
                      borderColor: AppColors.borderRed,
                      onTap: () => _openDetails(
                        context,
                        FilterType.abnormalMovement,
                        S.of(context).priceIncreasedecreaseByMoreThan10,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.barChart,
                      text: S.of(context).priceMovementOverTheLast24Hours,
                      description: S
                          .of(context)
                          .priceIncreasedecreaseByMoreThan5,
                      borderColor: AppColors.borderOrange,
                      onTap: () => _openDetails(
                        context,
                        FilterType.priceMovement,
                        S.of(context).priceIncreasedecreaseByMoreThan5,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.inflationRate,
                      text: S.of(context).highVolatility,
                      description: S
                          .of(context)
                          .priceFluctuationRangeOverTheLast24Hours,
                      borderColor: AppColors.borderGreen,
                      onTap: () => _openDetails(
                        context,
                        FilterType.highVolatility,
                        S.of(context).priceFluctuationRangeOverTheLast24Hours,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.volatility,
                      text: S.of(context).historicalMaximumminimum,
                      description: S
                          .of(context)
                          .approachingItsHistoricalMaximumminimum,
                      borderColor: AppColors.borderTeal,
                      onTap: () => _openDetails(
                        context,
                        FilterType.historicalExtremum,
                        S.of(context).approachingItsHistoricalMaximumminimum,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.inflation,
                      text: S.of(context).turnover,
                      description: S
                          .of(context)
                          .abnormallyHighTradingActivityRelativeToCoinSize,
                      borderColor: AppColors.amber,
                      onTap: () => _openDetails(
                        context,
                        FilterType.turnover,
                        S
                            .of(context)
                            .abnormallyHighTradingActivityRelativeToCoinSize,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.currency,
                      text: S.of(context).capitalInflow,
                      description: S
                          .of(context)
                          .marketCapIncreaseoutflowOfMoreThan5Over24Hours,
                      borderColor: AppColors.magenta,
                      onTap: () => _openDetails(
                        context,
                        FilterType.capitalInflow,
                        S
                            .of(context)
                            .marketCapIncreaseoutflowOfMoreThan5Over24Hours,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.analyze,
                      text: S.of(context).nearDailyPeakbottom,
                      description: S
                          .of(context)
                          .abnormallyHighTradingActivityRelativeToCoinSize,
                      borderColor: AppColors.borderGreen,
                      onTap: () => _openDetails(
                        context,
                        FilterType.dailyExtremum,
                        S
                            .of(context)
                            .abnormallyHighTradingActivityRelativeToCoinSize,
                      ),
                    ),
                  ),
                  Expanded(
                    child: AssistantCardInformation(
                      icon: AppImages.high,
                      text: S.of(context).confirmedAnomaly,
                      description: S
                          .of(context)
                          .priceIsCurrentlyAtTheUpperOrLowerBoundaryOf,
                      borderColor: AppColors.whiteColor,
                      onTap: () => _openDetails(
                        context,
                        FilterType.confirmedAnomaly,
                        S
                            .of(context)
                            .priceIsCurrentlyAtTheUpperOrLowerBoundaryOf,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
