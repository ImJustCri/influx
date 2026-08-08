import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:influx/theme.dart';

import '../../pages/simple_trend_chart_page.dart';
import '../app_container.dart';

class SimpleTrendChart extends StatelessWidget {
  final List<double> values;
  final String title;

  const SimpleTrendChart({
    super.key,
    required this.values,
    this.title = "Spesi in questo periodo",
  }) : assert(
  values.length >= 2 && values.length <= 3,
  'I valori devono essere 2 o 3.',
  );

  double get percentChange {
    final previousValue = values[values.length - 2];
    final currentValue = values.last;

    if (previousValue == 0) return 0;
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isUp = percentChange >= 0;
    final color = isUp ? Colors.redAccent : Colors.greenAccent;

    final minY = values.reduce(math.min);
    final maxY = values.reduce(math.max);
    final range = maxY - minY;
    final padding = range == 0 ? 1.0 : range * 0.25;

    final spots = values
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SimpleTrendChartPage(
              values: values,
              title: title,
            ),
          ),
        );
      },
      child: AppContainer(
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
              height: 80,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (values.length - 1).toDouble(),
                  minY: minY - padding,
                  maxY: maxY + padding,
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
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
      ),
    );
  }
}