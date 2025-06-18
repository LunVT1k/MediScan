// lib/widgets/patient_health_trends.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme/app_theme.dart';
import '../providers/dashboard_provider.dart';
import '../providers/patient_provider.dart';

class PatientHealthTrends extends StatelessWidget {
  const PatientHealthTrends({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Trends', 
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16, 
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTimeframeButton(
                            'D',
                            ChartTimeframe.daily,
                            provider.currentTimeframe == ChartTimeframe.daily,
                            () => provider.setTimeframe(ChartTimeframe.daily),
                          ),
                          _buildTimeframeButton(
                            'W', // Verkürzt zu einem Buchstaben
                            ChartTimeframe.weekly,
                            provider.currentTimeframe == ChartTimeframe.weekly,
                            () => provider.setTimeframe(ChartTimeframe.weekly),
                          ),
                          _buildTimeframeButton(
                            'M', 
                            ChartTimeframe.monthly,
                            provider.currentTimeframe == ChartTimeframe.monthly,
                            () => provider.setTimeframe(ChartTimeframe.monthly),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12), 
            Wrap(
              spacing: 4, 
              runSpacing: 4,
              children: [
                _buildLegendItem('HR', AppColors.heartRate), 
                _buildLegendItem('O2', AppColors.bloodOxygen), 
                _buildLegendItem('Temp', AppColors.temperature), 
              ],
            ),

            const SizedBox(height: 12), 
            // Chart
            Expanded(
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 20,
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: AppColors.textMuted.withAlpha(26),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: AppColors.textMuted.withAlpha(26),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              const dates = [
                                'Jun 8',
                                'Jun 9',
                                'Jun 10',
                                'Jun 11',
                                'Jun 12',
                                'Jun 13',
                                'Jun 14',
                              ];
                              if (value.toInt() >= 0 &&
                                  value.toInt() < dates.length) {
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    dates[value.toInt()],
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: const Text(''),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                            reservedSize: 32,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: AppColors.textMuted.withAlpha(51),
                        ),
                      ),
                      minX: 0,
                      maxX: 6,
                      minY: 30,
                      maxY: 130,
                      lineBarsData: [
                        // Heart Rate Line
                        LineChartBarData(
                          spots: _generateHeartRateSpots(),
                          isCurved: true,
                          color: AppColors.heartRate,
                          barWidth: 3,
                          // KORRIGIERT: isStroke entfernt
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.heartRate,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.background,
                                ),
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),

                        // Blood Oxygen Line
                        LineChartBarData(
                          spots: _generateBloodOxygenSpots(),
                          isCurved: true,
                          color: AppColors.bloodOxygen,
                          barWidth: 3,
                          // KORRIGIERT: isStroke entfernt
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.bloodOxygen,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.background,
                                ),
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),

                        // Temperature Line (scaled)
                        LineChartBarData(
                          spots: _generateTemperatureSpots(),
                          isCurved: true,
                          color: AppColors.temperature,
                          barWidth: 3,
                          // KORRIGIERT: isStroke entfernt
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.temperature,
                                  strokeWidth: 2,
                                  strokeColor: AppColors.background,
                                ),
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeButton(
    String title,
    ChartTimeframe timeframe,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ), // Kleinere Padding
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10, // Kleinere Schrift
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8, // Kleinere Indikatoren
          height: 2, // Dünnere Linie
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 4), // Weniger Abstand
        Text(
          label,
          style: const TextStyle(
            fontSize: 9, // Kleinere Schrift
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateHeartRateSpots() {
    // Heart rate data points (110-120 range)
    return [
      const FlSpot(0, 110),
      const FlSpot(1, 112),
      const FlSpot(2, 115),
      const FlSpot(3, 118),
      const FlSpot(4, 120),
      const FlSpot(5, 118),
      const FlSpot(6, 115),
    ];
  }

  List<FlSpot> _generateBloodOxygenSpots() {
    // Blood oxygen data points (90-100 range)
    return [
      const FlSpot(0, 95),
      const FlSpot(1, 96),
      const FlSpot(2, 94),
      const FlSpot(3, 97),
      const FlSpot(4, 98),
      const FlSpot(5, 96),
      const FlSpot(6, 97),
    ];
  }

  List<FlSpot> _generateTemperatureSpots() {
    // Temperature data points (scaled to fit chart: 36-38°C -> 36-38 range)
    return [
      const FlSpot(0, 36.5),
      const FlSpot(1, 36.8),
      const FlSpot(2, 37.1),
      const FlSpot(3, 37.3),
      const FlSpot(4, 37.0),
      const FlSpot(5, 36.9),
      const FlSpot(6, 36.7),
    ];
  }
}
