import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../theme.dart';
import '../widgets/page_padding.dart';

class SimpleTrendChartPage extends StatelessWidget {
  final List<double> values;
  final String title;

  const SimpleTrendChartPage({
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

    final average = (values.reduce((a, b) => a + b) / values.length);
    final highest = maxY;
    final lowest = minY;

    // Map list to chart spots
    final spots = values
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    final maxX = (values.length - 1).toDouble();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PagePadding(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.containerBody,
              ),
              const SizedBox(height: 8),
              Text(
                "${isUp ? '+' : ''}${percentChange.toStringAsFixed(0)}%",
                style: TextStyle(
                  color: color,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: maxX,
                    minY: minY - padding,
                    maxY: maxY + padding,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: range == 0 ? 1 : range / 4,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white.withAlpha(30),
                          strokeWidth: 1,
                        );
                      },
                      drawVerticalLine: false,
                    ),
                    titlesData: const FlTitlesData(
                      show: false,
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(
                          color: Colors.white.withAlpha(50),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: Colors.white.withAlpha(50),
                          width: 1,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 3,
                        color: color,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 6,
                              color: color,
                              strokeWidth: 2,
                              strokeColor: Colors.white.withAlpha(200),
                            );
                          },
                        ),
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
                      // Average Line
                      LineChartBarData(
                        spots: [
                          FlSpot(0, average.roundToDouble()),
                          FlSpot(maxX, average.roundToDouble()),
                        ],
                        isCurved: false,
                        barWidth: 2,
                        color: Colors.blueAccent.withAlpha(150),
                        dashArray: [5, 5],
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withAlpha(30),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StatRow(
                      label: 'Massimo',
                      value: highest.toStringAsFixed(2),
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    _StatRow(
                      label: 'Media',
                      value: average.toStringAsFixed(2),
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 12),
                    _StatRow(
                      label: 'Minimo',
                      value: lowest.toStringAsFixed(1),
                      color: Colors.greenAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.containerBody.copyWith(
            color: AppColors.white.withAlpha(180),
          ),
        ),
        Text(
          value,
          style: AppTypography.containerBody.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}