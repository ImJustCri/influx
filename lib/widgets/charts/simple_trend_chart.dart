import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:influx/theme.dart';

import '../app_container.dart';

class SimpleTrendChart extends StatelessWidget {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final String title;

  const SimpleTrendChart({
    super.key,
    required this.firstValue,
    required this.secondValue,
    required this.thirdValue,
    this.title = "Spesi questo mese",
  });

  // percentage change from previous period and current period
  double get percentChange {
    if (secondValue == 0) return 0;
    return ((thirdValue - secondValue) / secondValue) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isUp = percentChange >= 0;
    final color = isUp ? Colors.redAccent : Colors.greenAccent;

    final minY = math.min(math.min(firstValue, secondValue), thirdValue);
    final maxY = math.max(math.max(firstValue, secondValue), thirdValue);
    final padding = (maxY - minY) * 0.25 == 0 ? 1 : (maxY - minY) * 0.25;

    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.containerBody,
          ),
          const SizedBox(height: 4),
          Text(
            "${isUp ? '+' : ''}${percentChange.toStringAsFixed(0)}%",
            style: TextStyle(
              color: color,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 2,
                minY: minY - padding,
                maxY: maxY + padding,
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, firstValue),
                      FlSpot(1, secondValue),
                      FlSpot(2, thirdValue),
                    ],
                    isCurved: false,
                    barWidth: 5,
                    color: color,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          color.withAlpha(50),
                          color.withAlpha(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}